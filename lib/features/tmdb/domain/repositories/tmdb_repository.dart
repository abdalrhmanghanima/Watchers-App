import '../entities/paginated_result.dart';
import '../entities/tmdb_cast_member.dart';
import '../entities/tmdb_episode.dart';
import '../entities/tmdb_genre.dart';
import '../entities/tmdb_movie.dart';
import '../entities/tmdb_search_result.dart';
import '../entities/tmdb_show.dart';

abstract interface class TmdbRepository {
  Future<PaginatedResult<TmdbMovie>> getPopularMovies({int page = 1});

  Future<PaginatedResult<TmdbMovie>> getNowPlayingMovies({int page = 1});

  Future<PaginatedResult<TmdbMovie>> getTopRatedMovies({int page = 1});

  Future<PaginatedResult<TmdbShow>> getPopularShows({int page = 1});

  Future<PaginatedResult<TmdbShow>> getAiringTodayShows({int page = 1});

  Future<TmdbMovie?> getMovieDetails(int movieId);

  Future<PaginatedResult<TmdbMovie>> getSimilarMovies(
    int movieId, {
    int page = 1,
  });

  Future<TmdbShow?> getShowDetails(int showId);

  Future<List<TmdbCastMember>> getMovieCredits(int movieId);

  Future<List<TmdbCastMember>> getShowCredits(int showId);

  Future<PaginatedResult<TmdbEpisode>> getSeasonEpisodes(
    int showId,
    int seasonNumber,
  );

  Future<TmdbEpisode?> getEpisodeDetails(
    int showId,
    int seasonNumber,
    int episodeNumber,
  );

  Future<PaginatedResult<TmdbSearchResult>> searchMovies({
    required String query,
    int page = 1,
  });

  Future<PaginatedResult<TmdbSearchResult>> searchShows({
    required String query,
    int page = 1,
  });

  Future<PaginatedResult<TmdbSearchResult>> searchMulti({
    required String query,
    int page = 1,
  });

  Future<List<TmdbGenre>> getMovieGenres();

  Future<List<TmdbGenre>> getShowGenres();
}
