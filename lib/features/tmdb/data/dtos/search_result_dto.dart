class SearchResultDto {
  const SearchResultDto({
    required this.id,
    required this.title,
    required this.mediaType,
    required this.posterPath,
    this.overview,
    this.releaseDate,
    this.voteAverage,
  });

  final int id;
  final String title;
  final String mediaType;
  final String? posterPath;
  final String? overview;
  final String? releaseDate;
  final double? voteAverage;

  factory SearchResultDto.fromJson(Map<String, dynamic> json) {
    final mediaType = json['media_type'] as String? ?? '';
    final title = _titleFor(json, mediaType);
    final releaseDate = _dateFor(json, mediaType);
    return SearchResultDto(
      id: _toInt(json['id']) ?? 0,
      title: title,
      mediaType: mediaType,
      posterPath: json['poster_path'] as String?,
      overview: json['overview'] as String?,
      releaseDate: releaseDate,
      voteAverage: _parseDouble(json['vote_average']),
    );
  }

  static int? _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return null;
  }

  static String _titleFor(Map<String, dynamic> json, String mediaType) {
    if (mediaType == 'tv') {
      return json['name'] as String? ?? '';
    }
    return json['title'] as String? ?? '';
  }

  static String? _dateFor(Map<String, dynamic> json, String mediaType) {
    if (mediaType == 'tv') {
      return json['first_air_date'] as String?;
    }
    return json['release_date'] as String?;
  }

  static double? _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return null;
  }
}
