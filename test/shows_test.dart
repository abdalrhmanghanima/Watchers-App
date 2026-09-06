import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/core/theme/app_theme.dart';
import 'package:watchers/features/shows/shows_screen.dart';
import 'package:watchers/features/shows/widgets/episode_list_item.dart';
import 'package:watchers/shared/widgets/poster_card.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(theme: AppTheme.dark(), home: child);

  Future<void> pumpShows(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(wrap(const ShowsScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  testWidgets('Continue Watching is no longer displayed', (tester) async {
    await pumpShows(tester);

    expect(find.text('Continue Watching'), findsNothing);
  });

  testWidgets('Episodes section exists', (tester) async {
    await pumpShows(tester);

    expect(find.text('Episodes'), findsOneWidget);
  });

  testWidgets('Episodes render as a vertical list', (tester) async {
    await pumpShows(tester);

    final items = find.byType(EpisodeListItem);
    expect(items, findsNWidgets(6));

    final first = tester.getTopLeft(items.at(0));
    final second = tester.getTopLeft(items.at(1));
    final third = tester.getTopLeft(items.at(2));
    expect(second.dy, greaterThan(first.dy));
    expect(third.dy, greaterThan(second.dy));
  });

  testWidgets('a new episode displays NEW', (tester) async {
    await pumpShows(tester);

    expect(find.text('NEW'), findsOneWidget);
    final item = find.ancestor(
      of: find.text('First Contact'),
      matching: find.byType(EpisodeListItem),
    );
    expect(
      find.descendant(of: item, matching: find.text('NEW')),
      findsOneWidget,
    );
  });

  testWidgets(
    'an in-progress show shows its next unwatched episode without NEW',
    (tester) async {
      await pumpShows(tester);

      expect(find.text('Red Folder'), findsOneWidget);
      final item = find.ancestor(
        of: find.text('Red Folder'),
        matching: find.byType(EpisodeListItem),
      );
      expect(
        find.descendant(of: item, matching: find.text('NEW')),
        findsNothing,
      );
    },
  );

  testWidgets('Watch Next exists below Episodes', (tester) async {
    await pumpShows(tester);

    final episodes = tester.getTopLeft(find.text('Episodes'));
    final watchNext = tester.getTopLeft(find.text('Watch Next'));
    expect(watchNext.dy, greaterThan(episodes.dy));
  });

  testWidgets('Watch Next contains one episode per Watchlist show', (
    tester,
  ) async {
    await pumpShows(tester);

    expect(find.text('The Informant'), findsOneWidget);
    expect(find.text('The Docket'), findsOneWidget);
    expect(find.text('The First Meeting'), findsOneWidget);
  });

  testWidgets('Watch Next does not render show poster cards', (tester) async {
    await pumpShows(tester);

    expect(find.byType(PosterCard), findsNothing);
  });

  testWidgets(
    'checking an episode shows the watched check then advances after ~2s',
    (tester) async {
      await pumpShows(tester);

      expect(find.text('Red Folder'), findsOneWidget);
      final row = find.byKey(
        const ValueKey('episode-list-item-the-agency-1-5'),
      );
      await tester.tap(
        find.byKey(const ValueKey('shows-toggle-the-agency-1-5')),
      );
      await tester.pump();

      expect(find.text('Red Folder'), findsOneWidget);
      expect(find.text('The Long Game'), findsNothing);
      expect(
        find.descendant(of: row, matching: find.byIcon(Icons.check)),
        findsOneWidget,
      );

      await tester.pump(const Duration(milliseconds: 2100));

      expect(find.text('Red Folder'), findsNothing);
      expect(find.text('The Long Game'), findsOneWidget);
    },
  );

  testWidgets('a pending watched episode stays visible and tappable for ~2s', (
    tester,
  ) async {
    await pumpShows(tester);

    await tester.tap(find.byKey(const ValueKey('shows-toggle-the-agency-1-5')));
    await tester.pump();

    expect(find.text('Red Folder'), findsOneWidget);
    expect(find.text('The Long Game'), findsNothing);

    await tester.pump(const Duration(milliseconds: 1500));

    expect(find.text('Red Folder'), findsOneWidget);
    expect(find.text('The Long Game'), findsNothing);
  });

  testWidgets('tapping the check again within ~2s cancels the watched update', (
    tester,
  ) async {
    await pumpShows(tester);

    final toggle = find.byKey(const ValueKey('shows-toggle-the-agency-1-5'));
    final row = find.byKey(const ValueKey('episode-list-item-the-agency-1-5'));
    await tester.tap(toggle);
    await tester.pump();

    expect(
      find.descendant(of: row, matching: find.byIcon(Icons.check)),
      findsOneWidget,
    );

    await tester.tap(toggle);
    await tester.pump();

    expect(
      find.descendant(of: row, matching: find.byIcon(Icons.check)),
      findsNothing,
    );

    await tester.pump(const Duration(milliseconds: 2100));

    expect(find.text('Red Folder'), findsOneWidget);
    expect(find.text('The Long Game'), findsNothing);
  });

  testWidgets('a Watch Next episode advances after its pending ~2s', (
    tester,
  ) async {
    await pumpShows(tester);

    expect(find.text('The Informant'), findsOneWidget);
    final toggle = find.byKey(
      const ValueKey('shows-toggle-night-protocol-1-3'),
    );
    await tester.ensureVisible(toggle);
    await tester.tap(toggle);
    await tester.pump();

    expect(find.text('The Informant'), findsOneWidget);
    expect(find.text('Blind Spot'), findsNothing);

    await tester.pump(const Duration(milliseconds: 2100));

    expect(find.text('The Informant'), findsNothing);
    expect(find.text('Blind Spot'), findsOneWidget);
  });
}
