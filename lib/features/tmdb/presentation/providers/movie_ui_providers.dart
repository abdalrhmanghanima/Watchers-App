import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/movie.dart';
import '../../domain/entities/tmdb_movie.dart';
import '../adapters/tmdb_content_adapters.dart';
import 'movie_catalog_providers.dart';

class MoviesScreenData {
  const MoviesScreenData({
    required this.featured,
    required this.nowPlaying,
    required this.popular,
    required this.topRated,
    required this.genres,
  });

  final Movie? featured;
  final List<Movie> nowPlaying;
  final List<Movie> popular;
  final List<Movie> topRated;
  final List<String> genres;
}

final moviesScreenProvider = FutureProvider<MoviesScreenData>((ref) async {
  final tmdbNowPlaying =
      await ref.watch(moviesNowPlayingProvider.future);
  final tmdbPopular = await ref.watch(moviesPopularProvider.future);
  final tmdbTopRated = await ref.watch(moviesTopRatedProvider.future);
  final tmdbGenres = await ref.watch(movieGenresProvider.future);
  final featured = ref.watch(featuredMovieProvider);

  Movie mapMovie(TmdbMovie movie) {
    return tmdbMovieToMovie(
      movie,
      genres: tmdbGenres,
      inWatchlist: false,
    );
  }

  return MoviesScreenData(
    featured: featured == null ? null : mapMovie(featured),
    nowPlaying: tmdbNowPlaying.map(mapMovie).toList(),
    popular: tmdbPopular.map(mapMovie).toList(),
    topRated: tmdbTopRated.map(mapMovie).toList(),
    genres: tmdbGenres.map((genre) => genre.name).toList(),
  );
});

final moviesNowPlayingProviderAdapter =
    FutureProvider<List<Movie>>((ref) async {
  final tmdb = await ref.watch(moviesNowPlayingProvider.future);
  final genres = await ref.watch(movieGenresProvider.future);
  return tmdb
      .map((movie) => tmdbMovieToMovie(movie, genres: genres))
      .toList();
});

final moviesPopularProviderAdapter =
    FutureProvider<List<Movie>>((ref) async {
  final tmdb = await ref.watch(moviesPopularProvider.future);
  final genres = await ref.watch(movieGenresProvider.future);
  return tmdb
      .map((movie) => tmdbMovieToMovie(movie, genres: genres))
      .toList();
});

final moviesTopRatedProviderAdapter =
    FutureProvider<List<Movie>>((ref) async {
  final tmdb = await ref.watch(moviesTopRatedProvider.future);
  final genres = await ref.watch(movieGenresProvider.future);
  return tmdb
      .map((movie) => tmdbMovieToMovie(movie, genres: genres))
      .toList();
});
