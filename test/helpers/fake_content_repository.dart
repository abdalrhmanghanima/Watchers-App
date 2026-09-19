import 'package:watchers/data/models/comment.dart';
import 'package:watchers/data/models/movie.dart';
import 'package:watchers/data/models/search_result.dart';
import 'package:watchers/data/models/season.dart';
import 'package:watchers/data/models/show.dart';
import 'package:watchers/data/repositories/content_repository.dart';
import 'package:watchers/data/sources/mock_content_repository.dart';

const Map<String, String> fakeMovieIds = <String, String>{
  'meridian': '101',
  'forgotten-shore': '102',
  'hollow-city': '103',
  'veil': '104',
  'red-signal': '105',
  'patterns': '106',
  'behind-glass': '107',
  'aether': '108',
};

const Map<String, String> fakeShowIds = <String, String>{
  'the-agency': '201',
  'night-protocol': '202',
  'meridian-falls': '203',
  'the-remnants': '204',
  'accord': '205',
  'signal-lost': '206',
  'liminal': '207',
  'cascade-effect': '208',
};

const Map<String, String> _reverseMovieIds = <String, String>{
  '101': 'meridian',
  '102': 'forgotten-shore',
  '103': 'hollow-city',
  '104': 'veil',
  '105': 'red-signal',
  '106': 'patterns',
  '107': 'behind-glass',
  '108': 'aether',
};

const Map<String, String> _reverseShowIds = <String, String>{
  '201': 'the-agency',
  '202': 'night-protocol',
  '203': 'meridian-falls',
  '204': 'the-remnants',
  '205': 'accord',
  '206': 'signal-lost',
  '207': 'liminal',
  '208': 'cascade-effect',
};

Show _remapShow(Show show, String id) {
  return Show(
    id: id,
    title: show.title,
    year: show.year,
    genres: show.genres,
    synopsis: show.synopsis,
    posterUrl: show.posterUrl,
    backdropUrl: show.backdropUrl,
    seasons: show.seasons,
    episodes: show.episodes,
    status: show.status,
    cast: show.cast,
    episodeData: show.episodeData,
    progress: show.progress,
    unwatchedEpisodes: show.unwatchedEpisodes,
    inWatchlist: show.inWatchlist,
  );
}

Movie _remapMovie(Movie movie, String id) {
  return Movie(
    id: id,
    title: movie.title,
    year: movie.year,
    genres: movie.genres,
    synopsis: movie.synopsis,
    posterUrl: movie.posterUrl,
    backdropUrl: movie.backdropUrl,
    runtime: movie.runtime,
    cast: movie.cast,
    watched: movie.watched,
    inWatchlist: movie.inWatchlist,
  );
}

class FakeContentRepository implements ContentRepository {
  FakeContentRepository();

  final MockContentRepository _delegate = MockContentRepository();

  @override
  Future<List<Show>> getShows() async {
    final shows = await _delegate.getShows();
    return <Show>[
      for (final show in shows)
        _remapShow(show, fakeShowIds[show.id] ?? show.id),
    ];
  }

  @override
  Future<Show?> getShow(String id) async {
    final slug = _reverseShowIds[id];
    final show = await _delegate.getShow(slug ?? id);
    if (show == null) return null;
    return _remapShow(show, id);
  }

  @override
  Future<List<Movie>> getMovies() async {
    final movies = await _delegate.getMovies();
    return <Movie>[
      for (final movie in movies)
        _remapMovie(movie, fakeMovieIds[movie.id] ?? movie.id),
    ];
  }

  @override
  Future<Movie?> getMovie(String id) async {
    final slug = _reverseMovieIds[id];
    final movie = await _delegate.getMovie(slug ?? id);
    if (movie == null) return null;
    return _remapMovie(movie, id);
  }

  @override
  Future<Season?> getSeason(String showId, int seasonNumber) async {
    final slug = _reverseShowIds[showId];
    return _delegate.getSeason(slug ?? showId, seasonNumber);
  }

  @override
  Future<List<Comment>> getComments() => _delegate.getComments();

  @override
  Future<List<SearchResult>> search(String query) async {
    final results = await _delegate.search(query);
    return <SearchResult>[
      for (final result in results)
        SearchResult(
          type: result.type,
          id: result.type == ContentType.movie
              ? (fakeMovieIds[result.id] ?? result.id)
              : (fakeShowIds[result.id] ?? result.id),
          title: result.title,
          year: result.year,
          genres: result.genres,
          posterUrl: result.posterUrl,
        ),
    ];
  }
}