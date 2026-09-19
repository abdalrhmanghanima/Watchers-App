import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/features/tmdb/data/http/dio_tmdb_api_client.dart';
import 'package:watchers/features/tmdb/data/http/tmdb_configuration.dart';
import 'package:watchers/features/tmdb/domain/errors/tmdb_exception.dart';

class _StubAdapter implements HttpClientAdapter {
  Future<ResponseBody> Function(RequestOptions options)? handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final current = handler;
    if (current == null) {
      return ResponseBody.fromString('{}', 200);
    }
    return current(options);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late Dio dio;
  late _StubAdapter adapter;
  late DioTmdbApiClient client;

  const config = TmdbConfiguration(
    apiKey: 'test-key',
    baseUrl: 'https://api.themoviedb.org/3',
    imageBaseUrl: 'https://image.tmdb.org/t/p/',
  );

  setUp(() {
    dio = Dio();
    adapter = _StubAdapter();
    dio.httpClientAdapter = adapter;
    client = DioTmdbApiClient(configuration: config, dio: dio);
  });

  group('DioTmdbApiClient', () {
    test('performs a successful request and returns the data', () async {
      adapter.handler = (options) async {
        return ResponseBody.fromString(
          '{"hello":"world"}',
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      };

      final response = await client.get('/movie/popular');

      expect(response.statusCode, 200);
      expect((response.data as Map<String, dynamic>)['hello'], 'world');
    });

    test('passes query parameters along to the request', () async {
      Map<String, dynamic>? receivedQuery;
      adapter.handler = (options) async {
        receivedQuery = options.queryParameters;
        return ResponseBody.fromString('{}', 200);
      };

      await client.get('/search/movie', queryParameters: {'query': 'test'});

      expect(receivedQuery, {
        'api_key': 'test-key',
        'query': 'test',
      });
    });

    test('attaches the API key to every request', () async {
      Map<String, dynamic>? combinedQuery;
      adapter.handler = (options) async {
        combinedQuery = options.queryParameters;
        return ResponseBody.fromString('{}', 200);
      };

      await client.get('/movie/popular');

      expect(combinedQuery, containsPair('api_key', 'test-key'));
    });

    test('throws a configuration error when the API key is missing', () async {
      const missingConfig = TmdbConfiguration(
        apiKey: '',
        baseUrl: 'https://api.themoviedb.org/3',
        imageBaseUrl: 'https://image.tmdb.org/t/p/',
      );
      final missingClient = DioTmdbApiClient(
        configuration: missingConfig,
        dio: dio,
      );

      await expectLater(
        missingClient.get('/movie/popular'),
        throwsA(isA<TmdbException>()
            .having((e) => e.type, 'type', TmdbErrorType.configuration)),
      );
    });

    test('throws a timeout error on connection timeouts', () async {
      adapter.handler = (options) async {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionTimeout,
        );
      };

      await expectLater(
        client.get('/movie/popular'),
        throwsA(isA<TmdbException>()
            .having((e) => e.type, 'type', TmdbErrorType.timeout)),
      );
    });

    test('throws a timeout error on receive timeouts', () async {
      adapter.handler = (options) async {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.receiveTimeout,
        );
      };

      await expectLater(
        client.get('/movie/popular'),
        throwsA(isA<TmdbException>()
            .having((e) => e.type, 'type', TmdbErrorType.timeout)),
      );
    });

    test('throws a network error on connection failures', () async {
      adapter.handler = (options) async {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
        );
      };

      await expectLater(
        client.get('/movie/popular'),
        throwsA(isA<TmdbException>()
            .having((e) => e.type, 'type', TmdbErrorType.network)),
      );
    });

    test('maps HTTP 401 to unauthorized', () async {
      await expectLater(
        _erroring(client, adapter, 401),
        throwsA(isA<TmdbException>()
            .having((e) => e.type, 'type', TmdbErrorType.unauthorized)
            .having((e) => e.statusCode, 'statusCode', 401)),
      );
    });

    test('maps HTTP 403 to forbidden', () async {
      await expectLater(
        _erroring(client, adapter, 403),
        throwsA(isA<TmdbException>()
            .having((e) => e.type, 'type', TmdbErrorType.forbidden)),
      );
    });

    test('maps HTTP 404 to not found', () async {
      await expectLater(
        _erroring(client, adapter, 404),
        throwsA(isA<TmdbException>()
            .having((e) => e.type, 'type', TmdbErrorType.notFound)),
      );
    });

    test('maps HTTP 429 to rate limited', () async {
      await expectLater(
        _erroring(client, adapter, 429),
        throwsA(isA<TmdbException>()
            .having((e) => e.type, 'type', TmdbErrorType.rateLimited)),
      );
    });

    test('maps HTTP 500 to a server error', () async {
      await expectLater(
        _erroring(client, adapter, 500),
        throwsA(isA<TmdbException>()
            .having((e) => e.type, 'type', TmdbErrorType.server)),
      );
    });

    test('maps non-5xx bad responses to a network error', () async {
      await expectLater(
        _erroring(client, adapter, 418),
        throwsA(isA<TmdbException>()
            .having((e) => e.type, 'type', TmdbErrorType.network)),
      );
    });
  });
}

Future<Object> _erroring(
  DioTmdbApiClient client,
  _StubAdapter adapter,
  int statusCode,
) async {
  adapter.handler = (options) async {
    throw DioException(
      requestOptions: options,
      type: DioExceptionType.badResponse,
      response: Response<dynamic>(
        requestOptions: options,
        statusCode: statusCode,
        data: '{}',
      ),
    );
  };
  return client.get('/movie/popular');
}
