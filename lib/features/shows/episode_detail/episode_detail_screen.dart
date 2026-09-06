import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/episode.dart';
import '../../../data/models/season.dart';
import '../../../data/models/show.dart';
import '../../../data/repositories/content_repository.dart';
import '../../../data/sources/mock_content_repository.dart';
import '../../../shared/widgets/watcher_status_bar.dart';
import '../widgets/shows_status.dart';
import 'widgets/episode_detail_page.dart';
import 'widgets/episode_page_indicator.dart';

typedef _EpisodeEntry = ({Season season, Episode episode});

class EpisodeDetailScreen extends StatefulWidget {
  const EpisodeDetailScreen({
    super.key,
    required this.showId,
    required this.season,
    required this.episode,
    this.repository,
  });

  final String showId;
  final int season;
  final int episode;
  final ContentRepository? repository;

  @override
  State<EpisodeDetailScreen> createState() => _EpisodeDetailScreenState();
}

class _EpisodeDetailScreenState extends State<EpisodeDetailScreen> {
  late final ContentRepository _repository =
      widget.repository ?? MockContentRepository();
  late Future<Show?> _future;
  final Map<String, bool> _watchedOverrides = {};
  PageController? _pageController;
  int _entryCount = 0;
  bool _initialized = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _future = _repository.getShow(widget.showId);
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  Future<Show?> _load() => _repository.getShow(widget.showId);

  void _reload() {
    _initialized = false;
    setState(() {
      _future = _load();
    });
  }

  List<_EpisodeEntry> _flatten(Show show) {
    final entries = <_EpisodeEntry>[];
    for (final season in show.episodeData) {
      for (final episode in season.episodes) {
        entries.add((season: season, episode: episode));
      }
    }
    return entries;
  }

  int _indexFor(Show show, List<_EpisodeEntry> entries) {
    for (var i = 0; i < entries.length; i++) {
      if (entries[i].season.number == widget.season &&
          entries[i].episode.number == widget.episode) {
        return i;
      }
    }
    return 0;
  }

  void _ensureInitialized(Show show, List<_EpisodeEntry> entries) {
    if (_initialized || entries.isEmpty) return;
    _initialized = true;
    _entryCount = entries.length;
    _pageController = PageController(initialPage: _indexFor(show, entries));
  }

  bool _isWatched(Season season, Episode episode) =>
      _watchedOverrides['${season.number}-${episode.number}'] ??
      episode.watched;

  void _toggleWatched(Season season, Episode episode) {
    setState(() {
      _watchedOverrides['${season.number}-${episode.number}'] = !_isWatched(
        season,
        episode,
      );
    });
  }

  void _markWatched(Season season, Episode episode) {
    setState(() {
      _watchedOverrides['${season.number}-${episode.number}'] = true;
    });
  }

  void _goTo(int page) {
    if (page < 0 || page >= _entryCount) return;
    final controller = _pageController;
    if (controller == null || !controller.hasClients) return;
    controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOutCubic,
    );
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
                  "We couldn't load this episode. Check your connection and try again.",
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
    final entries = _flatten(show);
    if (entries.isEmpty) {
      return const ShowsStatus(
        icon: Icons.video_library_outlined,
        title: 'No episodes yet',
        message: "Episodes for this show haven't been added yet.",
      );
    }
    final sizes = context.sizes;
    _ensureInitialized(show, entries);
    final controller = _pageController!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const WatcherStatusBar(),
        Expanded(
          child: PageView.builder(
            controller: controller,
            itemCount: entries.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final entry = entries[index];
              return EpisodeDetailPage(
                show: show,
                season: entry.season,
                episode: entry.episode,
                watched: _isWatched(entry.season, entry.episode),
                onWatch: () => _markWatched(entry.season, entry.episode),
                onToggleWatched: () =>
                    _toggleWatched(entry.season, entry.episode),
                onShowTap: () => _openShow(show),
                onComments: () => _openComments(show, entry),
                hasNext: index < entries.length - 1,
                hasPrevious: index > 0,
                onNext: index < entries.length - 1
                    ? () => _goTo(index + 1)
                    : null,
                onPrevious: index > 0 ? () => _goTo(index - 1) : null,
              );
            },
          ),
        ),
        if (_entryCount > 1)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sizes.pagePadding,
              vertical: sizes.itemGap,
            ),
            child: EpisodePageIndicator(
              current: _currentIndex.clamp(0, entries.length - 1),
              total: entries.length,
            ),
          ),
      ],
    );
  }

  void _openShow(Show show) {
    context.push('/shows/detail/${show.id}');
  }

  void _openComments(Show show, _EpisodeEntry entry) {
    final id = '${show.id}:${entry.season.number}:${entry.episode.number}';
    context.push('/shows/detail/${show.id}/episode-comments/$id');
  }
}
