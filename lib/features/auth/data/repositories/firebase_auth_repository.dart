import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/errors/auth_exception.dart';
import '../../domain/repositories/auth_repository.dart';
import '../errors/auth_exception_mapper.dart';
import '../mappers/auth_user_mapper.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    required FirebaseAuth firebaseAuth,
    GoogleSignIn? googleSignIn,
    AuthUserMapper? userMapper,
    AuthExceptionMapper? exceptionMapper,
  }) : _auth = firebaseAuth,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
       _userMapper = userMapper ?? const AuthUserMapper(),
       _exceptionMapper = exceptionMapper ?? const AuthExceptionMapper();

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final AuthUserMapper _userMapper;
  final AuthExceptionMapper _exceptionMapper;
  bool _googleInitialized = false;

  @override
  AuthUser? get currentUser => _userMapper.fromFirebase(_auth.currentUser);

  @override
  Stream<AuthUser?> get authStateChanges =>
      _auth.authStateChanges().map(_userMapper.fromFirebase);

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _requireUser(credential.user);
    } on FirebaseAuthException catch (error) {
      throw _exceptionMapper.map(error);
    }
  }

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user!;
      final name = displayName.trim();
      if (name.isNotEmpty) {
        await user.updateDisplayName(name);
      }
      await user.reload();
      return _requireUser(user);
    } on FirebaseAuthException catch (error) {
      throw _exceptionMapper.map(error);
    }
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    try {
      if (!_googleInitialized) {
        await _googleSignIn.initialize();
        _googleInitialized = true;
      }
      final account = await _googleSignIn.authenticate();
      final authentication = account.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
      );
      final result = await _auth.signInWithCredential(credential);
      return _requireUser(result.user);
    } on AuthException {
      rethrow;
    } on GoogleSignInException catch (error) {
      switch (error.code) {
        case GoogleSignInExceptionCode.canceled:
        case GoogleSignInExceptionCode.interrupted:
        case GoogleSignInExceptionCode.uiUnavailable:
          throw const AuthException.cancelled();
        case GoogleSignInExceptionCode.clientConfigurationError:
        case GoogleSignInExceptionCode.providerConfigurationError:
          throw const AuthException('Google sign-in is not configured.');
        default:
          throw _exceptionMapper.map(error);
      }
    } catch (error) {
      throw _exceptionMapper.map(error);
    }
  }

  @override
  Future<AuthUser> updateDisplayName(String displayName) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AuthException('Please sign in again to continue.');
    }
    try {
      await user.updateDisplayName(displayName.trim());
      await user.reload();
      return _requireUser(user);
    } on FirebaseAuthException catch (error) {
      throw _exceptionMapper.map(error);
    }
  }

  @override
  Future<AuthUser> updatePhotoURL(String photoUrl) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AuthException('Please sign in again to continue.');
    }
    try {
      await user.updatePhotoURL(photoUrl.trim());
      await user.reload();
      return _requireUser(user);
    } on FirebaseAuthException catch (error) {
      throw _exceptionMapper.map(error);
    }
  }

  @override
  Future<AuthUser> reloadUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AuthException('Please sign in again to continue.');
    }
    try {
      await user.reload();
      return _requireUser(user);
    } on FirebaseAuthException catch (error) {
      throw _exceptionMapper.map(error);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      throw _exceptionMapper.map(error);
    }
  }

  @override
  Future<void> deleteAccount({required String password}) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AuthException('Please sign in again to continue.');
    }
    try {
      await user.delete();
    } on FirebaseAuthException catch (error) {
      if (error.code == 'requires-recent-login') {
        await _reauthenticate(user, password);
        await user.delete();
        return;
      }
      throw _exceptionMapper.map(error);
    }
  }

  AuthUser _requireUser(User? user) {
    final mapped = _userMapper.fromFirebase(user);
    if (mapped == null) {
      throw const AuthException('Something went wrong. Please try again.');
    }
    return mapped;
  }

  Future<void> _reauthenticate(User user, String password) async {
    final email = user.email;
    if (email == null) {
      throw const AuthException('Please sign in again to continue.');
    }
    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (error) {
      throw _exceptionMapper.map(error);
    }
  }
}