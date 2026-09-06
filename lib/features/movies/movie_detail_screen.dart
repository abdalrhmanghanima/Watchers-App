import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/movie.dart';
import '../../data/repositories/content_repository.dart';
import '../../data/sources/mock_content_repository.dart';
import '../../shared/widgets/genre_chip.dart';
import 'widgets/movie_detail_actions.dart';
import 'widgets/movie_detail_cast.dart';
import 'widgets/movie_detail_comments_button.dart';
import 'widgets/movie_detail_hero.dart';
import 'widgets/movie_detail_similar_movies.dart';
import 'widgets/movie_detail_synopsis.dart';
import 'widgets/movies_status.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key, required this.movieId, this.repository});

  final String movieId;
  final ContentRepository? repository;

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late final ContentRepository _repository =
      widget.repository ?? MockContentRepository();
  late Future<(Movie?, List<Movie>)> _future;
  bool? _inWatchlist;
  bool? _watched;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<(Movie?, List<Movie>)> _load() async {
    final movie = await _repository.getMovie(widget.movieId);
    final movies = await _repository.getMovies();
    return (movie, movies);
  }

  void _reload() {
    setState(() {
      _future = _load();
    });
  }

  void _toggleWatchlist() {
    setState(() {
      _inWatchlist = !(_inWatchlist ?? false);
    });
  }

  void _toggleWatched() {
    setState(() {
      _watched = !(_watched ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Scaffold(
      backgroundColor: palette.bg,
      body: FutureBuilder<(Movie?, List<Movie>)>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return MoviesStatus(
              icon: Icons.cloud_off_outlined,
              title: 'Something went wrong',
              message:
                  "We couldn't load this movie. Check your connection and try again.",
              actionLabel: 'Try again',
              onAction: _reload,
            );
          }
          final data = snapshot.data;
          final movie = data?.$1;
          if (movie == null) {
            return MoviesStatus(
              icon: Icons.local_movies_outlined,
              title: 'Movie not found',
              message:
                  'This movie could not be found. It may have been removed.',
            );
          }
          return _buildContent(movie, data!.$2);
        },
      ),
    );
  }

  Widget _buildContent(Movie movie, List<Movie> allMovies) {
    final inWatchlist = _inWatchlist ?? (movie.inWatchlist ?? false);
    final watched = _watched ?? (movie.watched ?? false);
    final sizes = context.sizes;
    final similar = allMovies
        .where(
          (m) =>
              m.id != movie.id && m.genres.any((g) => movie.genres.contains(g)),
        )
        .take(4)
        .toList();
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        MovieDetailHero(
          movie: movie,
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
                  for (final genre in movie.genres) GenreChip(label: genre),
                ],
              ),
              SizedBox(height: sizes.blockGap),
              MovieDetailActions(
                watched: watched,
                inWatchlist: inWatchlist,
                onToggleWatched: _toggleWatched,
                onToggleWatchlist: _toggleWatchlist,
              ),
              SizedBox(height: sizes.sectionGap),
              MovieDetailSynopsis(synopsis: movie.synopsis),
              SizedBox(height: sizes.sectionGap),
              MovieDetailCast(cast: movie.cast),
              SizedBox(height: sizes.sectionGap),
              MovieDetailCommentsButton(
                onTap: () =>
                    context.push('/movies/detail/${movie.id}/comments'),
              ),
              if (similar.isNotEmpty) ...[
                SizedBox(height: sizes.sectionGap),
                MovieDetailSimilarMovies(
                  movies: similar,
                  onMovieTap: (m) => context.push('/movies/detail/${m.id}'),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
