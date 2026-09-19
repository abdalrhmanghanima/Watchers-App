class TmdbEpisode {
  const TmdbEpisode({
    required this.id,
    required this.seasonNumber,
    required this.episodeNumber,
    required this.name,
    required this.overview,
    this.stillUrl,
    this.airDate,
    this.runtimeMinutes,
    this.rating,
    this.voteCount,
  });

  final int id;
  final int seasonNumber;
  final int episodeNumber;
  final String name;
  final String overview;
  final String? stillUrl;
  final DateTime? airDate;
  final int? runtimeMinutes;
  final double? rating;
  final int? voteCount;
}