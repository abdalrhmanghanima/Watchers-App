import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/tmdb_cast_member.dart';
import '../../domain/entities/tmdb_genre.dart';
import '../../domain/entities/tmdb_movie.dart';
import '../../domain/entities/tmdb_show.dart';
import 'movie_catalog_providers.dart';
import 'show_catalog_providers.dart';
import 'tmdb_providers.dart';

typedef MovieDetailBundle = ({
  TmdbMovie? movie,
  List<TmdbCastMember> cast,
});

typedef ShowDetailBundle = ({TmdbShow? show, List<TmdbCastMember> cast});

final movieDetailBundleProvider =
    FutureProvider.autoDispose.family<MovieDetailBundle, int>((
      ref,
      movieId,
    ) async {
      final repository = ref.watch(tmdbRepositoryProvider);
      final movieFuture = repository.getMovieDetails(movieId);
      final castFuture = repository.getMovieCredits(movieId);
      final movie = await movieFuture;
      final cast = await castFuture;
      return (movie: movie, cast: cast);
    });

final showDetailBundleProvider =
    FutureProvider.autoDispose.family<ShowDetailBundle, int>((
      ref,
      showId,
    ) async {
      final repository = ref.watch(tmdbRepositoryProvider);
      final showFuture = repository.getShowDetails(showId);
      final castFuture = repository.getShowCredits(showId);
      final show = await showFuture;
      final cast = await castFuture;
      return (show: show, cast: cast);
    });

final similarMoviesProvider =
    FutureProvider.autoDispose.family<List<TmdbMovie>, int>((
      ref,
      movieId,
    ) async {
      final result = await ref.watch(tmdbRepositoryProvider).getSimilarMovies(movieId);
      return result.items;
    }, retry: (retryCount, error) => null);

final movieGenreNameProvider = Provider.family<String?, int>((ref, genreId) {
  final genres = ref.watch(movieGenresProvider).value ?? const <TmdbGenre>[];
  return genreNameFor(genres, genreId);
});

final showGenreNameProvider = Provider.family<String?, int>((ref, genreId) {
  final genres = ref.watch(showGenresProvider).value ?? const <TmdbGenre>[];
  return genreNameFor(genres, genreId);
});

String? genreNameFor(List<TmdbGenre> genres, int genreId) {
  for (final genre in genres) {
    if (genre.id == genreId) return genre.name;
  }
  return null;
}

List<String> genreNamesFor(List<TmdbGenre> genres, List<int> genreIds) {
  final names = <String>[];
  for (final id in genreIds) {
    final name = genreNameFor(genres, id);
    if (name != null) names.add(name);
  }
  return names;
}