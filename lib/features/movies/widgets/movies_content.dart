import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/responsive/responsive.dart';
import '../../../data/models/movie.dart';
import '../../../shared/widgets/genre_chip.dart';
import '../../../shared/widgets/poster_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../movie_list_screen.dart';
import 'movie_grid.dart';
import 'movie_row.dart';
import 'movies_hero.dart';

class MoviesContent extends StatelessWidget {
  const MoviesContent({
    super.key,
    required this.featured,
    required this.nowPlaying,
    required this.popular,
    required this.topRated,
    required this.genres,
    this.featuredInWatchlist,
    this.onToggleFeaturedWatchlist,
  });

  final Movie? featured;
  final List<Movie> nowPlaying;
  final List<Movie> popular;
  final List<Movie> topRated;
  final List<String> genres;
  final bool? featuredInWatchlist;
  final VoidCallback? onToggleFeaturedWatchlist;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    final heroMovie = featured ?? (nowPlaying.isNotEmpty ? nowPlaying.first : null);
    void openMovie(Movie movie) => context.push('/movies/detail/${movie.id}');
    void openMovieList(String title, List<Movie> movies) => context.push(
      '/movies/list',
      extra: MovieListArgs(title: title, movies: movies),
    );
    return ListView(
      key: const ValueKey('movies-content-list'),
      primary: true,
      padding: const EdgeInsets.only(bottom: AppConstants.bottomNavOffset),
      children: [
        if (heroMovie != null)
          MoviesHero(
            movie: heroMovie,
            onViewDetails: () => openMovie(heroMovie),
            onToggleWatchlist: onToggleFeaturedWatchlist,
          ),
        SizedBox(height: sizes.blockGap),
        if (nowPlaying.isNotEmpty) ...[
          SectionHeader(
            title: 'Now Playing',
            action: 'See all',
            onAction: () => openMovieList('Now Playing', nowPlaying),
          ),
          MovieRow(
            movies: nowPlaying,
            size: PosterCardSize.md,
            onMovieTap: openMovie,
          ),
        ],
        if (popular.isNotEmpty) ...[
          SizedBox(height: sizes.sectionGap),
          SectionHeader(
            title: 'Popular',
            action: 'See all',
            onAction: () => openMovieList('Popular', popular),
          ),
          MovieRow(
            movies: popular,
            size: PosterCardSize.md,
            onMovieTap: openMovie,
          ),
        ],
        if (topRated.isNotEmpty) ...[
          SizedBox(height: sizes.sectionGap),
          SectionHeader(
            title: 'Top Rated',
            action: 'See all',
            onAction: () => openMovieList('Top Rated', topRated),
          ),
          MovieRow(
            movies: topRated,
            size: PosterCardSize.md,
            onMovieTap: openMovie,
          ),
        ],
        if (genres.isNotEmpty) ...[
          SizedBox(height: sizes.sectionGap),
          const SectionHeader(title: 'Genres'),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sizes.pagePadding),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final genre in genres) GenreChip(label: genre),
              ],
            ),
          ),
        ],
        SizedBox(height: sizes.sectionGap),
        const SectionHeader(title: 'All Movies'),
        MovieGrid(
          movies: [...nowPlaying, ...popular, ...topRated],
          onMovieTap: openMovie,
        ),
      ],
    );
  }
}
