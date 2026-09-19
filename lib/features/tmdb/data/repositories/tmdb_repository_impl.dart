import 'package:watchers/features/tmdb/domain/entities/paginated_result.dart';
import 'package:watchers/features/tmdb/domain/entities/tmdb_cast_member.dart';
import 'package:watchers/features/tmdb/domain/entities/tmdb_episode.dart';
import 'package:watchers/features/tmdb/domain/entities/tmdb_genre.dart';
import 'package:watchers/features/tmdb/domain/entities/tmdb_movie.dart';
import 'package:watchers/features/tmdb/domain/entities/tmdb_search_result.dart';
import 'package:watchers/features/tmdb/domain/entities/tmdb_show.dart';
import 'package:watchers/features/tmdb/domain/errors/tmdb_exception.dart';
import 'package:watchers/features/tmdb/domain/repositories/tmdb_repository.dart';

import '../mappers/tmdb_mappers.dart';
import '../sources/tmdb_remote_data_source.dart';

class TmdbRepositoryImpl implements TmdbRepository {
  TmdbRepositoryImpl({
    required this.remoteDataSource,
    required this.movieMapper,
    required this.showMapper,
    required this.searchResultMapper,
    required this.genreMapper,
    required this.castMapper,
    required this.episodeMapper,
  });

  final TmdbRemoteDataSource remoteDataSource;
  final MovieMapper movieMapper;
  final TvShowMapper showMapper;
  final SearchResultMapper searchResultMapper;
  final GenreMapper genreMapper;
  final CastMemberMapper castMapper;
  final EpisodeMapper episodeMapper;

  @override
  Future<PaginatedResult<TmdbMovie>> getPopularMovies({int page = 1}) async {
    final dto = await _guard(() => remoteDataSource.getPopularMovies(page: page));
    return PaginatedResult(
      items: dto.items.map(movieMapper.fromDto).toList(),
      page: dto.page,
      totalPages: dto.totalPages,
      totalResults: dto.totalResults,
    );
  }

  @override
  Future<PaginatedResult<TmdbMovie>> getNowPlayingMovies({int page = 1}) async {
    final dto = await _guard(
      () => remoteDataSource.getNowPlayingMovies(page: page),
    );
    return PaginatedResult(
      items: dto.items.map(movieMapper.fromDto).toList(),
      page: dto.page,
      totalPages: dto.totalPages,
      totalResults: dto.totalResults,
    );
  }

  @override
  Future<PaginatedResult<TmdbMovie>> getTopRatedMovies({int page = 1}) async {
    final dto = await _guard(() => remoteDataSource.getTopRatedMovies(page: page));
    return PaginatedResult(
      items: dto.items.map(movieMapper.fromDto).toList(),
      page: dto.page,
      totalPages: dto.totalPages,
      totalResults: dto.totalResults,
    );
  }

  @override
  Future<PaginatedResult<TmdbShow>> getPopularShows({int page = 1}) async {
    final dto = await _guard(() => remoteDataSource.getPopularShows(page: page));
    return PaginatedResult(
      items: dto.items.map(showMapper.fromDto).toList(),
      page: dto.page,
      totalPages: dto.totalPages,
      totalResults: dto.totalResults,
    );
  }

  @override
  Future<PaginatedResult<TmdbShow>> getAiringTodayShows({int page = 1}) async {
    final dto = await _guard(
      () => remoteDataSource.getAiringTodayShows(page: page),
    );
    return PaginatedResult(
      items: dto.items.map(showMapper.fromDto).toList(),
      page: dto.page,
      totalPages: dto.totalPages,
      totalResults: dto.totalResults,
    );
  }

  @override
  Future<TmdbMovie?> getMovieDetails(int movieId) async {
    final dto = await _guard(() => remoteDataSource.getMovieDetails(movieId));
    return movieMapper.fromDto(dto);
  }

  @override
  Future<PaginatedResult<TmdbMovie>> getSimilarMovies(
    int movieId, {
    int page = 1,
  }) async {
    final dto = await _guard(
      () => remoteDataSource.getSimilarMovies(movieId, page: page),
    );
    return PaginatedResult(
      items: dto.items.map(movieMapper.fromDto).toList(),
      page: dto.page,
      totalPages: dto.totalPages,
      totalResults: dto.totalResults,
    );
  }

  @override
  Future<TmdbShow?> getShowDetails(int showId) async {
    final dto = await _guard(() => remoteDataSource.getShowDetails(showId));
    return showMapper.fromDto(dto);
  }

  @override
  Future<List<TmdbCastMember>> getMovieCredits(int movieId) async {
    final dto = await _guard(() => remoteDataSource.getMovieCredits(movieId));
    return dto.map(castMapper.fromDto).toList();
  }

  @override
  Future<List<TmdbCastMember>> getShowCredits(int showId) async {
    final dto = await _guard(() => remoteDataSource.getShowCredits(showId));
    return dto.map(castMapper.fromDto).toList();
  }

  @override
  Future<PaginatedResult<TmdbEpisode>> getSeasonEpisodes(
    int showId,
    int seasonNumber,
  ) async {
    final dto = await _guard(
      () => remoteDataSource.getSeasonEpisodes(showId, seasonNumber),
    );
    return PaginatedResult(
      items: dto.items.map(episodeMapper.fromDto).toList(),
      page: dto.page,
      totalPages: dto.totalPages,
      totalResults: dto.totalResults,
    );
  }

  @override
  Future<TmdbEpisode?> getEpisodeDetails(
    int showId,
    int seasonNumber,
    int episodeNumber,
  ) async {
    final dto = await _guard(
      () =>
          remoteDataSource.getEpisodeDetails(showId, seasonNumber, episodeNumber),
    );
    return episodeMapper.fromDto(dto);
  }

  @override
  Future<PaginatedResult<TmdbSearchResult>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    final dto = await _guard(
      () => remoteDataSource.searchMovies(query: query, page: page),
    );
    return PaginatedResult(
      items: dto.items.map(searchResultMapper.fromDto).toList(),
      page: dto.page,
      totalPages: dto.totalPages,
      totalResults: dto.totalResults,
    );
  }

  @override
  Future<PaginatedResult<TmdbSearchResult>> searchShows({
    required String query,
    int page = 1,
  }) async {
    final dto = await _guard(
      () => remoteDataSource.searchShows(query: query, page: page),
    );
    return PaginatedResult(
      items: dto.items.map(searchResultMapper.fromDto).toList(),
      page: dto.page,
      totalPages: dto.totalPages,
      totalResults: dto.totalResults,
    );
  }

  @override
  Future<PaginatedResult<TmdbSearchResult>> searchMulti({
    required String query,
    int page = 1,
  }) async {
    final dto = await _guard(
      () => remoteDataSource.searchMulti(query: query, page: page),
    );
    return PaginatedResult(
      items: dto.items.map(searchResultMapper.fromDto).toList(),
      page: dto.page,
      totalPages: dto.totalPages,
      totalResults: dto.totalResults,
    );
  }

  @override
  Future<List<TmdbGenre>> getMovieGenres() async {
    final genres = await _guard(() => remoteDataSource.getMovieGenres());
    return genres.map(genreMapper.fromDto).toList();
  }

  @override
  Future<List<TmdbGenre>> getShowGenres() async {
    final genres = await _guard(() => remoteDataSource.getShowGenres());
    return genres.map(genreMapper.fromDto).toList();
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on TmdbException {
      rethrow;
    } catch (_) {
      throw const TmdbException.unknown();
    }
  }
}
