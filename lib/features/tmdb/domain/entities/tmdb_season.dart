class TmdbSeason {
  const TmdbSeason({
    required this.number,
    required this.name,
    required this.overview,
    required this.episodeCount,
    this.posterUrl,
    this.airDate,
  });

  final int number;
  final String name;
  final String overview;
  final int episodeCount;
  final String? posterUrl;
  final DateTime? airDate;
}