import 'tmdb_api_response.dart';

abstract interface class TmdbApiClient {
  Future<TmdbApiResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  });
}
