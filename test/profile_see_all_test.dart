import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/core/theme/app_theme.dart';
import 'package:watchers/features/profile/watched_movies_screen.dart';
import 'package:watchers/features/profile/watched_shows_screen.dart';
import 'package:watchers/features/profile/watchlist_screen.dart';

import 'helpers/auth_test_harness.dart';

void _setTallViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

Future<void> _goToProfile(WidgetTester tester) async {
  _setTallViewport(tester);
  final container = await pumpApp(tester);
  await goToProfile(tester, container);
}

Future<void> _scrollItemClearOfNavBar(
  WidgetTester tester,
  Finder scrollable,
  Finder item,
) async {
  await tester.scrollUntilVisible(item, 200, scrollable: scrollable);
  final bottomEdge = tester.getRect(scrollable).bottom;
  var guard = 0;
  while (guard < 20 && tester.getRect(item).bottom > bottomEdge - 80) {
    await tester.drag(scrollable, const Offset(0, -80));
    await tester.pumpAndSettle();
    guard += 1;
  }
}

void main() {
  group('Watchlist See All', () {
    testWidgets('watchlist See all opens Watchlist screen', (
      WidgetTester tester,
    ) async {
      await _goToProfile(tester);

      final seeAll = find.text('See all').first;
      await tester.tap(seeAll);
      await tester.pumpAndSettle();

      expect(find.text('Watchlist'), findsOneWidget);
      expect(find.text('Movies'), findsOneWidget);
      expect(find.text('Shows'), findsWidgets);
    });

    testWidgets('watchlist Movies tab displays movie grid', (
      WidgetTester tester,
    ) async {
      await _goToProfile(tester);

      await tester.tap(find.text('See all').first);
      await tester.pumpAndSettle();

      expect(find.text('Hollow City'), findsOneWidget);
      expect(find.text('Patterns'), findsOneWidget);
      expect(find.text('Aether'), findsOneWidget);
    });

    testWidgets('watchlist Shows tab displays show grid', (
      WidgetTester tester,
    ) async {
      await _goToProfile(tester);

      await tester.tap(find.text('See all').first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Shows').last);
      await tester.pumpAndSettle();

      expect(find.text('Night Protocol'), findsOneWidget);
      expect(find.text('Accord'), findsOneWidget);
      expect(find.text('Liminal'), findsOneWidget);
    });

    testWidgets('movie in Watchlist opens Movie Detail', (
      WidgetTester tester,
    ) async {
      await _goToProfile(tester);

      await tester.tap(find.text('See all').first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Hollow City'));
      await tester.pumpAndSettle();

      expect(find.text('Hollow City'), findsOneWidget);
      expect(find.text('Synopsis'), findsOneWidget);
    });

    testWidgets('show in Watchlist opens Show Detail', (
      WidgetTester tester,
    ) async {
      await _goToProfile(tester);

      await tester.tap(find.text('See all').first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Shows').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Accord'));
      await tester.pumpAndSettle();

      expect(find.text('Accord'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('Movies/Shows toggle changes the Watchlist grid correctly', (
      WidgetTester tester,
    ) async {
      await _goToProfile(tester);

      await tester.tap(find.text('See all').first);
      await tester.pumpAndSettle();

      expect(find.text('Hollow City'), findsOneWidget);
      expect(find.text('Night Protocol'), findsNothing);

      await tester.tap(find.text('Shows').last);
      await tester.pumpAndSettle();

      expect(find.text('Night Protocol'), findsOneWidget);
      expect(find.text('Hollow City'), findsNothing);
    });
  });

  group('Watched Shows See All', () {
    testWidgets('Profile Shows See all opens watched Shows grid', (
      WidgetTester tester,
    ) async {
      await _goToProfile(tester);

      final scrollable = find.byType(Scrollable).first;
      final showsSeeAll = find.text('See all').at(1);
      await _scrollItemClearOfNavBar(tester, scrollable, showsSeeAll);
      await tester.tap(showsSeeAll);
      await tester.pumpAndSettle();

      expect(find.text('Shows'), findsOneWidget);
      expect(find.text('The Agency'), findsOneWidget);
    });

    testWidgets('watched Show opens Show Detail', (WidgetTester tester) async {
      await _goToProfile(tester);

      final scrollable = find.byType(Scrollable).first;
      final showsSeeAll = find.text('See all').at(1);
      await _scrollItemClearOfNavBar(tester, scrollable, showsSeeAll);
      await tester.tap(showsSeeAll);
      await tester.pumpAndSettle();

      await tester.tap(find.text('The Agency'));
      await tester.pumpAndSettle();

      expect(find.text('The Agency'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });
  });

  group('Watched Movies See All', () {
    testWidgets('Profile Movies See all opens watched Movies grid', (
      WidgetTester tester,
    ) async {
      await _goToProfile(tester);

      final scrollable = find.byType(Scrollable).first;
      final moviesSeeAll = find.text('See all').at(2);
      await _scrollItemClearOfNavBar(tester, scrollable, moviesSeeAll);
      await tester.tap(moviesSeeAll);
      await tester.pumpAndSettle();

      expect(find.text('Movies'), findsOneWidget);
      expect(find.text('The Forgotten Shore'), findsOneWidget);
      expect(find.text('Red Signal'), findsOneWidget);
    });

    testWidgets('watched Movie opens Movie Detail', (
      WidgetTester tester,
    ) async {
      await _goToProfile(tester);

      final scrollable = find.byType(Scrollable).first;
      final moviesSeeAll = find.text('See all').at(2);
      await _scrollItemClearOfNavBar(tester, scrollable, moviesSeeAll);
      await tester.tap(moviesSeeAll);
      await tester.pumpAndSettle();

      await tester.tap(find.text('The Forgotten Shore'));
      await tester.pumpAndSettle();

      expect(find.text('The Forgotten Shore'), findsOneWidget);
      expect(find.text('Synopsis'), findsOneWidget);
    });
  });

  group('Back navigation', () {
    testWidgets('back from Watchlist returns to Profile', (
      WidgetTester tester,
    ) async {
      await _goToProfile(tester);

      await tester.tap(find.text('See all').first);
      await tester.pumpAndSettle();

      expect(find.text('Watchlist'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pumpAndSettle();

      expect(find.text('celestialwatcher'), findsOneWidget);
    });

    testWidgets('back from Watched Shows returns to Profile', (
      WidgetTester tester,
    ) async {
      await _goToProfile(tester);

      final scrollable = find.byType(Scrollable).first;
      final showsSeeAll = find.text('See all').at(1);
      await _scrollItemClearOfNavBar(tester, scrollable, showsSeeAll);
      await tester.tap(showsSeeAll);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pumpAndSettle();

      expect(find.text('celestialwatcher'), findsOneWidget);
    });

    testWidgets('back from Watched Movies returns to Profile', (
      WidgetTester tester,
    ) async {
      await _goToProfile(tester);

      final scrollable = find.byType(Scrollable).first;
      final moviesSeeAll = find.text('See all').at(2);
      await _scrollItemClearOfNavBar(tester, scrollable, moviesSeeAll);
      await tester.tap(moviesSeeAll);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pumpAndSettle();

      expect(find.text('celestialwatcher'), findsOneWidget);
    });
  });

  group('No All Titles screen', () {
    testWidgets('No All Titles is present on any screen', (
      WidgetTester tester,
    ) async {
      await _goToProfile(tester);
      expect(find.text('All Titles'), findsNothing);
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

    final cases = <(String, Widget, String)>[
      ('WatchlistScreen', const WatchlistScreen(), 'Watchlist'),
      ('WatchedShowsScreen', const WatchedShowsScreen(), 'Shows'),
      ('WatchedMoviesScreen', const WatchedMoviesScreen(), 'Movies'),
    ];

    for (final (name, screen, marker) in cases) {
      for (final (tierLabel, size) in viewportSizes) {
        testWidgets('$name renders without overflow on a $tierLabel phone', (
          WidgetTester tester,
        ) async {
          await pumpSized(tester, size, screen);
          expect(find.text(marker), findsWidgets);
        });
      }
    }
  });
}