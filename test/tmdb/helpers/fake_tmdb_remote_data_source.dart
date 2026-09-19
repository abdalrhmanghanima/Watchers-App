import 'package:watchers/features/tmdb/data/dtos/cast_member_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/episode_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/genre_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/movie_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/paginated_response_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/search_result_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/tv_show_dto.dart';
import 'package:watchers/features/tmdb/data/sources/tmdb_remote_data_source.dart';

class FakeTmdbRemoteDataSource implements TmdbRemoteDataSource {
  FakeTmdbRemoteDataSource({
    Map<String, PaginatedResponseDto<MovieDto>>? popularMovies,
    Map<String, PaginatedResponseDto<MovieDto>>? nowPlaying,
    Map<String, PaginatedResponseDto<MovieDto>>? topRated,
    Map<String, PaginatedResponseDto<TvShowDto>>? popularShows,
    Map<String, PaginatedResponseDto<TvShowDto>>? airingToday,
    Map<String, PaginatedResponseDto<SearchResultDto>>? searchedMovies,
    Map<String, PaginatedResponseDto<SearchResultDto>>? searchedShows,
    Map<String, PaginatedResponseDto<SearchResultDto>>? searchedMulti,
    Map<String, PaginatedResponseDto<MovieDto>>? similarMovies,
    this.movieDetails,
    this.showDetails,
    this.movieCredits,
    this.showCredits,
    this.seasonEpisodes,
    this.episodeDetails,
    this.movieGenres,
    this.showGenres,
    this.error,
  })  : popularMovies = popularMovies ?? <String, PaginatedResponseDto<MovieDto>>{},
        nowPlaying = nowPlaying ?? <String, PaginatedResponseDto<MovieDto>>{},
        topRated = topRated ?? <String, PaginatedResponseDto<MovieDto>>{},
        popularShows = popularShows ?? <String, PaginatedResponseDto<TvShowDto>>{},
        airingToday = airingToday ?? <String, PaginatedResponseDto<TvShowDto>>{},
        searchedMovies = searchedMovies ?? <String, PaginatedResponseDto<SearchResultDto>>{},
        searchedShows = searchedShows ?? <String, PaginatedResponseDto<SearchResultDto>>{},
        searchedMulti = searchedMulti ?? <String, PaginatedResponseDto<SearchResultDto>>{},
        similarMovies = similarMovies ?? <String, PaginatedResponseDto<MovieDto>>{};

  final Map<String, PaginatedResponseDto<MovieDto>> popularMovies;
  final Map<String, PaginatedResponseDto<MovieDto>> nowPlaying;
  final Map<String, PaginatedResponseDto<MovieDto>> topRated;
  final Map<String, PaginatedResponseDto<TvShowDto>> popularShows;
  final Map<String, PaginatedResponseDto<TvShowDto>> airingToday;
  final Map<String, PaginatedResponseDto<SearchResultDto>> searchedMovies;
  final Map<String, PaginatedResponseDto<SearchResultDto>> searchedShows;
  final Map<String, PaginatedResponseDto<SearchResultDto>> searchedMulti;
  final Map<String, PaginatedResponseDto<MovieDto>> similarMovies;
  MovieDto? movieDetails;
  TvShowDto? showDetails;
  List<CastMemberDto>? movieCredits;
  List<CastMemberDto>? showCredits;
  List<EpisodeDto>? seasonEpisodes;
  EpisodeDto? episodeDetails;
  List<GenreDto>? movieGenres;
  List<GenreDto>? showGenres;
  Object? error;

  void failWith(Object error) {
    this.error = error;
  }

  void _maybeThrow() {
    final failure = error;
    if (failure != null) throw failure;
  }

  @override
  Future<PaginatedResponseDto<MovieDto>> getNowPlayingMovies({int page = 1}) async {
    _maybeThrow();
    return nowPlaying['$page'] ?? _emptyMoviePage();
  }

  @override
  Future<PaginatedResponseDto<MovieDto>> getPopularMovies({int page = 1}) async {
    _maybeThrow();
    return popularMovies['$page'] ?? _emptyMoviePage();
  }

