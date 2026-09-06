import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_theme.dart';
import 'package:watchers/features/shows/shows_screen.dart';
import 'package:watchers/features/shows/widgets/episode_list_item.dart';
import 'package:watchers/features/shows/widgets/watch_history_item.dart';
import 'package:watchers/shared/widgets/section_header.dart';

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

  Future<void> revealHistory(WidgetTester tester) async {
    if (find.text('Watch History').evaluate().isEmpty) {
      await tester.drag(find.byType(ListView), const Offset(0, 1500));
      await tester.pumpAndSettle();
    }
  }

  Finder historyRows() => find.byType(WatchHistoryItem, skipOffstage: false);
  Finder episodeRows() => find.byType(EpisodeListItem, skipOffstage: false);

  testWidgets('Watch History is hidden in the initial viewport', (
    tester,
  ) async {
    await pumpShows(tester);

    expect(find.text('Watch History'), findsNothing);
    expect(find.text('Episodes'), findsOneWidget);
  });

  testWidgets('scrolling up reveals Watch History above Episodes', (
    tester,
  ) async {
    await pumpShows(tester);

    await tester.drag(find.byType(ListView), const Offset(0, 1500));
    await tester.pumpAndSettle();

    expect(find.text('Watch History'), findsOneWidget);
    expect(find.text('Episodes'), findsNothing);
  });

  testWidgets('every watched episode renders a Watch History row', (
    tester,
  ) async {
    await pumpShows(tester);

    expect(historyRows(), findsNWidgets(15));
  });

  testWidgets('history rows keep the episode card layout', (tester) async {
    await pumpShows(tester);
    await revealHistory(tester);

    final row = find.byKey(const ValueKey('watch-history-item-the-agency-1-1'));
    expect(
      find.descendant(of: row, matching: find.text('The Agency')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: row, matching: find.text('The Briefing')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: row, matching: find.text('S1 • E1')),
      findsOneWidget,
    );
  });

  testWidgets('history check uses the purple accent with a white check', (
    tester,
  ) async {
    await pumpShows(tester);
    await revealHistory(tester);

    final row = find.byKey(const ValueKey('watch-history-item-the-agency-1-1'));
    final check = find.descendant(of: row, matching: find.byIcon(Icons.check));
    expect(check, findsOneWidget);
    expect(tester.widget<Icon>(check).color, Colors.white);

    final circle = find.ancestor(of: check, matching: find.byType(Container));
    final decoration =
        tester.widget<Container>(circle).decoration! as BoxDecoration;
    expect(decoration.color, AppColors.accent);
    expect(decoration.shape, BoxShape.circle);
  });

  testWidgets('toggling an episode adds it to Watch History after ~2s', (
    tester,
  ) async {
    await pumpShows(tester);

    expect(historyRows(), findsNWidgets(15));

    await tester.tap(find.byKey(const ValueKey('shows-toggle-the-agency-1-5')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2100));

    expect(historyRows(), findsNWidgets(16));
    expect(
      find.byKey(
        const ValueKey('watch-history-item-the-agency-1-5'),
        skipOffstage: false,
      ),
      findsOneWidget,
    );
  });

  testWidgets(
    'tapping the check in Watch History removes the episode immediately',
    (tester) async {
      await pumpShows(tester);
      await revealHistory(tester);

      expect(historyRows(), findsNWidgets(15));

      await tester.tap(
        find.byKey(const ValueKey('shows-toggle-the-agency-1-1')),
      );
      await tester.pump();

      expect(historyRows(), findsNWidgets(14));
      expect(
        find.byKey(const ValueKey('watch-history-item-the-agency-1-1')),
        findsNothing,
      );
      expect(
        find.descendant(
          of: find.byKey(
            const ValueKey('episode-list-item-the-agency-1-1'),
            skipOffstage: false,
          ),
          matching: find.text('The Briefing', skipOffstage: false),
          skipOffstage: false,
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('Episodes and Watch Next still render alongside history', (
    tester,
  ) async {
    await pumpShows(tester);

    expect(find.text('Episodes'), findsOneWidget);
    expect(find.text('Watch Next'), findsOneWidget);
    expect(episodeRows(), findsNWidgets(6));

    await revealHistory(tester);

    expect(find.text('Watch History'), findsOneWidget);
    expect(episodeRows(), findsNWidgets(6));
    expect(find.text('Red Folder', skipOffstage: false), findsOneWidget);
    expect(find.text('The Informant', skipOffstage: false), findsOneWidget);
  });

  testWidgets('Watch History and Episodes share one scrollable page', (
    tester,
  ) async {
    await pumpShows(tester);

    final historyHeader = find.text('Watch History', skipOffstage: false);
    final episodesHeader = find.text('Episodes', skipOffstage: false);

    expect(historyHeader, findsOneWidget);
    expect(episodesHeader, findsOneWidget);
    expect(
      tester.getTopLeft(historyHeader).dy,
      lessThan(tester.getTopLeft(episodesHeader).dy),
    );
  });

  testWidgets('Watch History uses the section header pattern', (tester) async {
    await pumpShows(tester);
    await revealHistory(tester);

    expect(
      find.ancestor(
        of: find.text('Watch History'),
        matching: find.byType(SectionHeader),
      ),
      findsOneWidget,
    );
  });

  testWidgets('history rows follow show, season, then episode order (bonus)', (
    tester,
  ) async {
    await pumpShows(tester);

    final first = find.byKey(
      const ValueKey('watch-history-item-the-agency-1-1'),
      skipOffstage: false,
    );
    final last = find.byKey(
      const ValueKey('watch-history-item-meridian-falls-1-7'),
      skipOffstage: false,
    );

    expect(first, findsOneWidget);
    expect(last, findsOneWidget);
    expect(tester.getTopLeft(first).dy, lessThan(tester.getTopLeft(last).dy));
  });
}
