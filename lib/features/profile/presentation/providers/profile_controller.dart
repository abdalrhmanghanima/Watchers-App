import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_controller.dart';
import '../../data/providers/profile_providers.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/enums/profile_image_source.dart';
import '../../domain/errors/profile_exception.dart';

final profileBusyProvider = NotifierProvider<ProfileBusyNotifier, bool>(
  ProfileBusyNotifier.new,
);

class ProfileBusyNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

final profileErrorProvider = NotifierProvider<ProfileErrorNotifier, String?>(
  ProfileErrorNotifier.new,
);

class ProfileErrorNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void show(String message) => state = message;

  void clear() => state = null;
}

class ProfileController extends AsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() async {
    final authState = ref.watch(authControllerProvider);
    final authUser = authState.value;
    if (authUser == null) return null;
    return ref.read(profileRepositoryProvider).loadProfile(authUser);
  }

  Future<bool> updateDisplayName(String name) async {
    final current = state.value;
    if (current == null) return false;
    return _run(
      () => ref.read(profileRepositoryProvider).updateDisplayName(current, name),
    );
  }

  Future<bool> updateProfilePhoto(ProfileImageSource source) async {
    final current = state.value;
    if (current == null) return false;
    return _run(
      () =>
          ref
              .read(profileRepositoryProvider)
              .updateProfilePhoto(current, source),
    );
  }

  Future<bool> updateCoverPhoto(ProfileImageSource source) async {
    final current = state.value;
    if (current == null) return false;
    return _run(
      () => ref.read(profileRepositoryProvider).updateCoverPhoto(current, source),
    );
  }

  Future<bool> _run(Future<UserProfile> Function() action) async {
    final previous = state.value;
    ref.read(profileBusyProvider.notifier).set(true);
    ref.read(profileErrorProvider.notifier).clear();
    final result = await AsyncValue.guard(action);
    ref.read(profileBusyProvider.notifier).set(false);
    if (result.hasError) {
      final error = result.error;
      final message = error is ProfileException
          ? error.message
          : 'Something went wrong. Please try again.';
      ref.read(profileErrorProvider.notifier).show(message);
      state = AsyncData(previous);
      return false;
    }
    state = result;
    return true;
  }
}

final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, UserProfile?>(
  ProfileController.new,
);