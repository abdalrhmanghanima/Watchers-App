import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/firebase_auth_provider.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/delete_account.dart';
import '../../domain/usecases/observe_auth_state.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
  );
});

final observeAuthStateProvider = Provider<ObserveAuthState>((ref) {
  return ObserveAuthState(ref.watch(authRepositoryProvider));
});

final signInProvider = Provider<SignIn>((ref) {
  return SignIn(ref.watch(authRepositoryProvider));
});

final signInWithGoogleProvider = Provider<SignInWithGoogle>((ref) {
  return SignInWithGoogle(ref.watch(authRepositoryProvider));
});

final signUpProvider = Provider<SignUp>((ref) {
  return SignUp(ref.watch(authRepositoryProvider));
});

final signOutProvider = Provider<SignOut>((ref) {
  return SignOut(ref.watch(authRepositoryProvider));
});

final deleteAccountProvider = Provider<DeleteAccount>((ref) {
  return DeleteAccount(ref.watch(authRepositoryProvider));
});