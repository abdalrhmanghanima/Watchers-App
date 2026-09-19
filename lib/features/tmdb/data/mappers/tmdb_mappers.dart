import 'package:watchers/core/tmdb/tmdb_image_url_builder.dart';

import '../../domain/entities/tmdb_cast_member.dart';
import '../../domain/entities/tmdb_episode.dart';
import '../../domain/entities/tmdb_genre.dart';
import '../../domain/entities/tmdb_movie.dart';
import '../../domain/entities/tmdb_search_result.dart';
import '../../domain/entities/tmdb_season.dart';
import '../../domain/entities/tmdb_show.dart';
import '../dtos/cast_member_dto.dart';
import '../dtos/episode_dto.dart';
import '../dtos/genre_dto.dart';
import '../dtos/movie_dto.dart';
import '../dtos/search_result_dto.dart';
import '../dtos/season_dto.dart';
import '../dtos/tv_show_dto.dart';

class MovieMapper {
  const MovieMapper({required this.imageUrlBuilder});

  final TmdbImageUrlBuilder imageUrlBuilder;

  TmdbMovie fromDto(MovieDto dto) {
    return TmdbMovie(
      id: dto.id,
      title: dto.title,
      overview: dto.overview,
      posterUrl: imageUrlBuilder.poster(dto.posterPath),
      backdropUrl: imageUrlBuilder.backdrop(dto.backdropPath),
      genreIds: dto.genreIds,
      releaseDate: _parseDate(dto.releaseDate),
      rating: dto.voteAverage,
      voteCount: dto.voteCount,
      runtimeMinutes: dto.runtime,
    );
  }

  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}

class TvShowMapper {
  const TvShowMapper({required this.imageUrlBuilder, this.seasonMapper});

  final TmdbImageUrlBuilder imageUrlBuilder;
  final SeasonMapper? seasonMapper;

  TmdbShow fromDto(TvShowDto dto) {
    final seasonMapper = this.seasonMapper ??
        SeasonMapper(imageUrlBuilder: imageUrlBuilder);
    return TmdbShow(
      id: dto.id,
      name: dto.name,
      overview: dto.overview,
      posterUrl: imageUrlBuilder.poster(dto.posterPath),
      backdropUrl: imageUrlBuilder.backdrop(dto.backdropPath),
      genreIds: dto.genreIds,
      firstAirDate: _parseDate(dto.firstAirDate),
      rating: dto.voteAverage,
      voteCount: dto.voteCount,
      status: dto.status,
      seasons: dto.seasons.map(seasonMapper.fromDto).toList(),
    );
  }

  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}

class SeasonMapper {
  const SeasonMapper({required this.imageUrlBuilder});

  final TmdbImageUrlBuilder imageUrlBuilder;

  TmdbSeason fromDto(SeasonDto dto) {
    return TmdbSeason(
      number: dto.number,
      name: dto.name,
      overview: dto.overview,
      episodeCount: dto.episodeCount,
      posterUrl: imageUrlBuilder.poster(dto.posterPath),
      airDate: _parseDate(dto.airDate),
    );
  }

  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}

class EpisodeMapper {
  const EpisodeMapper({required this.imageUrlBuilder});

  final TmdbImageUrlBuilder imageUrlBuilder;

  TmdbEpisode fromDto(EpisodeDto dto) {
    return TmdbEpisode(
      id: dto.id,
      seasonNumber: dto.seasonNumber,
      episodeNumber: dto.episodeNumber,
      name: dto.name,
      overview: dto.overview,
      stillUrl: imageUrlBuilder.still(dto.stillPath),
      airDate: _parseDate(dto.airDate),
      runtimeMinutes: dto.runtime,
      rating: dto.voteAverage,
      voteCount: dto.voteCount,
    );
  }

  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}

class CastMemberMapper {
  const CastMemberMapper({required this.imageUrlBuilder});

  final TmdbImageUrlBuilder imageUrlBuilder;

  TmdbCastMember fromDto(CastMemberDto dto) {
    return TmdbCastMember(
      id: dto.id,
      name: dto.name,
      character: dto.character,
      order: dto.order,
      profileUrl: imageUrlBuilder.profile(dto.profilePath),
    );
  }
}

class SearchResultMapper {
  const SearchResultMapper({required this.imageUrlBuilder});

  final TmdbImageUrlBuilder imageUrlBuilder;

  TmdbSearchResult fromDto(SearchResultDto dto) {
    return TmdbSearchResult(
      id: dto.id,
      title: dto.title,
      mediaType: dto.mediaType,
      posterUrl: imageUrlBuilder.poster(dto.posterPath),
      overview: dto.overview,
      releaseDate: _parseDate(dto.releaseDate),
      rating: dto.voteAverage,
    );
  }

  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}

class GenreMapper {
  const GenreMapper();

  TmdbGenre fromDto(GenreDto dto) => TmdbGenre(id: dto.id, name: dto.name);
}
