class AuthException implements Exception {
  const AuthException(this.message, {this.cancelled = false});

  const AuthException.cancelled()
      : cancelled = true,
        message = 'The sign-in was cancelled.';

  final String message;
  final bool cancelled;

  @override
  String toString() => message;
}