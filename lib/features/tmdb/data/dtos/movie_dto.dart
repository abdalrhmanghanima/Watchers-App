class MovieDto {
  const MovieDto({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.genreIds,
    this.releaseDate,
    this.voteAverage,
    this.voteCount,
    this.runtime,
  });

  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final List<int> genreIds;
  final String? releaseDate;
  final double? voteAverage;
  final int? voteCount;
  final int? runtime;

  factory MovieDto.fromJson(Map<String, dynamic> json) {
    return MovieDto(
      id: _toInt(json['id']) ?? 0,
      title: json['title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      genreIds: _parseIntList(json['genre_ids']),
      releaseDate: json['release_date'] as String?,
      voteAverage: _parseDouble(json['vote_average']),
      voteCount: _toInt(json['vote_count']),
      runtime: _toInt(json['runtime']),
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

  static double? _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return null;
  }
}
