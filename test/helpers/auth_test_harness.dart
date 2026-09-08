import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/app/watchers_app.dart';
import 'package:watchers/features/auth/domain/entities/auth_user.dart';
import 'package:watchers/features/auth/domain/errors/auth_exception.dart';
import 'package:watchers/features/auth/domain/repositories/auth_repository.dart';
import 'package:watchers/features/auth/presentation/providers/auth_providers.dart';
import 'package:watchers/features/profile/data/providers/profile_providers.dart';
import 'package:watchers/features/profile/domain/entities/user_profile.dart';
import 'package:watchers/features/profile/domain/enums/profile_image_source.dart';
import 'package:watchers/features/profile/domain/errors/profile_exception.dart';
import 'package:watchers/features/profile/domain/repositories/profile_repository.dart';
import 'package:watchers/shared/widgets/gradient_button.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    AuthUser? initialUser,
    List<AuthUser>? users,
    this.failSignIn = false,
    this.failSignUp = false,
    this.failSignOut = false,
    this.failDeleteAccount = false,
    this.failGoogleSignIn = false,
    this.cancelGoogleSignIn = false,
    this.googleSignIn,
  }) : _current = initialUser,
       _users = users ?? <AuthUser>[],
       _controller = StreamController<AuthUser?>.broadcast(sync: true) {
    _controller.onListen = () => _controller.add(_current);
  }

  AuthUser? _current;
  final List<AuthUser> _users;
  bool failSignIn;
  bool failSignUp;
  bool failSignOut;
  bool failDeleteAccount;
  bool failGoogleSignIn;
  bool cancelGoogleSignIn;
  Future<AuthUser> Function()? googleSignIn;
  late final StreamController<AuthUser?> _controller;

  @override
  AuthUser? get currentUser => _current;

  @override
  Stream<AuthUser?> get authStateChanges => _controller.stream;

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    if (failSignIn) throw const AuthException('Invalid email or password.');
    final user = AuthUser(
      uid: 'uid-$email',
      email: email,
      displayName: email == 'watcher@watchers.app' ? 'celestialwatcher' : null,
    );
    _emit(user);
    return user;
  }

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    if (failSignUp) {
      throw const AuthException('That email is already in use.');
    }
    final user = AuthUser(
      uid: 'uid-$email',
      email: email,
      displayName: displayName,
    );
    _users.add(user);
    _emit(user);
    return user;
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    if (googleSignIn != null) return googleSignIn!();
    if (cancelGoogleSignIn) throw const AuthException.cancelled();
    if (failGoogleSignIn) {
      throw const AuthException('Something went wrong. Please try again.');
    }
    const user = AuthUser(
      uid: 'google-uid',
      email: 'google@watchers.app',
      displayName: 'Google User',
    );
    _emit(user);
    return user;
  }

  @override
  Future<AuthUser> updateDisplayName(String displayName) async {
    final current = _current;
    if (current == null) throw const AuthException('Please sign in again.');
    final updated = AuthUser(
      uid: current.uid,
      email: current.email,
      displayName: displayName.trim(),
      photoUrl: current.photoUrl,
    );
    _emit(updated);
    return updated;
  }

  @override
  Future<AuthUser> updatePhotoURL(String photoUrl) async {
    final current = _current;
    if (current == null) throw const AuthException('Please sign in again.');
    final updated = AuthUser(
      uid: current.uid,
      email: current.email,
      displayName: current.displayName,
      photoUrl: photoUrl.trim(),
    );
    _emit(updated);
    return updated;
  }

  @override
  Future<AuthUser> reloadUser() async {
    final current = _current;
    if (current == null) throw const AuthException('Please sign in again.');
    return current;
  }

  @override
  Future<void> signOut() async {
    if (failSignOut) {
      throw const AuthException('Something went wrong. Please try again.');
    }
    _emit(null);
  }

  @override
  Future<void> deleteAccount({required String password}) async {
    if (failDeleteAccount) {
      throw const AuthException('Please sign in again to continue.');
    }
    _emit(null);
  }

  void _emit(AuthUser? user) {
    _current = user;
    _controller.add(user);
  }
}

