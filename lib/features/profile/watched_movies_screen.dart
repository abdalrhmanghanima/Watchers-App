import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/movie.dart';
import '../../data/repositories/content_repository.dart';
import '../../data/sources/mock_content_repository.dart';
import '../../shared/widgets/watcher_status_bar.dart';
import '../movies/widgets/movie_grid.dart';
import 'widgets/profile_empty_state.dart';
import 'widgets/profile_page_header.dart';

class WatchedMoviesScreen extends StatefulWidget {
  const WatchedMoviesScreen({super.key, this.repository});

  final ContentRepository? repository;

  @override
  State<WatchedMoviesScreen> createState() => _WatchedMoviesScreenState();
}

class _WatchedMoviesScreenState extends State<WatchedMoviesScreen> {
  late final ContentRepository _repository =
      widget.repository ?? MockContentRepository();
  late Future<List<Movie>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repository.getMovies();
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
            const ProfilePageHeader(title: 'Movies'),
            Expanded(
              child: FutureBuilder<List<Movie>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }
                  final watchedMovies = snapshot.data!
                      .where((m) => m.watched == true)
                      .toList();
                  if (watchedMovies.isEmpty) {
                    return const ProfileEmptyState(
                      title: 'No watched movies',
                      message: 'Start watching movies to see them here',
                    );
                  }
                  return ListView(
                    padding: const EdgeInsets.only(bottom: 40),
                    children: [
                      const SizedBox(height: 16),
                      MovieGrid(
                        movies: watchedMovies,
                        onMovieTap: (movie) =>
                            context.push('/movies/detail/${movie.id}'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
