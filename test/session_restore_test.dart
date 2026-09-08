import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/features/auth/domain/entities/auth_user.dart';
import 'package:watchers/features/auth/presentation/providers/auth_controller.dart';

import 'helpers/auth_test_harness.dart';

void main() {
  testWidgets('a returning user is restored straight to the shell', (
    WidgetTester tester,
  ) async {
    await pumpApp(
      tester,
      initialUser: const AuthUser(
        uid: 'u1',
        email: 'watcher@watchers.app',
        displayName: 'celestialwatcher',
      ),
    );

    expect(find.text('Shows'), findsOneWidget);
    expect(find.text('Email address'), findsNothing);
  });

  testWidgets('an unauthenticated start lands on the splash, then auth', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    expect(find.text('WATCHERS'), findsOneWidget);

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Email address'), findsOneWidget);
  });

  testWidgets('signing out drops the restored session and returns to auth', (
    WidgetTester tester,
  ) async {
    final container = await pumpApp(
      tester,
      initialUser: const AuthUser(uid: 'u1', email: 'watcher@watchers.app'),
    );

    await container.read(authControllerProvider.notifier).signOut();
    await tester.pumpAndSettle();

    expect(find.text('Email address'), findsOneWidget);
  });
}