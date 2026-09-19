import 'package:watchers/features/tmdb/data/http/tmdb_api_client.dart';
import 'package:watchers/features/tmdb/data/http/tmdb_api_response.dart';
import 'package:watchers/features/tmdb/domain/errors/tmdb_exception.dart';

class FakeTmdbApiClient implements TmdbApiClient {
  FakeTmdbApiClient({Map<String, dynamic>? responses, this.failWith})
      : responses = responses ?? <String, dynamic>{};

  final Map<String, dynamic> responses;
  TmdbException? failWith;
  final List<String> requestedPaths = [];
  final List<Map<String, dynamic>?> requestedQuery = [];

  void enqueue(String path, dynamic body) {
    responses[path] = body;
  }

  @override
  Future<TmdbApiResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    requestedPaths.add(path);
    requestedQuery.add(queryParameters);
    final failure = failWith;
    if (failure != null) {
      throw failure;
    }
    final body = responses[path];
    if (body == null) {
      return const TmdbApiResponse(statusCode: 200, data: <String, dynamic>{});
    }
    return TmdbApiResponse(statusCode: 200, data: body);
  }
}
