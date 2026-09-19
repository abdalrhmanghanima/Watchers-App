class EpisodeDto {
  const EpisodeDto({
    required this.id,
    required this.seasonNumber,
    required this.episodeNumber,
    required this.name,
    required this.overview,
    this.stillPath,
    this.airDate,
    this.runtime,
    this.voteAverage,
    this.voteCount,
  });

  final int id;
  final int seasonNumber;
  final int episodeNumber;
  final String name;
  final String overview;
  final String? stillPath;
  final String? airDate;
  final int? runtime;
  final double? voteAverage;
  final int? voteCount;

  factory EpisodeDto.fromJson(Map<String, dynamic> json) {
    return EpisodeDto(
      id: _toInt(json['id']) ?? 0,
      seasonNumber: _toInt(json['season_number']) ?? 0,
      episodeNumber: _toInt(json['episode_number']) ?? 0,
      name: json['name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      stillPath: json['still_path'] as String?,
      airDate: json['air_date'] as String?,
      runtime: _toInt(json['runtime']),
      voteAverage: _parseDouble(json['vote_average']),
      voteCount: _toInt(json['vote_count']),
    );
  }

  static int? _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return null;
  }
}