import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/core/tmdb/tmdb_image_url_builder.dart';
import 'package:watchers/features/tmdb/data/dtos/cast_member_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/episode_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/genre_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/movie_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/search_result_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/season_dto.dart';
import 'package:watchers/features/tmdb/data/dtos/tv_show_dto.dart';
import 'package:watchers/features/tmdb/data/mappers/tmdb_mappers.dart';

void main() {
  const imageBase = 'https://image.tmdb.org/t/p/';

  group('MovieMapper', () {
    const mapper = MovieMapper(
      imageUrlBuilder: TmdbImageUrlBuilder(imageBaseUrl: imageBase),
    );

    test('maps a full DTO to a domain entity', () {
      final entity = mapper.fromDto(
        MovieDto.fromJson({
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
        }),
      );

      expect(entity.id, 1);
      expect(entity.title, 'Dune');
      expect(entity.overview, 'A desert planet.');
      expect(entity.posterUrl, '${imageBase}w342/poster.jpg');
      expect(entity.backdropUrl, '${imageBase}w1280/backdrop.jpg');
      expect(entity.genreIds, [878, 12]);
      expect(entity.releaseDate, DateTime(2021, 9, 15));
      expect(entity.rating, 8.1);
      expect(entity.voteCount, 5000);
      expect(entity.runtimeMinutes, 155);
    });

    test('maps nullable image paths to null URLs', () {
      final entity = mapper.fromDto(
        MovieDto.fromJson({'id': 2, 'poster_path': null}),
      );

      expect(entity.posterUrl, isNull);
      expect(entity.backdropUrl, isNull);
      expect(entity.releaseDate, isNull);
      expect(entity.rating, isNull);
    });

    test('handles an invalid release date', () {
      final entity = mapper.fromDto(
        MovieDto.fromJson({'id': 3, 'release_date': 'not-a-date'}),
      );

      expect(entity.releaseDate, isNull);
    });

    test('maps an empty release date', () {
      final entity = mapper.fromDto(
        MovieDto.fromJson({'id': 4, 'release_date': ''}),
      );

      expect(entity.releaseDate, isNull);
    });
  });

  group('TvShowMapper', () {
    const mapper = TvShowMapper(
      imageUrlBuilder: TmdbImageUrlBuilder(imageBaseUrl: imageBase),
    );

    test('maps a full DTO to a domain entity', () {
      final entity = mapper.fromDto(
        TvShowDto.fromJson({
          'id': 7,
          'name': 'Foundation',
          'overview': 'An empire.',
          'poster_path': '/poster.jpg',
          'backdrop_path': '/backdrop.jpg',
          'genre_ids': [10765, 18],
          'first_air_date': '2021-09-24',
          'vote_average': 8.4,
          'vote_count': 2000,
        }),
      );

      expect(entity.id, 7);
      expect(entity.name, 'Foundation');
      expect(entity.overview, 'An empire.');
      expect(entity.posterUrl, '${imageBase}w342/poster.jpg');
      expect(entity.backdropUrl, '${imageBase}w1280/backdrop.jpg');
      expect(entity.genreIds, [10765, 18]);
      expect(entity.firstAirDate, DateTime(2021, 9, 24));
      expect(entity.rating, 8.4);
      expect(entity.voteCount, 2000);
    });

    test('maps nullable image paths to null URLs', () {
      final entity = mapper.fromDto(
        TvShowDto.fromJson({'id': 8, 'poster_path': null}),
      );

      expect(entity.posterUrl, isNull);
      expect(entity.backdropUrl, isNull);
      expect(entity.firstAirDate, isNull);
    });

    test('maps status and seasons with a custom season mapper', () {
      final mapper = TvShowMapper(
        imageUrlBuilder: TmdbImageUrlBuilder(imageBaseUrl: imageBase),
        seasonMapper: const SeasonMapper(
          imageUrlBuilder: TmdbImageUrlBuilder(imageBaseUrl: imageBase),
        ),
      );

      final entity = mapper.fromDto(
        TvShowDto.fromJson({
          'id': 9,
          'name': 'Foundation',
          'status': 'Returning Series',
          'seasons': [
            {
              'season_number': 1,
              'name': 'Season 1',
              'poster_path': '/poster.jpg',
            },
          ],
        }),
      );

      expect(entity.status, 'Returning Series');
      expect(entity.seasons, hasLength(1));
      expect(entity.seasons.first.number, 1);
      expect(entity.seasons.first.name, 'Season 1');
      expect(entity.seasons.first.posterUrl, '${imageBase}w342/poster.jpg');
    });

    test('maps an empty seasons list', () {
      final entity = mapper.fromDto(
        TvShowDto.fromJson({'id': 10, 'name': 'X', 'seasons': []}),
      );

      expect(entity.status, isNull);
      expect(entity.seasons, isEmpty);
    });
  });

  group('SeasonMapper', () {
    test('maps a full DTO to a domain entity', () {
      const mapper = SeasonMapper(
        imageUrlBuilder: TmdbImageUrlBuilder(imageBaseUrl: imageBase),
      );

      final entity = mapper.fromDto(
        const SeasonDto(
          number: 1,
          name: 'Season 1',
          overview: 'First season.',
          episodeCount: 8,
          posterPath: '/poster.jpg',
          airDate: '2024-01-01',
        ),
      );

      expect(entity.number, 1);
      expect(entity.name, 'Season 1');
      expect(entity.overview, 'First season.');
      expect(entity.episodeCount, 8);
      expect(entity.posterUrl, '${imageBase}w342/poster.jpg');
      expect(entity.airDate, DateTime(2024, 1, 1));
    });

    test('maps null poster and overview', () {
      const mapper = SeasonMapper(
        imageUrlBuilder: TmdbImageUrlBuilder(imageBaseUrl: imageBase),
      );

      final entity = mapper.fromDto(
        const SeasonDto(
          number: 0,
          name: '',
          overview: '',
          episodeCount: 0,
        ),
      );

      expect(entity.name, '');
      expect(entity.overview, '');
      expect(entity.posterUrl, isNull);
      expect(entity.airDate, isNull);
    });
  });

  group('EpisodeMapper', () {
    test('maps a full DTO to a domain entity', () {
      const mapper = EpisodeMapper(
        imageUrlBuilder: TmdbImageUrlBuilder(imageBaseUrl: imageBase),
      );

      final entity = mapper.fromDto(
        EpisodeDto.fromJson({
          'id': 42,
          'season_number': 1,
          'episode_number': 3,
          'name': 'Episode 3',
          'overview': 'Overview.',
          'still_path': '/still.jpg',
          'air_date': '2024-02-02',
          'runtime': 52,
          'vote_average': 8.1,
          'vote_count': 12,
        }),
      );

      expect(entity.id, 42);
      expect(entity.seasonNumber, 1);
      expect(entity.episodeNumber, 3);
      expect(entity.name, 'Episode 3');
      expect(entity.overview, 'Overview.');
      expect(entity.stillUrl, '${imageBase}w185/still.jpg');
      expect(entity.airDate, DateTime(2024, 2, 2));
      expect(entity.runtimeMinutes, 52);
      expect(entity.rating, 8.1);
      expect(entity.voteCount, 12);
    });

    test('maps nulls from an empty DTO', () {
      const mapper = EpisodeMapper(
        imageUrlBuilder: TmdbImageUrlBuilder(imageBaseUrl: imageBase),
      );

      final entity = mapper.fromDto(const EpisodeDto(
        id: 0,
        seasonNumber: 0,
        episodeNumber: 0,
        name: '',
        overview: '',
      ));

      expect(entity.stillUrl, isNull);
      expect(entity.airDate, isNull);
      expect(entity.runtimeMinutes, isNull);
      expect(entity.rating, isNull);
      expect(entity.overview, '');
    });
  });

  group('CastMemberMapper', () {
    test('maps a full DTO to a domain entity', () {
      const mapper = CastMemberMapper(
        imageUrlBuilder: TmdbImageUrlBuilder(imageBaseUrl: imageBase),
      );

      final entity = mapper.fromDto(
        CastMemberDto.fromJson({
          'id': 7,
          'name': 'Jane Doe',
          'character': 'The Hero',
          'order': 0,
          'profile_path': '/profile.jpg',
        }),
      );

      expect(entity.id, 7);
      expect(entity.name, 'Jane Doe');
      expect(entity.character, 'The Hero');
      expect(entity.order, 0);
      expect(entity.profileUrl, '${imageBase}w185/profile.jpg');
    });

    test('maps a DTO without a profile path', () {
      const mapper = CastMemberMapper(
        imageUrlBuilder: TmdbImageUrlBuilder(imageBaseUrl: imageBase),
      );

      final entity = mapper.fromDto(const CastMemberDto(
        id: 8,
        name: 'Someone',
        character: '',
        order: 1,
      ));

      expect(entity.character, '');
      expect(entity.profileUrl, isNull);
    });
  });

  group('SearchResultMapper', () {
    const mapper = SearchResultMapper(
      imageUrlBuilder: TmdbImageUrlBuilder(imageBaseUrl: imageBase),
    );

    test('maps a movie search result', () {
      final entity = mapper.fromDto(
        SearchResultDto.fromJson({
          'id': 1,
          'title': 'Dune',
          'media_type': 'movie',
          'poster_path': '/poster.jpg',
          'overview': 'An overview.',
          'release_date': '2021-09-15',
          'vote_average': 8.0,
        }),
      );

      expect(entity.id, 1);
      expect(entity.title, 'Dune');
      expect(entity.mediaType, 'movie');
      expect(entity.posterUrl, '${imageBase}w342/poster.jpg');
      expect(entity.overview, 'An overview.');
      expect(entity.releaseDate, DateTime(2021, 9, 15));
      expect(entity.rating, 8.0);
    });

    test('maps null poster and undefined fields', () {
      final entity = mapper.fromDto(
        SearchResultDto.fromJson({'id': 2, 'title': 'X', 'media_type': 'tv'}),
      );

      expect(entity.posterUrl, isNull);
      expect(entity.releaseDate, isNull);
      expect(entity.rating, isNull);
      expect(entity.overview, isNull);
    });
  });

  group('GenreMapper', () {
    test('maps a genre DTO to a domain entity', () {
      const mapper = GenreMapper();

      final entity = mapper.fromDto(const GenreDto(id: 28, name: 'Action'));

      expect(entity.id, 28);
      expect(entity.name, 'Action');
    });
  });
}
