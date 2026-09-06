import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/app/watchers_app.dart';
import 'package:watchers/features/profile/widgets/profile_section_title.dart';
import 'package:watchers/shared/navigation/app_router.dart';
import 'package:watchers/shared/widgets/gradient_button.dart';

void _setTallViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

Future<void> _goToProfile(WidgetTester tester) async {
  _setTallViewport(tester);
  AppRouter.instance.go('/');
  await tester.pumpWidget(const WatchersApp());
  await tester.pumpAndSettle();
  await tester.tap(find.text('Get Started'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).at(0), 'watcher@watchers.app');
  await tester.enterText(find.byType(TextField).at(1), 'watchers');
  await tester.tap(find.widgetWithText(GradientButton, 'Sign In'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('PROFILE'));
  await tester.pumpAndSettle();
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
  testWidgets('watchlist movie opens its detail screen from the profile', (
    WidgetTester tester,
  ) async {
    await _goToProfile(tester);
    await tester.pumpAndSettle();

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
    expect(find.text('Mark Watched'), findsOneWidget);
  });

  testWidgets('watchlist show opens its detail screen from the profile', (
    WidgetTester tester,
  ) async {
    await _goToProfile(tester);
    await tester.pumpAndSettle();

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
    expect(find.text('Seasons'), findsOneWidget);
  });

  testWidgets(
    'history movie opens its detail screen and keeps the watch check',
    (WidgetTester tester) async {
      await _goToProfile(tester);
      await tester.pumpAndSettle();

      final scrollable = find.byType(Scrollable).first;
      final title = find.text('The Forgotten Shore').first;
      await _scrollItemClearOfNavBar(tester, scrollable, title);
      await tester.tap(title);
      await tester.pumpAndSettle();

      expect(find.text('The Forgotten Shore'), findsOneWidget);
      expect(find.text('Synopsis'), findsOneWidget);
      expect(find.text('Watched'), findsOneWidget);
    },
  );

  testWidgets('history movie opens its detail screen for a second entry', (
    WidgetTester tester,
  ) async {
    await _goToProfile(tester);
    await tester.pumpAndSettle();

    final scrollable = find.byType(Scrollable).first;
    final title = find.text('Red Signal').first;
    await _scrollItemClearOfNavBar(tester, scrollable, title);
    await tester.tap(title);
    await tester.pumpAndSettle();

    expect(find.text('Red Signal'), findsOneWidget);
    expect(find.text('Synopsis'), findsOneWidget);
    expect(find.text('Watched'), findsOneWidget);
  });

  testWidgets('watchlist and watched sections both present without overflow', (
    WidgetTester tester,
  ) async {
    await _goToProfile(tester);
    await tester.pumpAndSettle();

    expect(find.text('Watchlist'), findsOneWidget);
    expect(find.byType(ProfileSectionTitle), findsWidgets);
    expect(find.text('Shows'), findsWidgets);
    expect(find.text('Movies'), findsWidgets);
  });
}
