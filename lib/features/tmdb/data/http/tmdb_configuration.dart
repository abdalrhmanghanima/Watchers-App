const String _tmdbApiKey = String.fromEnvironment('TMDB_API_KEY');
const String _tmdbBaseUrl = String.fromEnvironment(
  'TMDB_BASE_URL',
  defaultValue: 'https://api.themoviedb.org/3',
);
const String _tmdbImageBaseUrl = String.fromEnvironment(
  'TMDB_IMAGE_BASE_URL',
  defaultValue: 'https://image.tmdb.org/t/p/',
);

class TmdbConfiguration {
  const TmdbConfiguration({
    required this.apiKey,
    required this.baseUrl,
    required this.imageBaseUrl,
    this.timeout = const Duration(seconds: 15),
  });

  factory TmdbConfiguration.fromEnvironment() {
    return TmdbConfiguration(
      apiKey: _tmdbApiKey,
      baseUrl: normalizeBaseUrl(_tmdbBaseUrl),
      imageBaseUrl: normalizeBaseUrl(_tmdbImageBaseUrl),
    );
  }

  final String apiKey;
  final String baseUrl;
  final String imageBaseUrl;
  final Duration timeout;

  bool get hasApiKey => apiKey.trim().isNotEmpty;
}

String normalizeBaseUrl(String url) {
  final trimmed = url.trim();
  if (trimmed.isEmpty) return trimmed;
  return trimmed.endsWith('/') ? trimmed : '$trimmed/';
}
