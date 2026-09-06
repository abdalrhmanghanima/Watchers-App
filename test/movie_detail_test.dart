import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/app/watchers_app.dart';
import 'package:watchers/shared/navigation/app_router.dart';
import 'package:watchers/shared/widgets/gradient_button.dart';

Future<void> _goToShell(WidgetTester tester) async {
  AppRouter.instance.go('/');
  await tester.pumpWidget(const WatchersApp());
  await tester.pumpAndSettle();
  await tester.tap(find.text('Get Started'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).at(0), 'watcher@watchers.app');
  await tester.enterText(find.byType(TextField).at(1), 'watchers');
  await tester.tap(find.widgetWithText(GradientButton, 'Sign In'));
  await tester.pumpAndSettle();
}

Future<void> _goToMovies(WidgetTester tester) async {
  await _goToShell(tester);
  await tester.tap(find.text('MOVIES'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('View Details on the Movies tab opens the movie detail screen', (
    WidgetTester tester,
  ) async {
    await _goToMovies(tester);

    await tester.tap(find.text('View Details'));
    await tester.pumpAndSettle();

    expect(find.text('Meridian'), findsOneWidget);
    expect(find.text('2024 · 2h 8m'), findsOneWidget);
    expect(find.text('Synopsis'), findsOneWidget);
    expect(find.text('Cast'), findsOneWidget);
    expect(find.text('Similar Movies'), findsOneWidget);
    expect(find.text('Mark Watched'), findsOneWidget);
    expect(find.text('Add to Watchlist'), findsOneWidget);
  });

  testWidgets('watched and watchlist actions toggle from the detail screen', (
    WidgetTester tester,
  ) async {
    await _goToMovies(tester);

    await tester.tap(find.text('View Details'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add to Watchlist'));
    await tester.pumpAndSettle();
    expect(find.text('In Watchlist'), findsOneWidget);

    await tester.tap(find.text('Mark Watched'));
    await tester.pumpAndSettle();
    expect(find.text('Watched'), findsOneWidget);
  });

  testWidgets('an unknown movie id renders the movie-not-found state', (
    WidgetTester tester,
  ) async {
    await _goToMovies(tester);

    AppRouter.instance.go('/movies/detail/unknown');
    await tester.pumpAndSettle();

    expect(find.text('Movie not found'), findsOneWidget);
  });
}
