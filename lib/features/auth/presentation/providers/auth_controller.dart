import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/errors/auth_exception.dart';
import 'auth_providers.dart';

class AuthController extends AsyncNotifier<AuthUser?> {
  @override
  Future<AuthUser?> build() async {
    final repository = ref.read(authRepositoryProvider);
    final completer = Completer<AuthUser?>();
    final subscription = repository.authStateChanges.listen((user) {
      state = AsyncData(user);
      if (!completer.isCompleted) completer.complete(user);
    });
    ref.onDispose(() => subscription.cancel());
    return completer.future;
  }

  Future<bool> signIn(String email, String password) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(signInProvider)(email.trim(), password),
    );
    state = result;
    return result.hasValue;
  }

  Future<bool> signUp({
    required String displayName,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () =>
          ref.read(signUpProvider)(
            email: email.trim(),
            password: password,
            displayName: displayName.trim(),
          ),
    );
    state = result;
    return result.hasValue;
  }

  Future<bool> signInWithGoogle() => _socialSignIn(
        () => ref.read(signInWithGoogleProvider)(),
      );

  Future<bool> _socialSignIn(Future<AuthUser> Function() action) async {
    final previous = state.value;
    state = const AsyncLoading();
    final result = await AsyncValue.guard(action);
    if (result.hasError) {
      final error = result.error;
      if (error is AuthException && error.cancelled) {
        state = AsyncData(previous);
        return false;
      }
      state = result;
      return false;
    }
    state = result;
    return true;
  }

  Future<bool> signOut() async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => ref.read(signOutProvider)());
    state = result.whenData<AuthUser?>((_) => null);
    return state.hasValue && !state.hasError;
  }

  Future<bool> deleteAccount(String password) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(deleteAccountProvider)(password),
    );
    state = result.whenData<AuthUser?>((_) => null);
    return state.hasValue && !state.hasError;
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthUser?>(AuthController.new);