import 'cast_member.dart';

class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.genres,
    required this.synopsis,
    required this.posterUrl,
    required this.backdropUrl,
    required this.runtime,
    required this.cast,
    this.watched,
    this.inWatchlist,
  });

  final String id;
  final String title;
  final int year;
  final List<String> genres;
  final String synopsis;
  final String posterUrl;
  final String backdropUrl;
  final int runtime;
  final List<CastMember> cast;
  final bool? watched;
  final bool? inWatchlist;
}
