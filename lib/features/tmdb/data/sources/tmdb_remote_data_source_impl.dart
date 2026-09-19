import 'package:watchers/features/tmdb/domain/errors/tmdb_exception.dart';

import '../dtos/cast_member_dto.dart';
import '../dtos/episode_dto.dart';
import '../dtos/genre_dto.dart';
import '../dtos/movie_dto.dart';
import '../dtos/paginated_response_dto.dart';
import '../dtos/search_result_dto.dart';
import '../dtos/tv_show_dto.dart';
import '../http/tmdb_api_client.dart';
import '../http/tmdb_api_response.dart';
import 'tmdb_remote_data_source.dart';

class TmdbRemoteDataSourceImpl implements TmdbRemoteDataSource {
  TmdbRemoteDataSourceImpl({required this.apiClient});

  final TmdbApiClient apiClient;

  @override
  Future<PaginatedResponseDto<MovieDto>> getPopularMovies({int page = 1}) async {
    final response = await _get('/movie/popular', page: page);
    return _parseList<MovieDto>(response, MovieDto.fromJson);
  }

  @override
  Future<PaginatedResponseDto<MovieDto>> getNowPlayingMovies({int page = 1}) async {
    final response = await _get('/movie/now_playing', page: page);
    return _parseList<MovieDto>(response, MovieDto.fromJson);
  }

  @override
  Future<PaginatedResponseDto<MovieDto>> getTopRatedMovies({int page = 1}) async {
    final response = await _get('/movie/top_rated', page: page);
    return _parseList<MovieDto>(response, MovieDto.fromJson);
  }

  @override
  Future<PaginatedResponseDto<TvShowDto>> getPopularShows({int page = 1}) async {
    final response = await _get('/tv/popular', page: page);
    return _parseList<TvShowDto>(response, TvShowDto.fromJson);
  }

  @override
  Future<PaginatedResponseDto<TvShowDto>> getAiringTodayShows({int page = 1}) async {
    final response = await _get('/tv/airing_today', page: page);
    return _parseList<TvShowDto>(response, TvShowDto.fromJson);
  }

  @override
  Future<MovieDto> getMovieDetails(int movieId) async {
    final response = await _get('/movie/$movieId');
    return _parseObject<MovieDto>(response, MovieDto.fromJson);
  }

  @override
  Future<PaginatedResponseDto<MovieDto>> getSimilarMovies(
    int movieId, {
    int page = 1,
  }) async {
    final response = await _get('/movie/$movieId/similar', page: page);
    return _parseList<MovieDto>(response, MovieDto.fromJson);
  }

  @override
  Future<TvShowDto> getShowDetails(int showId) async {
    final response = await _get('/tv/$showId');
    return _parseObject<TvShowDto>(response, TvShowDto.fromJson);
  }

  @override
  Future<List<CastMemberDto>> getMovieCredits(int movieId) async {
    final response = await _get('/movie/$movieId/credits');
    return _parseCreditList(response);
  }

  @override
  Future<List<CastMemberDto>> getShowCredits(int showId) async {
    final response = await _get('/tv/$showId/credits');
    return _parseCreditList(response);
  }

  @override
  Future<PaginatedResponseDto<EpisodeDto>> getSeasonEpisodes(
    int showId,
    int seasonNumber,
  ) async {
    final response = await _get('/tv/$showId/season/$seasonNumber');
    return _parseList<EpisodeDto>(response, EpisodeDto.fromJson);
  }

  @override
  Future<EpisodeDto> getEpisodeDetails(
    int showId,
    int seasonNumber,
    int episodeNumber,
  ) async {
    final response = await _get(
      '/tv/$showId/season/$seasonNumber/episode/$episodeNumber',
    );
    return _parseObject<EpisodeDto>(response, EpisodeDto.fromJson);
  }

  @override
  Future<PaginatedResponseDto<SearchResultDto>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    final response = await apiClient.get(
      '/search/movie',
      queryParameters: {'query': query, 'page': page},
    );
    return _parseList<SearchResultDto>(response, SearchResultDto.fromJson);
  }

  @override
  Future<PaginatedResponseDto<SearchResultDto>> searchShows({
    required String query,
    int page = 1,
  }) async {
    final response = await apiClient.get(
      '/search/tv',
      queryParameters: {'query': query, 'page': page},
    );
    return _parseList<SearchResultDto>(response, SearchResultDto.fromJson);
  }

  @override
  Future<PaginatedResponseDto<SearchResultDto>> searchMulti({
    required String query,
    int page = 1,
  }) async {
    final response = await apiClient.get(
      '/search/multi',
      queryParameters: {'query': query, 'page': page},
    );
    return _parseList<SearchResultDto>(response, SearchResultDto.fromJson);
  }

  @override
  Future<List<GenreDto>> getMovieGenres() async {
    final response = await _get('/genre/movie/list');
    return _parseGenreList(response);
  }

  @override
  Future<List<GenreDto>> getShowGenres() async {
    final response = await _get('/genre/tv/list');
    return _parseGenreList(response);
  }

  Future<TmdbApiResponse> _get(String path, {int? page}) {
    if (page != null) {
      return apiClient.get(path, queryParameters: {'page': page});
    }
    return apiClient.get(path);
  }

  dynamic _responseData(TmdbApiResponse response) {
    final data = response.data;
    if (data is! Map) {
      throw const TmdbException.malformedResponse();
    }
    return data;
  }

  PaginatedResponseDto<T> _parseList<T>(
    TmdbApiResponse response,
    T Function(Map<String, dynamic>) parser,
  ) {
    final data = _responseData(response);
    return PaginatedResponseDto.fromJson(Map<String, dynamic>.from(data), parser);
  }

  T _parseObject<T>(
    TmdbApiResponse response,
    T Function(Map<String, dynamic>) parser,
  ) {
    final data = _responseData(response);
    return parser(Map<String, dynamic>.from(data));
  }

  List<GenreDto> _parseGenreList(TmdbApiResponse response) {
    final data = _responseData(response);
    final map = Map<String, dynamic>.from(data);
    final genres = map['genres'];
    if (genres is List) {
      return genres.whereType<Map>().map((e) {
        return GenreDto.fromJson(Map<String, dynamic>.from(e));
      }).toList();
    }
    throw const TmdbException.malformedResponse();
  }

  List<CastMemberDto> _parseCreditList(TmdbApiResponse response) {
    final data = _responseData(response);
    final map = Map<String, dynamic>.from(data);
    final cast = map['cast'];
    if (cast == null) return const [];
    if (cast is List) {
      return cast.whereType<Map>().map((e) {
        return CastMemberDto.fromJson(Map<String, dynamic>.from(e));
      }).toList();
    }
    throw const TmdbException.malformedResponse();
  }
}
