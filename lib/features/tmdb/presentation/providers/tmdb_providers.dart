import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/tmdb/tmdb_image_url_builder.dart';
import '../../data/http/dio_tmdb_api_client.dart';
import '../../data/http/tmdb_api_client.dart';
import '../../data/http/tmdb_configuration.dart';
import '../../data/mappers/tmdb_mappers.dart';
import '../../data/repositories/tmdb_repository_impl.dart';
import '../../data/sources/tmdb_remote_data_source.dart';
import '../../data/sources/tmdb_remote_data_source_impl.dart';
import '../../domain/repositories/tmdb_repository.dart';

final tmdbConfigurationProvider = Provider<TmdbConfiguration>(
  (_) => TmdbConfiguration.fromEnvironment(),
);

final tmdbImageUrlBuilderProvider = Provider<TmdbImageUrlBuilder>((ref) {
  return TmdbImageUrlBuilder(
    imageBaseUrl: ref.watch(tmdbConfigurationProvider).imageBaseUrl,
  );
});

final tmdbApiClientProvider = Provider<TmdbApiClient>((ref) {
  return DioTmdbApiClient(configuration: ref.watch(tmdbConfigurationProvider));
});

final tmdbRemoteDataSourceProvider = Provider<TmdbRemoteDataSource>((ref) {
  return TmdbRemoteDataSourceImpl(apiClient: ref.watch(tmdbApiClientProvider));
});

final tmdbMovieMapperProvider = Provider<MovieMapper>((ref) {
  return MovieMapper(imageUrlBuilder: ref.watch(tmdbImageUrlBuilderProvider));
});

final tmdbShowMapperProvider = Provider<TvShowMapper>((ref) {
  return TvShowMapper(imageUrlBuilder: ref.watch(tmdbImageUrlBuilderProvider));
});

final tmdbSearchResultMapperProvider = Provider<SearchResultMapper>((ref) {
  return SearchResultMapper(
    imageUrlBuilder: ref.watch(tmdbImageUrlBuilderProvider),
  );
});

final tmdbGenreMapperProvider = Provider<GenreMapper>(
  (_) => const GenreMapper(),
);

final tmdbCastMapperProvider = Provider<CastMemberMapper>((ref) {
  return CastMemberMapper(imageUrlBuilder: ref.watch(tmdbImageUrlBuilderProvider));
});

final tmdbEpisodeMapperProvider = Provider<EpisodeMapper>((ref) {
  return EpisodeMapper(imageUrlBuilder: ref.watch(tmdbImageUrlBuilderProvider));
});

final tmdbRepositoryProvider = Provider<TmdbRepository>((ref) {
  return TmdbRepositoryImpl(
    remoteDataSource: ref.watch(tmdbRemoteDataSourceProvider),
    movieMapper: ref.watch(tmdbMovieMapperProvider),
    showMapper: ref.watch(tmdbShowMapperProvider),
    searchResultMapper: ref.watch(tmdbSearchResultMapperProvider),
    genreMapper: ref.watch(tmdbGenreMapperProvider),
    castMapper: ref.watch(tmdbCastMapperProvider),
    episodeMapper: ref.watch(tmdbEpisodeMapperProvider),
  );
});
