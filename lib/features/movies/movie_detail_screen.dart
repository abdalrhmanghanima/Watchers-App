import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../features/tmdb/presentation/providers/tmdb_detail_ui_providers.dart';
import '../../shared/widgets/genre_chip.dart';
import 'widgets/movie_detail_actions.dart';
import 'widgets/movie_detail_cast.dart';
import 'widgets/movie_detail_comments_button.dart';
import 'widgets/movie_detail_hero.dart';
import 'widgets/movie_detail_similar_movies.dart';
import 'widgets/movie_detail_synopsis.dart';
import 'widgets/movies_status.dart';

class MovieDetailScreen extends ConsumerStatefulWidget {
  const MovieDetailScreen({super.key, required this.movieId});

  final String movieId;

  @override
  ConsumerState<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends ConsumerState<MovieDetailScreen> {
  bool? _inWatchlist;
  bool? _watched;

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

  void _reload(int id) {
    ref.invalidate(movieDetailDataProvider(id));
  }

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final id = int.tryParse(widget.movieId);
    return Scaffold(
      backgroundColor: palette.bg,
      body: id == null
          ? MoviesStatus(
              icon: Icons.local_movies_outlined,
              title: 'Movie not found',
              message: 'This movie could not be found. It may have been removed.',
            )
          : _buildBody(id),
    );
  }

  Widget _buildBody(int id) {
    final data = ref.watch(movieDetailDataProvider(id));
    return data.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => MoviesStatus(
        icon: Icons.cloud_off_outlined,
        title: 'Something went wrong',
        message:
            "We couldn't load this movie. Check your connection and try again.",
        actionLabel: 'Try again',
        onAction: () => _reload(id),
      ),
      data: (value) {
        final detail = value;
        if (detail == null) {
          return MoviesStatus(
            icon: Icons.local_movies_outlined,
            title: 'Movie not found',
            message:
                'This movie could not be found. It may have been removed.',
          );
        }
        return _buildContent(detail);
      },
    );
  }

  Widget _buildContent(MovieDetailData detail) {
    final movie = detail.movie;
    final inWatchlist = _inWatchlist ?? (movie.inWatchlist ?? false);
    final watched = _watched ?? (movie.watched ?? false);
    final sizes = context.sizes;
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
                  for (final genre in detail.genres) GenreChip(label: genre),
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
              MovieDetailCast(cast: detail.cast),
              SizedBox(height: sizes.sectionGap),
              MovieDetailCommentsButton(
                onTap: () =>
                    context.push('/movies/detail/${movie.id}/comments'),
              ),
              if (detail.similar.isNotEmpty) ...[
                SizedBox(height: sizes.sectionGap),
                MovieDetailSimilarMovies(
                  movies: detail.similar,
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
