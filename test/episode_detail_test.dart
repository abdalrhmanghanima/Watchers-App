import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/core/theme/app_theme.dart';
import 'package:watchers/features/shows/episode_detail/episode_detail_screen.dart';
import 'package:watchers/features/shows/episode_detail/widgets/episode_detail_hero.dart';
import 'package:watchers/features/shows/episode_detail/widgets/episode_navigation_row.dart';
import 'package:watchers/features/shows/episode_detail/widgets/episode_show_bar.dart';
import 'package:watchers/features/tmdb/domain/entities/tmdb_episode.dart';
import 'package:watchers/features/tmdb/domain/errors/tmdb_exception.dart';
import 'package:watchers/features/tmdb/domain/repositories/tmdb_repository.dart';
import 'package:watchers/shared/navigation/app_router.dart';

import 'helpers/auth_test_harness.dart';
import 'helpers/fake_tmdb_repository.dart';

Widget _wrap(Widget child) => MaterialApp(theme: AppTheme.dark(), home: child);

Future<void> _pump(
  WidgetTester tester, {
  int season = 1,
  int episode = 1,
  TmdbRepository? tmdbRepository,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final container = createTestContainer(tmdbRepository: tmdbRepository);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: _wrap(
        EpisodeDetailScreen(
          showId: '201',
          season: season,
          episode: episode,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<ProviderContainer> _goToShell(WidgetTester tester) async {
  final container = await pumpApp(tester);
  await goToShell(tester, container);
  return container;
}

void main() {
  testWidgets('Episode Details displays the episode artwork hero', (
    tester,
  ) async {
    await _pump(tester);

    expect(find.byType(EpisodeDetailHero), findsOneWidget);
  });

  testWidgets('Episode Details displays the episode title', (tester) async {
    await _pump(tester);

    expect(find.text('The Briefing'), findsOneWidget);
  });

  testWidgets('Episode Details displays the parent show name', (tester) async {
    await _pump(tester);

    expect(find.text('The Agency'), findsOneWidget);
    expect(find.text('From the series'), findsOneWidget);
  });

  testWidgets('parent show container is tappable', (tester) async {
    await _pump(tester);

    expect(find.byType(EpisodeShowBar), findsOneWidget);
  });

  testWidgets('Episode Details has a Watch Episode button', (tester) async {
    await _pump(tester);

    expect(find.text('Watch Episode'), findsOneWidget);
  });

  testWidgets('Episode Details does NOT have Add to Watchlist', (tester) async {
    await _pump(tester);

    expect(find.text('Add to Watchlist'), findsNothing);
    expect(find.text('Watchlist'), findsNothing);
    expect(find.byIcon(Icons.bookmark), findsNothing);
    expect(find.byIcon(Icons.bookmark_border), findsNothing);
  });

  testWidgets('Episode Details displays the episode description', (
    tester,
  ) async {
    await _pump(tester);

    expect(find.text('About this episode'), findsOneWidget);
    expect(
      find.textContaining("Hana Mori arrives at the Agency's headquarters"),
      findsOneWidget,
    );
  });

  testWidgets('Episode Details displays the cast', (tester) async {
    await _pump(tester);

    expect(find.text('Cast'), findsOneWidget);
    expect(find.text('Diana Roth'), findsOneWidget);
    expect(find.text('Garrett Wells'), findsOneWidget);
  });

  testWidgets('Episode Details displays Comments', (tester) async {
    await _pump(tester);

    expect(find.text('Comments'), findsOneWidget);
    expect(find.textContaining('discussions'), findsOneWidget);
  });

  testWidgets('swiping to the next episode updates the UI', (tester) async {
    await _pump(tester);

    expect(find.text('The Briefing'), findsOneWidget);

    await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();

    expect(find.text('Need to Know'), findsOneWidget);
    expect(find.text('The Briefing'), findsNothing);
  });

  testWidgets('swiping back to the previous episode works', (tester) async {
    await _pump(tester, episode: 2);

    expect(find.text('Need to Know'), findsOneWidget);

    await tester.fling(find.byType(PageView), const Offset(400, 0), 1000);
    await tester.pumpAndSettle();

    expect(find.text('The Briefing'), findsOneWidget);
  });

  testWidgets('first episode boundary does not advance backwards', (
    tester,
  ) async {
    await _pump(tester, episode: 1);

    expect(find.text('The Briefing'), findsOneWidget);

    await tester.fling(find.byType(PageView), const Offset(400, 0), 1000);
    await tester.pumpAndSettle();

    expect(find.text('The Briefing'), findsOneWidget);
  });

  testWidgets('last episode boundary does not advance forwards', (
    tester,
  ) async {
    await _pump(tester, season: 3, episode: 2);

    expect(find.text('The Asset'), findsOneWidget);

    await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();

    expect(find.text('The Asset'), findsOneWidget);
  });

  testWidgets('Watch Episode marks the episode watched', (tester) async {
    await _pump(tester, episode: 5);

    expect(find.text('Not watched'), findsOneWidget);

    await tester.ensureVisible(find.text('Watch Episode'));
    await tester.tap(find.text('Watch Episode'));
    await tester.pumpAndSettle();

    expect(find.text('Watched'), findsOneWidget);
    expect(find.text('Not watched'), findsNothing);
  });

  testWidgets('toggling the watched check reflects the watched state', (
    tester,
  ) async {
    await _pump(tester, episode: 1);

    expect(find.text('Watched'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    expect(find.text('Not watched'), findsOneWidget);
  });

  testWidgets('tapping an episode in the Shows list opens Episode Details', (
    tester,
  ) async {
    await _goToShell(tester);

    final redFolder = find.text('Red Folder');
    await tester.ensureVisible(redFolder);
    await tester.tap(redFolder);
    await tester.pumpAndSettle();

    expect(find.text('Watch Episode'), findsOneWidget);
    expect(find.byType(EpisodeDetailHero), findsOneWidget);
    expect(find.text('Watchlist'), findsNothing);
    expect(find.text('Seasons'), findsNothing);
  });

  testWidgets('tapping the parent show opens the existing Show Details', (
    tester,
  ) async {
    await _goToShell(tester);

    final redFolder = find.text('Red Folder');
    await tester.ensureVisible(redFolder);
    await tester.tap(redFolder);
    await tester.pumpAndSettle();

    expect(find.byType(EpisodeShowBar), findsOneWidget);

    await tester.ensureVisible(find.byType(EpisodeShowBar));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(EpisodeShowBar));
    await tester.pumpAndSettle();

    expect(find.text('About'), findsOneWidget);
    expect(find.text('Seasons'), findsOneWidget);
    expect(find.text('Cast'), findsOneWidget);
  });

  testWidgets('Show Details still keeps Add to Watchlist and seasons', (
    tester,
  ) async {
    final container = await _goToShell(tester);

    container.read(routerProvider).go('/shows/detail/201');
    await tester.pumpAndSettle();

    expect(find.text('About'), findsOneWidget);
    expect(find.text('Seasons'), findsOneWidget);
    expect(find.text('All Episodes'), findsOneWidget);
    expect(find.byIcon(Icons.bookmark), findsNothing);
    expect(find.byIcon(Icons.bookmark_border), findsWidgets);
  });

  testWidgets('tapping an episode in Watch History opens Episode Details', (
    tester,
  ) async {
    await _goToShell(tester);

    await tester.drag(find.byType(ListView), const Offset(0, 1500));
    await tester.pumpAndSettle();

    final briefing = find.text('The Briefing').first;
    await tester.ensureVisible(briefing);
    await tester.tap(briefing);
    await tester.pumpAndSettle();

    expect(find.byType(EpisodeDetailHero), findsOneWidget);
    expect(find.text('Watch Episode'), findsOneWidget);
  });

  testWidgets('Episode Details has no responsive overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await _pump(tester);

    expect(tester.takeException(), isNull);
  });

  testWidgets('Previous/Next controls sit directly below the artwork', (
    tester,
  ) async {
    await _pump(tester);

    final navTop = tester.getTopLeft(find.byType(EpisodeNavigationRow)).dy;
    final heroBottom = tester.getBottomLeft(find.byType(EpisodeDetailHero)).dy;

    expect(navTop, greaterThan(heroBottom));
  });

  testWidgets('tapping Next opens the next episode and updates all content', (
    tester,
  ) async {
    await _pump(tester);

    expect(find.text('The Briefing'), findsOneWidget);
    expect(find.text('Season 1 • Episode 1'), findsOneWidget);

    await tester.ensureVisible(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Need to Know'), findsOneWidget);
    expect(find.text('The Briefing'), findsNothing);
    expect(find.text('Season 1 • Episode 2'), findsOneWidget);
  });

  testWidgets(
    'tapping Previous opens the previous episode and updates all content',
    (tester) async {
      await _pump(tester, episode: 2);

      expect(find.text('Need to Know'), findsOneWidget);
      expect(find.text('Season 1 • Episode 2'), findsOneWidget);

      await tester.ensureVisible(find.text('Previous'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Previous'));
      await tester.pumpAndSettle();

      expect(find.text('The Briefing'), findsOneWidget);
      expect(find.text('Need to Know'), findsNothing);
      expect(find.text('Season 1 • Episode 1'), findsOneWidget);
      expect(find.text('52 min'), findsOneWidget);
      expect(find.text('Mar 10, 2022'), findsOneWidget);
    },
  );

  testWidgets('Previous is disabled on the first episode', (tester) async {
    await _pump(tester, episode: 1);

    final previousInkWell = tester.widget<InkWell>(
      find
          .ancestor(of: find.text('Previous'), matching: find.byType(InkWell))
          .first,
    );
    expect(previousInkWell.onTap, isNull);

    await tester.tap(find.text('Previous'));
    await tester.pumpAndSettle();

    expect(find.text('The Briefing'), findsOneWidget);
    expect(find.text('Season 1 • Episode 1'), findsOneWidget);
  });

  testWidgets('Next is disabled on the last episode', (tester) async {
    await _pump(tester, season: 3, episode: 2);

    final nextInkWell = tester.widget<InkWell>(
      find
          .ancestor(of: find.text('Next'), matching: find.byType(InkWell))
          .first,
    );
    expect(nextInkWell.onTap, isNull);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('The Asset'), findsOneWidget);
    expect(find.text('Season 3 • Episode 2'), findsOneWidget);
  });

  testWidgets('requests dedicated TMDB episode details with the right ids', (
    tester,
  ) async {
    final repo = FakeTmdbRepository();
    await _pump(tester, tmdbRepository: repo);

    expect(
      repo.episodeDetailsRequests,
      contains((showId: 201, seasonNumber: 1, episodeNumber: 1)),
    );
  });

  testWidgets('renders data from the dedicated episode details endpoint', (
    tester,
  ) async {
    await _pump(tester, tmdbRepository: _DistinctEpisodeRepository());

    expect(find.text('The Briefing (Extended)'), findsOneWidget);
    expect(find.text('74 min'), findsOneWidget);
    expect(find.text('A dedicated overview.'), findsOneWidget);
  });

  testWidgets('falls back to list data when dedicated episode details fail', (
    tester,
  ) async {
    await _pump(tester, tmdbRepository: _FailingEpisodeRepository());

    expect(find.text('The Briefing'), findsOneWidget);
    expect(find.text('52 min'), findsOneWidget);
    expect(find.text('Something went wrong'), findsNothing);
  });

  testWidgets(
    'falls back to list data when dedicated episode details are unavailable',
    (tester) async {
      await _pump(tester, tmdbRepository: _NullEpisodeRepository());

      expect(find.text('The Briefing'), findsOneWidget);
      expect(find.text('52 min'), findsOneWidget);
    },
  );

  testWidgets('watched state is preserved alongside dedicated episode details',
      (tester) async {
    await _pump(tester, episode: 1, tmdbRepository: _DistinctEpisodeRepository());

    expect(find.text('Watched'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    expect(find.text('Not watched'), findsOneWidget);
  });
}

class _DistinctEpisodeRepository extends FakeTmdbRepository {
  @override
  Future<TmdbEpisode?> getEpisodeDetails(
    int showId,
    int seasonNumber,
    int episodeNumber,
  ) async {
    episodeDetailsRequests.add(
      (
        showId: showId,
        seasonNumber: seasonNumber,
        episodeNumber: episodeNumber,
      ),
    );
    if (showId == 201 && seasonNumber == 1 && episodeNumber == 1) {
      return TmdbEpisode(
        id: 1011,
        seasonNumber: 1,
        episodeNumber: 1,
        name: 'The Briefing (Extended)',
        overview: 'A dedicated overview.',
        stillUrl: 'https://example.com/still-1011-ext.jpg',
        airDate: DateTime(2022, 3, 10),
        runtimeMinutes: 74,
        rating: 8.7,
        voteCount: 45,
      );
    }
    return super.getEpisodeDetails(showId, seasonNumber, episodeNumber);
  }
}

class _FailingEpisodeRepository extends FakeTmdbRepository {
  @override
  Future<TmdbEpisode?> getEpisodeDetails(
    int showId,
    int seasonNumber,
    int episodeNumber,
  ) async {
    throw const TmdbException.network();
  }
}

class _NullEpisodeRepository extends FakeTmdbRepository {
  @override
  Future<TmdbEpisode?> getEpisodeDetails(
    int showId,
    int seasonNumber,
    int episodeNumber,
  ) async {
    return null;
  }
}
