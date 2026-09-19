enum TmdbErrorType {
  configuration,
  network,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  rateLimited,
  server,
  malformedResponse,
  unknown,
}

class TmdbException implements Exception {
  const TmdbException(this.type, this.message, {this.statusCode});

  const TmdbException.configuration()
      : type = TmdbErrorType.configuration,
        message = 'TMDB is not configured. Add an API key to continue.',
        statusCode = null;

  const TmdbException.network()
      : type = TmdbErrorType.network,
        message = 'Network error. Check your connection and try again.',
        statusCode = null;

  const TmdbException.timeout()
      : type = TmdbErrorType.timeout,
        message = 'The request timed out. Try again.',
        statusCode = null;

  const TmdbException.unauthorized()
      : type = TmdbErrorType.unauthorized,
        message = 'TMDB authentication failed. Check your API key.',
        statusCode = 401;

  const TmdbException.forbidden()
      : type = TmdbErrorType.forbidden,
        message = 'Access to TMDB is forbidden. Check your API configuration.',
        statusCode = 403;

  const TmdbException.notFound()
      : type = TmdbErrorType.notFound,
        message = 'The requested content could not be found.',
        statusCode = 404;

  const TmdbException.rateLimited()
      : type = TmdbErrorType.rateLimited,
        message = 'Too many requests. Try again later.',
        statusCode = 429;

  const TmdbException.server()
      : type = TmdbErrorType.server,
        message = 'TMDB is having issues. Try again later.',
        statusCode = null;

  const TmdbException.malformedResponse()
      : type = TmdbErrorType.malformedResponse,
        message = 'The response from TMDB could not be read.',
        statusCode = null;

  const TmdbException.unknown()
      : type = TmdbErrorType.unknown,
        message = 'Something went wrong. Please try again.',
        statusCode = null;

  final TmdbErrorType type;
  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}
