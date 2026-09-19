import 'package:dio/dio.dart';

import '../../domain/errors/tmdb_exception.dart';
import 'tmdb_api_client.dart';
import 'tmdb_api_response.dart';
import 'tmdb_configuration.dart';

class DioTmdbApiClient implements TmdbApiClient {
  DioTmdbApiClient({required this.configuration, Dio? dio})
      : _dio = dio ?? _buildDio(configuration) {
    _dio.options.queryParameters['api_key'] = configuration.apiKey;
  }

  final TmdbConfiguration configuration;
  final Dio _dio;

  static Dio _buildDio(TmdbConfiguration configuration) {
    final dio = Dio(
      BaseOptions(
        baseUrl: configuration.baseUrl,
        connectTimeout: configuration.timeout,
        receiveTimeout: configuration.timeout,
        sendTimeout: configuration.timeout,
        queryParameters: {'api_key': configuration.apiKey},
        headers: {'Accept': 'application/json'},
      ),
    );
    return dio;
  }

  @override
  Future<TmdbApiResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    _assertConfigured();
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );
      return TmdbApiResponse(
        statusCode: response.statusCode ?? 200,
        data: response.data,
      );
    } on DioException catch (error) {
      throw _mapError(error);
    }
  }

  void _assertConfigured() {
    if (!configuration.hasApiKey) {
      throw const TmdbException.configuration();
    }
  }

  TmdbException _mapError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const TmdbException.timeout();
    }
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.unknown) {
      return const TmdbException.network();
    }
    final statusCode = error.response?.statusCode;
    switch (statusCode) {
      case 401:
        return const TmdbException.unauthorized();
      case 403:
        return const TmdbException.forbidden();
      case 404:
        return const TmdbException.notFound();
      case 429:
        return const TmdbException.rateLimited();
      default:
        if (statusCode != null && statusCode >= 500) {
          return const TmdbException.server();
        }
        return const TmdbException.network();
    }
  }
}
