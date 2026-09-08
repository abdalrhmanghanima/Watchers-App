import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/core/theme/app_theme.dart';
import 'package:watchers/core/theme/theme_controller.dart';
import 'package:watchers/features/auth/domain/entities/auth_user.dart';
import 'package:watchers/features/profile/presentation/providers/profile_controller.dart';
import 'package:watchers/features/profile/settings_screen.dart';
import 'package:watchers/shared/widgets/setting_row.dart';
import 'package:watchers/shared/widgets/watcher_toggle.dart';

import 'helpers/auth_test_harness.dart';

const _signedInUser = AuthUser(
  uid: 'u1',
  email: 'celestial@example.com',
  displayName: 'celestialwatcher',
);

Future<ProviderContainer> _pumpSettings(
  WidgetTester tester, {
  AuthUser? initialUser,
}) async {
  final container = createTestContainer(initialUser: initialUser);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(theme: AppTheme.dark(), home: const SettingsScreen()),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

void main() {
  setUp(() {
    ThemeController.instance.setDark(true);
  });

  void setTallViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  WatcherToggle toggleOf(String label) {
    final toggle = find
        .descendant(
          of: find.widgetWithText(SettingRow, label),
          matching: find.byType(WatcherToggle),
        )
        .evaluate()
        .single
        .widget;
    return toggle as WatcherToggle;
  }

  testWidgets('renders the profile card and all settings rows', (
    WidgetTester tester,
  ) async {
    setTallViewport(tester);
    await _pumpSettings(tester, initialUser: _signedInUser);

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('celestialwatcher'), findsOneWidget);
    expect(find.text('celestial@example.com'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);

    expect(find.text('APPEARANCE'), findsOneWidget);
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Dark mode'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);

    expect(find.text('NOTIFICATIONS'), findsOneWidget);
    expect(find.text('New Episodes'), findsOneWidget);
    expect(find.text('Get notified when new episodes air'), findsOneWidget);
    expect(find.text('Watchlist Reminders'), findsOneWidget);
    expect(find.text('Remind me about unwatched content'), findsOneWidget);

    expect(find.text('PRIVACY'), findsOneWidget);
    expect(find.text('Private Profile'), findsOneWidget);
    expect(find.text('Only you can see your activity'), findsOneWidget);
    expect(find.text('Manage Account'), findsOneWidget);
    expect(find.text('Password, email, and account details'), findsOneWidget);

    expect(find.text('ABOUT'), findsOneWidget);
    expect(find.text('About WATCHERS'), findsOneWidget);
    expect(find.text('Version 1.0.0'), findsOneWidget);
    expect(find.text('Contact Support'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);

    expect(find.text('ACCOUNT'), findsOneWidget);
    expect(find.text('Sign Out'), findsOneWidget);
  });

  testWidgets('Edit name updates the display name on the profile card', (
    WidgetTester tester,
  ) async {
    setTallViewport(tester);
    final container = await _pumpSettings(tester, initialUser: _signedInUser);

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    expect(find.text('Edit name'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Nova Lee');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Nova Lee'), findsOneWidget);
    expect(find.text('celestialwatcher'), findsNothing);
    expect(
      container.read(profileControllerProvider).value?.displayName,
      'Nova Lee',
    );
  });

  testWidgets('appearance toggle flips the app theme', (
    WidgetTester tester,
  ) async {
    await _pumpSettings(tester);

    expect(ThemeController.instance.isDark, isTrue);
    expect(find.text('Dark mode'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.widgetWithText(SettingRow, 'Appearance'),
        matching: find.byType(WatcherToggle),
      ),
    );
    await tester.pumpAndSettle();

    expect(ThemeController.instance.isDark, isFalse);
    expect(find.text('Light mode'), findsOneWidget);
    expect(toggleOf('Appearance').value, isFalse);

    await tester.tap(
      find.descendant(
        of: find.widgetWithText(SettingRow, 'Appearance'),
        matching: find.byType(WatcherToggle),
      ),
    );
    await tester.pumpAndSettle();

    expect(ThemeController.instance.isDark, isTrue);
    expect(find.text('Dark mode'), findsOneWidget);
  });

  testWidgets('notification and privacy toggles flip their own state', (
    WidgetTester tester,
  ) async {
    setTallViewport(tester);
    await _pumpSettings(tester);

    expect(toggleOf('New Episodes').value, isTrue);
    await tester.tap(
      find.descendant(
        of: find.widgetWithText(SettingRow, 'New Episodes'),
        matching: find.byType(WatcherToggle),
      ),
    );
    await tester.pumpAndSettle();
    expect(toggleOf('New Episodes').value, isFalse);

    expect(toggleOf('Watchlist Reminders').value, isFalse);
    expect(toggleOf('Private Profile').value, isFalse);
    await tester.tap(
      find.descendant(
        of: find.widgetWithText(SettingRow, 'Watchlist Reminders'),
        matching: find.byType(WatcherToggle),
      ),
    );
    await tester.pumpAndSettle();
    expect(toggleOf('Watchlist Reminders').value, isTrue);

    await tester.tap(
      find.descendant(
        of: find.widgetWithText(SettingRow, 'Private Profile'),
        matching: find.byType(WatcherToggle),
      ),
    );
    await tester.pumpAndSettle();
    expect(toggleOf('Private Profile').value, isTrue);
  });

  testWidgets('Settings opens from the profile screen', (
    WidgetTester tester,
  ) async {
    setTallViewport(tester);
    final container = await pumpApp(tester);
    await goToProfile(tester, container);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Sign Out'), findsOneWidget);
  });

  testWidgets('back from Settings returns to the profile screen', (
    WidgetTester tester,
  ) async {
    setTallViewport(tester);
    final container = await pumpApp(tester);
    await goToProfile(tester, container);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
    await tester.pumpAndSettle();

    expect(find.text('celestialwatcher'), findsOneWidget);
    expect(find.text('Settings'), findsNothing);
  });

  testWidgets('Sign Out returns to the auth screen', (
    WidgetTester tester,
  ) async {
    setTallViewport(tester);
    final container = await pumpApp(tester);
    await goToProfile(tester, container);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Sign Out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign Out'));
    await tester.pumpAndSettle();

    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Settings'), findsNothing);
  });

  testWidgets('Delete Account requires confirmation and signs out', (
    WidgetTester tester,
  ) async {
    setTallViewport(tester);
    final container = await pumpApp(tester);
    await goToProfile(tester, container);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Delete Account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete Account'));
    await tester.pumpAndSettle();

    expect(find.text('Delete account?'), findsOneWidget);

    await tester.enterText(find.byType(TextField).last, 'watchers');
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Settings'), findsNothing);
  });
}