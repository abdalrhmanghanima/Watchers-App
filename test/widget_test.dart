import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/shared/navigation/app_router.dart';
import 'package:watchers/shared/widgets/gradient_button.dart';
import 'package:watchers/shared/widgets/watchers_logo.dart';

import 'helpers/auth_test_harness.dart';

Future<void> _boot(WidgetTester tester) async {
  final container = await pumpApp(tester);
  container.read(routerProvider).go('/');
  await tester.pumpAndSettle();
}

Future<void> _goToAuth(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await tester.tap(find.text('Get Started'));
  await tester.pumpAndSettle();
}

Future<void> _goToShell(WidgetTester tester) async {
  await _goToAuth(tester);
  await tester.enterText(find.byType(TextField).at(0), 'watcher@watchers.app');
  await tester.enterText(find.byType(TextField).at(1), 'watchers');
  await tester.tap(find.widgetWithText(GradientButton, 'Sign In'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('splash renders logo, wordmark, tagline, and CTA', (
    WidgetTester tester,
  ) async {
    await _boot(tester);

    expect(find.text('WATCHERS'), findsOneWidget);
    expect(find.text('TRACK WHAT YOU WATCH'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(
      find.text('Free forever · No subscription required'),
      findsOneWidget,
    );
  });

  testWidgets('tapping Get Started navigates to Auth', (
    WidgetTester tester,
  ) async {
    await _boot(tester);
    await _goToAuth(tester);

    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
  });

  testWidgets('splash logo is centered and fits small screens', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await _boot(tester);

    expect(tester.takeException(), isNull);

    final logoCenter = tester.getCenter(find.byType(WatchersLogo)).dx;
    expect(logoCenter, closeTo(160, 2));

    expect(find.text('WATCHERS'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });

  testWidgets('auth renders fields, mode toggle, and actions', (
    WidgetTester tester,
  ) async {
    await _boot(tester);
    await _goToAuth(tester);

    expect(find.text('Sign In'), findsWidgets);
    expect(find.text('Create Account'), findsWidgets);
    expect(find.text('or continue with'), findsOneWidget);
    expect(find.text('Google'), findsOneWidget);

    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    expect(find.text('Full name'), findsOneWidget);
    expect(find.text('Already have an account? '), findsOneWidget);

    await tester.ensureVisible(find.text('Sign in'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Full name'), findsNothing);
  });

  testWidgets('successful local login reaches the main shell', (
    WidgetTester tester,
  ) async {
    await _boot(tester);
    await _goToShell(tester);

    expect(find.text('Shows'), findsOneWidget);
    expect(find.text('SHOWS'), findsOneWidget);
  });

  testWidgets('the four main tabs still switch after login', (
    WidgetTester tester,
  ) async {
    await _boot(tester);
    await _goToShell(tester);

    await tester.tap(find.text('MOVIES'));
    await tester.pumpAndSettle();
    expect(find.text('Now Playing'), findsOneWidget);

    await tester.tap(find.text('SEARCH'));
    await tester.pumpAndSettle();
    expect(find.text('Search'), findsOneWidget);

    await tester.tap(find.text('PROFILE'));
    await tester.pumpAndSettle();
    expect(find.text('celestialwatcher'), findsOneWidget);

    await tester.tap(find.text('SHOWS'));
    await tester.pumpAndSettle();
    expect(find.text('Shows'), findsOneWidget);
  });
}
