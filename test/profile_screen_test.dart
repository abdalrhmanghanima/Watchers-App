import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/features/profile/widgets/profile_section_title.dart';
import 'package:watchers/features/profile/widgets/profile_stats_card.dart';
import 'package:watchers/shared/widgets/profile_avatar.dart';

import 'helpers/auth_test_harness.dart';

void _setTallViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

Future<ProviderContainer> _goToProfile(WidgetTester tester) async {
  _setTallViewport(tester);
  final container = await pumpApp(tester);
  await goToProfile(tester, container);
  return container;
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
  testWidgets('header shows only the profile picture and the username', (
    WidgetTester tester,
  ) async {
    await _goToProfile(tester);

    final avatar = find.byType(ProfileAvatar);
    final username = find.text('celestialwatcher');
    expect(avatar, findsOneWidget);
    expect(username, findsOneWidget);
    expect(
      tester.getRect(avatar).right,
      lessThan(tester.getRect(username).left),
    );
    expect(find.text('Member since Jan 2024'), findsNothing);
    expect(find.text('Cinephile'), findsNothing);
    expect(find.byIcon(Icons.add), findsNothing);
  });

  testWidgets('all five stats cards have identical fixed dimensions', (
    WidgetTester tester,
  ) async {
    await _goToProfile(tester);

    final cards = find.byType(ProfileStatsCard);
    expect(cards, findsNWidgets(5));
    final sizes = <Size>{
      for (final element in cards.evaluate())
        (element.renderObject as RenderBox).size,
    };
    expect(sizes, hasLength(1));
  });

  testWidgets('stats cards remain horizontally scrollable', (
    WidgetTester tester,
  ) async {
    await _goToProfile(tester);

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    await tester.pumpAndSettle();

    final statsScroll = find.byType(SingleChildScrollView).first;
    final scrollable = find
        .descendant(of: statsScroll, matching: find.byType(Scrollable))
        .first;
    final position = tester.state<ScrollableState>(scrollable).position;
    final before = position.pixels;
    await tester.drag(statsScroll, const Offset(-200, 0));
    await tester.pumpAndSettle();
    expect(position.pixels, greaterThan(before));
  });

  testWidgets('four stats are present', (WidgetTester tester) async {
    await _goToProfile(tester);

    expect(find.text('TV Shows'), findsWidgets);
    expect(find.text('Movies'), findsWidgets);
  });

  testWidgets('TV Shows count is displayed', (WidgetTester tester) async {
    await _goToProfile(tester);

    expect(find.text('3'), findsWidgets);
  });

  testWidgets('Episodes Time is displayed', (WidgetTester tester) async {
    await _goToProfile(tester);

    expect(find.text('Episodes Time'), findsOneWidget);
    expect(find.text('Episodes'), findsNothing);
  });

  testWidgets('Movies count is displayed', (WidgetTester tester) async {
    await _goToProfile(tester);

    expect(find.text('2'), findsWidgets);
  });

  testWidgets('Movies Time is displayed', (WidgetTester tester) async {
    await _goToProfile(tester);

    expect(find.text('Movies Time'), findsOneWidget);
    expect(find.text('4h 6m'), findsWidgets);
  });

  testWidgets('Comments count is displayed', (WidgetTester tester) async {
    await _goToProfile(tester);

    expect(find.text('Comments'), findsOneWidget);
    expect(find.text('6'), findsWidgets);
  });

  testWidgets('Watchlist horizontal section is present', (
    WidgetTester tester,
  ) async {
    await _goToProfile(tester);

    expect(find.text('Watchlist'), findsOneWidget);
    expect(find.text('See all'), findsWidgets);
  });

  testWidgets('Shows horizontal section is present', (
    WidgetTester tester,
  ) async {
    await _goToProfile(tester);

    expect(find.byType(ProfileSectionTitle), findsWidgets);
    expect(find.text('Shows'), findsWidgets);
  });

  testWidgets('Movies horizontal section is present', (
    WidgetTester tester,
  ) async {
    await _goToProfile(tester);

    expect(find.text('Movies'), findsWidgets);
  });

  testWidgets('section titles are exactly Shows and Movies', (
    WidgetTester tester,
  ) async {
    await _goToProfile(tester);

    expect(find.text('Shows'), findsWidgets);
    expect(find.text('Movies'), findsWidgets);
  });

  testWidgets('All Titles is not present', (WidgetTester tester) async {
    await _goToProfile(tester);

    expect(find.text('All Titles'), findsNothing);
  });

  testWidgets('watchlist movie opens its detail screen', (
    WidgetTester tester,
  ) async {
    await _goToProfile(tester);

    final scrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.text('Hollow City').first,
      200,
      scrollable: scrollable,
    );
    await tester.tap(find.text('Hollow City').first);
    await tester.pumpAndSettle();

    expect(find.text('Hollow City'), findsOneWidget);
    expect(find.text('Synopsis'), findsOneWidget);
  });

  testWidgets('watchlist show opens its detail screen', (
    WidgetTester tester,
  ) async {
    await _goToProfile(tester);

    final scrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.text('Night Protocol').first,
      200,
      scrollable: scrollable,
    );
    await tester.tap(find.text('Night Protocol').first);
    await tester.pumpAndSettle();

    expect(find.text('Night Protocol'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
  });

  testWidgets('watched movie opens its detail screen', (
    WidgetTester tester,
  ) async {
    await _goToProfile(tester);

    final scrollable = find.byType(Scrollable).first;
    final title = find.text('The Forgotten Shore').first;
    await _scrollItemClearOfNavBar(tester, scrollable, title);
    await tester.tap(title);
    await tester.pumpAndSettle();

    expect(find.text('The Forgotten Shore'), findsOneWidget);
    expect(find.text('Synopsis'), findsOneWidget);
  });
}