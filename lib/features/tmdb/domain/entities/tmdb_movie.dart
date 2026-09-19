class TmdbMovie {
  const TmdbMovie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterUrl,
    required this.backdropUrl,
    required this.genreIds,
    this.releaseDate,
    this.rating,
    this.voteCount,
    this.runtimeMinutes,
  });

  final int id;
  final String title;
  final String overview;
  final String? posterUrl;
  final String? backdropUrl;
  final List<int> genreIds;
  final DateTime? releaseDate;
  final double? rating;
  final int? voteCount;
  final int? runtimeMinutes;
}
