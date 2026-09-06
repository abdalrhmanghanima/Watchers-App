import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/core/theme/app_theme.dart';
import 'package:watchers/data/models/search_result.dart';
import 'package:watchers/features/auth/auth_screen.dart';
import 'package:watchers/features/comments/comments_screen.dart';
import 'package:watchers/features/movies/movie_detail_screen.dart';
import 'package:watchers/features/movies/movies_screen.dart';
import 'package:watchers/features/profile/profile_screen.dart';
import 'package:watchers/features/profile/settings_screen.dart';
import 'package:watchers/features/search/search_screen.dart';
import 'package:watchers/features/shows/episodes_screen.dart';
import 'package:watchers/features/shows/show_detail_screen.dart';
import 'package:watchers/features/shows/shows_screen.dart';

const _sizes = <(String, Size)>[
  ('small', Size(320, 568)),
  ('normal', Size(390, 844)),
  ('large', Size(430, 926)),
];

void main() {
  Widget wrap(Widget child) => MaterialApp(theme: AppTheme.dark(), home: child);

  Future<void> pumpSized(WidgetTester tester, Size size, Widget child) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(wrap(child));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  final cases = <(String, Widget, String)>[
    ('ShowsScreen', const ShowsScreen(), 'Episodes'),
    ('ShowDetailScreen', const ShowDetailScreen(showId: 'the-agency'), 'About'),
    ('MoviesScreen', const MoviesScreen(), 'Now Playing'),
    (
      'MovieDetailScreen',
      const MovieDetailScreen(movieId: 'meridian'),
      'Synopsis',
    ),
    ('SearchScreen', const SearchScreen(), 'Browse Categories'),
    ('ProfileScreen', const ProfileScreen(), 'celestialwatcher'),
    ('SettingsScreen', const SettingsScreen(), 'Settings'),
    ('AuthScreen', const AuthScreen(), 'or continue with'),
    (
      'EpisodesScreen',
      const EpisodesScreen(showId: 'the-agency', season: 1),
      'Season progress',
    ),
    (
      'CommentsScreen',
      const CommentsScreen(itemId: 'the-agency', itemType: ContentType.show),
      'Hide Spoilers',
    ),
  ];

  for (final (name, screen, marker) in cases) {
    for (final (tierLabel, size) in _sizes) {
      testWidgets('$name renders without overflow on a $tierLabel phone', (
        WidgetTester tester,
      ) async {
        await pumpSized(tester, size, screen);
        expect(find.text(marker), findsWidgets);
      });
    }
  }
}
