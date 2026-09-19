import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/core/tmdb/tmdb_image_url_builder.dart';
import 'package:watchers/features/tmdb/data/dtos/movie_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/paginated_response_dto.dart';
import 'package:watchers/features/tmdb/data/http/tmdb_configuration.dart';
import 'package:watchers/features/tmdb/data/repositories/tmdb_repository_impl.dart';
import 'package:watchers/features/tmdb/domain/repositories/tmdb_repository.dart';
import 'package:watchers/features/tmdb/presentation/providers/tmdb_providers.dart';

import 'helpers/fake_tmdb_api_client.dart';
import 'helpers/fake_tmdb_remote_data_source.dart';

void main() {
  test('providers expose the default TMDB configuration', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final config = container.read(tmdbConfigurationProvider);

    expect(config, isA<TmdbConfiguration>());
    expect(config.hasApiKey, isFalse);
  });

  test('providers expose an image URL builder from the configuration', () {
    final container = ProviderContainer(
      overrides: [
        tmdbConfigurationProvider.overrideWithValue(
          const TmdbConfiguration(
            apiKey: 'key',
            baseUrl: 'https://api.themoviedb.org/3',
            imageBaseUrl: 'https://image.tmdb.org/t/p/',
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    final builder = container.read(tmdbImageUrlBuilderProvider);

    expect(builder, isA<TmdbImageUrlBuilder>());
    expect(builder.poster('/p.jpg'), 'https://image.tmdb.org/t/p/w342/p.jpg');
  });

  test('providers expose a TMDB repository implementation', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final repository = container.read(tmdbRepositoryProvider);

    expect(repository, isA<TmdbRepository>());
    expect(repository, isA<TmdbRepositoryImpl>());
  });

  test('overriding the data source flows through to the repository', () async {
    final fakeDataSource = FakeTmdbRemoteDataSource();
    fakeDataSource.popularMovies['1'] = PaginatedResponseDto<MovieDto>(
      items: [
        MovieDto.fromJson({
          'id': 1,
          'title': 'Dune',
          'overview': 'O.',
          'poster_path': '/p.jpg',
        }),
      ],
      page: 1,
      totalPages: 1,
      totalResults: 1,
    );
    final container = ProviderContainer(
      overrides: [
        tmdbRemoteDataSourceProvider.overrideWithValue(fakeDataSource),
      ],
    );
    addTearDown(container.dispose);

    final result = await container.read(tmdbRepositoryProvider).getPopularMovies();

    expect(result.items.single.title, 'Dune');
    expect(result.items.single.posterUrl, isNotNull);
  });

  test('overriding the api client flows through the whole stack', () async {
    final apiClient = FakeTmdbApiClient();
    apiClient.enqueue('/movie/popular', {
      'page': 1,
      'total_pages': 1,
      'total_results': 1,
      'results': [
        {
          'id': 5,
          'title': 'FromClient',
          'overview': 'O.',
          'poster_path': '/p.jpg',
        },
      ],
    });
    final container = ProviderContainer(
      overrides: [
        tmdbApiClientProvider.overrideWithValue(apiClient),
      ],
    );
    addTearDown(container.dispose);

    final result = await container.read(tmdbRepositoryProvider).getPopularMovies();

    expect(result.items.single.title, 'FromClient');
    expect(apiClient.requestedPaths, ['/movie/popular']);
  });
}
