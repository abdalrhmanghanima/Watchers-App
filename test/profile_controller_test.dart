import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/features/auth/domain/entities/auth_user.dart';
import 'package:watchers/features/profile/data/providers/profile_providers.dart';
import 'package:watchers/features/profile/domain/enums/profile_image_source.dart';
import 'package:watchers/features/profile/presentation/providers/profile_controller.dart';

import 'helpers/auth_test_harness.dart';

Future<dynamic> _pumpState() => Future<void>.delayed(Duration.zero);

void main() {
  test('loads the profile for the signed-in user', () async {
    final container = createTestContainer(
      initialUser: const AuthUser(
        uid: 'u1',
        email: 'a@b.com',
        displayName: 'Nova',
      ),
    );

    final profile = await container.read(profileControllerProvider.future);

    expect(profile?.uid, 'u1');
    expect(profile?.displayName, 'Nova');
    expect(profile?.email, 'a@b.com');
  });

  test('is null when no user is signed in', () async {
    final container = createTestContainer();

    final profile = await container.read(profileControllerProvider.future);

    expect(profile, isNull);
  });

  test('updateDisplayName refreshes the stored display name', () async {
    final container = createTestContainer(
      initialUser: const AuthUser(uid: 'u1', email: 'a@b.com', displayName: 'Old'),
    );
    await container.read(profileControllerProvider.future);

    final ok = await container
        .read(profileControllerProvider.notifier)
        .updateDisplayName('New Name');
    await _pumpState();

    expect(ok, isTrue);
    expect(
      container.read(profileControllerProvider).value?.displayName,
      'New Name',
    );
  });

  test('a failed updateDisplayName preserves the current profile', () async {
    final container = createTestContainer(
      initialUser: const AuthUser(uid: 'u1', email: 'a@b.com', displayName: 'Old'),
    );
    await container.read(profileControllerProvider.future);
    final repo = container.read(profileRepositoryProvider) as FakeProfileRepository;
    repo.failUpdateName = true;

    final ok = await container
        .read(profileControllerProvider.notifier)
        .updateDisplayName('New Name');
    await _pumpState();

    expect(ok, isFalse);
    expect(
      container.read(profileControllerProvider).value?.displayName,
      'Old',
    );
    expect(
      container.read(profileErrorProvider),
      'Could not update your display name.',
    );
    expect(container.read(profileBusyProvider), isFalse);
  });

  test('exposes busy while a profile update is in flight', () async {
    final container = createTestContainer(
      initialUser: const AuthUser(uid: 'u1', email: 'a@b.com'),
    );
    final repo = container.read(profileRepositoryProvider) as FakeProfileRepository;
    await container.read(profileControllerProvider.future);
    final gate = Completer<void>();
    repo.profileGate = gate;

    final pending = container
        .read(profileControllerProvider.notifier)
        .updateProfilePhoto(ProfileImageSource.gallery);
    await _pumpState();

    expect(container.read(profileBusyProvider), isTrue);

    gate.complete();
    await pending;
    await _pumpState();

    expect(container.read(profileBusyProvider), isFalse);
  });

  test('updateProfilePhoto refreshes the photo URL and records the source', () async {
    final container = createTestContainer(
      initialUser: const AuthUser(uid: 'u1', email: 'a@b.com'),
    );
    final repo = container.read(profileRepositoryProvider) as FakeProfileRepository;
    await container.read(profileControllerProvider.future);

    final ok = await container
        .read(profileControllerProvider.notifier)
        .updateProfilePhoto(ProfileImageSource.camera);
    await _pumpState();

    expect(ok, isTrue);
    expect(repo.profilePhotoCalls, 1);
    expect(repo.lastProfileSource, ProfileImageSource.camera);
    expect(
      container.read(profileControllerProvider).value?.photoUrl,
      'https://example.com/profile.jpg',
    );
  });

  test('a failed profile photo update keeps the previous photo', () async {
    final container = createTestContainer(
      initialUser: const AuthUser(uid: 'u1', email: 'a@b.com'),
    );
    await container.read(profileControllerProvider.future);
    final repo = container.read(profileRepositoryProvider) as FakeProfileRepository;
    repo.failProfilePhoto = true;

    final ok = await container
        .read(profileControllerProvider.notifier)
        .updateProfilePhoto(ProfileImageSource.gallery);
    await _pumpState();

    expect(ok, isFalse);
    expect(container.read(profileControllerProvider).value?.photoUrl, isNull);
    expect(
      container.read(profileErrorProvider),
      'Could not upload your profile photo.',
    );
  });

  test('updateCoverPhoto refreshes the cover URL and records the source', () async {
    final container = createTestContainer(
      initialUser: const AuthUser(uid: 'u1', email: 'a@b.com'),
    );
    final repo = container.read(profileRepositoryProvider) as FakeProfileRepository;
    await container.read(profileControllerProvider.future);

    final ok = await container
        .read(profileControllerProvider.notifier)
        .updateCoverPhoto(ProfileImageSource.gallery);
    await _pumpState();

    expect(ok, isTrue);
    expect(repo.coverPhotoCalls, 1);
    expect(repo.lastCoverSource, ProfileImageSource.gallery);
    expect(
      container.read(profileControllerProvider).value?.coverUrl,
      'https://example.com/cover.jpg',
    );
  });

  test('a failed cover update keeps the previous cover', () async {
    final container = createTestContainer(
      initialUser: const AuthUser(uid: 'u1', email: 'a@b.com'),
    );
    await container.read(profileControllerProvider.future);
    final repo = container.read(profileRepositoryProvider) as FakeProfileRepository;

    final first = await container
        .read(profileControllerProvider.notifier)
        .updateCoverPhoto(ProfileImageSource.gallery);
    await _pumpState();
    expect(first, isTrue);

    repo.failCoverPhoto = true;
    final ok = await container
        .read(profileControllerProvider.notifier)
        .updateCoverPhoto(ProfileImageSource.camera);
    await _pumpState();

    expect(ok, isFalse);
    expect(
      container.read(profileControllerProvider).value?.coverUrl,
      'https://example.com/cover.jpg',
    );
  });
}