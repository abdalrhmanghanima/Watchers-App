import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/features/tmdb/data/dtos/cast_member_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/episode_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/genre_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/movie_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/paginated_response_dto.dart';
import 'package:watchers/features/tmdb/data/sources/tmdb_remote_data_source_impl.dart';
import 'package:watchers/features/tmdb/domain/errors/tmdb_exception.dart';

import 'helpers/fake_tmdb_api_client.dart';

void main() {
  late FakeTmdbApiClient apiClient;
  late TmdbRemoteDataSourceImpl dataSource;

  setUp(() {
    apiClient = FakeTmdbApiClient();
    dataSource = TmdbRemoteDataSourceImpl(apiClient: apiClient);
  });

  group('TmdbRemoteDataSourceImpl', () {
    test('getPopularMovies builds the correct endpoint with a page', () async {
      apiClient.enqueue('/movie/popular', _paginatedMovieBody());

      await dataSource.getPopularMovies(page: 3);

      expect(apiClient.requestedPaths, ['/movie/popular']);
      expect(apiClient.requestedQuery.last, {'page': 3});
    });

    test('getPopularMovies parses a successful JSON response', () async {
      apiClient.enqueue('/movie/popular', _paginatedMovieBody());

      final result = await dataSource.getPopularMovies();

      expect(result, isA<PaginatedResponseDto<MovieDto>>());
      expect(result.page, 1);
      expect(result.totalPages, 10);
      expect(result.totalResults, 100);
      expect(result.items, hasLength(2));
      expect(result.items.first.title, 'First Movie');
      expect(result.items.first.id, 1);
    });

    test('getNowPlayingMovies builds the correct endpoint', () async {
      apiClient.enqueue('/movie/now_playing', _paginatedMovieBody());

      await dataSource.getNowPlayingMovies();

      expect(apiClient.requestedPaths, ['/movie/now_playing']);
    });

    test('getPopularShows builds the correct endpoint', () async {
      apiClient.enqueue('/tv/popular', _paginatedShowBody());

      await dataSource.getPopularShows(page: 2);

      expect(apiClient.requestedPaths, ['/tv/popular']);
      expect(apiClient.requestedQuery.last, {'page': 2});
    });

    test('getPopularShows parses a successful JSON response', () async {
      apiClient.enqueue('/tv/popular', _paginatedShowBody());

      final result = await dataSource.getPopularShows();

      expect(result.items, hasLength(1));
      expect(result.items.first.name, 'First Show');
    });

    test('getAiringTodayShows builds the correct endpoint', () async {
      apiClient.enqueue('/tv/airing_today', _paginatedShowBody());

      await dataSource.getAiringTodayShows();

      expect(apiClient.requestedPaths, ['/tv/airing_today']);
    });

    test('getMovieDetails builds the correct endpoint', () async {
      apiClient.enqueue('/movie/42', _movieBody());

      final result = await dataSource.getMovieDetails(42);

      expect(apiClient.requestedPaths, ['/movie/42']);
      expect(result.id, 42);
    });

    test('getSimilarMovies builds the correct endpoint with a page', () async {
      apiClient.enqueue('/movie/42/similar', _paginatedMovieBody());

      final result = await dataSource.getSimilarMovies(42, page: 2);

      expect(apiClient.requestedPaths, ['/movie/42/similar']);
      expect(apiClient.requestedQuery.last, {'page': 2});
      expect(result, isA<PaginatedResponseDto<MovieDto>>());
    });

    test('getSimilarMovies parses a successful JSON response', () async {
      apiClient.enqueue('/movie/42/similar', _paginatedMovieBody());

      final result = await dataSource.getSimilarMovies(42);

      expect(result.items, hasLength(2));
      expect(result.items.first.title, 'First Movie');
      expect(result.items.first.id, 1);
    });

    test('getShowDetails builds the correct endpoint', () async {
      apiClient.enqueue('/tv/7', _showBody());

      final result = await dataSource.getShowDetails(7);

      expect(apiClient.requestedPaths, ['/tv/7']);
      expect(result.id, 7);
    });

    test('searchMovies sends the query and page', () async {
      apiClient.enqueue('/search/movie', _paginatedSearchBody());

      await dataSource.searchMovies(query: 'matrix', page: 2);

      expect(apiClient.requestedPaths, ['/search/movie']);
      expect(apiClient.requestedQuery.last, {'query': 'matrix', 'page': 2});
    });

    test('searchShows sends the query and page', () async {
      apiClient.enqueue('/search/tv', _paginatedSearchBody());

      await dataSource.searchShows(query: 'friends', page: 1);

      expect(apiClient.requestedPaths, ['/search/tv']);
      expect(apiClient.requestedQuery.last, {'query': 'friends', 'page': 1});
    });

    test('getTopRatedMovies builds the correct endpoint with a page', () async {
      apiClient.enqueue('/movie/top_rated', _paginatedMovieBody());

      await dataSource.getTopRatedMovies(page: 4);

      expect(apiClient.requestedPaths, ['/movie/top_rated']);
      expect(apiClient.requestedQuery.last, {'page': 4});
    });

    test('getTopRatedMovies parses a successful JSON response', () async {
      apiClient.enqueue('/movie/top_rated', _paginatedMovieBody());

      final result = await dataSource.getTopRatedMovies();

      expect(result.items, hasLength(2));
      expect(result.items.first.title, 'First Movie');
    });

    test('getMovieCredits builds the correct endpoint and parses cast', () async {
      apiClient.enqueue('/movie/42/credits', _creditBody());

      final result = await dataSource.getMovieCredits(42);

      expect(apiClient.requestedPaths, ['/movie/42/credits']);
      expect(result, hasLength(2));
      expect(result.first, isA<CastMemberDto>());
      expect(result.first.name, 'Jane Doe');
      expect(result.first.character, 'The Hero');
    });

    test('getShowCredits builds the correct endpoint and parses cast', () async {
      apiClient.enqueue('/tv/7/credits', _creditBody());

      final result = await dataSource.getShowCredits(7);

      expect(apiClient.requestedPaths, ['/tv/7/credits']);
      expect(result, hasLength(2));
      expect(result.first.name, 'Jane Doe');
    });

    test('returns an empty cast list when cast is missing', () async {
      apiClient.enqueue('/movie/1/credits', {'crew': []});

      final result = await dataSource.getMovieCredits(1);

      expect(result, isEmpty);
    });

    test('throws a malformed response error when cast is not a list', () async {
      apiClient.enqueue('/movie/1/credits', {'cast': 'bad'});

      await expectLater(
        dataSource.getMovieCredits(1),
        throwsA(isA<TmdbException>()
            .having((e) => e.type, 'type', TmdbErrorType.malformedResponse)),
      );
    });

    test('getSeasonEpisodes builds the correct endpoint', () async {
      apiClient.enqueue('/tv/7/season/2', _paginatedEpisodeBody());

      final result = await dataSource.getSeasonEpisodes(7, 2);

      expect(apiClient.requestedPaths, ['/tv/7/season/2']);
      expect(result, isA<PaginatedResponseDto<EpisodeDto>>());
      expect(result.items, hasLength(1));
      expect(result.items.first.episodeNumber, 1);
    });

    test('getEpisodeDetails builds the correct endpoint and parses the episode',
        () async {
      apiClient.enqueue('/tv/7/season/2/episode/3', {
        'id': 9,
        'season_number': 2,
        'episode_number': 3,
        'name': 'Midnight',
        'overview': 'A dedicated overview.',
        'still_path': '/still.jpg',
        'air_date': '2024-01-01',
        'runtime': 45,
        'vote_average': 8.1,
        'vote_count': 12,
      });

      final result = await dataSource.getEpisodeDetails(7, 2, 3);

      expect(apiClient.requestedPaths, ['/tv/7/season/2/episode/3']);
      expect(result, isA<EpisodeDto>());
      expect(result.seasonNumber, 2);
      expect(result.episodeNumber, 3);
      expect(result.name, 'Midnight');
      expect(result.runtime, 45);
    });

    test('searchMulti sends the query and page', () async {
      apiClient.enqueue('/search/multi', _paginatedSearchBody());

      await dataSource.searchMulti(query: 'star', page: 3);

      expect(apiClient.requestedPaths, ['/search/multi']);
      expect(apiClient.requestedQuery.last, {'query': 'star', 'page': 3});
    });

    test('getMovieGenres builds the correct endpoint and parses genres', () async {
      apiClient.enqueue('/genre/movie/list', {
        'genres': [
          {'id': 28, 'name': 'Action'},
          {'id': 12, 'name': 'Adventure'},
        ],
      });

      final result = await dataSource.getMovieGenres();

      expect(apiClient.requestedPaths, ['/genre/movie/list']);
      expect(result, hasLength(2));
      expect(result.first, isA<GenreDto>());
      expect(result.first.name, 'Action');
    });

    test('getShowGenres builds the correct endpoint', () async {
      apiClient.enqueue('/genre/tv/list', {
        'genres': [
          {'id': 18, 'name': 'Drama'},
        ],
      });

      final result = await dataSource.getShowGenres();

      expect(apiClient.requestedPaths, ['/genre/tv/list']);
      expect(result, hasLength(1));
      expect(result.first.name, 'Drama');
    });

    test('throws a malformed response error on non-map data', () async {
      apiClient.enqueue('/movie/popular', [1, 2, 3]);

      await expectLater(
        dataSource.getPopularMovies(),
        throwsA(isA<TmdbException>()
            .having((e) => e.type, 'type', TmdbErrorType.malformedResponse)),
      );
    });

    test('returns an empty page when results are missing', () async {
      apiClient.enqueue('/movie/popular', {'other': 'value'});

      final result = await dataSource.getPopularMovies();

      expect(result.items, isEmpty);
      expect(result.totalPages, 0);
    });

    test('propagates infra exceptions from the api client', () async {
      apiClient.failWith = const TmdbException.network();

      await expectLater(
        dataSource.getPopularMovies(),
        throwsA(isA<TmdbException>()
            .having((e) => e.type, 'type', TmdbErrorType.network)),
      );
    });
  });
}

