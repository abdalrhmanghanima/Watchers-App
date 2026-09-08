import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:watchers/core/theme/app_theme.dart';
import 'package:watchers/data/models/imported_content.dart';
import 'package:watchers/data/models/imported_stats.dart';
import 'package:watchers/data/repositories/imported_stats_repository.dart';
import 'package:watchers/features/import/import_controller.dart';
import 'package:watchers/features/import/import_ready_screen.dart';
import 'package:watchers/features/import/import_screen.dart';
import 'package:watchers/features/import/imported_stats_store.dart';

class _ShowsStub extends StatelessWidget {
  const _ShowsStub();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Shows')));
  }
}

class _FakeRepository implements ImportedStatsRepository {
  _FakeRepository(
    this.result, {
    this.shouldThrow = false,
    this.gate,
  });

  final ImportedUserStats result;
  final bool shouldThrow;
  final Completer<void>? gate;

  @override
  Future<ImportedUserStats> importStats() async {
    if (gate != null) await gate!.future;
    if (shouldThrow) throw Exception('import failed');
    return result;
  }

  @override
  Future<ImportedContentHistory> importHistory() async {
    return const ImportedContentHistory();
  }
}

class _DelegatingRepository implements ImportedStatsRepository {
  _DelegatingRepository(this._factory);

  final ImportedStatsRepository Function() _factory;

  @override
  Future<ImportedContentHistory> importHistory() async {
    return _factory().importHistory();
  }

  @override
  Future<ImportedUserStats> importStats() async {
    return _factory().importStats();
  }
}

final _stats = ImportedUserStats(
  showsWatched: 12,
  episodesWatched: 128,
  episodesWatchTime: const Duration(hours: 40, minutes: 30),
  moviesWatched: 34,
  movieWatchEvents: 36,
  moviesWatchTime: const Duration(hours: 18, minutes: 15),
  comments: 7,
  episodeRewatches: 3,
  rewatchedMovies: 1,
  episodeRatings: 50,
  movieRatings: 20,
  followedShows: 25,
  followedMovies: 10,
  toWatchMovies: 5,
);

void main() {
  setUp(() => ImportedStatsStore.instance.clear());
  tearDown(() => ImportedStatsStore.instance.clear());

  Future<void> pumpImport(
    WidgetTester tester,
    ImportedStatsRepository repository,
  ) async {
    final router = GoRouter(
      initialLocation: '/import',
      routes: [
        GoRoute(
          path: '/import',
          builder: (context, state) => const ImportScreen(),
        ),
        GoRoute(
          path: '/import/success',
          builder: (context, state) => const ImportReadyScreen(),
        ),
        GoRoute(path: '/shows', builder: (context, state) => const _ShowsStub()),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [importRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp.router(theme: AppTheme.dark(), routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('successful import lands on the ready screen with the summary', (
    WidgetTester tester,
  ) async {
    await pumpImport(tester, _FakeRepository(_stats));

    expect(find.text('Import your Watchers history'), findsOneWidget);
    expect(find.text('Skip for now'), findsOneWidget);

    await tester.tap(find.text('Import my stats'));
    await tester.pumpAndSettle();

    expect(find.text('Your stats are ready'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('34'), findsOneWidget);
    expect(find.text('128'), findsOneWidget);
    expect(find.text('2d 10h 45m'), findsOneWidget);
    expect(find.text('70'), findsOneWidget);
    expect(ImportedStatsStore.instance.hasImported, isTrue);
    expect(ImportedStatsStore.instance.stats, same(_stats));
  });

  testWidgets('import shows a loader until the data resolves', (
    WidgetTester tester,
  ) async {
    final gate = Completer<void>();
    await pumpImport(tester, _FakeRepository(_stats, gate: gate));

    await tester.tap(find.text('Import my stats'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Your stats are ready'), findsNothing);

    gate.complete();
    await tester.pumpAndSettle();

    expect(find.text('Your stats are ready'), findsOneWidget);
  });

  testWidgets('continue moves from the ready screen into the app', (
    WidgetTester tester,
  ) async {
    await pumpImport(tester, _FakeRepository(_stats));
    await tester.tap(find.text('Import my stats'));
    await tester.pumpAndSettle();
    final continueButton = find.text('Continue to Watchers');
    await tester.ensureVisible(continueButton);
    await tester.pumpAndSettle();
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    expect(find.text('Shows'), findsOneWidget);
    expect(ImportedStatsStore.instance.hasImported, isTrue);
  });

  testWidgets('skipping leaves the store empty and enters the app', (
    WidgetTester tester,
  ) async {
    await pumpImport(tester, _FakeRepository(_stats));

    await tester.tap(find.text('Skip for now'));
    await tester.pumpAndSettle();

    expect(find.text('Shows'), findsOneWidget);
    expect(ImportedStatsStore.instance.hasImported, isFalse);
  });

  testWidgets('a failed import shows an error and stays on the screen', (
    WidgetTester tester,
  ) async {
    await pumpImport(tester, _FakeRepository(_stats, shouldThrow: true));

    await tester.tap(find.text('Import my stats'));
    await tester.pumpAndSettle();

    expect(find.text('Import your Watchers history'), findsOneWidget);
    expect(
      find.text('Could not import your data. Please try again.'),
      findsOneWidget,
    );
    expect(ImportedStatsStore.instance.hasImported, isFalse);
  });

  testWidgets('a retry after failure can still succeed', (
    WidgetTester tester,
  ) async {
    var attempts = 0;
    await pumpImport(
      tester,
      _DelegatingRepository(() {
        attempts += 1;
        return _FakeRepository(_stats, shouldThrow: attempts == 1);
      }),
    );

    await tester.tap(find.text('Import my stats'));
    await tester.pumpAndSettle();
    expect(
      find.text('Could not import your data. Please try again.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Import my stats'));
    await tester.pumpAndSettle();
    expect(find.text('Your stats are ready'), findsOneWidget);
  });

  testWidgets('ready screen renders without stats as an empty state', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    ImportedStatsStore.instance.clear();
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.dark(), home: const ImportReadyScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Your stats are ready'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}