import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/core/tmdb/tmdb_image_url_builder.dart';

void main() {
  const base = 'https://image.tmdb.org/t/p/';
  final builder = TmdbImageUrlBuilder(imageBaseUrl: base);

  group('TmdbImageUrlBuilder', () {
    test('builds a poster URL', () {
      expect(builder.poster('/abc123.jpg'), '${base}w342/abc123.jpg');
    });

    test('builds a backdrop URL', () {
      expect(builder.backdrop('/abc123.jpg'), '${base}w1280/abc123.jpg');
    });

    test('builds a profile URL', () {
      expect(builder.profile('/abc123.jpg'), '${base}w185/abc123.jpg');
    });

    test('strips a leading slash from the path', () {
      expect(builder.poster('abc123.jpg'), '${base}w342/abc123.jpg');
    });

    test('returns null for a null path', () {
      expect(builder.poster(null), isNull);
      expect(builder.backdrop(null), isNull);
      expect(builder.profile(null), isNull);
    });

    test('returns null for an empty path', () {
      expect(builder.poster(''), isNull);
      expect(builder.backdrop(''), isNull);
      expect(builder.profile(''), isNull);
    });

    test('supports explicit poster sizes', () {
      expect(
        builder.poster('/p.jpg', size: TmdbImageSize.posterLarge),
        '${base}w500/p.jpg',
      );
      expect(
        builder.poster('/p.jpg', size: TmdbImageSize.posterOriginal),
        '${base}original/p.jpg',
      );
    });

    test('supports explicit backdrop sizes', () {
      expect(
        builder.backdrop('/b.jpg', size: TmdbImageSize.backdropMedium),
        '${base}w780/b.jpg',
      );
    });

    test('supports explicit profile sizes', () {
      expect(
        builder.profile('/pr.jpg', size: TmdbImageSize.profileLarge),
        '${base}h632/pr.jpg',
      );
    });

    test('builds a still URL', () {
      expect(builder.still('/still.jpg'), '${base}w185/still.jpg');
    });

    test('supports explicit still sizes', () {
      expect(
        builder.still('/still.jpg', size: TmdbImageSize.stillOriginal),
        '${base}original/still.jpg',
      );
      expect(
        builder.still('/still.jpg', size: TmdbImageSize.stillSmall),
        '${base}w92/still.jpg',
      );
      expect(
        builder.still('/still.jpg', size: TmdbImageSize.stillLarge),
        '${base}w300/still.jpg',
      );
    });

    test('returns null for a null or empty still path', () {
      expect(builder.still(null), isNull);
      expect(builder.still(''), isNull);
    });

    test('falls back to a still size for a mismatched still call', () {
      expect(
        builder.still('/still.jpg', size: TmdbImageSize.posterSmall),
        '${base}w185/still.jpg',
      );
    });

    test('falls back to a poster size for a mismatched poster call', () {
      expect(
        builder.poster('/p.jpg', size: TmdbImageSize.backdropLarge),
        '${base}w342/p.jpg',
      );
    });

    test('falls back to a backdrop size for a mismatched backdrop call', () {
      expect(
        builder.backdrop('/b.jpg', size: TmdbImageSize.posterSmall),
        '${base}w1280/b.jpg',
      );
    });

    test('falls back to a profile size for a mismatched profile call', () {
      expect(
        builder.profile('/pr.jpg', size: TmdbImageSize.posterSmall),
        '${base}w185/pr.jpg',
      );
    });
  });
}
