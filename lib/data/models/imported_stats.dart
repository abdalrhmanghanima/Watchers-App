class ImportedUserStats {
  const ImportedUserStats({
    required this.showsWatched,
    required this.episodesWatched,
    required this.episodesWatchTime,
    required this.moviesWatched,
    required this.movieWatchEvents,
    required this.moviesWatchTime,
    required this.comments,
    required this.episodeRewatches,
    required this.rewatchedMovies,
    required this.episodeRatings,
    required this.movieRatings,
    required this.followedShows,
    required this.followedMovies,
    required this.toWatchMovies,
  });

  factory ImportedUserStats.empty() => const ImportedUserStats(
    showsWatched: 0,
    episodesWatched: 0,
    episodesWatchTime: Duration.zero,
    moviesWatched: 0,
    movieWatchEvents: 0,
    moviesWatchTime: Duration.zero,
    comments: 0,
    episodeRewatches: 0,
    rewatchedMovies: 0,
    episodeRatings: 0,
    movieRatings: 0,
    followedShows: 0,
    followedMovies: 0,
    toWatchMovies: 0,
  );

  final int showsWatched;
  final int episodesWatched;
  final Duration episodesWatchTime;
  final int moviesWatched;
  final int movieWatchEvents;
  final Duration moviesWatchTime;
  final int comments;
  final int episodeRewatches;
  final int rewatchedMovies;
  final int episodeRatings;
  final int movieRatings;
  final int followedShows;
  final int followedMovies;
  final int toWatchMovies;

  bool get isEmpty =>
      showsWatched == 0 && moviesWatched == 0 && episodesWatched == 0;

  Duration get totalWatchTime => episodesWatchTime + moviesWatchTime;

  int get totalRatings => episodeRatings + movieRatings;
}