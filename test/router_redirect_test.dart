import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/features/auth/domain/entities/auth_user.dart';
import 'package:watchers/features/auth/presentation/providers/auth_controller.dart';
import 'package:watchers/features/auth/presentation/providers/auth_providers.dart';
import 'package:watchers/shared/navigation/app_router.dart';
import 'package:watchers/shared/widgets/gradient_button.dart';
import 'package:watchers/shared/widgets/outline_button.dart';

import 'helpers/auth_test_harness.dart';

void main() {
  testWidgets('unauthenticated users are sent to auth for protected routes', (
    WidgetTester tester,
  ) async {
    final container = await pumpApp(tester);

    container.read(routerProvider).go('/shows');
    await tester.pumpAndSettle();

    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('unauthenticated users can open splash and auth', (
    WidgetTester tester,
  ) async {
    final container = await pumpApp(tester);

    container.read(routerProvider).go('/auth');
    await tester.pumpAndSettle();

    expect(find.text('Email address'), findsOneWidget);
  });

  testWidgets('authenticated users start at the shell from the splash', (
    WidgetTester tester,
  ) async {
    await pumpApp(
      tester,
      initialUser: const AuthUser(uid: 'u1', email: 'a@b.com'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Shows'), findsOneWidget);
  });

  testWidgets('authenticated users can reach the import step', (
    WidgetTester tester,
  ) async {
    final container = await pumpApp(
      tester,
      initialUser: const AuthUser(uid: 'u1', email: 'a@b.com'),
    );

    container.read(routerProvider).go('/import');
    await tester.pumpAndSettle();

    expect(find.text('Import your Watchers history'), findsOneWidget);
  });

  testWidgets('signing out returns to the auth screen', (
    WidgetTester tester,
  ) async {
    final container = await pumpApp(tester);

    container.read(routerProvider).go('/auth');
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'a@b.com');
    await tester.enterText(find.byType(TextField).at(1), 'pw');
    await tester.tap(find.widgetWithText(GradientButton, 'Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Shows'), findsOneWidget);

    await container
        .read(authControllerProvider.notifier)
        .signOut();
    await tester.pumpAndSettle();

    expect(find.text('Email address'), findsOneWidget);
  });

  testWidgets('a successful Google sign in reaches the shell', (
    WidgetTester tester,
  ) async {
    final container = await pumpApp(tester);

    container.read(routerProvider).go('/auth');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlineButton, 'Google'));
    await tester.pumpAndSettle();

    expect(find.text('Shows'), findsOneWidget);
    expect(container.read(authControllerProvider).value?.email, 'google@watchers.app');
  });

  testWidgets('a cancelled Google sign in stays on the auth screen', (
    WidgetTester tester,
  ) async {
    final container = await pumpApp(tester);
    final repo = container.read(authRepositoryProvider) as FakeAuthRepository;
    repo.cancelGoogleSignIn = true;

    container.read(routerProvider).go('/auth');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(OutlineButton, 'Google'));
    await tester.pumpAndSettle();

    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Shows'), findsNothing);
  });
}