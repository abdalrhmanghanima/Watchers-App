import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_text_styles.dart';
import 'package:watchers/data/models/episode.dart';
import 'package:watchers/data/models/season.dart';
import 'package:watchers/data/models/show.dart';
import 'package:watchers/features/tmdb/presentation/providers/show_detail_ui_providers.dart';
import 'package:watchers/shared/widgets/watcher_status_bar.dart';

import 'widgets/episode_card.dart';
import 'widgets/episodes_header.dart';
import 'widgets/episodes_progress.dart';
import 'widgets/episodes_season_tabs.dart';
import 'widgets/shows_status.dart';

class EpisodesScreen extends ConsumerStatefulWidget {
  const EpisodesScreen({
    super.key,
    required this.showId,
    required this.season,
  });

  final String showId;
  final int season;

  @override
  ConsumerState<EpisodesScreen> createState() => _EpisodesScreenState();
}

class _EpisodesScreenState extends ConsumerState<EpisodesScreen> {
  late int _activeSeason = widget.season;
  final Map<String, bool> _watchedOverrides = {};

  Season _seasonFor(Show show) {
    for (final season in show.episodeData) {
      if (season.number == _activeSeason) return season;
    }
    return show.episodeData.first;
  }

  bool _isWatched(int seasonNumber, Episode episode) =>
      _watchedOverrides['$seasonNumber-${episode.number}'] ?? episode.watched;

  int _watchedCount(Season season) =>
      season.episodes.where((e) => _isWatched(season.number, e)).length;

  void _toggleWatched(int seasonNumber, Episode episode) {
    final key = '$seasonNumber-${episode.number}';
    setState(() {
      _watchedOverrides[key] = !_isWatched(seasonNumber, episode);
    });
  }

  void _markAllWatched(Season season) {
    setState(() {
      for (final episode in season.episodes) {
        _watchedOverrides['${season.number}-${episode.number}'] = true;
      }
    });
  }

  void _openEpisode(Show show, int seasonNumber, Episode episode) {
    context.push(
      '/shows/detail/${show.id}/episode/$seasonNumber/${episode.number}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final showId = int.tryParse(widget.showId);
    return Scaffold(
      backgroundColor: palette.bg,
      body: showId == null
          ? ShowsStatus(
              icon: Icons.live_tv_outlined,
              title: 'Show not found',
              message:
                  'This show could not be found. It may have been removed.',
            )
          : _buildBody(showId),
    );
  }

  Widget _buildBody(int showId) {
    final detail = ref.watch(
      showDetailForActiveSeasonProvider(
        (showId: showId, seasonNumber: _activeSeason),
      ),
    );
    return detail.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => ShowsStatus(
        icon: Icons.cloud_off_outlined,
        title: 'Something went wrong',
        message:
            "We couldn't load this show. Check your connection and try again.",
        actionLabel: 'Try again',
        onAction: () => ref.invalidate(
          showDetailForActiveSeasonProvider(
            (showId: showId, seasonNumber: _activeSeason),
          ),
        ),
      ),
      data: (data) {
        if (data == null) {
          return ShowsStatus(
            icon: Icons.live_tv_outlined,
            title: 'Show not found',
            message:
                'This show could not be found. It may have been removed.',
          );
        }
        return _buildContent(data.show);
      },
    );
  }

  Widget _buildContent(Show show) {
    if (show.episodeData.isEmpty) {
      return const ShowsStatus(
        icon: Icons.video_library_outlined,
        title: 'No episodes yet',
        message: "Episodes for this show haven't been added yet.",
      );
    }
    final season = _seasonFor(show);
    final watched = _watchedCount(season);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const WatcherStatusBar(),
        EpisodesHeader(
          title: show.title,
          seasonNumber: season.number,
          watchedCount: watched,
          total: season.episodes.length,
        ),
        EpisodesSeasonTabs(
          seasons: show.episodeData,
          activeSeason: season.number,
          onSelect: (number) => setState(() => _activeSeason = number),
          onMarkAll: () => _markAllWatched(season),
        ),
        EpisodesProgress(watchedCount: watched, total: season.episodes.length),
        Expanded(
          child: season.episodes.isEmpty
              ? _emptyMessage()
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 32),
                  itemCount: season.episodes.length,
                  itemBuilder: (context, index) {
                    final episode = season.episodes[index];
                    return EpisodeCard(
                      key: ValueKey(
                        'episode-${season.number}-${episode.number}',
                      ),
                      episode: episode,
                      backdropUrl: show.backdropUrl,
                      watched: _isWatched(season.number, episode),
                      onToggleWatched: () =>
                          _toggleWatched(season.number, episode),
                      onTap: () => _openEpisode(show, season.number, episode),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _emptyMessage() {
    final palette = WatchersPalette.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          'No episodes available yet.',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: palette.textSec),
        ),
      ),
    );
  }
}
