import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/features/tmdb/data/http/tmdb_configuration.dart';

void main() {
  group('TmdbConfiguration', () {
    test('exposes a valid API configuration', () {
      const config = TmdbConfiguration(
        apiKey: 'test-key',
        baseUrl: 'https://api.themoviedb.org/3/',
        imageBaseUrl: 'https://image.tmdb.org/t/p/',
      );

      expect(config.hasApiKey, isTrue);
      expect(config.apiKey, 'test-key');
      expect(config.baseUrl, 'https://api.themoviedb.org/3/');
      expect(config.imageBaseUrl, 'https://image.tmdb.org/t/p/');
    });

    test('missing API key is reported as not configured', () {
      const config = TmdbConfiguration(
        apiKey: '',
        baseUrl: 'https://api.themoviedb.org/3/',
        imageBaseUrl: 'https://image.tmdb.org/t/p/',
      );

      expect(config.hasApiKey, isFalse);
    });

    test('whitespace-only API key is not configured', () {
      const config = TmdbConfiguration(
        apiKey: '   ',
        baseUrl: 'https://api.themoviedb.org/3/',
        imageBaseUrl: 'https://image.tmdb.org/t/p/',
      );

      expect(config.hasApiKey, isFalse);
    });

    test('default timeout is used when not specified', () {
      const config = TmdbConfiguration(
        apiKey: 'key',
        baseUrl: 'https://api.themoviedb.org/3/',
        imageBaseUrl: 'https://image.tmdb.org/t/p/',
      );

      expect(config.timeout, const Duration(seconds: 15));
    });
  });

  group('fromEnvironment', () {
    test('uses an empty API key when not defined', () {
      final config = TmdbConfiguration.fromEnvironment();

      expect(config.hasApiKey, isFalse);
      expect(config.baseUrl, 'https://api.themoviedb.org/3/');
      expect(config.imageBaseUrl, 'https://image.tmdb.org/t/p/');
    });
  });

  group('normalizeBaseUrl', () {
    test('appends a trailing slash to a URL without one', () {
      expect(normalizeBaseUrl('https://api.themoviedb.org/3'),
          'https://api.themoviedb.org/3/');
      expect(normalizeBaseUrl('https://image.tmdb.org/t/p'),
          'https://image.tmdb.org/t/p/');
    });

    test('keeps a URL that already ends in a slash unchanged', () {
      expect(normalizeBaseUrl('https://api.themoviedb.org/3/'),
          'https://api.themoviedb.org/3/');
    });

    test('trims surrounding whitespace before normalizing', () {
      expect(normalizeBaseUrl('  https://api.themoviedb.org/3  '),
          'https://api.themoviedb.org/3/');
    });

    test('returns an empty string unchanged', () {
      expect(normalizeBaseUrl(''), '');
    });
  });
}
