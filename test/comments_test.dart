import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/app/watchers_app.dart';
import 'package:watchers/core/theme/app_theme.dart';
import 'package:watchers/data/models/search_result.dart';
import 'package:watchers/data/sources/mock_content_repository.dart';
import 'package:watchers/features/comments/comments_screen.dart';
import 'package:watchers/shared/navigation/app_router.dart';
import 'package:watchers/shared/widgets/gradient_button.dart';

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
  testWidgets('renders the header, comment count, and comment list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        CommentsScreen(
          itemId: 'the-agency',
          itemType: ContentType.show,
          repository: MockContentRepository(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('The Agency'), findsOneWidget);
    expect(find.text('6 comments'), findsOneWidget);
    expect(find.text('Hide Spoilers'), findsOneWidget);
    expect(find.text('celestialwatcher'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('spoiler comments stay hidden until tapped', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        CommentsScreen(
          itemId: 'the-agency',
          itemType: ContentType.show,
          repository: MockContentRepository(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Contains spoilers · Tap to reveal'), findsOneWidget);
    expect(find.textContaining('changes everything'), findsNothing);
    expect(find.text('SPOILER'), findsOneWidget);

    await tester.tap(find.text('Contains spoilers · Tap to reveal'));
    await tester.pumpAndSettle();

    expect(find.textContaining('changes everything'), findsOneWidget);
    expect(find.text('Contains spoilers · Tap to reveal'), findsNothing);
  });

  testWidgets('hiding spoilers filters the list and updates the count', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        CommentsScreen(
          itemId: 'the-agency',
          itemType: ContentType.show,
          repository: MockContentRepository(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Hide Spoilers'));
    await tester.pumpAndSettle();

    expect(find.text('5 comments'), findsOneWidget);
    expect(find.text('Show All'), findsOneWidget);
    expect(find.text('Contains spoilers · Tap to reveal'), findsNothing);

    await tester.tap(find.text('Show All'));
    await tester.pumpAndSettle();

    expect(find.text('6 comments'), findsOneWidget);
    expect(find.text('Hide Spoilers'), findsOneWidget);
  });

  testWidgets('tapping like on a comment increments its count', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        CommentsScreen(
          itemId: 'the-agency',
          itemType: ContentType.show,
          repository: MockContentRepository(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('48'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.thumb_up_outlined).first);
    await tester.pumpAndSettle();

    expect(find.text('49'), findsOneWidget);
    expect(find.text('48'), findsNothing);
  });

  testWidgets('posting a comment prepends it and clears the input', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        CommentsScreen(
          itemId: 'the-agency',
          itemType: ContentType.show,
          repository: MockContentRepository(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextField),
      'A fresh take on that ending.',
    );
    await tester.pump();
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    expect(find.text('7 comments'), findsOneWidget);
    expect(find.text('A fresh take on that ending.'), findsOneWidget);
    expect(find.text('you'), findsOneWidget);
  });

  testWidgets('Comments on an episode detail opens the comments screen', (
    WidgetTester tester,
  ) async {
    await _goToShell(tester);

    AppRouter.instance.go('/shows/detail/the-agency/episode/1/1');
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Comments'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Comments'));
    await tester.pumpAndSettle();

    expect(find.text('The Briefing'), findsOneWidget);
    expect(find.text('6 comments'), findsOneWidget);
    expect(find.text('Hide Spoilers'), findsOneWidget);
  });

  testWidgets('Comments on a movie detail opens the comments screen', (
    WidgetTester tester,
  ) async {
    await _goToShell(tester);
    await tester.tap(find.text('MOVIES'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('View Details'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Comments'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Comments'));
    await tester.pumpAndSettle();

    expect(find.text('Meridian'), findsOneWidget);
    expect(find.text('6 comments'), findsOneWidget);
    expect(find.text('Hide Spoilers'), findsOneWidget);
  });
}
