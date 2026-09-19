import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/features/tmdb/data/dtos/genre_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/movie_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/paginated_response_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/tv_show_dto.dart';
import 'package:watchers/features/tmdb/presentation/providers/movie_catalog_providers.dart';
import 'package:watchers/features/tmdb/presentation/providers/show_catalog_providers.dart';
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

  group('movie catalog providers', () {
    test('moviesNowPlayingProvider resolves items from the repository', () async {
      dataSource.nowPlaying['1'] = _moviePage(1, 'Now Playing');

      final result = await container.read(moviesNowPlayingProvider.future);

      expect(result.single.id, 1);
      expect(result.single.title, 'Now Playing');
    });

    test('moviesPopularProvider resolves items from the repository', () async {
      dataSource.popularMovies['1'] = _moviePage(2, 'Popular');

      final result = await container.read(moviesPopularProvider.future);

      expect(result.single.title, 'Popular');
    });

    test('moviesTopRatedProvider resolves items from the repository', () async {
      dataSource.topRated['1'] = _moviePage(3, 'Top Rated');

      final result = await container.read(moviesTopRatedProvider.future);

      expect(result.single.title, 'Top Rated');
    });

    test('movieGenresProvider resolves genres from the repository', () async {
      dataSource.movieGenres = const [GenreDto(id: 28, name: 'Action')];

      final result = await container.read(movieGenresProvider.future);

      expect(result.single.name, 'Action');
    });

    test('featuredMovieProvider picks a movie with a backdrop and poster', () async {
      dataSource.nowPlaying['1'] = PaginatedResponseDto<MovieDto>(
        items: [
          MovieDto.fromJson({'id': 10, 'title': 'No Image'}),
          MovieDto.fromJson({
            'id': 11,
            'title': 'With Image',
            'poster_path': '/p.jpg',
            'backdrop_path': '/b.jpg',
          }),
        ],
        page: 1,
        totalPages: 1,
        totalResults: 2,
      );
      dataSource.popularMovies['1'] = _moviePage(12, 'Popular');

      await container.read(moviesNowPlayingProvider.future);
      await container.read(moviesPopularProvider.future);

      final featured = container.read(featuredMovieProvider);

      expect(featured, isNotNull);
      expect(featured!.title, 'With Image');
    });

    test('featuredMovieProvider falls back to the first now playing movie', () async {
      dataSource.nowPlaying['1'] = _moviePage(20, 'Only One');
      dataSource.popularMovies['1'] = _moviePage(21, 'Popular');

      await container.read(moviesNowPlayingProvider.future);
      await container.read(moviesPopularProvider.future);

      final featured = container.read(featuredMovieProvider);
      expect(featured!.id, 20);
    });

    test('featuredMovieProvider resolves when either list is empty', () async {
      dataSource.popularMovies['1'] = _moviePage(22, 'Less Popular');

      await container.read(moviesNowPlayingProvider.future);
      await container.read(moviesPopularProvider.future);

      final featured = container.read(featuredMovieProvider);
      expect(featured!.id, 22);
    });

    test('moviesSectionProvider resolves each section independently', () async {
      dataSource.nowPlaying['1'] = _moviePage(30, 'Now');
      dataSource.popularMovies['1'] = _moviePage(31, 'Pop');
      dataSource.topRated['1'] = _moviePage(32, 'Top');

      expect((await container.read(moviesSectionProvider(MovieSection.nowPlaying).future)).single.title, 'Now');
      expect((await container.read(moviesSectionProvider(MovieSection.popular).future)).single.title, 'Pop');
      expect((await container.read(moviesSectionProvider(MovieSection.topRated).future)).single.title, 'Top');
    });

    test('moviesSectionProvider featured resolves to a single item', () async {
      dataSource.nowPlaying['1'] = _moviePage(40, 'Featured');

      final result =
          await container.read(moviesSectionProvider(MovieSection.featured).future);

      expect(result, hasLength(1));
      expect(result.single.id, 40);
    });

    test('selectFeaturedMovie returns null for empty inputs', () {
      expect(selectFeaturedMovie(const [], const []), isNull);
    });
  });

  group('show catalog providers', () {
    test('showsPopularProvider resolves items from the repository', () async {
      dataSource.popularShows['1'] = _showPage(50, 'Popular Show');

      final result = await container.read(showsPopularProvider.future);

      expect(result.single.name, 'Popular Show');
    });

    test('showsAiringTodayProvider resolves items from the repository', () async {
      dataSource.airingToday['1'] = _showPage(51, 'Airing Today');

      final result = await container.read(showsAiringTodayProvider.future);

      expect(result.single.name, 'Airing Today');
    });

    test('showGenresProvider resolves genres from the repository', () async {
      dataSource.showGenres = const [GenreDto(id: 18, name: 'Drama')];

      final result = await container.read(showGenresProvider.future);

      expect(result.single.name, 'Drama');
    });

    test('showsSectionProvider resolves each section independently', () async {
      dataSource.popularShows['1'] = _showPage(60, 'Pop');
      dataSource.airingToday['1'] = _showPage(61, 'Airing');

      expect((await container.read(showsSectionProvider(ShowSection.popular).future)).single.name, 'Pop');
      expect((await container.read(showsSectionProvider(ShowSection.airingToday).future)).single.name, 'Airing');
    });
  });
}

PaginatedResponseDto<MovieDto> _moviePage(int id, String title) {
  return PaginatedResponseDto<MovieDto>(
    items: [
      MovieDto.fromJson({
        'id': id,
        'title': title,
        'overview': 'An overview.',
        'poster_path': '/poster$id.jpg',
        'backdrop_path': '/backdrop$id.jpg',
      }),
    ],
    page: 1,
    totalPages: 1,
    totalResults: 1,
  );
}

PaginatedResponseDto<TvShowDto> _showPage(int id, String name) {
  return PaginatedResponseDto<TvShowDto>(
    items: [
      TvShowDto.fromJson({
        'id': id,
        'name': name,
        'overview': 'An overview.',
        'poster_path': '/poster$id.jpg',
        'backdrop_path': '/backdrop$id.jpg',
      }),
    ],
    page: 1,
    totalPages: 1,
    totalResults: 1,
  );
}