  @override
  Future<PaginatedResponseDto<MovieDto>> getTopRatedMovies({int page = 1}) async {
    _maybeThrow();
    return topRated['$page'] ?? _emptyMoviePage();
  }

  @override
  Future<List<CastMemberDto>> getMovieCredits(int movieId) async {
    _maybeThrow();
    return movieCredits ?? const [];
  }

  @override
  Future<PaginatedResponseDto<MovieDto>> getSimilarMovies(
    int movieId, {
    int page = 1,
  }) async {
    _maybeThrow();
    return similarMovies['$movieId:$page'] ?? _emptyMoviePage();
  }

  @override
  Future<List<CastMemberDto>> getShowCredits(int showId) async {
    _maybeThrow();
    return showCredits ?? const [];
  }

  @override
  Future<PaginatedResponseDto<EpisodeDto>> getSeasonEpisodes(
    int showId,
    int seasonNumber,
  ) async {
    _maybeThrow();
    final episodes = seasonEpisodes;
    if (episodes == null) return _emptyEpisodePage();
    return PaginatedResponseDto(
      items: episodes,
      page: 1,
      totalPages: 1,
      totalResults: episodes.length,
    );
  }

  @override
  Future<EpisodeDto> getEpisodeDetails(
    int showId,
    int seasonNumber,
    int episodeNumber,
  ) async {
    _maybeThrow();
    if (episodeDetails == null) {
      throw StateError('no details');
    }
    return episodeDetails!;
  }

  @override
  Future<PaginatedResponseDto<SearchResultDto>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    _maybeThrow();
    return searchedMovies['$query:$page'] ?? _emptySearchPage();
  }

  @override
  Future<PaginatedResponseDto<SearchResultDto>> searchShows({
    required String query,
    int page = 1,
  }) async {
    _maybeThrow();
    return searchedShows['$query:$page'] ?? _emptySearchPage();
  }

  @override
  Future<PaginatedResponseDto<SearchResultDto>> searchMulti({
    required String query,
    int page = 1,
  }) async {
    _maybeThrow();
    return searchedMulti['$query:$page'] ?? _emptySearchPage();
  }

  @override
  Future<PaginatedResponseDto<TvShowDto>> getAiringTodayShows({int page = 1}) async {
    _maybeThrow();
    return airingToday['$page'] ?? _emptyShowPage();
  }

  @override
  Future<PaginatedResponseDto<TvShowDto>> getPopularShows({int page = 1}) async {
    _maybeThrow();
    return popularShows['$page'] ?? _emptyShowPage();
  }

  @override
  Future<MovieDto> getMovieDetails(int movieId) async {
    _maybeThrow();
    if (movieDetails == null) {
      throw StateError('no details');
    }
    return movieDetails!;
  }

  @override
  Future<TvShowDto> getShowDetails(int showId) async {
    _maybeThrow();
    if (showDetails == null) {
      throw StateError('no details');
    }
    return showDetails!;
  }

  @override
  Future<List<GenreDto>> getMovieGenres() async {
    _maybeThrow();
    return movieGenres ?? const [];
  }

  @override
  Future<List<GenreDto>> getShowGenres() async {
    _maybeThrow();
    return showGenres ?? const [];
  }

  PaginatedResponseDto<MovieDto> _emptyMoviePage() {
    return const PaginatedResponseDto(
      items: <MovieDto>[],
      page: 1,
      totalPages: 0,
      totalResults: 0,
    );
  }

  PaginatedResponseDto<TvShowDto> _emptyShowPage() {
    return const PaginatedResponseDto(
      items: <TvShowDto>[],
      page: 1,
      totalPages: 0,
      totalResults: 0,
    );
  }

  PaginatedResponseDto<EpisodeDto> _emptyEpisodePage() {
    return const PaginatedResponseDto(
      items: <EpisodeDto>[],
      page: 1,
      totalPages: 0,
      totalResults: 0,
    );
  }

  PaginatedResponseDto<SearchResultDto> _emptySearchPage() {
    return const PaginatedResponseDto(
      items: <SearchResultDto>[],
      page: 1,
      totalPages: 0,
      totalResults: 0,
    );
  }
}