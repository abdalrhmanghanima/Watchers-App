import 'package:watchers/features/auth/domain/entities/auth_user.dart';
import 'package:watchers/features/auth/domain/errors/auth_exception.dart';
import 'package:watchers/features/auth/domain/repositories/auth_repository.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/enums/profile_image_source.dart';
import '../../domain/enums/profile_image_type.dart';
import '../../domain/errors/profile_exception.dart';
import '../../domain/repositories/profile_repository.dart';
import '../services/profile_image_compressor.dart';
import '../services/profile_image_picker.dart';
import '../services/profile_photo_storage.dart';
import '../services/user_profile_store.dart';

class FirebaseProfileRepository implements ProfileRepository {
  const FirebaseProfileRepository({
    required ProfileImagePicker picker,
    required ProfileImageCompressor compressor,
    required ProfilePhotoStorage storage,
    required UserProfileStore store,
    required AuthRepository repository,
  }) : _imagePicker = picker,
       _imageCompressor = compressor,
       _photoStorage = storage,
       _profileStore = store,
       _authRepository = repository;

  final ProfileImagePicker _imagePicker;
  final ProfileImageCompressor _imageCompressor;
  final ProfilePhotoStorage _photoStorage;
  final UserProfileStore _profileStore;
  final AuthRepository _authRepository;

  @override
  Future<UserProfile> loadProfile(AuthUser user) async {
    final coverUrl = await _profileStore.getCoverUrl(user.uid);
    return UserProfile(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoUrl,
      coverUrl: coverUrl,
    );
  }

  @override
  Future<UserProfile> updateDisplayName(
    UserProfile profile,
    String name,
  ) async {
    final updated = await _guardAuth(() => _authRepository.updateDisplayName(name));
    return _copyProfile(profile, updated);
  }

  @override
  Future<UserProfile> updateProfilePhoto(
    UserProfile profile,
    ProfileImageSource source,
  ) async {
    final path = await _imagePicker.pickImage(source);
    final bytes = await _imageCompressor.compress(
      path,
      ProfileImageType.profilePhoto,
    );
    final url = await _photoStorage.upload(
      bytes,
      ProfileImageType.profilePhoto,
      profile.uid,
    );
    final updated = await _guardAuth(() => _authRepository.updatePhotoURL(url));
    return _copyProfile(profile, updated);
  }

  @override
  Future<UserProfile> updateCoverPhoto(
    UserProfile profile,
    ProfileImageSource source,
  ) async {
    final path = await _imagePicker.pickImage(source);
    final bytes = await _imageCompressor.compress(
      path,
      ProfileImageType.coverPhoto,
    );
    final url = await _photoStorage.upload(
      bytes,
      ProfileImageType.coverPhoto,
      profile.uid,
    );
    await _profileStore.setCoverUrl(profile.uid, url);
    return UserProfile(
      uid: profile.uid,
      displayName: profile.displayName,
      email: profile.email,
      photoUrl: profile.photoUrl,
      coverUrl: url,
    );
  }

  Future<AuthUser> _guardAuth(Future<AuthUser> Function() action) async {
    try {
      return await action();
    } on AuthException catch (error) {
      throw ProfileException(error.message);
    }
  }

  UserProfile _copyProfile(UserProfile previous, AuthUser updated) {
    return UserProfile(
      uid: updated.uid,
      displayName: updated.displayName,
      email: updated.email,
      photoUrl: updated.photoUrl,
      coverUrl: previous.coverUrl,
    );
  }
}