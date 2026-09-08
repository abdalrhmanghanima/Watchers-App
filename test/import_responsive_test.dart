import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/core/theme/app_theme.dart';
import 'package:watchers/data/models/imported_stats.dart';
import 'package:watchers/features/import/import_ready_screen.dart';
import 'package:watchers/features/import/import_screen.dart';
import 'package:watchers/features/import/imported_stats_store.dart';

const _sizes = <(String, Size)>[
  ('small', Size(320, 568)),
  ('normal', Size(390, 844)),
  ('large', Size(430, 926)),
];

final _stats = ImportedUserStats(
  showsWatched: 114,
  episodesWatched: 6072,
  episodesWatchTime: const Duration(seconds: 9214800),
  moviesWatched: 437,
  movieWatchEvents: 441,
  moviesWatchTime: const Duration(seconds: 2903460),
  comments: 6,
  episodeRewatches: 15,
  rewatchedMovies: 4,
  episodeRatings: 500,
  movieRatings: 91,
  followedShows: 110,
  followedMovies: 547,
  toWatchMovies: 111,
);

void main() {
  setUp(() => ImportedStatsStore.instance.clear());
  tearDown(() => ImportedStatsStore.instance.clear());

  Widget wrap(Widget child) =>
      ProviderScope(child: MaterialApp(theme: AppTheme.dark(), home: child));

  Future<void> pumpSized(WidgetTester tester, Size size, Widget child) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(wrap(child));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  for (final (tierLabel, size) in _sizes) {
    testWidgets(
      'ImportScreen renders without overflow on a $tierLabel phone',
      (WidgetTester tester) async {
        await pumpSized(tester, size, const ImportScreen());
        expect(find.text('Import your Watchers history'), findsOneWidget);
        expect(find.text('Skip for now'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'ImportReadyScreen renders the summary without overflow on a '
      '$tierLabel phone',
      (WidgetTester tester) async {
        ImportedStatsStore.instance.handleImport(_stats);
        await pumpSized(tester, size, const ImportReadyScreen());
        expect(find.text('Your stats are ready'), findsOneWidget);
        expect(find.text('114'), findsOneWidget);
        expect(find.text('6072'), findsOneWidget);
        expect(find.text('437'), findsOneWidget);
        expect(find.text('140d 6h 11m'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}