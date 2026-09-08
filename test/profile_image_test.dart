import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/core/theme/app_theme.dart';
import 'package:watchers/features/auth/domain/entities/auth_user.dart';
import 'package:watchers/features/profile/data/providers/profile_providers.dart';
import 'package:watchers/features/profile/domain/enums/profile_image_source.dart';
import 'package:watchers/features/profile/presentation/providers/profile_controller.dart';
import 'package:watchers/features/profile/profile_screen.dart';
import 'package:watchers/shared/widgets/profile_avatar.dart';

import 'helpers/auth_test_harness.dart';

Future<ProviderContainer> _pumpProfile(WidgetTester tester) async {
  final container = createTestContainer(
    initialUser: const AuthUser(
      uid: 'u1',
      email: 'watcher@watchers.app',
      displayName: 'celestialwatcher',
    ),
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(theme: AppTheme.dark(), home: const ProfileScreen()),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

void main() {
  testWidgets('tapping the avatar opens the photo source sheet', (
    WidgetTester tester,
  ) async {
    await _pumpProfile(tester);

    await tester.tap(find.byType(ProfileAvatar));
    await tester.pumpAndSettle();

    expect(find.text('Camera'), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);
  });

  testWidgets('picking Gallery from the avatar updates the profile photo', (
    WidgetTester tester,
  ) async {
    final container = await _pumpProfile(tester);
    final repo = container.read(profileRepositoryProvider) as FakeProfileRepository;

    await tester.tap(find.byType(ProfileAvatar));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();

    expect(repo.profilePhotoCalls, 1);
    expect(repo.lastProfileSource, ProfileImageSource.gallery);
    expect(
      container.read(profileControllerProvider).value?.photoUrl,
      'https://example.com/profile.jpg',
    );
  });

  testWidgets('picking Camera from the cover updates the cover photo', (
    WidgetTester tester,
  ) async {
    final container = await _pumpProfile(tester);
    final repo = container.read(profileRepositoryProvider) as FakeProfileRepository;

    await tester.tapAt(const Offset(200, 50));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Camera'));
    await tester.pumpAndSettle();

    expect(repo.coverPhotoCalls, 1);
    expect(repo.lastCoverSource, ProfileImageSource.camera);
    expect(
      container.read(profileControllerProvider).value?.coverUrl,
      'https://example.com/cover.jpg',
    );
  });

  testWidgets('dismissing the sheet without a choice makes no changes', (
    WidgetTester tester,
  ) async {
    final container = await _pumpProfile(tester);
    final repo = container.read(profileRepositoryProvider) as FakeProfileRepository;

    await tester.tap(find.byType(ProfileAvatar));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(200, 600));
    await tester.pumpAndSettle();

    expect(repo.profilePhotoCalls, 0);
    expect(repo.coverPhotoCalls, 0);
    expect(find.text('celestialwatcher'), findsOneWidget);
  });
}