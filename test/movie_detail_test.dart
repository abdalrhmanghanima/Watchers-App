import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/shared/navigation/app_router.dart';

import 'helpers/auth_test_harness.dart';

Future<ProviderContainer> _goToShell(WidgetTester tester) async {
  final container = await pumpApp(tester);
  await goToShell(tester, container);
  return container;
}

Future<ProviderContainer> _goToMovies(WidgetTester tester) async {
  final container = await _goToShell(tester);
  await tester.tap(find.text('MOVIES'));
  await tester.pumpAndSettle();
  return container;
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
    final container = await _goToMovies(tester);

    container.read(routerProvider).go('/movies/detail/unknown');
    await tester.pumpAndSettle();

    expect(find.text('Movie not found'), findsOneWidget);
  });
}
