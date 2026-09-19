import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/cast_member.dart';
import '../../../../data/models/movie.dart';
import '../../../../data/models/show.dart';
import '../../../../data/providers/content_repository_provider.dart';
import '../../domain/entities/tmdb_genre.dart';
import '../adapters/tmdb_content_adapters.dart';
import 'movie_catalog_providers.dart';
import 'show_catalog_providers.dart';
import 'tmdb_detail_providers.dart';

class MovieDetailData {
  const MovieDetailData({
    required this.movie,
    required this.cast,
    required this.genres,
    required this.similar,
  });

  final Movie movie;
  final List<CastMember> cast;
  final List<String> genres;
  final List<Movie> similar;
}

final movieDetailDataProvider =
    FutureProvider.autoDispose.family<MovieDetailData?, int>((
      ref,
      movieId,
    ) async {
  final bundle = await ref.watch(movieDetailBundleProvider(movieId).future);
  final movie = bundle.movie;
  if (movie == null) return null;

  final catalogGenres = await ref.watch(movieGenresProvider.future);

  final userMovie = await ref
      .watch(contentRepositoryProvider)
      .getMovie(movieId.toString());

  final mapped = tmdbMovieToMovie(
    movie,
    genres: catalogGenres,
    cast: bundle.cast,
    watched: userMovie?.watched,
    inWatchlist: userMovie?.inWatchlist,
  );

  final similarTmdb = await ref.watch(similarMoviesProvider(movieId).future);
  final similarMovies = <Movie>[];
  final seen = <int>{movieId};
  for (final entry in similarTmdb) {
    if (seen.contains(entry.id)) continue;
    seen.add(entry.id);
    similarMovies.add(tmdbMovieToMovie(entry, genres: catalogGenres));
    if (similarMovies.length >= 4) break;
  }

  return MovieDetailData(
    movie: mapped,
    cast: bundle.cast.map(tmdbCastMemberToCastMember).toList(),
    genres: _genreNamesFor(catalogGenres, movie.genreIds),
    similar: similarMovies,
  );
});

List<String> _genreNamesFor(List<TmdbGenre> genres, List<int> ids) {
  final names = <String>[];
  for (final id in ids) {
    for (final genre in genres) {
      if (genre.id == id) {
        names.add(genre.name);
        break;
      }
    }
  }
  return names;
}

class ShowDetailData {
  const ShowDetailData({
    required this.show,
    required this.cast,
    required this.genres,
  });

  final Show show;
  final List<CastMember> cast;
  final List<String> genres;
}

final showDetailDataProvider =
    FutureProvider.autoDispose.family<ShowDetailData?, int>((
      ref,
      showId,
    ) async {
  final bundle = await ref.watch(showDetailBundleProvider(showId).future);
  final show = bundle.show;
  if (show == null) return null;

  final catalogGenres = await ref.watch(showGenresProvider.future);
  final mapped = tmdbShowToShow(show, genres: catalogGenres, cast: bundle.cast);

  return ShowDetailData(
    show: mapped,
    cast: bundle.cast.map(tmdbCastMemberToCastMember).toList(),
    genres: _genreNamesFor(catalogGenres, show.genreIds),
  );
});
