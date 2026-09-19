import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/movie.dart';
import '../../data/models/show.dart';
import '../../data/providers/content_repository_provider.dart';
import '../../shared/widgets/watcher_status_bar.dart';
import '../movies/widgets/movie_grid.dart';
import 'widgets/profile_empty_state.dart';
import 'widgets/profile_page_header.dart';
import 'widgets/profile_tabs.dart';
import 'widgets/show_grid.dart';

class WatchlistScreen extends ConsumerStatefulWidget {
  const WatchlistScreen({super.key});

  @override
  ConsumerState<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends ConsumerState<WatchlistScreen> {
  int _activeTab = 0;
  late Future<(List<Movie>, List<Show>)> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<(List<Movie>, List<Show>)> _load() async {
    final repository = ref.read(contentRepositoryProvider);
    final movies = await repository.getMovies();
    final shows = await repository.getShows();
    return (movies, shows);
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
            const ProfilePageHeader(title: 'Watchlist'),
            ProfileTabs(
              tabs: const ['Movies', 'Shows'],
              active: _activeTab,
              onChanged: (i) => setState(() => _activeTab = i),
            ),
            Expanded(
              child: FutureBuilder<(List<Movie>, List<Show>)>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }
                  final (movies, shows) = snapshot.data!;
                  final watchlistMovies = movies
                      .where((m) => m.inWatchlist == true)
                      .toList();
                  final watchlistShows = shows
                      .where((s) => s.inWatchlist == true)
                      .toList();
                  if (_activeTab == 0) {
                    if (watchlistMovies.isEmpty) {
                      return const ProfileEmptyState(
                        title: 'No movies in your watchlist',
                        message: 'Add movies to see them here',
                      );
                    }
                    return ListView(
                      padding: const EdgeInsets.only(bottom: 40),
                      children: [
                        const SizedBox(height: 16),
                        MovieGrid(
                          movies: watchlistMovies,
                          onMovieTap: (movie) =>
                              context.push('/movies/detail/${movie.id}'),
                        ),
                      ],
                    );
                  } else {
                    if (watchlistShows.isEmpty) {
                      return const ProfileEmptyState(
                        title: 'No shows in your watchlist',
                        message: 'Add shows to see them here',
                      );
                    }
                    return ListView(
                      padding: const EdgeInsets.only(bottom: 40),
                      children: [
                        const SizedBox(height: 16),
                        ShowGrid(
                          shows: watchlistShows,
                          onShowTap: (show) =>
                              context.push('/shows/detail/${show.id}'),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
