import '../models/imported_content.dart';
import '../models/raw_import_data.dart';

class ImportedHistoryMapper {
  const ImportedHistoryMapper();

  ImportedContentHistory map(RawImportData data) {
    final episodes = <ImportedEpisodeRecord>[];
    for (final row in data.table(ImportTables.trackingEpisodes)) {
      final type = row['record_type']?.trim();
      if (type != 'watch') continue;
      final showTitle = row['series_name']?.trim();
      if (showTitle == null || showTitle.isEmpty) continue;
      episodes.add(
        ImportedEpisodeRecord(
          showTitle: showTitle,
          season: _toInt(row['season_number']),
          episode: _toInt(row['episode_number']),
          runtime: _toNullableInt(row['runtime']),
          watchedAt: _toDateTime(row['created_at']),
        ),
      );
    }

    final movies = <ImportedMovieRecord>[
      for (final row in data.table(ImportTables.trackingMovies))
        if (_kindOf(row) case final kind? when _isValidTitle(row))
          ImportedMovieRecord(
            title: row['movie_name']!.trim(),
            kind: kind,
            runtime: _toNullableInt(row['runtime']),
            releaseDate: _toDateTime(row['release_date']),
            rewatchCount: _toNullableInt(row['rewatch_count']),
          ),
    ];

    final followedShows = <ImportedFollowedShow>[
      for (final row in data.table(ImportTables.followedShows))
        if (_isValidTitle(row))
          ImportedFollowedShow(
            title: row['tv_show_name']!.trim(),
            active: row['active']?.trim() == '1',
          ),
    ];

    final comments = <ImportedCommentRecord>[
      for (final row in data.table(ImportTables.comments))
        if (row['comment']?.trim().isNotEmpty ?? false)
          ImportedCommentRecord(
            showTitle: row['tv_show_name'] ?? '',
            season: _toInt(row['episode_season_number']),
            episode: _toInt(row['episode_number']),
            text: row['comment']!,
            likes: _toNullableInt(row['nb_likes']),
            points: _toNullableInt(row['nb_points']),
          ),
    ];

    final episodeRatings = <ImportedEpisodeRating>[
      for (final row in data.table(ImportTables.ratingsEpisodes))
        if (_isValidTitle(row))
          ImportedEpisodeRating(
            showTitle: row['series_name']!.trim(),
            season: _toInt(row['season_number']),
            episode: _toInt(row['episode_number']),
            value: _toInt(row['vote']),
          ),
    ];

    final movieRatings = <ImportedMovieRating>[
      for (final row in data.table(ImportTables.ratingsMovies))
        if (_isValidTitle(row))
          ImportedMovieRating(
            title: row['movie_name']!.trim(),
            value: _toInt(row['vote']),
          ),
    ];

    return ImportedContentHistory(
      watchedEpisodes: episodes,
      movies: movies,
      followedShows: followedShows,
      comments: comments,
      episodeRatings: episodeRatings,
      movieRatings: movieRatings,
    );
  }

  static bool _isValidTitle(Map<String, String> row) {
    final title = row.entries.fold<String?>(
      null,
      (previous, entry) => switch (entry.key) {
        'movie_name' || 'tv_show_name' || 'series_name' => entry.value,
        _ => previous,
      },
    );
    return title != null && title.trim().isNotEmpty;
  }

  static ImportedMovieKind? _kindOf(Map<String, String> row) {
    final kind = switch (row['type']?.trim()) {
      'watch' => ImportedMovieKind.watched,
      'rewatch' => ImportedMovieKind.rewatch,
      'rewatch_count' => ImportedMovieKind.rewatchedCount,
      'follow' => ImportedMovieKind.followed,
      'towatch' => ImportedMovieKind.toWatch,
      _ => null,
    };
    return kind;
  }

  static DateTime? _toDateTime(String? value) {
    final cleaned = (value ?? '').trim().replaceFirst(' ', 'T');
    return DateTime.tryParse(cleaned);
  }

  static int _toInt(String? value) {
    final parsed = int.tryParse((value ?? '').trim());
    if (parsed == null || parsed < 0) return 0;
    return parsed;
  }

  static int? _toNullableInt(String? value) {
    final parsed = int.tryParse((value ?? '').trim());
    if (parsed == null || parsed < 0) return null;
    return parsed;
  }
}