class FakeProfileRepository implements ProfileRepository {
  FakeProfileRepository({
    this.displayName,
    this.photoUrl,
    this.coverUrl,
    this.failLoad = false,
    this.failUpdateName = false,
    this.failProfilePhoto = false,
    this.failCoverPhoto = false,
  });

  String? displayName;
  String? photoUrl;
  String? coverUrl;
  bool failLoad;
  bool failUpdateName;
  bool failProfilePhoto;
  bool failCoverPhoto;
  int updateNameCalls = 0;
  int profilePhotoCalls = 0;
  int coverPhotoCalls = 0;
  ProfileImageSource? lastProfileSource;
  ProfileImageSource? lastCoverSource;
  Completer<void>? profileGate;

  @override
  Future<UserProfile> loadProfile(AuthUser user) async {
    if (failLoad) throw const ProfileException('Could not load your profile.');
    return UserProfile(
      uid: user.uid,
      displayName: displayName ?? user.displayName,
      email: user.email,
      photoUrl: photoUrl ?? user.photoUrl,
      coverUrl: coverUrl,
    );
  }

  @override
  Future<UserProfile> updateDisplayName(UserProfile profile, String name) async {
    updateNameCalls += 1;
    if (profileGate != null) await profileGate!.future;
    if (failUpdateName) {
      throw const ProfileException('Could not update your display name.');
    }
    final trimmed = name.trim();
    displayName = trimmed;
    return UserProfile(
      uid: profile.uid,
      displayName: trimmed,
      email: profile.email,
      photoUrl: profile.photoUrl,
      coverUrl: profile.coverUrl,
    );
  }

  @override
  Future<UserProfile> updateProfilePhoto(
    UserProfile profile,
    ProfileImageSource source,
  ) async {
    profilePhotoCalls += 1;
    lastProfileSource = source;
    if (profileGate != null) await profileGate!.future;
    if (failProfilePhoto) {
      throw const ProfileException('Could not upload your profile photo.');
    }
    photoUrl = 'https://example.com/profile.jpg';
    return UserProfile(
      uid: profile.uid,
      displayName: profile.displayName,
      email: profile.email,
      photoUrl: photoUrl,
      coverUrl: profile.coverUrl,
    );
  }

  @override
  Future<UserProfile> updateCoverPhoto(
    UserProfile profile,
    ProfileImageSource source,
  ) async {
    coverPhotoCalls += 1;
    lastCoverSource = source;
    if (profileGate != null) await profileGate!.future;
    if (failCoverPhoto) {
      throw const ProfileException('Could not upload your cover photo.');
    }
    coverUrl = 'https://example.com/cover.jpg';
    return UserProfile(
      uid: profile.uid,
      displayName: profile.displayName,
      email: profile.email,
      photoUrl: profile.photoUrl,
      coverUrl: coverUrl,
    );
  }
}

ProviderContainer createTestContainer({AuthUser? initialUser}) {
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(
        FakeAuthRepository(initialUser: initialUser),
      ),
      profileRepositoryProvider.overrideWithValue(FakeProfileRepository()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<ProviderContainer> pumpApp(
  WidgetTester tester, {
  AuthUser? initialUser,
}) async {
  final container = createTestContainer(initialUser: initialUser);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const WatchersApp(),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

Future<void> goToShell(WidgetTester tester, ProviderContainer container) async {
  await tester.pumpAndSettle();
  await tester.tap(find.text('Get Started'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).at(0), 'watcher@watchers.app');
  await tester.enterText(find.byType(TextField).at(1), 'watchers');
  await tester.tap(find.widgetWithText(GradientButton, 'Sign In'));
  await tester.pumpAndSettle();
}

Future<void> goToProfile(WidgetTester tester, ProviderContainer container) async {
  await goToShell(tester, container);
  await tester.tap(find.text('PROFILE'));
  await tester.pumpAndSettle();
}
