import '../../../../data/models/cast_member.dart';
import '../../../../data/models/episode.dart';
import '../../../../data/models/movie.dart';
import '../../../../data/models/search_result.dart';
import '../../../../data/models/season.dart';
import '../../../../data/models/show.dart';
import '../../domain/entities/tmdb_cast_member.dart';
import '../../domain/entities/tmdb_episode.dart';
import '../../domain/entities/tmdb_genre.dart';
import '../../domain/entities/tmdb_movie.dart';
import '../../domain/entities/tmdb_search_result.dart';
import '../../domain/entities/tmdb_season.dart';
import '../../domain/entities/tmdb_show.dart';

String? _imageOrNull(String? url) {
  if (url == null || url.isEmpty) return null;
  return url;
}

Movie tmdbMovieToMovie(
  TmdbMovie movie, {
  List<TmdbGenre> genres = const [],
  List<TmdbCastMember> cast = const [],
  bool? watched,
  bool? inWatchlist,
}) {
  return Movie(
    id: movie.id.toString(),
    title: movie.title,
    year: movie.releaseDate?.year ?? 0,
    genres: _genreNames(genres, movie.genreIds),
    synopsis: movie.overview,
    posterUrl: _imageOrNull(movie.posterUrl) ?? '',
    backdropUrl: _imageOrNull(movie.backdropUrl) ?? '',
    runtime: movie.runtimeMinutes ?? 0,
    cast: cast.map(tmdbCastMemberToCastMember).toList(),
    watched: watched,
    inWatchlist: inWatchlist,
  );
}

CastMember tmdbCastMemberToCastMember(TmdbCastMember member) {
  return CastMember(
    name: member.name,
    role: member.character,
    photoUrl: _imageOrNull(member.profileUrl) ?? '',
  );
}

List<String> _genreNames(List<TmdbGenre> genres, List<int> genreIds) {
  final names = <String>[];
  for (final id in genreIds) {
    for (final genre in genres) {
      if (genre.id == id) {
        names.add(genre.name);
        break;
      }
    }
  }
  return names;
}

Show tmdbShowToShow(
  TmdbShow show, {
  List<TmdbGenre> genres = const [],
  List<TmdbCastMember> cast = const [],
}) {
  return Show(
    id: show.id.toString(),
    title: show.name,
    year: show.firstAirDate?.year ?? 0,
    genres: _genreNames(genres, show.genreIds),
    synopsis: show.overview,
    posterUrl: _imageOrNull(show.posterUrl) ?? '',
    backdropUrl: _imageOrNull(show.backdropUrl) ?? '',
    seasons: show.seasons.length,
    episodes: show.seasons.fold<int>(
      0,
      (sum, season) => sum + season.episodeCount,
    ),
    status: _mapStatus(show.status),
    cast: cast.map(tmdbCastMemberToCastMember).toList(),
    episodeData: show.seasons
        .map((season) => tmdbSeasonToSeason(season, show))
        .toList(),
  );
}

ShowStatus _mapStatus(String? status) {
  if (status == null) return ShowStatus.ongoing;
  final normalized = status.toLowerCase();
  if (normalized.contains('ended') || normalized.contains('canceled')) {
    return ShowStatus.ended;
  }
  if (normalized.contains('returning') ||
      normalized.contains('in production') ||
      normalized.contains('planned')) {
    return ShowStatus.ongoing;
  }
  if (normalized.contains('pilot') || normalized.contains('upcoming')) {
    return ShowStatus.upcoming;
  }
  return ShowStatus.ongoing;
}

Season tmdbSeasonToSeason(TmdbSeason season, TmdbShow show) {
  return Season(number: season.number, episodes: const <Episode>[]);
}

Episode tmdbEpisodeToEpisode(
  TmdbEpisode episode, {
  String? showId,
  int? showSeasonNumber,
}) {
  return Episode(
    number: episode.episodeNumber,
    title: episode.name,
    duration: episode.runtimeMinutes ?? 0,
    synopsis: episode.overview,
    watched: false,
    airDate: _formatAirDate(episode.airDate),
    id: episode.id.toString(),
    imageUrl: _imageOrNull(episode.stillUrl),
    cast: const [],
  );
}

String _formatAirDate(DateTime? date) {
  if (date == null) return '';
  const months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

SearchResult tmdbSearchResultToSearchResult(TmdbSearchResult result) {
  final isMovie = result.mediaType == 'movie';
  return SearchResult(
    type: isMovie ? ContentType.movie : ContentType.show,
    id: result.id.toString(),
    title: result.title,
    year: result.releaseDate?.year ?? 0,
    genres: const <String>[],
    posterUrl: _imageOrNull(result.posterUrl) ?? '',
  );
}
