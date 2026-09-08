import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/features/auth/domain/entities/auth_user.dart';
import 'package:watchers/features/auth/domain/errors/auth_exception.dart';
import 'package:watchers/features/auth/domain/repositories/auth_repository.dart';
import 'package:watchers/features/profile/data/repositories/firebase_profile_repository.dart';
import 'package:watchers/features/profile/data/services/profile_image_compressor.dart';
import 'package:watchers/features/profile/data/services/profile_image_picker.dart';
import 'package:watchers/features/profile/data/services/profile_photo_storage.dart';
import 'package:watchers/features/profile/data/services/user_profile_store.dart';
import 'package:watchers/features/profile/domain/entities/user_profile.dart';
import 'package:watchers/features/profile/domain/enums/profile_image_source.dart';
import 'package:watchers/features/profile/domain/enums/profile_image_type.dart';
import 'package:watchers/features/profile/domain/errors/profile_exception.dart';

import 'helpers/auth_test_harness.dart';

class _FakePicker implements ProfileImagePicker {
  final List<ProfileImageSource> picks = [];
  bool fail = false;

  @override
  Future<String> pickImage(ProfileImageSource source) async {
    picks.add(source);
    if (fail) throw const ProfileException('Could not open the image picker.');
    return 'picked.jpg';
  }
}

class _FakeCompressor implements ProfileImageCompressor {
  final List<ProfileImageType> calls = [];
  Uint8List bytes = Uint8List.fromList(const [1, 2, 3]);
  bool fail = false;

  @override
  Future<Uint8List> compress(String sourcePath, ProfileImageType type) async {
    calls.add(type);
    if (fail) throw const ProfileException('Could not prepare your image.');
    return bytes;
  }
}

class _FakeStorage implements ProfilePhotoStorage {
  final List<(Uint8List, ProfileImageType, String)> calls = [];
  String url = 'https://storage.example.com/image.jpg';
  bool fail = false;

  @override
  Future<String> upload(
    Uint8List bytes,
    ProfileImageType type,
    String uid,
  ) async {
    calls.add((bytes, type, uid));
    if (fail) throw const ProfileException('Could not upload your image.');
    return url;
  }
}

class _FakeStore implements UserProfileStore {
  String? coverUrl;
  final List<String> savedUids = [];
  bool failGet = false;

  @override
  Future<String?> getCoverUrl(String uid) async {
    if (failGet) throw const ProfileException('Could not load your profile.');
    return coverUrl;
  }

  @override
  Future<void> setCoverUrl(String uid, String url) async {
    savedUids.add(uid);
    coverUrl = url;
  }
}

class _FailingAuthRepository extends FakeAuthRepository {
  _FailingAuthRepository()
    : super(initialUser: const AuthUser(uid: 'u1', email: 'a@b.com'));

  @override
  Future<AuthUser> updateDisplayName(String displayName) async {
    throw const AuthException('Please sign in again to continue.');
  }
}

void main() {
  const user = AuthUser(uid: 'u1', email: 'a@b.com', displayName: 'Nova');
  const profile = UserProfile(
    uid: 'u1',
    displayName: 'Old',
    email: 'a@b.com',
    photoUrl: 'https://example.com/old.jpg',
    coverUrl: 'https://example.com/cover.jpg',
  );

  FirebaseProfileRepository buildRepository({
    ProfileImagePicker? picker,
    ProfileImageCompressor? compressor,
    ProfilePhotoStorage? storage,
    UserProfileStore? store,
    AuthRepository? auth,
  }) => FirebaseProfileRepository(
    picker: picker ?? _FakePicker(),
    compressor: compressor ?? _FakeCompressor(),
    storage: storage ?? _FakeStorage(),
    store: store ?? _FakeStore(),
    repository: auth ?? FakeAuthRepository(initialUser: user),
  );

  test('loadProfile combines auth fields with the stored cover URL', () async {
    final store = _FakeStore()..coverUrl = 'https://example.com/cover.jpg';
    final repo = buildRepository(
      store: store,
      auth: FakeAuthRepository(initialUser: user),
    );

    final loaded = await repo.loadProfile(user);

    expect(loaded.uid, 'u1');
    expect(loaded.email, 'a@b.com');
    expect(loaded.displayName, 'Nova');
    expect(loaded.coverUrl, 'https://example.com/cover.jpg');
  });

  test('loadProfile surfaces a store failure', () async {
    final store = _FakeStore()..failGet = true;
    final repo = buildRepository(store: store);

    await expectLater(
      repo.loadProfile(user),
      throwsA(isA<ProfileException>()),
    );
  });

  test('updateDisplayName updates the auth name and keeps the cover', () async {
    final auth = FakeAuthRepository(initialUser: user);
    final repo = buildRepository(auth: auth);

    final updated = await repo.updateDisplayName(profile, 'New Name');

    expect(auth.currentUser?.displayName, 'New Name');
    expect(updated.displayName, 'New Name');
    expect(updated.coverUrl, profile.coverUrl);
  });

  test('maps an auth failure to a ProfileException', () async {
    final repo = buildRepository(auth: _FailingAuthRepository());

    await expectLater(
      repo.updateDisplayName(profile, 'New Name'),
      throwsA(isA<ProfileException>()),
    );
  });

  test('updateProfilePhoto picks, compresses, uploads, then updates auth', () async {
    final picker = _FakePicker();
    final compressor = _FakeCompressor();
    final storage = _FakeStorage();
    final auth = FakeAuthRepository(initialUser: user);
    final repo = buildRepository(
      picker: picker,
      compressor: compressor,
      storage: storage,
      auth: auth,
    );

    final updated = await repo.updateProfilePhoto(
      profile,
      ProfileImageSource.gallery,
    );

    expect(picker.picks, [ProfileImageSource.gallery]);
    expect(compressor.calls, [ProfileImageType.profilePhoto]);
    expect(storage.calls.single.$2, ProfileImageType.profilePhoto);
    expect(storage.calls.single.$3, 'u1');
    expect(storage.calls.single.$1, isNotEmpty);
    expect(auth.currentUser?.photoUrl, storage.url);
    expect(updated.photoUrl, storage.url);
    expect(updated.coverUrl, profile.coverUrl);
  });

  test('a failed photo upload leaves the auth photo untouched', () async {
    final storage = _FakeStorage()..fail = true;
    final auth = FakeAuthRepository(initialUser: user);
    final repo = buildRepository(storage: storage, auth: auth);

    await expectLater(
      repo.updateProfilePhoto(profile, ProfileImageSource.camera),
      throwsA(isA<ProfileException>()),
    );
    expect(auth.currentUser?.photoUrl, isNull);
  });

  test('updateCoverPhoto picks, compresses, uploads, and persists the URL', () async {
    final picker = _FakePicker();
    final compressor = _FakeCompressor();
    final storage = _FakeStorage();
    final store = _FakeStore();
    final repo = buildRepository(
      picker: picker,
      compressor: compressor,
      storage: storage,
      store: store,
    );

    final updated = await repo.updateCoverPhoto(profile, ProfileImageSource.camera);

    expect(picker.picks, [ProfileImageSource.camera]);
    expect(compressor.calls, [ProfileImageType.coverPhoto]);
    expect(storage.calls.single.$2, ProfileImageType.coverPhoto);
    expect(storage.calls.single.$3, 'u1');
    expect(store.savedUids, ['u1']);
    expect(updated.coverUrl, storage.url);
  });
}