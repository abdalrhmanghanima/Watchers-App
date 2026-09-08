import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/features/auth/data/errors/auth_exception_mapper.dart';
import 'package:watchers/features/auth/domain/errors/auth_exception.dart';

void main() {
  const mapper = AuthExceptionMapper();

  test('maps known Firebase codes to friendly messages', () {
    expect(
      mapper.map(FirebaseAuthException(code: 'email-already-in-use')),
      isA<AuthException>().having(
        (e) => e.message,
        'message',
        'An account with this email already exists.',
      ),
    );
    expect(
      mapper.map(FirebaseAuthException(code: 'invalid-email')),
      isA<AuthException>().having(
        (e) => e.message,
        'message',
        'Enter a valid email address.',
      ),
    );
    expect(
      mapper.map(FirebaseAuthException(code: 'weak-password')),
      isA<AuthException>().having(
        (e) => e.message,
        'message',
        'Use a password that is at least 6 characters.',
      ),
    );
    expect(
      mapper.map(FirebaseAuthException(code: 'invalid-credential')),
      isA<AuthException>().having(
        (e) => e.message,
        'message',
        'Incorrect email or password.',
      ),
    );
    expect(
      mapper.map(FirebaseAuthException(code: 'wrong-password')),
      isA<AuthException>().having(
        (e) => e.message,
        'message',
        'Incorrect email or password.',
      ),
    );
    expect(
      mapper.map(FirebaseAuthException(code: 'user-not-found')),
      isA<AuthException>().having(
        (e) => e.message,
        'message',
        'Incorrect email or password.',
      ),
    );
    expect(
      mapper.map(FirebaseAuthException(code: 'user-disabled')),
      isA<AuthException>().having(
        (e) => e.message,
        'message',
        'This account has been disabled.',
      ),
    );
    expect(
      mapper.map(FirebaseAuthException(code: 'too-many-requests')),
      isA<AuthException>().having(
        (e) => e.message,
        'message',
        'Too many attempts. Try again later.',
      ),
    );
    expect(
      mapper.map(FirebaseAuthException(code: 'network-request-failed')),
      isA<AuthException>().having(
        (e) => e.message,
        'message',
        'Network error. Check your connection and try again.',
      ),
    );
    expect(
      mapper.map(FirebaseAuthException(code: 'operation-not-allowed')),
      isA<AuthException>().having(
        (e) => e.message,
        'message',
        'This sign-in method is not enabled.',
      ),
    );
    expect(
      mapper.map(FirebaseAuthException(code: 'requires-recent-login')),
      isA<AuthException>().having(
        (e) => e.message,
        'message',
        'Please sign in again to confirm this action.',
      ),
    );
  });

  test('falls back to a generic message for unknown errors', () {
    expect(
      mapper.map(FirebaseAuthException(code: 'unknown-thing')),
      isA<AuthException>().having(
        (e) => e.message,
        'message',
        'Something went wrong. Please try again.',
      ),
    );
    expect(
      mapper.map(Exception('boom')),
      isA<AuthException>().having(
        (e) => e.message,
        'message',
        'Something went wrong. Please try again.',
      ),
    );
  });

  test('maps provider cancellation codes without an error message', () {
    expect(
      mapper.map(PlatformException(code: 'sign_in_canceled')),
      isA<AuthException>().having(
        (e) => e.cancelled,
        'cancelled',
        isTrue,
      ),
    );
    expect(
      mapper.map(PlatformException(code: 'sign_in_aborted')),
      isA<AuthException>().having(
        (e) => e.cancelled,
        'cancelled',
        isTrue,
      ),
    );
  });

  test('maps provider platform errors to friendly messages', () {
    expect(
      mapper.map(PlatformException(code: 'network_error')),
      isA<AuthException>().having(
        (e) => e.message,
        'message',
        'Network error. Check your connection and try again.',
      ),
    );
    expect(
      mapper.map(PlatformException(code: 'something-else')),
      isA<AuthException>().having(
        (e) => e.message,
        'message',
        'Something went wrong. Please try again.',
      ),
    );
  });

  test('maps account conflicts to a cross-provider hint', () {
    expect(
      mapper.map(FirebaseAuthException(code: 'account-exists-with-different-credential')),
      isA<AuthException>().having(
        (e) => e.message,
        'message',
        'An account already exists with this email. Sign in with that '
        'method instead.',
      ),
    );
  });
}