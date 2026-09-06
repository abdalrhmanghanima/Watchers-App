import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/app/watchers_app.dart';
import 'package:watchers/core/theme/app_theme.dart';
import 'package:watchers/core/theme/theme_controller.dart';
import 'package:watchers/features/profile/settings_screen.dart';
import 'package:watchers/shared/navigation/app_router.dart';
import 'package:watchers/shared/widgets/gradient_button.dart';
import 'package:watchers/shared/widgets/setting_row.dart';
import 'package:watchers/shared/widgets/watcher_toggle.dart';

Widget _wrap(Widget child) => MaterialApp(theme: AppTheme.dark(), home: child);

Future<void> _goToShell(WidgetTester tester) async {
  AppRouter.instance.go('/');
  await tester.pumpWidget(const WatchersApp());
  await tester.pumpAndSettle();
  await tester.tap(find.text('Get Started'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).at(0), 'watcher@watchers.app');
  await tester.enterText(find.byType(TextField).at(1), 'watchers');
  await tester.tap(find.widgetWithText(GradientButton, 'Sign In'));
  await tester.pumpAndSettle();
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
    await tester.pumpWidget(_wrap(const SettingsScreen()));
    await tester.pumpAndSettle();

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

  testWidgets('appearance toggle flips the app theme', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_wrap(const SettingsScreen()));
    await tester.pumpAndSettle();

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
    await tester.pumpWidget(_wrap(const SettingsScreen()));
    await tester.pumpAndSettle();

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
    await _goToShell(tester);
    await tester.tap(find.text('PROFILE'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Sign Out'), findsOneWidget);
  });

  testWidgets('back from Settings returns to the profile screen', (
    WidgetTester tester,
  ) async {
    await _goToShell(tester);
    await tester.tap(find.text('PROFILE'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
    await tester.pumpAndSettle();

    expect(find.text('celestialwatcher'), findsOneWidget);
    expect(find.text('Settings'), findsNothing);
  });
}
