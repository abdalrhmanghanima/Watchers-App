import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/app/watchers_app.dart';
import 'package:watchers/features/import/imported_stats_store.dart';
import 'package:watchers/shared/navigation/app_router.dart';
import 'package:watchers/shared/widgets/gradient_button.dart';

Future<void> _boot(WidgetTester tester) async {
  AppRouter.instance.go('/');
  await tester.pumpWidget(const WatchersApp());
  await tester.pumpAndSettle();
}

Future<void> _goToAuth(WidgetTester tester) async {
  await tester.tap(find.text('Get Started'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => ImportedStatsStore.instance.clear());
  tearDown(() => ImportedStatsStore.instance.clear());

  testWidgets('account creation routes to the import step', (
    WidgetTester tester,
  ) async {
    await _boot(tester);
    await _goToAuth(tester);

    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(GradientButton, 'Create Account'));
    await tester.pumpAndSettle();

    expect(find.text('Import your Watchers history'), findsOneWidget);
    expect(find.text('Import my stats'), findsOneWidget);
    expect(find.text('Skip for now'), findsOneWidget);
  });

  testWidgets('signing in skips the import step entirely', (
    WidgetTester tester,
  ) async {
    await _boot(tester);
    await _goToAuth(tester);

    await tester.enterText(
      find.byType(TextField).at(0),
      'watcher@watchers.app',
    );
    await tester.enterText(find.byType(TextField).at(1), 'watchers');
    await tester.tap(find.widgetWithText(GradientButton, 'Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Import your Watchers history'), findsNothing);
    expect(find.text('Shows'), findsOneWidget);
  });

  testWidgets('skipping the import step reaches the main shell', (
    WidgetTester tester,
  ) async {
    await _boot(tester);
    await _goToAuth(tester);
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(GradientButton, 'Create Account'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Skip for now'));
    await tester.pumpAndSettle();

    expect(find.text('Shows'), findsOneWidget);
    expect(ImportedStatsStore.instance.hasImported, isFalse);
  });
}