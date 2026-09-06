import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watchers/core/constants/app_constants.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/data/models/comment.dart';
import 'package:watchers/data/models/movie.dart';
import 'package:watchers/data/models/show.dart';
import 'package:watchers/data/repositories/content_repository.dart';
import 'package:watchers/data/sources/mock_content_repository.dart';
import 'package:watchers/features/profile/widgets/movies_section.dart';
import 'package:watchers/features/profile/widgets/profile_cover.dart';
import 'package:watchers/features/profile/widgets/profile_stats.dart';
import 'package:watchers/features/profile/widgets/profile_status.dart';
import 'package:watchers/features/profile/widgets/shows_section.dart';
import 'package:watchers/features/profile/widgets/watchlist_section.dart';
import 'package:watchers/features/import/imported_stats_store.dart';
import 'package:watchers/shared/widgets/watcher_status_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.repository});

  final ContentRepository? repository;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ContentRepository _repository =
      widget.repository ?? MockContentRepository();
  late Future<(List<Movie>, List<Show>, List<Comment>)> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<(List<Movie>, List<Show>, List<Comment>)> _load() async {
    final movies = await _repository.getMovies();
    final shows = await _repository.getShows();
    final comments = await _repository.getComments();
    return (movies, shows, comments);
  }

  void _reload() {
    setState(() {
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Scaffold(
      backgroundColor: palette.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const WatcherStatusBar(),
            Expanded(
              child: FutureBuilder<(List<Movie>, List<Show>, List<Comment>)>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return ProfileStatus(
                      icon: Icons.cloud_off_outlined,
                      title: 'Something went wrong',
                      message:
                          "We couldn't load your profile. Check your connection and try again.",
                      actionLabel: 'Try again',
                      onAction: _reload,
                    );
                  }
                  final (movies, shows, comments) =
                      snapshot.data ??
                      (const <Movie>[], const <Show>[], const <Comment>[]);
                  return _buildContent(movies, shows, comments);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    List<Movie> movies,
    List<Show> shows,
    List<Comment> comments,
  ) {
    final watchlistMovies = movies.where((m) => m.inWatchlist == true).toList();
    final watchlistShows = shows.where((s) => s.inWatchlist == true).toList();
    final watchedMovies = movies.where((m) => m.watched == true).toList();
    final watchedShows = shows.where((s) => (s.progress ?? 0) > 0).toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: AppConstants.bottomNavOffset),
      children: [
        ProfileCover(onSettings: () => context.push('/profile/settings')),
        ListenableBuilder(
          listenable: ImportedStatsStore.instance,
          builder: (context, _) => ProfileStats(
            movies: movies,
            shows: shows,
            comments: comments,
            importedStats: ImportedStatsStore.instance.stats,
          ),
        ),
        WatchlistSection(
          movies: watchlistMovies,
          shows: watchlistShows,
          onSeeAll: () => context.push('/profile/watchlist'),
        ),
        ShowsSection(
          shows: watchedShows,
          onSeeAll: () => context.push('/profile/watched-shows'),
        ),
        MoviesSection(
          movies: watchedMovies,
          onSeeAll: () => context.push('/profile/watched-movies'),
        ),
      ],
    );
  }
}
