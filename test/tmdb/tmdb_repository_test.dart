import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/core/tmdb/tmdb_image_url_builder.dart';
import 'package:watchers/features/tmdb/data/dtos/cast_member_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/episode_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/genre_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/movie_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/paginated_response_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/search_result_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/tv_show_dto.dart';
import 'package:watchers/features/tmdb/data/mappers/tmdb_mappers.dart';
import 'package:watchers/features/tmdb/data/repositories/tmdb_repository_impl.dart';
import 'package:watchers/features/tmdb/domain/errors/tmdb_exception.dart';
import 'package:watchers/features/tmdb/domain/entities/paginated_result.dart';
import 'package:watchers/features/tmdb/domain/entities/tmdb_cast_member.dart';
import 'package:watchers/features/tmdb/domain/entities/tmdb_episode.dart';
import 'package:watchers/features/tmdb/domain/entities/tmdb_movie.dart';
import 'package:watchers/features/tmdb/domain/entities/tmdb_season.dart';

import 'helpers/fake_tmdb_remote_data_source.dart';

void main() {
  const imageBase = 'https://image.tmdb.org/t/p/';
  late FakeTmdbRemoteDataSource dataSource;
  late TmdbRepositoryImpl repository;

  setUp(() {
    dataSource = FakeTmdbRemoteDataSource();
    repository = TmdbRepositoryImpl(
      remoteDataSource: dataSource,
      movieMapper: const MovieMapper(
        imageUrlBuilder: TmdbImageUrlBuilder(imageBaseUrl: imageBase),
      ),
      showMapper: const TvShowMapper(
        imageUrlBuilder: TmdbImageUrlBuilder(imageBaseUrl: imageBase),
      ),
      searchResultMapper: const SearchResultMapper(
        imageUrlBuilder: TmdbImageUrlBuilder(imageBaseUrl: imageBase),
      ),
      genreMapper: const GenreMapper(),
      castMapper: const CastMemberMapper(
        imageUrlBuilder: TmdbImageUrlBuilder(imageBaseUrl: imageBase),
      ),
      episodeMapper: const EpisodeMapper(
        imageUrlBuilder: TmdbImageUrlBuilder(imageBaseUrl: imageBase),
      ),
    );
  });

  group('TmdbRepositoryImpl', () {
    test('getPopularMovies maps DTOs to domain entities', () async {
      dataSource.popularMovies['1'] = PaginatedResponseDto<MovieDto>(
        items: [
          MovieDto.fromJson({
            'id': 1,
            'title': 'Dune',
            'overview': 'An overview.',
            'poster_path': '/poster.jpg',
            'backdrop_path': '/backdrop.jpg',
            'genre_ids': [878],
          }),
        ],
        page: 1,
        totalPages: 10,
        totalResults: 100,
      );

      final result = await repository.getPopularMovies();

      expect(result, isA<PaginatedResult<TmdbMovie>>());
      expect(result.page, 1);
      expect(result.totalPages, 10);
      expect(result.items, hasLength(1));
      final movie = result.items.single;
      expect(movie.id, 1);
      expect(movie.title, 'Dune');
      expect(movie.posterUrl, '${imageBase}w342/poster.jpg');
    });

    test('getMovieDetails maps a detail DTO', () async {
      dataSource.movieDetails = MovieDto.fromJson({
        'id': 42,
        'title': 'Detail',
        'overview': 'D.',
        'runtime': 95,
      });

      final result = await repository.getMovieDetails(42);

      expect(result, isNotNull);
      expect(result!.id, 42);
      expect(result.runtimeMinutes, 95);
    });

    test('getSimilarMovies maps DTOs to domain entities', () async {
      dataSource.similarMovies['42:1'] = PaginatedResponseDto<MovieDto>(
        items: [
          MovieDto.fromJson({
            'id': 3,
            'title': 'Echo',
            'overview': 'An overview.',
            'genre_ids': [1],
          }),
        ],
        page: 1,
        totalPages: 5,
        totalResults: 50,
      );

      final result = await repository.getSimilarMovies(42);

      expect(result, isA<PaginatedResult<TmdbMovie>>());
      expect(result.items.single.id, 3);
      expect(result.items.single.title, 'Echo');
      expect(result.totalPages, 5);
    });

    test('getPopularShows maps shows to domain entities', () async {
      dataSource.popularShows['1'] = PaginatedResponseDto<TvShowDto>(
        items: [
          TvShowDto.fromJson({
            'id': 7,
            'name': 'Foundation',
            'poster_path': '/poster.jpg',
          }),
        ],
        page: 1,
        totalPages: 2,
        totalResults: 20,
      );

      final result = await repository.getPopularShows();

      expect(result.items.single.name, 'Foundation');
      expect(result.totalPages, 2);
    });

    test('converts remote TmdbExceptions without leaking infrastructure', () async {
      dataSource.failWith(const TmdbException.network());

      await expectLater(
        repository.getPopularMovies(),
        throwsA(isA<TmdbException>()
            .having((e) => e.type, 'type', TmdbErrorType.network)),
      );
    });

    test('converts unknown remote errors to an unknown domain error', () async {
      dataSource.failWith(StateError('boom'));

      await expectLater(
        repository.getPopularMovies(),
        throwsA(isA<TmdbException>()
            .having((e) => e.type, 'type', TmdbErrorType.unknown)),
      );
    });

    test('converts a configuration failure through the repository boundary', () async {
      dataSource.failWith(const TmdbException.configuration());

      await expectLater(
        repository.getPopularMovies(),
        throwsA(isA<TmdbException>()
            .having((e) => e.type, 'type', TmdbErrorType.configuration)),
      );
    });

    test('getMovieGenres maps genres to domain entities', () async {
      dataSource.movieGenres = const [
        GenreDto(id: 28, name: 'Action'),
      ];

      final result = await repository.getMovieGenres();

      expect(result.single.id, 28);
      expect(result.single.name, 'Action');
    });

    test('getTopRatedMovies maps DTOs to domain entities', () async {
      dataSource.topRated['1'] = PaginatedResponseDto<MovieDto>(
        items: [
          MovieDto.fromJson({'id': 3, 'title': 'Top Film'}),
        ],
        page: 1,
        totalPages: 5,
        totalResults: 50,
      );

      final result = await repository.getTopRatedMovies();

      expect(result.items.single.id, 3);
      expect(result.items.single.title, 'Top Film');
      expect(result.totalPages, 5);
    });

    test('getMovieCredits maps cast DTOs to domain entities', () async {
      dataSource.movieCredits = const [
        CastMemberDto(
          id: 7,
          name: 'Jane Doe',
          character: 'Hero',
          order: 0,
          profilePath: '/profile.jpg',
        ),
      ];

      final result = await repository.getMovieCredits(42);

      expect(result, isA<List<TmdbCastMember>>());
      expect(result.single.id, 7);
      expect(result.single.character, 'Hero');
      expect(result.single.profileUrl, '${imageBase}w185/profile.jpg');
    });

    test('getShowCredits maps cast DTOs to domain entities', () async {
      dataSource.showCredits = const [
        CastMemberDto(id: 8, name: 'John Roe', character: '', order: 1),
      ];

      final result = await repository.getShowCredits(7);

      expect(result.single.name, 'John Roe');
      expect(result.single.profileUrl, isNull);
    });

    test('getSeasonEpisodes maps episodes to domain entities', () async {
      dataSource.seasonEpisodes = const [
        EpisodeDto(
          id: 1,
          seasonNumber: 2,
          episodeNumber: 3,
          name: 'Episode 3',
          overview: '',
          stillPath: '/still.jpg',
        ),
      ];

      final result = await repository.getSeasonEpisodes(7, 2);

      expect(result, isA<PaginatedResult<TmdbEpisode>>());
      expect(result.items.single.episodeNumber, 3);
      expect(result.items.single.name, 'Episode 3');
      expect(
        result.items.single.stillUrl,
        '${imageBase}w185/still.jpg',
      );
    });

    test('getEpisodeDetails maps a single episode DTO', () async {
      dataSource.episodeDetails = const EpisodeDto(
        id: 9,
        seasonNumber: 2,
        episodeNumber: 3,
        name: 'Midnight',
        overview: 'A dedicated overview.',
        stillPath: '/still.jpg',
        runtime: 45,
        voteAverage: 8.1,
        voteCount: 12,
      );

      final result = await repository.getEpisodeDetails(7, 2, 3);

      expect(result, isNotNull);
      expect(result!.seasonNumber, 2);
      expect(result.episodeNumber, 3);
      expect(result.name, 'Midnight');
      expect(result.runtimeMinutes, 45);
      expect(result.rating, 8.1);
      expect(result.stillUrl, '${imageBase}w185/still.jpg');
    });

    test('searchMulti maps mixed results to domain entities', () async {
      dataSource.searchedMulti['star:1'] = PaginatedResponseDto<SearchResultDto>(
        items: [
          SearchResultDto.fromJson({
            'id': 1,
            'title': 'Star Trek',
            'media_type': 'movie',
          }),
        ],
        page: 1,
        totalPages: 1,
        totalResults: 1,
      );

      final result = await repository.searchMulti(query: 'star');

      expect(result.items.single.title, 'Star Trek');
      expect(result.items.single.mediaType, 'movie');
    });

    test('getShowDetails maps status and season metadata', () async {
      dataSource.showDetails = TvShowDto.fromJson({
        'id': 9,
        'name': 'Foundation',
        'status': 'Returning Series',
        'seasons': [
          {
            'season_number': 1,
            'name': 'Season 1',
            'episode_count': 10,
          },
        ],
      });

      final result = await repository.getShowDetails(9);

      expect(result, isNotNull);
      expect(result!.seasons, isA<List<TmdbSeason>>());
      expect(result.status, 'Returning Series');
      expect(result.seasons.single.number, 1);
      expect(result.seasons.single.episodeCount, 10);
    });
  });
}
