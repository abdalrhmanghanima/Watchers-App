enum ImportedMovieKind {
  watched,
  rewatch,
  rewatchedCount,
  followed,
  toWatch,
}

class ImportedEpisodeRecord {
  const ImportedEpisodeRecord({
    required this.showTitle,
    required this.season,
    required this.episode,
    this.runtime,
    this.watchedAt,
  });

  final String showTitle;
  final int season;
  final int episode;
  final int? runtime;
  final DateTime? watchedAt;
}

class ImportedMovieRecord {
  const ImportedMovieRecord({
    required this.title,
    required this.kind,
    this.runtime,
    this.releaseDate,
    this.rewatchCount,
  });

  final String title;
  final ImportedMovieKind kind;
  final int? runtime;
  final DateTime? releaseDate;
  final int? rewatchCount;
}

class ImportedFollowedShow {
  const ImportedFollowedShow({required this.title, required this.active});

  final String title;
  final bool active;
}

class ImportedCommentRecord {
  const ImportedCommentRecord({
    required this.showTitle,
    required this.season,
    required this.episode,
    required this.text,
    this.likes,
    this.points,
  });

  final String showTitle;
  final int season;
  final int episode;
  final String text;
  final int? likes;
  final int? points;
}

class ImportedEpisodeRating {
  const ImportedEpisodeRating({
    required this.showTitle,
    required this.season,
    required this.episode,
    required this.value,
  });

  final String showTitle;
  final int season;
  final int episode;
  final int value;
}

class ImportedMovieRating {
  const ImportedMovieRating({required this.title, required this.value});

  final String title;
  final int value;
}

class ImportedContentHistory {
  const ImportedContentHistory({
    this.watchedEpisodes = const [],
    this.movies = const [],
    this.followedShows = const [],
    this.comments = const [],
    this.episodeRatings = const [],
    this.movieRatings = const [],
  });

  final List<ImportedEpisodeRecord> watchedEpisodes;
  final List<ImportedMovieRecord> movies;
  final List<ImportedFollowedShow> followedShows;
  final List<ImportedCommentRecord> comments;
  final List<ImportedEpisodeRating> episodeRatings;
  final List<ImportedMovieRating> movieRatings;

  bool get isEmpty =>
      watchedEpisodes.isEmpty &&
      movies.isEmpty &&
      followedShows.isEmpty &&
      comments.isEmpty;
}