import 'cast_member.dart';
import 'season.dart';

enum ShowStatus {
  ongoing('Ongoing'),
  ended('Ended'),
  upcoming('Upcoming');

  const ShowStatus(this.label);

  final String label;
}

class Show {
  const Show({
    required this.id,
    required this.title,
    required this.year,
    required this.genres,
    required this.synopsis,
    required this.posterUrl,
    required this.backdropUrl,
    required this.seasons,
    required this.episodes,
    required this.status,
    required this.cast,
    required this.episodeData,
    this.progress,
    this.unwatchedEpisodes,
    this.inWatchlist,
  });

  final String id;
  final String title;
  final int year;
  final List<String> genres;
  final String synopsis;
  final String posterUrl;
  final String backdropUrl;
  final int seasons;
  final int episodes;
  final ShowStatus status;
  final List<CastMember> cast;
  final List<Season> episodeData;
  final double? progress;
  final int? unwatchedEpisodes;
  final bool? inWatchlist;
}
