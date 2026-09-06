enum ContentType { movie, show, episode }

class SearchResult {
  const SearchResult({
    required this.type,
    required this.id,
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
  });

  final ContentType type;
  final String id;
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return false;
    return title.toLowerCase().contains(q) ||
        genres.any((genre) => genre.toLowerCase().contains(q));
  }
}
