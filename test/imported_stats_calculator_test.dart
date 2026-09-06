import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/data/models/raw_import_data.dart';
import 'package:watchers/data/services/imported_stats_calculator.dart';

RawImportData _build({
  List<Map<String, String>> episodes = const [],
  List<Map<String, String>> movies = const [],
  List<Map<String, String>> followedShows = const [],
  List<Map<String, String>> comments = const [],
  List<Map<String, String>> episodeRatings = const [],
  List<Map<String, String>> movieRatings = const [],
}) {
  return RawImportData(tables: {
    ImportTables.trackingEpisodes: episodes,
    ImportTables.trackingMovies: movies,
    ImportTables.followedShows: followedShows,
    ImportTables.comments: comments,
    ImportTables.ratingsEpisodes: episodeRatings,
    ImportTables.ratingsMovies: movieRatings,
  });
}

void main() {
  const calculator = ImportedStatsCalculator();

  test('computes totals from known episode rows', () {
    final data = _build(episodes: const [
      {
        'record_type': 'watch',
        'series_name': 'The Agency',
        'season_number': '1',
        'episode_number': '1',
        'runtime': '600',
      },
      {
        'record_type': 'watch',
        'series_name': 'The Agency',
        'season_number': '1',
        'episode_number': '2',
        'runtime': '900',
      },
      {
        'record_type': 'watch',
        'series_name': 'Night Protocol',
        'season_number': '2',
        'episode_number': '1',
        'runtime': '300',
      },
      {
        'record_type': 'rewatch',
        'series_name': 'The Agency',
        'season_number': '1',
        'episode_number': '1',
        'runtime': '600',
      },
      {
        'record_type': 'rewatch',
        'series_name': 'The Agency',
        'season_number': '1',
        'episode_number': '2',
        'runtime': '600',
      },
    ]);
    final stats = calculator.calculate(data);
    expect(stats.showsWatched, 2);
    expect(stats.episodesWatched, 3);
    expect(stats.episodesWatchTime, const Duration(seconds: 1800));
    expect(stats.episodeRewatches, 2);
    expect(stats.isEmpty, isFalse);
  });

  test('counts rewatched episodes as distinct show/season/episode', () {
    final data = _build(episodes: const [
      {
        'record_type': 'rewatch',
        'series_name': 'A',
        'season_number': '1',
        'episode_number': '1',
        'runtime': '600',
      },
      {
        'record_type': 'rewatch',
        'series_name': 'A',
        'season_number': '1',
        'episode_number': '1',
        'runtime': '600',
      },
    ]);
    final stats = calculator.calculate(data);
    expect(stats.episodeRewatches, 1);
    expect(stats.episodesWatched, 0);
  });

  test('computes movie stats from known movie rows', () {
    final data = _build(movies: [
      {'type': 'watch', 'movie_name': 'Dune', 'runtime': '1200'},
      {'type': 'watch', 'movie_name': 'Arrival', 'runtime': '600'},
      {'type': 'watch', 'movie_name': 'Dune', 'runtime': '1200'},
      {'type': 'rewatch', 'movie_name': 'Dune'},
      {'type': 'follow', 'movie_name': 'Blade Runner'},
      {'type': 'towatch', 'movie_name': '2049'},
    ]);
    final stats = calculator.calculate(data);
    expect(stats.moviesWatched, 2);
    expect(stats.movieWatchEvents, 3);
    expect(stats.moviesWatchTime, const Duration(seconds: 3000));
    expect(stats.rewatchedMovies, 1);
    expect(stats.followedMovies, 1);
    expect(stats.toWatchMovies, 1);
  });

  test('counts a movie as rewatched only when rewatch_count is positive', () {
    final data = _build(movies: const [
      {'type': 'rewatch_count', 'movie_name': 'Dune', 'rewatch_count': '2'},
      {'type': 'rewatch_count', 'movie_name': 'Arrival', 'rewatch_count': '0'},
    ]);
    final stats = calculator.calculate(data);
    expect(stats.rewatchedMovies, 1);
  });

  test('ignores empty movie names and treats invalid runtime as zero', () {
    final data = _build(movies: [
      {'type': 'watch', 'movie_name': '', 'runtime': '1200'},
      {'type': 'watch', 'movie_name': 'Dune', 'runtime': 'not-a-number'},
      {'type': 'follow', 'movie_name': ''},
    ]);
    final stats = calculator.calculate(data);
    expect(stats.moviesWatched, 1);
    expect(stats.moviesWatchTime, Duration.zero);
    expect(stats.followedMovies, 0);
  });

  test('counts only active distinct followed shows', () {
    final data = _build(followedShows: const [
      {'tv_show_name': 'A', 'active': '1'},
      {'tv_show_name': 'A', 'active': '1'},
      {'tv_show_name': 'B', 'active': '0'},
      {'tv_show_name': '', 'active': '1'},
    ]);
    final stats = calculator.calculate(data);
    expect(stats.followedShows, 1);
  });

  test('sums comments and ratings from table sizes', () {
    final data = _build(
      comments: const [{'comment': 'one'}, {'comment': 'two'}],
      episodeRatings: const [{'vote': '1'}],
      movieRatings: const [
        {'vote': '1'},
        {'vote': '2'},
      ],
    );
    final stats = calculator.calculate(data);
    expect(stats.comments, 2);
    expect(stats.episodeRatings, 1);
    expect(stats.movieRatings, 2);
    expect(stats.totalRatings, 3);
  });

  test('empty data produces empty (all-zero) stats', () {
    final stats = calculator.calculate(_build());
    expect(stats.isEmpty, isTrue);
    expect(stats.showsWatched, 0);
    expect(stats.episodesWatched, 0);
    expect(stats.episodesWatchTime, Duration.zero);
    expect(stats.moviesWatched, 0);
    expect(stats.movieWatchEvents, 0);
    expect(stats.moviesWatchTime, Duration.zero);
    expect(stats.comments, 0);
    expect(stats.episodeRewatches, 0);
    expect(stats.rewatchedMovies, 0);
    expect(stats.episodeRatings, 0);
    expect(stats.movieRatings, 0);
    expect(stats.followedShows, 0);
    expect(stats.followedMovies, 0);
    expect(stats.toWatchMovies, 0);
    expect(stats.totalWatchTime, Duration.zero);
  });

  test('totalWatchTime combines episode and movie watch time', () {
    final data = _build(
      episodes: const [
        {
          'record_type': 'watch',
          'series_name': 'A',
          'season_number': '1',
          'episode_number': '1',
          'runtime': '600',
        },
      ],
      movies: const [
        {'type': 'watch', 'movie_name': 'Dune', 'runtime': '1200'},
      ],
    );
    final stats = calculator.calculate(data);
    expect(stats.totalWatchTime, const Duration(seconds: 1800));
  });
}