Map<String, dynamic> _paginatedMovieBody() {
  return {
    'page': 1,
    'total_pages': 10,
    'total_results': 100,
    'results': [_movieJson(1, 'First Movie'), _movieJson(2, 'Second Movie')],
  };
}

Map<String, dynamic> _paginatedShowBody() {
  return {
    'page': 1,
    'total_pages': 2,
    'total_results': 20,
    'results': [_showJson(7, 'First Show')],
  };
}

Map<String, dynamic> _paginatedSearchBody() {
  return {
    'page': 1,
    'total_pages': 3,
    'total_results': 30,
    'results': [_searchJson(1, 'Matrix', 'movie')],
  };
}

Map<String, dynamic> _paginatedEpisodeBody() {
  return {
    'page': 1,
    'total_pages': 1,
    'total_results': 1,
    'results': [_episodeJson(1)],
  };
}

Map<String, dynamic> _creditBody() {
  return {
    'id': 42,
    'cast': [
      {
        'id': 7,
        'name': 'Jane Doe',
        'character': 'The Hero',
        'order': 0,
        'profile_path': '/profile.jpg',
      },
      {
        'id': 8,
        'name': 'John Roe',
        'character': 'The Villain',
        'order': 1,
      },
    ],
  };
}

Map<String, dynamic> _movieJson(int id, String title) {
  return {
    'id': id,
    'title': title,
    'overview': 'An overview.',
    'poster_path': '/poster$id.jpg',
    'backdrop_path': '/backdrop$id.jpg',
    'genre_ids': [28, 12],
    'release_date': '2020-01-01',
    'vote_average': 7.5,
    'vote_count': 100,
    'runtime': 120,
  };
}

