import '../entities/auth_user.dart';

abstract interface class AuthRepository {
  Stream<AuthUser?> get authStateChanges;

  AuthUser? get currentUser;

  Future<AuthUser> signIn({
    required String email,
    required String password,
  });

  Future<AuthUser> signUp({
    required String email,
    required String password,
    required String displayName,
  });

  Future<AuthUser> signInWithGoogle();

  Future<AuthUser> updateDisplayName(String displayName);

  Future<AuthUser> updatePhotoURL(String photoUrl);

  Future<AuthUser> reloadUser();

  Future<void> signOut();

  Future<void> deleteAccount({required String password});
}