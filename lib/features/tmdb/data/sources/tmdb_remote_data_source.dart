import 'package:watchers/features/tmdb/data/dtos/cast_member_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/episode_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/genre_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/movie_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/paginated_response_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/search_result_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/tv_show_dto.dart';

abstract interface class TmdbRemoteDataSource {
  Future<PaginatedResponseDto<MovieDto>> getPopularMovies({int page = 1});

  Future<PaginatedResponseDto<MovieDto>> getNowPlayingMovies({int page = 1});

  Future<PaginatedResponseDto<MovieDto>> getTopRatedMovies({int page = 1});

  Future<PaginatedResponseDto<TvShowDto>> getPopularShows({int page = 1});

  Future<PaginatedResponseDto<TvShowDto>> getAiringTodayShows({int page = 1});

  Future<MovieDto> getMovieDetails(int movieId);

  Future<PaginatedResponseDto<MovieDto>> getSimilarMovies(
    int movieId, {
    int page = 1,
  });

  Future<TvShowDto> getShowDetails(int showId);

  Future<List<CastMemberDto>> getMovieCredits(int movieId);

  Future<List<CastMemberDto>> getShowCredits(int showId);

  Future<PaginatedResponseDto<EpisodeDto>> getSeasonEpisodes(
    int showId,
    int seasonNumber,
  );

  Future<EpisodeDto> getEpisodeDetails(
    int showId,
    int seasonNumber,
    int episodeNumber,
  );

  Future<PaginatedResponseDto<SearchResultDto>> searchMovies({
    required String query,
    int page = 1,
  });

  Future<PaginatedResponseDto<SearchResultDto>> searchShows({
    required String query,
    int page = 1,
  });

  Future<PaginatedResponseDto<SearchResultDto>> searchMulti({
    required String query,
    int page = 1,
  });

  Future<List<GenreDto>> getMovieGenres();

  Future<List<GenreDto>> getShowGenres();
}
