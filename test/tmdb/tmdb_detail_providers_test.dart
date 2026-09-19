import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/features/tmdb/data/dtos/cast_member_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/genre_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/movie_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/tv_show_dto.dart';
import 'package:watchers/features/tmdb/domain/entities/tmdb_genre.dart';
import 'package:watchers/features/tmdb/presentation/providers/movie_catalog_providers.dart';
import 'package:watchers/features/tmdb/presentation/providers/show_catalog_providers.dart';
import 'package:watchers/features/tmdb/presentation/providers/tmdb_detail_providers.dart';
import 'package:watchers/features/tmdb/presentation/providers/tmdb_providers.dart';

import 'helpers/fake_tmdb_remote_data_source.dart';

void main() {
  late FakeTmdbRemoteDataSource dataSource;
  late ProviderContainer container;

  setUp(() {
    dataSource = FakeTmdbRemoteDataSource();
    container = ProviderContainer(
      overrides: [tmdbRemoteDataSourceProvider.overrideWithValue(dataSource)],
    );
    addTearDown(container.dispose);
  });

  group('detail bundle providers', () {
    test('movieDetailBundleProvider combines details and cast', () async {
      dataSource.movieDetails = MovieDto.fromJson({
        'id': 42,
        'title': 'Dune',
        'overview': 'O.',
      });
      dataSource.movieCredits = const [
        CastMemberDto(id: 7, name: 'Jane', character: 'Hero', order: 0),
      ];

      final result = await container.read(movieDetailBundleProvider(42).future);

      expect(result.movie, isNotNull);
      expect(result.movie!.title, 'Dune');
      expect(result.cast.single.name, 'Jane');
    });

    test('showDetailBundleProvider combines details and cast', () async {
      dataSource.showDetails = TvShowDto.fromJson({
        'id': 7,
        'name': 'Foundation',
        'seasons': [
          {'season_number': 1, 'name': 'Season 1', 'episode_count': 10},
        ],
      });
      dataSource.showCredits = const [
        CastMemberDto(id: 8, name: 'John', character: 'Villain', order: 1),
      ];

      final result = await container.read(showDetailBundleProvider(7).future);

      expect(result.show, isNotNull);
      expect(result.show!.name, 'Foundation');
      expect(result.show!.seasons, hasLength(1));
      expect(result.cast.single.name, 'John');
    });

    test('detail bundle providers are autoDispose families', () {
      final container = ProviderContainer(
        overrides: [tmdbRemoteDataSourceProvider.overrideWithValue(dataSource)],
      );

      expect(movieDetailBundleProvider(42), isNot(movieDetailBundleProvider(43)));
      expect(
        container.read(movieDetailBundleProvider(42)),
        isA<AsyncValue<MovieDetailBundle>>(),
      );
      container.dispose();
    });
  });

  group('genre name providers', () {
    test('movieGenreNameProvider resolves a genre name', () async {
      dataSource.movieGenres = const [
        GenreDto(id: 28, name: 'Action'),
        GenreDto(id: 12, name: 'Adventure'),
      ];
      dataSource.showGenres = const [GenreDto(id: 18, name: 'Drama')];

      await container.read(movieGenresProvider.future);
      await container.read(showGenresProvider.future);

      expect(container.read(movieGenreNameProvider(28)), 'Action');
      expect(container.read(movieGenreNameProvider(999)), isNull);
      expect(container.read(showGenreNameProvider(18)), 'Drama');
    });

    test('genreNameFor and genreNamesFor resolve names individually', () {
      const genres = [
        TmdbGenre(id: 28, name: 'Action'),
        TmdbGenre(id: 12, name: 'Adventure'),
      ];

      expect(genreNameFor(genres, 12), 'Adventure');
      expect(genreNameFor(genres, 99), isNull);
      expect(genreNamesFor(genres, const [28, 99, 12]), ['Action', 'Adventure']);
      expect(genreNamesFor(genres, const []), isEmpty);
    });
  });
}