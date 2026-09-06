import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/responsive/responsive.dart';
import '../../../data/models/episode.dart';
import '../../../data/models/season.dart';
import '../../../data/models/show.dart';
import '../../../shared/widgets/section_header.dart';
import 'episode_list_item.dart';
import 'watch_history_item.dart';

typedef _EpisodeEntry = ({
  Show show,
  Season season,
  Episode episode,
  bool isNew,
});

class ShowsContent extends StatefulWidget {
  const ShowsContent({
    super.key,
    required this.shows,
    this.watchedOverrides = const {},
    this.pendingWatched = const <String>{},
    this.onToggleWatched,
    this.onClearWatched,
  });

  final List<Show> shows;
  final Map<String, bool> watchedOverrides;
  final Set<String> pendingWatched;
  final ValueChanged<String>? onToggleWatched;
  final ValueChanged<String>? onClearWatched;

  @override
  State<ShowsContent> createState() => _ShowsContentState();
}

class _ShowsContentState extends State<ShowsContent> {
  final ScrollController _controller = ScrollController();
  final GlobalKey _episodesKey = GlobalKey();
  bool _didAlign = false;
  bool _alignScheduled = false;
  int _alignAttempts = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scheduleInitialAlign() {
    if (_alignScheduled) return;
    _alignScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback(_performInitialAlign);
  }

  void _performInitialAlign(Duration _) {
    _alignScheduled = false;
    if (!mounted || _didAlign) return;
    final target = _episodesKey.currentContext;
    if (target == null) {
      if (_alignAttempts < 5) {
        _alignAttempts += 1;
        _scheduleInitialAlign();
      }
      return;
    }
    if (!_controller.hasClients) return;
    final renderObject = target.findRenderObject();
    if (renderObject == null) return;
    final reveal = RenderAbstractViewport.of(
      renderObject,
    ).getOffsetToReveal(renderObject, 0.0);
    _controller.jumpTo(reveal.offset);
    _didAlign = true;
  }

  void _openEpisode(_EpisodeEntry entry) {
    context.push(
      '/shows/detail/${entry.show.id}/episode/'
      '${entry.season.number}/${entry.episode.number}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final watched = _watchedFor(
      widget.shows,
      widget.watchedOverrides,
      widget.pendingWatched,
    );
    final upNext = _upNextFor(widget.shows, widget.watchedOverrides);
    final watchNext = _watchNextFor(widget.shows, widget.watchedOverrides);

    if (watched.isNotEmpty && !_didAlign) {
      _scheduleInitialAlign();
    }

    return ListView(
      controller: _controller,
      scrollCacheExtent: const ScrollCacheExtent.pixels(10000),
      padding: const EdgeInsets.only(bottom: AppConstants.bottomNavOffset),
      children: [
        if (watched.isNotEmpty) ...[
          const SectionHeader(title: 'Watch History'),
          for (final entry in watched)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.sizes.pagePadding,
              ),
              child: _historyItem(entry),
            ),
        ],
        if (watched.isNotEmpty && (upNext.isNotEmpty || watchNext.isNotEmpty))
          SizedBox(height: context.sizes.sectionGap),
        if (upNext.isNotEmpty) ...[
          SectionHeader(key: _episodesKey, title: 'Episodes'),
          for (final entry in upNext)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.sizes.pagePadding,
              ),
              child: _item(entry),
            ),
        ],
        if (watchNext.isNotEmpty) ...[
          if (upNext.isNotEmpty) SizedBox(height: context.sizes.sectionGap),
          const SectionHeader(title: 'Watch Next'),
          for (final entry in watchNext)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.sizes.pagePadding,
              ),
              child: _item(entry),
            ),
        ],
      ],
    );
  }

  Widget _historyItem(_EpisodeEntry entry) {
    final key = _episodeKey(entry.show, entry.season, entry.episode);
    return WatchHistoryItem(
      key: ValueKey('watch-history-item-$key'),
      show: entry.show,
      season: entry.season,
      episode: entry.episode,
      onTap: () => _openEpisode(entry),
      onToggleWatched: widget.onClearWatched == null
          ? null
          : () => widget.onClearWatched!(key),
    );
  }

  Widget _item(_EpisodeEntry entry) {
    final key = _episodeKey(entry.show, entry.season, entry.episode);
    return EpisodeListItem(
      key: ValueKey('episode-list-item-$key'),
      show: entry.show,
      season: entry.season,
      episode: entry.episode,
      watched:
          widget.watchedOverrides[key] ??
          (widget.pendingWatched.contains(key) || entry.episode.watched),
      isNew: entry.isNew,
      onTap: () => _openEpisode(entry),
      onToggleWatched: widget.onToggleWatched == null
          ? null
          : () => widget.onToggleWatched!(key),
    );
  }
}

String _episodeKey(Show show, Season season, Episode episode) =>
    '${show.id}-${season.number}-${episode.number}';

bool _isWatched(
  Show show,
  Season season,
  Episode episode,
  Map<String, bool> overrides,
) => overrides[_episodeKey(show, season, episode)] ?? episode.watched;

bool _isInProgress(Show show) {
  final progress = show.progress ?? 0;
  return progress > 0 && progress < 1;
}

bool _hasNew(Show show) => (show.unwatchedEpisodes ?? 0) > 0;

_EpisodeEntry? _nextEpisode(Show show, Map<String, bool> watchedOverrides) {
  final isNew = _hasNew(show) && !_isInProgress(show);
  for (final season in show.episodeData) {
    for (final episode in season.episodes) {
      if (!_isWatched(show, season, episode, watchedOverrides)) {
        return (show: show, season: season, episode: episode, isNew: isNew);
      }
    }
  }
  return null;
}

List<_EpisodeEntry> _upNextFor(
  List<Show> shows,
  Map<String, bool> watchedOverrides,
) {
  final entries = <_EpisodeEntry>[];
  for (final show in shows) {
    if (show.inWatchlist ?? false) continue;
    final hasNew = _hasNew(show);
    final inProgress = _isInProgress(show);
    final next = _nextEpisode(show, watchedOverrides);
    if (next != null && (hasNew || inProgress)) {
      entries.add(next);
    }
  }
  return entries;
}

List<_EpisodeEntry> _watchNextFor(
  List<Show> shows,
  Map<String, bool> watchedOverrides,
) {
  final entries = <_EpisodeEntry>[];
  for (final show in shows) {
    if (!(show.inWatchlist ?? false)) continue;
    final next = _nextEpisode(show, watchedOverrides);
    if (next != null) {
      entries.add(next);
    }
  }
  return entries;
}

List<_EpisodeEntry> _watchedFor(
  List<Show> shows,
  Map<String, bool> watchedOverrides,
  Set<String> pendingWatched,
) {
  final entries = <_EpisodeEntry>[];
  for (final show in shows) {
    for (final season in show.episodeData) {
      for (final episode in season.episodes) {
        final key = _episodeKey(show, season, episode);
        final committed =
            watchedOverrides[key] ??
            (episode.watched && !pendingWatched.contains(key));
        if (!committed) continue;
        entries.add((
          show: show,
          season: season,
          episode: episode,
          isNew: false,
        ));
      }
    }
  }
  return entries;
}
