import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/season.dart';
import '../../data/models/show.dart';
import '../../data/repositories/content_repository.dart';
import '../../data/sources/mock_content_repository.dart';
import '../../shared/widgets/genre_chip.dart';
import 'widgets/show_detail_about.dart';
import 'widgets/show_detail_actions.dart';
import 'widgets/show_detail_cast.dart';
import 'widgets/show_detail_episode_preview.dart';
import 'widgets/show_detail_hero.dart';
import 'widgets/show_detail_season_selector.dart';
import 'widgets/shows_status.dart';

class ShowDetailScreen extends StatefulWidget {
  const ShowDetailScreen({super.key, required this.showId, this.repository});

  final String showId;
  final ContentRepository? repository;

  @override
  State<ShowDetailScreen> createState() => _ShowDetailScreenState();
}

class _ShowDetailScreenState extends State<ShowDetailScreen> {
  late final ContentRepository _repository =
      widget.repository ?? MockContentRepository();
  late Future<Show?> _future;
  bool? _inWatchlist;
  int _activeSeason = 1;

  @override
  void initState() {
    super.initState();
    _future = _repository.getShow(widget.showId);
  }

  void _reload() {
    setState(() {
      _future = _repository.getShow(widget.showId);
    });
  }

  void _toggleWatchlist() {
    setState(() {
      _inWatchlist = !(_inWatchlist ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Scaffold(
      backgroundColor: palette.bg,
      body: FutureBuilder<Show?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ShowsStatus(
              icon: Icons.cloud_off_outlined,
              title: 'Something went wrong',
              message:
                  "We couldn't load this show. Check your connection and try again.",
              actionLabel: 'Try again',
              onAction: _reload,
            );
          }
          final show = snapshot.data;
          if (show == null) {
            return ShowsStatus(
              icon: Icons.live_tv_outlined,
              title: 'Show not found',
              message:
                  'This show could not be found. It may have been removed.',
            );
          }
          return _buildContent(show);
        },
      ),
    );
  }

  Widget _buildContent(Show show) {
    final inWatchlist = _inWatchlist ?? (show.inWatchlist ?? false);
    final season = _seasonFor(show);
    final sizes = context.sizes;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        ShowDetailHero(
          show: show,
          inWatchlist: inWatchlist,
          onToggleWatchlist: _toggleWatchlist,
        ),
        Padding(
          padding: EdgeInsets.all(sizes.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final genre in show.genres) GenreChip(label: genre),
                ],
              ),
              SizedBox(height: sizes.blockGap),
              ShowDetailActions(
                inWatchlist: inWatchlist,
                onToggleWatchlist: _toggleWatchlist,
                onViewEpisodes: season == null
                    ? null
                    : () => _openEpisodes(show, season),
              ),
              SizedBox(height: sizes.sectionGap),
              ShowDetailAbout(synopsis: show.synopsis),
              if (season != null) ...[
                SizedBox(height: sizes.sectionGap),
                ShowDetailSeasonSelector(
                  seasons: show.episodeData,
                  activeSeason: season.number,
                  onSelect: (number) {
                    setState(() => _activeSeason = number);
                  },
                  onAllEpisodes: () => _openEpisodes(show, season),
                ),
                SizedBox(height: sizes.sectionGap),
                ShowDetailEpisodePreview(
                  season: season,
                  onMoreEpisodes: () => _openEpisodes(show, season),
                ),
                SizedBox(height: sizes.sectionGap),
              ],
              ShowDetailCast(cast: show.cast),
            ],
          ),
        ),
      ],
    );
  }

  Season? _seasonFor(Show show) {
    if (show.episodeData.isEmpty) return null;
    for (final season in show.episodeData) {
      if (season.number == _activeSeason) return season;
    }
    return show.episodeData.first;
  }

  void _openEpisodes(Show show, Season season) {
    context.push('/shows/detail/${show.id}/episodes/${season.number}');
  }
}
