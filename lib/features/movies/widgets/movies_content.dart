import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/responsive/responsive.dart';
import '../../../data/models/movie.dart';
import '../../../shared/widgets/poster_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../movie_list_screen.dart';
import 'movie_grid.dart';
import 'movie_row.dart';
import 'movies_hero.dart';

class MoviesContent extends StatelessWidget {
  const MoviesContent({
    super.key,
    required this.movies,
    this.featuredInWatchlist,
    this.onToggleFeaturedWatchlist,
  });

  final List<Movie> movies;
  final bool? featuredInWatchlist;
  final VoidCallback? onToggleFeaturedWatchlist;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    final featured = movies.first;
    final featuredPinned =
        featuredInWatchlist ?? (featured.inWatchlist ?? false);
    final nowPlaying = movies.length > 1
        ? movies.sublist(1, movies.length > 5 ? 5 : movies.length)
        : const <Movie>[];
    final acclaimed = movies.length > 4
        ? movies.sublist(4, movies.length > 8 ? 8 : movies.length)
        : const <Movie>[];
    final watchlist = movies
        .where(
          (movie) => movie.id == featured.id
              ? featuredPinned
              : movie.inWatchlist ?? false,
        )
        .toList();
    void openMovie(Movie movie) => context.push('/movies/detail/${movie.id}');
    void openMovieList(String title, List<Movie> movies) => context.push(
      '/movies/list',
      extra: MovieListArgs(title: title, movies: movies),
    );
    return ListView(
      padding: const EdgeInsets.only(bottom: AppConstants.bottomNavOffset),
      children: [
        MoviesHero(
          movie: featured,
          onViewDetails: () => openMovie(featured),
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
        if (acclaimed.isNotEmpty) ...[
          SizedBox(height: sizes.sectionGap),
          SectionHeader(
            title: 'Top Rated',
            action: 'See all',
            onAction: () => openMovieList('Top Rated', acclaimed),
          ),
          MovieRow(
            movies: acclaimed,
            size: PosterCardSize.md,
            onMovieTap: openMovie,
          ),
        ],
        if (watchlist.isNotEmpty) ...[
          SizedBox(height: sizes.sectionGap),
          const SectionHeader(title: 'Your Watchlist'),
          MovieRow(
            movies: watchlist,
            size: PosterCardSize.sm,
            onMovieTap: openMovie,
          ),
        ],
        SizedBox(height: sizes.sectionGap),
        const SectionHeader(title: 'All Movies'),
        MovieGrid(movies: movies, onMovieTap: openMovie),
      ],
    );
  }
}
