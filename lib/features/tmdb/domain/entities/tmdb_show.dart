import 'tmdb_season.dart';

class TmdbShow {
  const TmdbShow({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterUrl,
    required this.backdropUrl,
    required this.genreIds,
    this.firstAirDate,
    this.rating,
    this.voteCount,
    this.status,
    this.seasons = const <TmdbSeason>[],
  });

  final int id;
  final String name;
  final String overview;
  final String? posterUrl;
  final String? backdropUrl;
  final List<int> genreIds;
  final DateTime? firstAirDate;
  final double? rating;
  final int? voteCount;
  final String? status;
  final List<TmdbSeason> seasons;
}
