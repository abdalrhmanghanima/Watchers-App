import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/tmdb_genre.dart';
import '../../domain/entities/tmdb_movie.dart';
import 'tmdb_providers.dart';

enum MovieSection { featured, nowPlaying, popular, topRated }

final moviesNowPlayingProvider = FutureProvider<List<TmdbMovie>>((ref) async {
  final result = await ref.watch(tmdbRepositoryProvider).getNowPlayingMovies();
  return result.items;
});

final moviesPopularProvider = FutureProvider<List<TmdbMovie>>((ref) async {
  final result = await ref.watch(tmdbRepositoryProvider).getPopularMovies();
  return result.items;
});

final moviesTopRatedProvider = FutureProvider<List<TmdbMovie>>((ref) async {
  final result = await ref.watch(tmdbRepositoryProvider).getTopRatedMovies();
  return result.items;
});

final movieGenresProvider = FutureProvider<List<TmdbGenre>>((ref) async {
  return ref.watch(tmdbRepositoryProvider).getMovieGenres();
});

final featuredMovieProvider = Provider<TmdbMovie?>((ref) {
  final nowPlaying =
      ref.watch(moviesNowPlayingProvider).value ?? const <TmdbMovie>[];
  final popular =
      ref.watch(moviesPopularProvider).value ?? const <TmdbMovie>[];
  return selectFeaturedMovie(nowPlaying, popular);
});

final moviesSectionProvider =
    FutureProvider.family<List<TmdbMovie>, MovieSection>((
      ref,
      section,
    ) async {
      final repository = ref.watch(tmdbRepositoryProvider);
      switch (section) {
        case MovieSection.nowPlaying:
          return (await repository.getNowPlayingMovies()).items;
        case MovieSection.popular:
          return (await repository.getPopularMovies()).items;
        case MovieSection.topRated:
          return (await repository.getTopRatedMovies()).items;
        case MovieSection.featured:
          final items = (await repository.getNowPlayingMovies()).items;
          final featured = selectFeaturedMovie(items, const <TmdbMovie>[]);
          return featured == null ? const <TmdbMovie>[] : <TmdbMovie>[featured];
      }
    });

TmdbMovie? selectFeaturedMovie(
  List<TmdbMovie> nowPlaying,
  List<TmdbMovie> popular,
) {
  for (final movie in nowPlaying) {
    if (movie.backdropUrl != null && movie.posterUrl != null) return movie;
  }
  for (final movie in nowPlaying) {
    if (movie.backdropUrl != null || movie.posterUrl != null) return movie;
  }
  if (nowPlaying.isEmpty) {
    for (final movie in popular) {
      if (movie.backdropUrl != null && movie.posterUrl != null) return movie;
    }
  }
  if (nowPlaying.isNotEmpty) return nowPlaying.first;
  if (popular.isNotEmpty) return popular.first;
  return null;
}