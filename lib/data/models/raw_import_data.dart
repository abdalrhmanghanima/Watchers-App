abstract final class ImportTables {
  static const String trackingEpisodes = 'tracking_episodes';
  static const String trackingMovies = 'tracking_movies';
  static const String watchedEpisodes = 'watched_episodes';
  static const String comments = 'comments';
  static const String ratingsEpisodes = 'ratings_episodes';
  static const String ratingsMovies = 'ratings_movies';
  static const String followedShows = 'followed_shows';
}

class RawImportData {
  const RawImportData({required this.tables});

  final Map<String, List<Map<String, String>>> tables;

  List<Map<String, String>> table(String name) => tables[name] ?? const [];

  bool get isEmpty => tables.values.every((table) => table.isEmpty);

  int get totalRows =>
      tables.values.fold<int>(0, (sum, table) => sum + table.length);
}