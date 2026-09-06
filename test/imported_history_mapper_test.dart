import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/data/models/imported_content.dart';
import 'package:watchers/data/models/raw_import_data.dart';
import 'package:watchers/data/services/imported_history_mapper.dart';

void main() {
  const mapper = ImportedHistoryMapper();

  test('normalizes episode watch rows into records', () {
    final data = RawImportData(tables: {
      ImportTables.trackingEpisodes: const [
        {
          'record_type': 'watch',
          'series_name': 'The Agency',
          'season_number': '1',
          'episode_number': '1',
          'runtime': '600',
          'created_at': '2025-06-25 15:46:34',
        },
      ],
      ImportTables.trackingMovies: const [],
      ImportTables.followedShows: const [],
      ImportTables.comments: const [],
      ImportTables.ratingsEpisodes: const [],
      ImportTables.ratingsMovies: const [],
    });
    final history = mapper.map(data);
    expect(history.isEmpty, isFalse);
    expect(history.watchedEpisodes, hasLength(1));
    final record = history.watchedEpisodes.single;
    expect(record.showTitle, 'The Agency');
    expect(record.season, 1);
    expect(record.episode, 1);
    expect(record.runtime, 600);
    expect(record.watchedAt, DateTime(2025, 6, 25, 15, 46, 34));
  });

  test('skips watch rows without a series name', () {
    final data = RawImportData(tables: {
      ImportTables.trackingEpisodes: const [
        {
          'record_type': 'watch',
          'series_name': '',
          'season_number': '1',
          'episode_number': '1',
          'runtime': '600',
        },
        {
          'record_type': 'watch',
          'series_name': 'A',
          'season_number': '1',
          'episode_number': '1',
          'runtime': '600',
        },
      ],
      ImportTables.trackingMovies: const [],
      ImportTables.followedShows: const [],
      ImportTables.comments: const [],
      ImportTables.ratingsEpisodes: const [],
      ImportTables.ratingsMovies: const [],
    });
    final history = mapper.map(data);
    expect(history.watchedEpisodes, hasLength(1));
    expect(history.watchedEpisodes.single.showTitle, 'A');
  });

  test('maps movie rows by kind and ignores unknown types', () {
    final data = RawImportData(tables: {
      ImportTables.trackingEpisodes: const [],
      ImportTables.trackingMovies: [
        {'type': 'watch', 'movie_name': 'Dune', 'runtime': '1200'},
        {'type': 'follow', 'movie_name': 'Arrival'},
        {'type': 'rewatch_count', 'movie_name': 'Dune', 'rewatch_count': '2'},
        {'type': 'mystery', 'movie_name': 'Ghost'},
        {'type': 'towatch', 'movie_name': ''},
      ],
      ImportTables.followedShows: const [],
      ImportTables.comments: const [],
      ImportTables.ratingsEpisodes: const [],
      ImportTables.ratingsMovies: const [],
    });
    final history = mapper.map(data);
    expect(history.movies, hasLength(3));
    expect(history.movies[0].kind, ImportedMovieKind.watched);
    expect(history.movies[1].kind, ImportedMovieKind.followed);
    expect(history.movies[2].kind, ImportedMovieKind.rewatchedCount);
    expect(history.movies[2].rewatchCount, 2);
  });

  test('maps followed shows and drops unknown-named rows', () {
    final data = RawImportData(tables: {
      ImportTables.trackingEpisodes: const [],
      ImportTables.trackingMovies: const [],
      ImportTables.followedShows: const [
        {'tv_show_name': 'A', 'active': '1'},
        {'tv_show_name': 'B', 'active': '0'},
        {'tv_show_name': '', 'active': '1'},
      ],
      ImportTables.comments: const [],
      ImportTables.ratingsEpisodes: const [],
      ImportTables.ratingsMovies: const [],
    });
    final history = mapper.map(data);
    expect(history.followedShows, hasLength(2));
    expect(history.followedShows[0].active, isTrue);
    expect(history.followedShows[1].active, isFalse);
  });

  test('skips comments with empty text', () {
    final data = RawImportData(tables: {
      ImportTables.trackingEpisodes: const [],
      ImportTables.trackingMovies: const [],
      ImportTables.followedShows: const [],
      ImportTables.comments: const [
        {'comment': '', 'nb_likes': '1', 'nb_points': '2'},
        {'comment': 'finally', 'nb_likes': '0', 'nb_points': '0'},
      ],
      ImportTables.ratingsEpisodes: const [],
      ImportTables.ratingsMovies: const [],
    });
    final history = mapper.map(data);
    expect(history.comments, hasLength(1));
    expect(history.comments.single.text, 'finally');
  });

  test('maps ratings rows for episodes and movies', () {
    final data = RawImportData(tables: {
      ImportTables.trackingEpisodes: const [],
      ImportTables.trackingMovies: const [],
      ImportTables.followedShows: const [],
      ImportTables.comments: const [],
      ImportTables.ratingsEpisodes: const [
        {'series_name': 'A', 'season_number': '1', 'episode_number': '2', 'vote': '9'},
      ],
      ImportTables.ratingsMovies: const [
        {'movie_name': 'Dune', 'vote': '8'},
      ],
    });
    final history = mapper.map(data);
    expect(history.episodeRatings.single.showTitle, 'A');
    expect(history.episodeRatings.single.value, 9);
    expect(history.movieRatings.single.title, 'Dune');
    expect(history.movieRatings.single.value, 8);
  });

  test('empty data maps to an empty normalized history', () {
    final history = mapper.map(RawImportData(tables: const {}));
    expect(history.isEmpty, isTrue);
    expect(history.watchedEpisodes, isEmpty);
    expect(history.movies, isEmpty);
    expect(history.followedShows, isEmpty);
    expect(history.comments, isEmpty);
    expect(history.episodeRatings, isEmpty);
    expect(history.movieRatings, isEmpty);
  });
}