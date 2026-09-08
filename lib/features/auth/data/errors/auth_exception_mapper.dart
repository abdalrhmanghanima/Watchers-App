import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../../domain/errors/auth_exception.dart';

class AuthExceptionMapper {
  const AuthExceptionMapper();

  AuthException map(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return const AuthException(
            'An account with this email already exists.',
          );
        case 'invalid-email':
          return const AuthException('Enter a valid email address.');
        case 'weak-password':
          return const AuthException(
            'Use a password that is at least 6 characters.',
          );
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          return const AuthException('Incorrect email or password.');
        case 'user-disabled':
          return const AuthException('This account has been disabled.');
        case 'too-many-requests':
          return const AuthException('Too many attempts. Try again later.');
        case 'network-request-failed':
          return const AuthException(
            'Network error. Check your connection and try again.',
          );
        case 'operation-not-allowed':
          return const AuthException('This sign-in method is not enabled.');
        case 'requires-recent-login':
          return const AuthException(
            'Please sign in again to confirm this action.',
          );
        case 'account-exists-with-different-credential':
          return const AuthException(
            'An account already exists with this email. Sign in with that '
            'method instead.',
          );
        default:
          return const AuthException('Something went wrong. Please try again.');
      }
    }
    if (error is PlatformException) {
      switch (error.code) {
        case 'sign_in_canceled':
        case 'sign_in_aborted':
          return const AuthException.cancelled();
        case 'network_error':
          return const AuthException(
            'Network error. Check your connection and try again.',
          );
        case 'sign_in_required':
          return const AuthException('Sign in was not completed.');
        default:
          return const AuthException('Something went wrong. Please try again.');
      }
    }
    return const AuthException('Something went wrong. Please try again.');
  }
}