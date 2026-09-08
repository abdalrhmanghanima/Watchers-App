import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../domain/entities/auth_user.dart';

class AuthUserMapper {
  const AuthUserMapper();

  AuthUser? fromFirebase(fb.User? user) {
    if (user == null) return null;
    return AuthUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }
}