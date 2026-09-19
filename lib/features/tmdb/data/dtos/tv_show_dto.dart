import 'season_dto.dart';

class TvShowDto {
  const TvShowDto({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.genreIds,
    this.firstAirDate,
    this.voteAverage,
    this.voteCount,
    this.status,
    this.seasons = const <SeasonDto>[],
  });

  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final List<int> genreIds;
  final String? firstAirDate;
  final double? voteAverage;
  final int? voteCount;
  final String? status;
  final List<SeasonDto> seasons;

  factory TvShowDto.fromJson(Map<String, dynamic> json) {
    return TvShowDto(
      id: _toInt(json['id']) ?? 0,
      name: json['name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      genreIds: _parseIntList(json['genre_ids']),
      firstAirDate: json['first_air_date'] as String?,
      voteAverage: _parseDouble(json['vote_average']),
      voteCount: _toInt(json['vote_count']),
      status: json['status'] as String?,
      seasons: _parseSeasonList(json['seasons']),
    );
  }

  static int? _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return null;
  }

  static List<int> _parseIntList(dynamic value) {
    if (value is! List) return const [];
    return value.whereType<num>().map((e) => e.toInt()).toList();
  }

  static List<SeasonDto> _parseSeasonList(dynamic value) {
    if (value is! List) return const [];
    return value.whereType<Map>().map((e) {
      return SeasonDto.fromJson(Map<String, dynamic>.from(e));
    }).toList();
  }

  static double? _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return null;
  }
}
