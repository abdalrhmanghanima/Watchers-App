import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/core/theme/app_theme.dart';
import 'package:watchers/data/sources/mock_content_repository.dart';
import 'package:watchers/features/movies/movie_list_screen.dart';
import 'package:watchers/features/movies/widgets/grid_cell.dart';
import 'package:watchers/features/movies/widgets/movie_grid.dart';
import 'package:watchers/features/movies/widgets/movies_hero.dart';
import 'package:watchers/shared/widgets/section_header.dart';

import 'helpers/auth_test_harness.dart';

void _setTallViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

Future<void> _goToMovies(WidgetTester tester) async {
  _setTallViewport(tester);
  final container = await pumpApp(tester);
  await goToShell(tester, container);
  await tester.tap(find.text('MOVIES'));
  await tester.pumpAndSettle();
}

Future<void> _tapSeeAll(WidgetTester tester, String sectionTitle) async {
  final titleFinder = find.text(sectionTitle);
  await tester.scrollUntilVisible(
    titleFinder,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  final header = find.ancestor(
    of: titleFinder,
    matching: find.byType(SectionHeader),
  );
  await tester.tap(find.descendant(of: header, matching: find.text('See all')));
  await tester.pumpAndSettle();
}

void main() {
  group('Movies sections', () {
    testWidgets(
      'Movies screen shows Top Rated instead of Critically Acclaimed',
      (WidgetTester tester) async {
        await _goToMovies(tester);

        expect(find.text('Now Playing'), findsOneWidget);
        expect(find.text('Top Rated'), findsOneWidget);
        expect(find.text('Critically Acclaimed'), findsNothing);
      },
    );

    testWidgets('all existing Movies sections still render', (
      WidgetTester tester,
    ) async {
      await _goToMovies(tester);

      expect(find.text('Now Playing'), findsOneWidget);
      expect(find.text('Top Rated'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Your Watchlist'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Your Watchlist'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('All Movies'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('All Movies'), findsOneWidget);
    });

    testWidgets('featured movie stays deterministic/static', (
      WidgetTester tester,
    ) async {
      await _goToMovies(tester);

      expect(find.text('Meridian'), findsOneWidget);
      expect(find.text('2024 · 2h 8m'), findsOneWidget);

      final hero = tester.widget<MoviesHero>(find.byType(MoviesHero));
      expect(hero.movie.id, 'meridian');
      expect(hero.movie.title, 'Meridian');
    });
  });

  group('Now Playing See All', () {
    testWidgets('opens the movie list screen with the matching title', (
      WidgetTester tester,
    ) async {
      await _goToMovies(tester);

      await _tapSeeAll(tester, 'Now Playing');

      expect(find.text('Now Playing'), findsOneWidget);
      expect(find.text('Top Rated'), findsNothing);
    });

    testWidgets('shows the Now Playing movies in a grid', (
      WidgetTester tester,
    ) async {
      await _goToMovies(tester);

      await _tapSeeAll(tester, 'Now Playing');

      expect(find.byType(MovieGrid), findsOneWidget);
      expect(find.byType(GridCell), findsWidgets);
      expect(find.text('The Forgotten Shore'), findsOneWidget);
      expect(find.text('Hollow City'), findsOneWidget);
      expect(find.text('Patterns'), findsNothing);
      expect(find.text('Aether'), findsNothing);
    });
  });

  group('Top Rated See All', () {
    testWidgets('opens the movie list screen with the matching title', (
      WidgetTester tester,
    ) async {
      await _goToMovies(tester);

      await _tapSeeAll(tester, 'Top Rated');

      expect(find.text('Top Rated'), findsOneWidget);
      expect(find.text('Now Playing'), findsNothing);
    });

    testWidgets('shows the Top Rated movies in a grid', (
      WidgetTester tester,
    ) async {
      await _goToMovies(tester);

      await _tapSeeAll(tester, 'Top Rated');

      expect(find.byType(MovieGrid), findsOneWidget);
      expect(find.byType(GridCell), findsWidgets);
      expect(find.text('Red Signal'), findsOneWidget);
      expect(find.text('Patterns'), findsOneWidget);
      expect(find.text('Aether'), findsOneWidget);
      expect(find.text('The Forgotten Shore'), findsNothing);
      expect(find.text('Hollow City'), findsNothing);
    });

    testWidgets('tapping a movie in the grid opens Movie Details', (
      WidgetTester tester,
    ) async {
      await _goToMovies(tester);

      await _tapSeeAll(tester, 'Top Rated');

      await tester.tap(find.text('Aether'));
      await tester.pumpAndSettle();

      expect(find.text('Aether'), findsOneWidget);
      expect(find.text('Synopsis'), findsOneWidget);
      expect(find.text('Cast'), findsOneWidget);
    });
  });

  group('Movie list screen', () {
    testWidgets('destination preserves the section identity', (
      WidgetTester tester,
    ) async {
      await _goToMovies(tester);

      await _tapSeeAll(tester, 'Now Playing');
      expect(find.text('Now Playing'), findsOneWidget);
      expect(find.text('Top Rated'), findsNothing);
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pumpAndSettle();

      await _tapSeeAll(tester, 'Top Rated');
      expect(find.text('Top Rated'), findsOneWidget);
      expect(find.text('Now Playing'), findsNothing);
    });
  });

  group('Responsive overflow', () {
    Widget wrap(Widget child) =>
        MaterialApp(theme: AppTheme.dark(), home: child);

    Future<void> pumpSized(WidgetTester tester, Size size, Widget child) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(wrap(child));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
    }

    const viewportSizes = <(String, Size)>[
      ('small', Size(320, 568)),
      ('normal', Size(390, 844)),
      ('large', Size(430, 926)),
    ];

    for (final (tierLabel, size) in viewportSizes) {
      testWidgets(
        'MovieListScreen renders without overflow on a $tierLabel phone',
        (WidgetTester tester) async {
          final movies = await MockContentRepository().getMovies();
          final list = movies.sublist(4, movies.length > 8 ? 8 : movies.length);
          final listScreen = MovieListScreen(title: 'Top Rated', movies: list);
          await pumpSized(tester, size, listScreen);
          expect(tester.takeException(), isNull);
          expect(find.text('Top Rated'), findsOneWidget);
          expect(find.byType(MovieGrid), findsOneWidget);
        },
      );
    }
  });
}
