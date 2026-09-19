enum TmdbImageSize {
  posterSmall('w185'),
  posterMedium('w342'),
  posterLarge('w500'),
  posterOriginal('original'),
  backdropSmall('w300'),
  backdropMedium('w780'),
  backdropLarge('w1280'),
  backdropOriginal('original'),
  stillSmall('w92'),
  stillMedium('w185'),
  stillLarge('w300'),
  stillOriginal('original'),
  profileSmall('w45'),
  profileMedium('w185'),
  profileLarge('h632'),
  profileOriginal('original');

  const TmdbImageSize(this.size);

  final String size;
}

enum TmdbImageType { poster, backdrop, still, profile }

class TmdbImageUrlBuilder {
  const TmdbImageUrlBuilder({required this.imageBaseUrl});

  final String imageBaseUrl;

  String? poster(
    String? path, {
    TmdbImageSize size = TmdbImageSize.posterMedium,
  }) {
    return _url(path, size, TmdbImageType.poster);
  }

  String? backdrop(
    String? path, {
    TmdbImageSize size = TmdbImageSize.backdropLarge,
  }) {
    return _url(path, size, TmdbImageType.backdrop);
  }

  String? profile(
    String? path, {
    TmdbImageSize size = TmdbImageSize.profileMedium,
  }) {
    return _url(path, size, TmdbImageType.profile);
  }

  String? still(
    String? path, {
    TmdbImageSize size = TmdbImageSize.stillMedium,
  }) {
    return _url(path, size, TmdbImageType.still);
  }

  String? _url(String? path, TmdbImageSize size, TmdbImageType type) {
    if (path == null || path.isEmpty) return null;
    final cleaned = path.startsWith('/') ? path.substring(1) : path;
    final desired = _sizeFor(size, type).size;
    return '$imageBaseUrl$desired/$cleaned';
  }

  TmdbImageSize _sizeFor(TmdbImageSize requested, TmdbImageType type) {
    final isPoster = requested.name.startsWith('poster');
    final isBackdrop = requested.name.startsWith('backdrop');
    final isStill = requested.name.startsWith('still');
    final isProfile = requested.name.startsWith('profile');
    if (type == TmdbImageType.poster && !isPoster) {
      return TmdbImageSize.posterMedium;
    }
    if (type == TmdbImageType.backdrop && !isBackdrop) {
      return TmdbImageSize.backdropLarge;
    }
    if (type == TmdbImageType.still && !isStill) {
      return TmdbImageSize.stillMedium;
    }
    if (type == TmdbImageType.profile && !isProfile) {
      return TmdbImageSize.profileMedium;
    }
    return requested;
  }
}
