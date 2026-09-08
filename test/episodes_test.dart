import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/core/theme/app_theme.dart';
import 'package:watchers/data/sources/mock_content_repository.dart';
import 'package:watchers/features/shows/episodes_screen.dart';
import 'package:watchers/shared/navigation/app_router.dart';

import 'helpers/auth_test_harness.dart';

Widget _wrap(Widget child) => MaterialApp(theme: AppTheme.dark(), home: child);

Future<ProviderContainer> _goToShell(WidgetTester tester) async {
  final container = await pumpApp(tester);
  await goToShell(tester, container);
  return container;
}

void main() {
  testWidgets('renders the active season with header, progress, and episodes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        EpisodesScreen(
          showId: 'the-agency',
          season: 1,
          repository: MockContentRepository(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('The Agency'), findsOneWidget);
    expect(find.text('Season 1 · 4/6 watched'), findsOneWidget);
    expect(find.text('Season progress'), findsOneWidget);
    expect(find.text('67%'), findsOneWidget);
    expect(find.text('Mark All'), findsOneWidget);
    expect(find.text('S1'), findsOneWidget);
    expect(find.text('S2'), findsOneWidget);
    expect(find.text('The Briefing'), findsOneWidget);
    expect(find.text('52m · Mar 10, 2022'), findsOneWidget);
  });

  testWidgets('opens on the season provided by the route', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        EpisodesScreen(
          showId: 'the-agency',
          season: 3,
          repository: MockContentRepository(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Season 3 · 0/2 watched'), findsOneWidget);
    expect(find.text('Year Zero'), findsOneWidget);
    expect(find.text('0%'), findsOneWidget);
  });

  testWidgets('switching seasons updates the header and episode list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        EpisodesScreen(
          showId: 'the-agency',
          season: 1,
          repository: MockContentRepository(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('S2'));
    await tester.pumpAndSettle();

    expect(find.text('Season 2 · 2/4 watched'), findsOneWidget);
    expect(find.text('50%'), findsOneWidget);
    expect(find.text('New Faces'), findsOneWidget);
    expect(find.text('The Briefing'), findsNothing);
  });

  testWidgets('toggling an episode updates the watched count and progress', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _wrap(
        EpisodesScreen(
          showId: 'the-agency',
          season: 1,
          repository: MockContentRepository(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Season 1 · 4/6 watched'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('episode-toggle-5')));
    await tester.pumpAndSettle();

    expect(find.text('Season 1 · 5/6 watched'), findsOneWidget);
    expect(find.text('83%'), findsOneWidget);
  });

  testWidgets('mark all marks every episode in the active season', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        EpisodesScreen(
          showId: 'the-agency',
          season: 1,
          repository: MockContentRepository(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mark All'));
    await tester.pumpAndSettle();

    expect(find.text('Season 1 · 6/6 watched'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
  });

  testWidgets('an unknown show id renders the missing state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        EpisodesScreen(
          showId: 'unknown',
          season: 1,
          repository: MockContentRepository(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Show not found'), findsOneWidget);
  });

  testWidgets('View Episodes on the show detail opens the episodes screen', (
    WidgetTester tester,
  ) async {
    final container = await _goToShell(tester);

    container.read(routerProvider).go('/shows/detail/the-agency');
    await tester.pumpAndSettle();

    await tester.tap(find.text('View Episodes'));
    await tester.pumpAndSettle();

    expect(find.text('Season 1 · 4/6 watched'), findsOneWidget);
    expect(find.text('The Briefing'), findsOneWidget);
  });
}
