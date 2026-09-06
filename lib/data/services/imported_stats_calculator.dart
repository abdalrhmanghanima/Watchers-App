import '../models/imported_stats.dart';
import '../models/raw_import_data.dart';

class ImportedStatsCalculator {
  const ImportedStatsCalculator();

  ImportedUserStats calculate(RawImportData data) {
    final episodes = data.table(ImportTables.trackingEpisodes);
    final showsWatched = <String>{};
    var episodesWatched = 0.0;
    var episodesSeconds = 0;
    final rewatchedEpisodes = <String>{};
    for (final row in episodes) {
      final type = row['record_type']?.trim();
      if (type == 'watch') {
        final show = row['series_name']?.trim();
        if (show != null && show.isNotEmpty) {
          showsWatched.add(show);
        }
        episodesWatched += 1;
        episodesSeconds += _toInt(row['runtime']);
      } else if (type == 'rewatch') {
        final show = row['series_name']?.trim();
        final season = row['season_number']?.trim();
        final episode = row['episode_number']?.trim();
        if (show != null && show.isNotEmpty) {
          rewatchedEpisodes.add('$show:$season:$episode');
        }
      }
    }

    final movies = data.table(ImportTables.trackingMovies);
    final watchedMovies = <String>{};
    final followedMovies = <String>{};
    final toWatchMovies = <String>{};
    final rewatchedMovies = <String>{};
    var movieWatchEvents = 0.0;
    var moviesSeconds = 0;
    for (final row in movies) {
      final type = row['type']?.trim();
      final title = row['movie_name']?.trim();
      if (title == null || title.isEmpty) continue;
      switch (type) {
        case 'watch':
          watchedMovies.add(title);
          movieWatchEvents += 1;
          moviesSeconds += _toInt(row['runtime']);
        case 'rewatch':
          rewatchedMovies.add(title);
        case 'rewatch_count':
          final rewatch = _toInt(row['rewatch_count']);
          if (rewatch > 0) rewatchedMovies.add(title);
        case 'follow':
          followedMovies.add(title);
        case 'towatch':
          toWatchMovies.add(title);
      }
    }

    final followedShows = <String>{};
    for (final row in data.table(ImportTables.followedShows)) {
      if (row['active']?.trim() == '1') {
        final show = row['tv_show_name']?.trim();
        if (show != null && show.isNotEmpty) followedShows.add(show);
      }
    }

    return ImportedUserStats(
      showsWatched: showsWatched.length,
      episodesWatched: episodesWatched.toInt(),
      episodesWatchTime: Duration(seconds: episodesSeconds),
      moviesWatched: watchedMovies.length,
      movieWatchEvents: movieWatchEvents.toInt(),
      moviesWatchTime: Duration(seconds: moviesSeconds),
      comments: data.table(ImportTables.comments).length,
      episodeRewatches: rewatchedEpisodes.length,
      rewatchedMovies: rewatchedMovies.length,
      episodeRatings: data.table(ImportTables.ratingsEpisodes).length,
      movieRatings: data.table(ImportTables.ratingsMovies).length,
      followedShows: followedShows.length,
      followedMovies: followedMovies.length,
      toWatchMovies: toWatchMovies.length,
    );
  }

  static int _toInt(String? value) {
    final parsed = int.tryParse((value ?? '').trim());
    if (parsed == null || parsed < 0) return 0;
    return parsed;
  }
}