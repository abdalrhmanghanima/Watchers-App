import 'package:watchers/data/models/movie.dart';
import 'package:watchers/data/models/show.dart';

String formatDuration(int totalMinutes) {
  final days = totalMinutes ~/ 1440;
  final remaining = totalMinutes % 1440;
  final hours = remaining ~/ 60;
  final minutes = remaining % 60;
  final parts = <String>[];
  if (days > 0) parts.add('${days}d');
  if (hours > 0) parts.add('${hours}h');
  parts.add('${minutes}m');
  return parts.join(' ');
}

int calculateMoviesTimeWasted(List<Movie> movies) {
  return movies
      .where((m) => m.watched == true)
      .fold<int>(0, (sum, m) => sum + m.runtime);
}

int calculateShowsTimeWasted(List<Show> shows) {
  return shows.fold<int>(0, (sum, show) {
    if (show.progress == null || show.progress! <= 0) return sum;
    int watchedMinutes = 0;
    for (final season in show.episodeData) {
      for (final episode in season.episodes) {
        if (episode.watched) {
          watchedMinutes += episode.duration;
        }
      }
    }
    return sum + watchedMinutes;
  });
}
