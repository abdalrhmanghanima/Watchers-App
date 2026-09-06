import 'package:flutter_test/flutter_test.dart';
import 'package:watchers/data/models/cast_member.dart';
import 'package:watchers/data/models/movie.dart';
import 'package:watchers/data/models/search_result.dart';
import 'package:watchers/data/models/show.dart';
import 'package:watchers/data/sources/mock_content_repository.dart';

void main() {
  final repository = MockContentRepository();

  group('models', () {
    test('Movie exposes typed fields', () {
      const movie = Movie(
        id: 'meridian',
        title: 'Meridian',
        year: 2024,
        genres: ['Sci-Fi', 'Thriller'],
        synopsis: 'synopsis',
        posterUrl: 'poster',
        backdropUrl: 'backdrop',
        runtime: 128,
        cast: [CastMember(name: 'a', role: 'b', photoUrl: 'c')],
        watched: true,
        inWatchlist: false,
      );

      expect(movie.id, 'meridian');
      expect(movie.year, 2024);
      expect(movie.genres, ['Sci-Fi', 'Thriller']);
      expect(movie.runtime, 128);
      expect(movie.cast.single.name, 'a');
      expect(movie.watched, isTrue);
      expect(movie.inWatchlist, isFalse);
    });

    test('Show exposes nullable progress fields', () {
      const show = Show(
        id: 'the-agency',
        title: 'The Agency',
        year: 2022,
        genres: ['Drama'],
        synopsis: 'synopsis',
        posterUrl: 'poster',
        backdropUrl: 'backdrop',
        seasons: 3,
        episodes: 28,
        status: ShowStatus.ongoing,
        cast: [],
        episodeData: [],
        progress: 0.65,
        unwatchedEpisodes: 2,
        inWatchlist: false,
      );

      expect(show.status, ShowStatus.ongoing);
      expect(show.progress, 0.65);
      expect(show.unwatchedEpisodes, 2);
      expect(show.inWatchlist, isFalse);
    });

    test('ShowStatus exposes the design label', () {
      expect(ShowStatus.ongoing.label, 'Ongoing');
      expect(ShowStatus.ended.label, 'Ended');
      expect(ShowStatus.upcoming.label, 'Upcoming');
    });

    test('SearchResult.matches trims and folds case', () {
      const result = SearchResult(
        type: ContentType.movie,
        id: 'meridian',
        title: 'Meridian',
        year: 2024,
        genres: ['Sci-Fi', 'Thriller'],
        posterUrl: 'poster',
      );

      expect(result.matches('  meridian  '), isTrue);
      expect(result.matches('MERIDIAN'), isTrue);
      expect(result.matches('sci-fi'), isTrue);
      expect(result.matches('romance'), isFalse);
      expect(result.matches('   '), isFalse);
    });
  });

  group('MockContentRepository', () {
    test('returns the full mock movie catalog', () async {
      final movies = await repository.getMovies();

      expect(movies, hasLength(8));
      expect(movies.first.title, 'Meridian');
      expect(
        movies.map((m) => m.id),
        containsAll(['veil', 'aether', 'hollow-city']),
      );
    });

    test('returns the full mock show catalog', () async {
      final shows = await repository.getShows();

      expect(shows, hasLength(8));
      expect(shows.first.title, 'The Agency');
      expect(shows.map((s) => s.id), containsAll(['the-agency', 'liminal']));
    });

    test('returns a show by id with seasons and episodes', () async {
      final show = await repository.getShow('the-agency');

      expect(show, isNotNull);
      expect(show!.status, ShowStatus.ongoing);
      expect(show.seasons, 3);
      expect(show.episodeData, hasLength(3));
      expect(show.episodeData.first.episodes, hasLength(6));
      expect(show.episodeData.first.episodes.first.title, 'The Briefing');
    });

    test('returns null for an unknown show', () async {
      expect(await repository.getShow('missing'), isNull);
    });

    test('returns a season with its episodes', () async {
      final season = await repository.getSeason('the-agency', 1);

      expect(season, isNotNull);
      expect(season!.number, 1);
      expect(season.episodes, hasLength(6));
      expect(season.episodes.first.watched, isTrue);
      expect(season.episodes.last.watched, isFalse);
    });

    test('returns null for an unknown season', () async {
      expect(await repository.getSeason('the-agency', 99), isNull);
      expect(await repository.getSeason('missing', 1), isNull);
    });

    test('returns a movie by id', () async {
      final movie = await repository.getMovie('meridian');

      expect(movie, isNotNull);
      expect(movie!.runtime, 128);
      expect(movie.inWatchlist, isFalse);
    });

    test('returns the mock comments', () async {
      final comments = await repository.getComments();

      expect(comments, hasLength(6));
      expect(comments.where((c) => c.spoiler).map((c) => c.id), ['c3']);
    });

    test('search matches titles only', () async {
      final results = await repository.search('veil');

      expect(results, hasLength(1));
      expect(results.single.title, 'Veil');
      expect(results.single.type, ContentType.movie);
    });

    test('search matches genres across movies and shows', () async {
      final results = await repository.search('sci-fi');

      expect(results.map((r) => r.title), [
        'Meridian',
        'Aether',
        'Meridian Falls',
        'Signal Lost',
      ]);
    });

    test('search with whitespace still matches', () async {
      final results = await repository.search('  agency ');

      expect(results, hasLength(1));
      expect(results.single.title, 'The Agency');
      expect(results.single.type, ContentType.show);
    });

    test('search with an empty query returns nothing', () async {
      expect(await repository.search(''), isEmpty);
      expect(await repository.search('   '), isEmpty);
    });
  });
}
