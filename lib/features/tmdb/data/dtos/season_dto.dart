class SeasonDto {
  const SeasonDto({
    required this.number,
    required this.name,
    required this.overview,
    required this.episodeCount,
    this.posterPath,
    this.airDate,
  });

  final int number;
  final String name;
  final String overview;
  final int episodeCount;
  final String? posterPath;
  final String? airDate;

  factory SeasonDto.fromJson(Map<String, dynamic> json) {
    return SeasonDto(
      number: _toInt(json['season_number']) ?? 0,
      name: json['name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      episodeCount: _toInt(json['episode_count']) ?? 0,
      posterPath: json['poster_path'] as String?,
      airDate: json['air_date'] as String?,
    );
  }

  static int? _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return null;
  }
}