Map<String, dynamic> _showJson(int id, String name) {
  return {
    'id': id,
    'name': name,
    'overview': 'An overview.',
    'poster_path': '/poster$id.jpg',
    'backdrop_path': '/backdrop$id.jpg',
    'genre_ids': [18],
    'first_air_date': '2019-01-01',
    'vote_average': 8.0,
    'vote_count': 50,
  };
}

Map<String, dynamic> _searchJson(int id, String title, String mediaType) {
  return {
    'id': id,
    'title': title,
    'name': title,
    'media_type': mediaType,
    'poster_path': '/poster$id.jpg',
    'overview': 'An overview.',
    'release_date': '2020-01-01',
    'vote_average': 7.0,
  };
}

Map<String, dynamic> _episodeJson(int id) {
  return {
    'id': id,
    'season_number': 2,
    'episode_number': 1,
    'name': 'Episode 1',
    'overview': 'An episode overview.',
    'still_path': '/still.jpg',
    'air_date': '2024-01-01',
    'runtime': 45,
    'vote_average': 7.0,
    'vote_count': 10,
  };
}

Map<String, dynamic> _movieBody() {
  return {
    'id': 42,
    'title': 'Detailed Movie',
    'overview': 'A detailed overview.',
    'poster_path': '/p.jpg',
    'backdrop_path': '/b.jpg',
    'genre_ids': [28],
    'release_date': '2021-05-05',
    'vote_average': 9.0,
    'vote_count': 10,
    'runtime': 95,
  };
}

Map<String, dynamic> _showBody() {
  return {
    'id': 7,
    'name': 'Detailed Show',
    'overview': 'A detailed overview.',
    'poster_path': '/p.jpg',
    'backdrop_path': '/b.jpg',
    'genre_ids': [18],
    'first_air_date': '2021-05-05',
    'vote_average': 9.0,
    'vote_count': 10,
  };
}
