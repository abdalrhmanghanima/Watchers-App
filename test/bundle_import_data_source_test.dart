import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/data/models/imported_content.dart';
import 'package:watchers/data/models/raw_import_data.dart';
import 'package:watchers/data/repositories/imported_stats_repository.dart';
import 'package:watchers/data/services/imported_history_mapper.dart';
import 'package:watchers/data/services/imported_stats_calculator.dart';
import 'package:watchers/data/sources/bundle_import_data_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const sensitive = [
    'password',
    'passwd',
    'pwd',
    'token',
    'oauth',
    'api_key',
    'secret',
    'email',
    'phone',
    'ip_address',
    'device',
    'cookie',
    'user_id',
    'user_name',
    'username',
  ];

  test('bundle source loads every import table with expected sizes', () async {
    final data = await BundleImportDataSource().load();
    expect(data.table(ImportTables.trackingEpisodes), hasLength(6102));
    expect(data.table(ImportTables.trackingMovies), hasLength(1137));
    expect(data.table(ImportTables.watchedEpisodes), hasLength(109));
    expect(data.table(ImportTables.comments), hasLength(6));
    expect(data.table(ImportTables.ratingsEpisodes), hasLength(500));
    expect(data.table(ImportTables.ratingsMovies), hasLength(91));
    expect(data.table(ImportTables.followedShows), hasLength(118));
  });

  test('bundle tables contain no sensitive columns', () async {
    final data = await BundleImportDataSource().load();
    for (final table in data.tables.values) {
      for (final row in table) {
        for (final column in row.keys) {
          final lowered = column.toLowerCase();
          expect(
            sensitive.any(lowered.contains),
            isFalse,
            reason: 'sensitive column "$column" leaked into imported data',
          );
        }
      }
    }
  });

  test('no raw table stores values for non-importable columns', () async {
    final data = await BundleImportDataSource().load();
    for (final table in data.tables.values) {
      for (final row in table) {
        expect(row.length, lessThanOrEqualTo(8), reason: '$row');
        for (final value in row.values) {
          expect(value.length, lessThanOrEqualTo(512), reason: '$row');
        }
      }
    }
  });

  test('calculator matches the derived stats report', () async {
    final data = await BundleImportDataSource().load();
    final stats = const ImportedStatsCalculator().calculate(data);
    expect(stats.showsWatched, 114);
    expect(stats.episodesWatched, 6072);
    expect(stats.episodesWatchTime, const Duration(seconds: 9214800));
    expect(stats.moviesWatched, 437);
    expect(stats.movieWatchEvents, 441);
    expect(stats.moviesWatchTime, const Duration(seconds: 2903460));
    expect(stats.comments, 6);
    expect(stats.episodeRewatches, 15);
    expect(stats.rewatchedMovies, 4);
    expect(stats.episodeRatings, 500);
    expect(stats.movieRatings, 91);
    expect(stats.followedShows, 110);
    expect(stats.followedMovies, 547);
    expect(stats.toWatchMovies, 111);
    expect(stats.totalWatchTime, const Duration(seconds: 12118260));
  });

  test('history mapper ignores the non-tracked watched_episodes table', () async {
    final data = await BundleImportDataSource().load();
    final history = const ImportedHistoryMapper().map(data);
    expect(history.isEmpty, isFalse);
    expect(history.watchedEpisodes, isNotEmpty);
  });

  test('repository imports the bundled dataset end to end', () async {
    final repository = LocalDatasetImportRepository();
    final stats = await repository.importStats();
    final history = await repository.importHistory();
    expect(stats.episodesWatched, 6072);
    expect(stats.isEmpty, isFalse);
    expect(history, isA<ImportedContentHistory>());
    expect(history.watchedEpisodes.length, stats.episodesWatched);
  });
}