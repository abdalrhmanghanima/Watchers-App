class TmdbSearchResult {
  const TmdbSearchResult({
    required this.id,
    required this.title,
    required this.mediaType,
    required this.posterUrl,
    this.overview,
    this.releaseDate,
    this.rating,
  });

  final int id;
  final String title;
  final String mediaType;
  final String? posterUrl;
  final String? overview;
  final DateTime? releaseDate;
  final double? rating;
}
