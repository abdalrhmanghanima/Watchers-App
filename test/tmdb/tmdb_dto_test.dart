import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/features/tmdb/data/dtos/cast_member_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/episode_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/genre_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/movie_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/paginated_response_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/search_result_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/season_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/tv_show_dto.dart';

void main() {
  group('MovieDto', () {
    test('maps a full valid TMDB response', () {
      final dto = MovieDto.fromJson({
        'id': 1,
        'title': 'Dune',
        'overview': 'A desert planet.',
        'poster_path': '/poster.jpg',
        'backdrop_path': '/backdrop.jpg',
        'genre_ids': [878, 12],
        'release_date': '2021-09-15',
        'vote_average': 8.1,
        'vote_count': 5000,
        'runtime': 155,
      });

      expect(dto.id, 1);
      expect(dto.title, 'Dune');
      expect(dto.overview, 'A desert planet.');
      expect(dto.posterPath, '/poster.jpg');
      expect(dto.backdropPath, '/backdrop.jpg');
      expect(dto.genreIds, [878, 12]);
      expect(dto.releaseDate, '2021-09-15');
      expect(dto.voteAverage, 8.1);
      expect(dto.voteCount, 5000);
      expect(dto.runtime, 155);
    });

    test('handles missing optional fields safely', () {
      final dto = MovieDto.fromJson({'id': 2});

      expect(dto.id, 2);
      expect(dto.title, '');
      expect(dto.overview, '');
      expect(dto.posterPath, isNull);
      expect(dto.backdropPath, isNull);
      expect(dto.genreIds, isEmpty);
      expect(dto.releaseDate, isNull);
      expect(dto.voteAverage, isNull);
      expect(dto.voteCount, isNull);
      expect(dto.runtime, isNull);
    });

    test('handles invalid numeric values', () {
      final dto = MovieDto.fromJson({
        'id': 3,
        'title': 'Test',
        'vote_average': 'not-a-number',
        'vote_count': 'many',
        'genre_ids': 'invalid',
      });

      expect(dto.voteAverage, isNull);
      expect(dto.voteCount, isNull);
      expect(dto.genreIds, isEmpty);
    });

    test('handles a runtime supplied as a double', () {
      final dto = MovieDto.fromJson({'id': 4, 'runtime': 120.0});

      expect(dto.runtime, 120);
    });
  });

  group('TvShowDto', () {
    test('maps a full valid TMDB response', () {
      final dto = TvShowDto.fromJson({
        'id': 7,
        'name': 'Foundation',
        'overview': 'An empire.',
        'poster_path': '/poster.jpg',
        'backdrop_path': '/backdrop.jpg',
        'genre_ids': [10765, 18],
        'first_air_date': '2021-09-24',
        'vote_average': 8.4,
        'vote_count': 2000,
      });

      expect(dto.id, 7);
      expect(dto.name, 'Foundation');
      expect(dto.overview, 'An empire.');
      expect(dto.posterPath, '/poster.jpg');
      expect(dto.backdropPath, '/backdrop.jpg');
      expect(dto.genreIds, [10765, 18]);
      expect(dto.firstAirDate, '2021-09-24');
      expect(dto.voteAverage, 8.4);
      expect(dto.voteCount, 2000);
    });

    test('handles missing fields safely', () {
      final dto = TvShowDto.fromJson({'id': 8});

      expect(dto.name, '');
      expect(dto.overview, '');
      expect(dto.posterPath, isNull);
      expect(dto.genreIds, isEmpty);
      expect(dto.firstAirDate, isNull);
      expect(dto.voteAverage, isNull);
    });
  });

  group('SearchResultDto', () {
    test('uses the movie title for movie media type', () {
      final dto = SearchResultDto.fromJson({
        'id': 1,
        'title': 'Movie Title',
        'name': 'Ignored',
        'media_type': 'movie',
        'release_date': '2020-01-01',
        'poster_path': '/poster.jpg',
        'vote_average': 6.5,
      });

      expect(dto.title, 'Movie Title');
      expect(dto.mediaType, 'movie');
      expect(dto.releaseDate, '2020-01-01');
      expect(dto.posterPath, '/poster.jpg');
    });

    test('uses the series name for tv media type', () {
      final dto = SearchResultDto.fromJson({
        'id': 2,
        'title': 'Ignored',
        'name': 'TV Name',
        'media_type': 'tv',
        'first_air_date': '2019-03-01',
      });

      expect(dto.title, 'TV Name');
      expect(dto.mediaType, 'tv');
      expect(dto.releaseDate, '2019-03-01');
    });

    test('handles missing fields safely', () {
      final dto = SearchResultDto.fromJson({'id': 3});

      expect(dto.title, '');
      expect(dto.mediaType, '');
      expect(dto.posterPath, isNull);
      expect(dto.overview, isNull);
      expect(dto.releaseDate, isNull);
      expect(dto.voteAverage, isNull);
    });
  });

  group('GenreDto', () {
    test('maps a valid genre', () {
      final dto = GenreDto.fromJson({'id': 28, 'name': 'Action'});

      expect(dto.id, 28);
      expect(dto.name, 'Action');
    });

    test('handles missing fields safely', () {
      final dto = GenreDto.fromJson({});

      expect(dto.id, 0);
      expect(dto.name, '');
    });
  });

  group('PaginatedResponseDto', () {
    test('parses items and pagination metadata', () {
      final dto = PaginatedResponseDto<MovieDto>.fromJson(
        {
          'page': 2,
          'total_pages': 5,
          'total_results': 50,
          'results': [
            {'id': 1, 'title': 'A'},
            {'id': 2, 'title': 'B'},
          ],
        },
        MovieDto.fromJson,
      );

      expect(dto.page, 2);
      expect(dto.totalPages, 5);
      expect(dto.totalResults, 50);
      expect(dto.items, hasLength(2));
      expect(dto.items.first.title, 'A');
    });

    test('returns empty items when results are not a list', () {
      final dto = PaginatedResponseDto<MovieDto>.fromJson(
        {'results': 'invalid'},
        MovieDto.fromJson,
      );

      expect(dto.items, isEmpty);
    });

    test('returns empty items when results are missing', () {
      final dto = PaginatedResponseDto<MovieDto>.fromJson(
        {},
        MovieDto.fromJson,
      );

      expect(dto.items, isEmpty);
      expect(dto.page, 1);
      expect(dto.totalPages, 0);
    });

    test('skips invalid item entries', () {
      final dto = PaginatedResponseDto<MovieDto>.fromJson(
        {
          'results': [
            {'id': 1, 'title': 'A'},
            'not-a-map',
            {'id': 2, 'title': 'C'},
          ],
        },
        MovieDto.fromJson,
      );

      expect(dto.items, hasLength(2));
    });
  });

  group('SeasonDto', () {
    test('parses all fields', () {
      final dto = SeasonDto.fromJson(const {
        'season_number': 2,
        'name': 'Season 2',
        'overview': 'The second season.',
        'episode_count': 10,
        'poster_path': '/season-poster.jpg',
        'air_date': '2024-01-01',
      });

      expect(dto.number, 2);
      expect(dto.name, 'Season 2');
      expect(dto.overview, 'The second season.');
      expect(dto.episodeCount, 10);
      expect(dto.posterPath, '/season-poster.jpg');
      expect(dto.airDate, '2024-01-01');
    });

    test('uses defaults when fields are missing', () {
      final dto = SeasonDto.fromJson(const {});

      expect(dto.number, 0);
      expect(dto.name, '');
      expect(dto.overview, '');
      expect(dto.episodeCount, 0);
      expect(dto.posterPath, null);
      expect(dto.airDate, null);
    });
  });

  group('EpisodeDto', () {
    test('parses all fields', () {
      final dto = EpisodeDto.fromJson(const {
        'id': 42,
        'season_number': 1,
        'episode_number': 3,
        'name': 'Episode 3',
        'overview': 'An important episode.',
        'still_path': '/still.jpg',
        'air_date': '2024-02-02',
        'runtime': 52,
        'vote_average': 8.1,
        'vote_count': 120,
      });

      expect(dto.id, 42);
      expect(dto.seasonNumber, 1);
      expect(dto.episodeNumber, 3);
      expect(dto.name, 'Episode 3');
      expect(dto.overview, 'An important episode.');
      expect(dto.stillPath, '/still.jpg');
      expect(dto.airDate, '2024-02-02');
      expect(dto.runtime, 52);
      expect(dto.voteAverage, 8.1);
      expect(dto.voteCount, 120);
    });

    test('uses defaults when fields are missing', () {
      final dto = EpisodeDto.fromJson(const {});

      expect(dto.id, 0);
      expect(dto.seasonNumber, 0);
      expect(dto.episodeNumber, 0);
      expect(dto.name, '');
      expect(dto.overview, '');
      expect(dto.stillPath, null);
      expect(dto.airDate, null);
      expect(dto.runtime, null);
      expect(dto.voteAverage, null);
      expect(dto.voteCount, null);
    });
  });

  group('CastMemberDto', () {
    test('parses all fields', () {
      final dto = CastMemberDto.fromJson(const {
        'id': 7,
        'name': 'Jane Doe',
        'character': 'The Hero',
        'order': 0,
        'profile_path': '/profile.jpg',
      });

      expect(dto.id, 7);
      expect(dto.name, 'Jane Doe');
      expect(dto.character, 'The Hero');
      expect(dto.order, 0);
      expect(dto.profilePath, '/profile.jpg');
    });

    test('uses defaults when fields are missing', () {
      final dto = CastMemberDto.fromJson(const {});

      expect(dto.id, 0);
      expect(dto.name, '');
      expect(dto.character, '');
      expect(dto.order, 0);
      expect(dto.profilePath, null);
    });
  });

  group('TvShowDto seasons', () {
    test('parses status and seasons list', () {
      final dto = TvShowDto.fromJson(const {
        'status': 'Returning Series',
        'seasons': [
          {
            'season_number': 1,
            'name': 'Season 1',
            'episode_count': 8,
          },
        ],
      });

      expect(dto.status, 'Returning Series');
      expect(dto.seasons, hasLength(1));
      expect(dto.seasons.first.number, 1);
      expect(dto.seasons.first.name, 'Season 1');
    });

    test('defaults to empty seasons when missing or invalid', () {
      final missing = TvShowDto.fromJson(const {});
      expect(missing.status, null);
      expect(missing.seasons, isEmpty);

      final invalid = TvShowDto.fromJson(const {'seasons': 'bad'});
      expect(invalid.seasons, isEmpty);

      final sparse = TvShowDto.fromJson(const {'seasons': []});
      expect(sparse.seasons, isEmpty);
    });
  });
}
