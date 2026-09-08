import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/features/shows/episode_detail/widgets/episode_show_bar.dart';
import 'package:watchers/shared/navigation/app_router.dart';

import 'helpers/auth_test_harness.dart';

Future<ProviderContainer> _goToShell(WidgetTester tester) async {
  final container = await pumpApp(tester);
  await goToShell(tester, container);
  return container;
}

void main() {
  testWidgets(
    'tapping an episode then its parent show opens the detail screen',
    (WidgetTester tester) async {
      await _goToShell(tester);

      final showsScrollable = find.byType(Scrollable).first;
      await tester.scrollUntilVisible(
        find.text('The Docket'),
        200,
        scrollable: showsScrollable,
      );
      await tester.tap(find.text('The Docket'));
      await tester.pumpAndSettle();

      expect(find.text('Watch Episode'), findsOneWidget);
      expect(find.text('Accord'), findsOneWidget);

      await tester.ensureVisible(find.byType(EpisodeShowBar));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(EpisodeShowBar));
      await tester.pumpAndSettle();

      expect(find.text('Accord'), findsWidgets);
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Cast'), findsOneWidget);
      expect(find.text('Seasons'), findsOneWidget);
      expect(find.text('Ended'), findsOneWidget);
    },
  );

  testWidgets('selecting a different season updates the episode preview', (
    WidgetTester tester,
  ) async {
    final container = await _goToShell(tester);

    container.read(routerProvider).go('/shows/detail/the-agency');
    await tester.pumpAndSettle();

    expect(find.text('4/6 episodes'), findsOneWidget);

    final detailScrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.text('Season 2'),
      100,
      scrollable: detailScrollable,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Season 2'));
    await tester.pumpAndSettle();

    expect(find.text('2/4 episodes'), findsOneWidget);
  });

  testWidgets('an unknown show id renders the missing-show state', (
    WidgetTester tester,
  ) async {
    final container = await _goToShell(tester);

    container.read(routerProvider).go('/shows/detail/unknown');
    await tester.pumpAndSettle();

    expect(find.text('Show not found'), findsOneWidget);
  });

  testWidgets('Show Details has no Comments section', (tester) async {
    final container = await _goToShell(tester);

    container.read(routerProvider).go('/shows/detail/the-agency');
    await tester.pumpAndSettle();

    expect(find.text('Comments'), findsNothing);
    expect(find.text('18 discussions'), findsNothing);
    expect(find.byIcon(Icons.chat_bubble_outline), findsNothing);

    expect(find.text('About'), findsOneWidget);
    expect(find.text('Seasons'), findsOneWidget);
    expect(find.text('All Episodes'), findsOneWidget);
    expect(find.text('4/6 episodes'), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_border), findsWidgets);

    await tester.dragUntilVisible(
      find.text('Cast'),
      find.byType(ListView),
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cast'), findsOneWidget);
    expect(find.text('Comments'), findsNothing);
    expect(find.text('18 discussions'), findsNothing);
    expect(find.byIcon(Icons.chat_bubble_outline), findsNothing);
  });
}
