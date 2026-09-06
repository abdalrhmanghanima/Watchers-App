import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/app/watchers_app.dart';
import 'package:watchers/data/models/imported_stats.dart';
import 'package:watchers/features/import/imported_stats_store.dart';
import 'package:watchers/features/profile/widgets/profile_stats_card.dart';
import 'package:watchers/shared/navigation/app_router.dart';
import 'package:watchers/shared/widgets/gradient_button.dart';

void _setTallViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

Future<void> _goToProfile(WidgetTester tester) async {
  _setTallViewport(tester);
  AppRouter.instance.go('/');
  await tester.pumpWidget(const WatchersApp());
  await tester.pumpAndSettle();
  await tester.tap(find.text('Get Started'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).at(0), 'watcher@watchers.app');
  await tester.enterText(find.byType(TextField).at(1), 'watchers');
  await tester.tap(find.widgetWithText(GradientButton, 'Sign In'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('PROFILE'));
  await tester.pumpAndSettle();
}

final _imported = ImportedUserStats(
  showsWatched: 7,
  episodesWatched: 90,
  episodesWatchTime: const Duration(minutes: 130),
  moviesWatched: 4,
  movieWatchEvents: 5,
  moviesWatchTime: const Duration(minutes: 80),
  comments: 3,
  episodeRewatches: 2,
  rewatchedMovies: 0,
  episodeRatings: 10,
  movieRatings: 5,
  followedShows: 5,
  followedMovies: 2,
  toWatchMovies: 1,
);

void main() {
  setUp(() => ImportedStatsStore.instance.clear());
  tearDown(() => ImportedStatsStore.instance.clear());

  testWidgets('profile shows imported stats when an import exists', (
    WidgetTester tester,
  ) async {
    ImportedStatsStore.instance.handleImport(_imported);
    await _goToProfile(tester);

    expect(find.byType(ProfileStatsCard), findsNWidgets(5));
    expect(find.text('TV Shows'), findsOneWidget);
    expect(find.text('7'), findsWidgets);
    expect(find.text('Episodes Time'), findsOneWidget);
    expect(find.text('2h 10m'), findsWidgets);
    expect(find.text('Movies'), findsWidgets);
    expect(find.text('4'), findsWidgets);
    expect(find.text('Movies Time'), findsOneWidget);
    expect(find.text('1h 20m'), findsWidgets);
    expect(find.text('Comments'), findsOneWidget);
    expect(find.text('3'), findsWidgets);
  });

  testWidgets('profile falls back to local stats without an import', (
    WidgetTester tester,
  ) async {
    await _goToProfile(tester);

    expect(find.text('4h 6m'), findsWidgets);
    expect(find.text('2h 10m'), findsNothing);
    expect(find.text('TV Shows'), findsOneWidget);
  });

  testWidgets('importing later updates the profile immediately', (
    WidgetTester tester,
  ) async {
    await _goToProfile(tester);
    expect(find.text('4h 6m'), findsWidgets);

    ImportedStatsStore.instance.handleImport(_imported);
    await tester.pumpAndSettle();

    expect(find.text('2h 10m'), findsWidgets);
    expect(find.text('4h 6m'), findsNothing);
    expect(find.text('7'), findsWidgets);
  });

  testWidgets('clearing the import restores local stats', (
    WidgetTester tester,
  ) async {
    ImportedStatsStore.instance.handleImport(_imported);
    await _goToProfile(tester);
    expect(find.text('2h 10m'), findsWidgets);

    ImportedStatsStore.instance.clear();
    await tester.pumpAndSettle();

    expect(find.text('4h 6m'), findsWidgets);
    expect(find.text('2h 10m'), findsNothing);
  });
}