import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/core/theme/app_theme.dart';
import 'package:watchers/data/models/search_result.dart';
import 'package:watchers/features/auth/domain/entities/auth_user.dart';
import 'package:watchers/features/auth/presentation/screens/auth_screen.dart';
import 'package:watchers/features/comments/comments_screen.dart';
import 'package:watchers/features/movies/movie_detail_screen.dart';
import 'package:watchers/features/movies/movies_screen.dart';
import 'package:watchers/features/profile/profile_screen.dart';
import 'package:watchers/features/profile/settings_screen.dart';
import 'package:watchers/features/search/search_screen.dart';
import 'package:watchers/features/shows/episodes_screen.dart';
import 'package:watchers/features/shows/show_detail_screen.dart';
import 'package:watchers/features/shows/shows_screen.dart';

import 'helpers/auth_test_harness.dart';

const _sizes = <(String, Size)>[
  ('small', Size(320, 568)),
  ('normal', Size(390, 844)),
  ('large', Size(430, 926)),
];

void main() {
  Widget wrap(Widget child, {ProviderContainer? container}) {
    final app = MaterialApp(theme: AppTheme.dark(), home: child);
    if (container == null) return ProviderScope(child: app);
    return UncontrolledProviderScope(container: container, child: app);
  }

  ProviderContainer signedInContainer() => createTestContainer(
    initialUser: const AuthUser(
      uid: 'u1',
      email: 'watcher@watchers.app',
      displayName: 'celestialwatcher',
    ),
  );

  Future<void> pumpSized(
    WidgetTester tester,
    Size size,
    Widget child, {
    ProviderContainer? container,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(wrap(child, container: container));
    if (container == null) {
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
    } else {
      await tester.pumpAndSettle();
    }
  }

  final cases = <(String, Widget, String, ProviderContainer? Function()?)>[
    ('ShowsScreen', const ShowsScreen(), 'Episodes', null),
    (
      'ShowDetailScreen',
      const ShowDetailScreen(showId: 'the-agency'),
      'About',
      null,
    ),
    ('MoviesScreen', const MoviesScreen(), 'Now Playing', null),
    (
      'MovieDetailScreen',
      const MovieDetailScreen(movieId: 'meridian'),
      'Synopsis',
      null,
    ),
    ('SearchScreen', const SearchScreen(), 'Browse Categories', null),
    ('ProfileScreen', const ProfileScreen(), 'celestialwatcher', signedInContainer),
    ('SettingsScreen', const SettingsScreen(), 'Settings', signedInContainer),
    ('AuthScreen', const AuthScreen(), 'or continue with', null),
    (
      'EpisodesScreen',
      const EpisodesScreen(showId: 'the-agency', season: 1),
      'Season progress',
      null,
    ),
    (
      'CommentsScreen',
      const CommentsScreen(itemId: 'the-agency', itemType: ContentType.show),
      'Hide Spoilers',
      null,
    ),
  ];

  for (final (name, screen, marker, containerFactory) in cases) {
    for (final (tierLabel, size) in _sizes) {
      testWidgets('$name renders without overflow on a $tierLabel phone', (
        WidgetTester tester,
      ) async {
        final container = containerFactory?.call();
        await pumpSized(tester, size, screen, container: container);
        expect(find.text(marker), findsWidgets);
      });
    }
  }
}
