import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/features/auth/domain/entities/auth_user.dart';
import 'package:watchers/features/auth/domain/errors/auth_exception.dart';
import 'package:watchers/features/auth/presentation/providers/auth_providers.dart';

import 'helpers/auth_test_harness.dart';
import 'package:watchers/features/auth/presentation/providers/auth_controller.dart';

Future<dynamic> _pumpState() => Future<void>.delayed(Duration.zero);

void main() {
  test('starts unauthenticated', () {
    final container = createTestContainer();
    expect(container.read(authControllerProvider).value, isNull);
  });

  test('signIn exposes the authenticated user', () async {
    final container = createTestContainer();
    final controller = container.read(authControllerProvider.notifier);

    final ok = await controller.signIn('watcher@watchers.app', 'watchers');
    await _pumpState();

    expect(ok, isTrue);
    final state = container.read(authControllerProvider);
    expect(state is AsyncError, isFalse);
    expect(state.value?.email, 'watcher@watchers.app');
  });

  test('a failed signIn surfaces a friendly error', () async {
    final container = createTestContainer();
    final repo = container.read(authRepositoryProvider) as FakeAuthRepository;
    repo.failSignIn = true;
    final controller = container.read(authControllerProvider.notifier);

    final ok = await controller.signIn('watcher@watchers.app', 'watchers');
    await _pumpState();

    expect(ok, isFalse);
    final state = container.read(authControllerProvider);
    expect(state is AsyncError, isTrue);
    expect(state.error, isA<AuthException>());
  });

  test('signUp exposes the authenticated user with a display name', () async {
    final container = createTestContainer();
    final controller = container.read(authControllerProvider.notifier);

    final ok = await controller.signUp(
      displayName: 'Nova Lee',
      email: 'nova@watchers.app',
      password: 'watchers',
    );
    await _pumpState();

    expect(ok, isTrue);
    final state = container.read(authControllerProvider);
    expect(state.value?.email, 'nova@watchers.app');
    expect(state.value?.displayName, 'Nova Lee');
  });

  test('a failed signUp surfaces a friendly error', () async {
    final container = createTestContainer();
    final repo = container.read(authRepositoryProvider) as FakeAuthRepository;
    repo.failSignUp = true;
    final controller = container.read(authControllerProvider.notifier);

    final ok = await controller.signUp(
      displayName: 'Nova Lee',
      email: 'nova@watchers.app',
      password: 'watchers',
    );
    await _pumpState();

    expect(ok, isFalse);
    expect(container.read(authControllerProvider) is AsyncError, isTrue);
  });

  test('signOut returns to the unauthenticated state', () async {
    final container = createTestContainer();
    final controller = container.read(authControllerProvider.notifier);
    await controller.signIn('watcher@watchers.app', 'watchers');
    await _pumpState();

    final ok = await controller.signOut();
    await _pumpState();

    expect(ok, isTrue);
    expect(container.read(authControllerProvider).value, isNull);
  });

  test('a failed signOut keeps the error surfaced', () async {
    final container = createTestContainer();
    final repo = container.read(authRepositoryProvider) as FakeAuthRepository;
    final controller = container.read(authControllerProvider.notifier);
    await controller.signIn('watcher@watchers.app', 'watchers');
    await _pumpState();

    repo.failSignOut = true;
    final ok = await controller.signOut();
    await _pumpState();

    expect(ok, isFalse);
    expect(container.read(authControllerProvider) is AsyncError, isTrue);
  });

  test('deleteAccount returns to the unauthenticated state', () async {
    final container = createTestContainer();
    final controller = container.read(authControllerProvider.notifier);
    await controller.signIn('watcher@watchers.app', 'watchers');
    await _pumpState();

    final ok = await controller.deleteAccount('watchers');
    await _pumpState();

    expect(ok, isTrue);
    expect(container.read(authControllerProvider).value, isNull);
  });

  test('a failed deleteAccount surfaces a friendly error', () async {
    final container = createTestContainer();
    final repo = container.read(authRepositoryProvider) as FakeAuthRepository;
    final controller = container.read(authControllerProvider.notifier);
    await controller.signIn('watcher@watchers.app', 'watchers');
    await _pumpState();

    repo.failDeleteAccount = true;
    final ok = await controller.deleteAccount('watchers');
    await _pumpState();

    expect(ok, isFalse);
    final state = container.read(authControllerProvider);
    expect(state is AsyncError, isTrue);
    expect(state.error, isA<AuthException>());
  });

  test('Google sign in exposes the authenticated user', () async {
    final container = createTestContainer();
    final controller = container.read(authControllerProvider.notifier);

    final ok = await controller.signInWithGoogle();
    await _pumpState();

    expect(ok, isTrue);
    final state = container.read(authControllerProvider);
    expect(state.value?.email, 'google@watchers.app');
    expect(state.value?.displayName, 'Google User');
  });

  test('Google sign in shows loading until the provider resolves', () async {
    final container = createTestContainer();
    final repo = container.read(authRepositoryProvider) as FakeAuthRepository;
    await _pumpState();
    final gate = Completer<AuthUser>();
    repo.googleSignIn = () => gate.future;
    final controller = container.read(authControllerProvider.notifier);

    final pending = controller.signInWithGoogle();

    expect(container.read(authControllerProvider).isLoading, isTrue);

    gate.complete(const AuthUser(uid: 'g', email: 'gate@watchers.app'));
    await pending;
    await _pumpState();

    final state = container.read(authControllerProvider);
    expect(state.isLoading, isFalse);
    expect(state.value?.email, 'gate@watchers.app');
  });

  test('cancelled Google sign in is not surfaced as an error', () async {
    final container = createTestContainer();
    final repo = container.read(authRepositoryProvider) as FakeAuthRepository;
    repo.cancelGoogleSignIn = true;
    final controller = container.read(authControllerProvider.notifier);

    final ok = await controller.signInWithGoogle();
    await _pumpState();

    expect(ok, isFalse);
    final state = container.read(authControllerProvider);
    expect(state is AsyncError, isFalse);
    expect(state.hasError, isFalse);
    expect(state.value, isNull);
  });

  test('a failed Google sign in surfaces a friendly error', () async {
    final container = createTestContainer();
    final repo = container.read(authRepositoryProvider) as FakeAuthRepository;
    repo.failGoogleSignIn = true;
    final controller = container.read(authControllerProvider.notifier);

    final ok = await controller.signInWithGoogle();
    await _pumpState();

    expect(ok, isFalse);
    final state = container.read(authControllerProvider);
    expect(state is AsyncError, isTrue);
    expect(state.error, isA<AuthException>());
  });
}
