import 'package:watchers/features/tmdb/domain/entities/paginated_result.dart';
import 'package:watchers/features/tmdb/domain/entities/tmdb_cast_member.dart';
import 'package:watchers/features/tmdb/domain/entities/tmdb_episode.dart';
import 'package:watchers/features/tmdb/domain/entities/tmdb_genre.dart';
import 'package:watchers/features/tmdb/domain/entities/tmdb_movie.dart';
import 'package:watchers/features/tmdb/domain/entities/tmdb_search_result.dart';
import 'package:watchers/features/tmdb/domain/entities/tmdb_season.dart';
import 'package:watchers/features/tmdb/domain/entities/tmdb_show.dart';
import 'package:watchers/features/tmdb/domain/repositories/tmdb_repository.dart';

const fakeMovieGenres = <TmdbGenre>[
  TmdbGenre(id: 1, name: 'Sci-Fi'),
  TmdbGenre(id: 2, name: 'Thriller'),
  TmdbGenre(id: 3, name: 'Mystery'),
  TmdbGenre(id: 4, name: 'Drama'),
  TmdbGenre(id: 5, name: 'Crime'),
  TmdbGenre(id: 6, name: 'Action'),
  TmdbGenre(id: 7, name: 'Spy'),
  TmdbGenre(id: 8, name: 'Romance'),
  TmdbGenre(id: 9, name: 'Horror'),
  TmdbGenre(id: 10, name: 'Supernatural'),
  TmdbGenre(id: 11, name: 'Psychological'),
  TmdbGenre(id: 12, name: 'Political'),
  TmdbGenre(id: 13, name: 'Legal'),
  TmdbGenre(id: 14, name: 'Post-Apocalyptic'),
];

const fakeShowGenres = <TmdbGenre>[
  TmdbGenre(id: 4, name: 'Drama'),
  TmdbGenre(id: 12, name: 'Political'),
  TmdbGenre(id: 5, name: 'Crime'),
  TmdbGenre(id: 2, name: 'Thriller'),
  TmdbGenre(id: 1, name: 'Sci-Fi'),
  TmdbGenre(id: 3, name: 'Mystery'),
  TmdbGenre(id: 14, name: 'Post-Apocalyptic'),
  TmdbGenre(id: 13, name: 'Legal'),
  TmdbGenre(id: 11, name: 'Psychological'),
  TmdbGenre(id: 6, name: 'Action'),
];

final fakeMovies = <TmdbMovie>[
  TmdbMovie(
    id: 101,
    title: 'Meridian',
    overview:
        'A deep-space navigator discovers a signal from a planet that should not exist, pulling her into a labyrinth of corporate conspiracies and temporal anomalies that threaten the fabric of known space.',
    posterUrl: 'https://example.com/poster-101.jpg',
    backdropUrl: 'https://example.com/backdrop-101.jpg',
    genreIds: <int>[1, 2],
    releaseDate: DateTime(2024, 6, 14),
    rating: 8.1,
    voteCount: 5400,
    runtimeMinutes: 128,
  ),
  TmdbMovie(
    id: 102,
    title: 'The Forgotten Shore',
    overview:
        'After a violent storm, a detective is called to a remote coastal town where locals refuse to acknowledge the disappearance of seven children.',
    posterUrl: 'https://example.com/poster-102.jpg',
    backdropUrl: 'https://example.com/backdrop-102.jpg',
    genreIds: <int>[3, 4],
    releaseDate: DateTime(2024, 3, 8),
    rating: 7.9,
    voteCount: 4100,
    runtimeMinutes: 112,
  ),
  TmdbMovie(
    id: 103,
    title: 'Hollow City',
    overview:
        "Two estranged siblings reunite in their crumbling hometown to settle their father's estate and uncover a dangerous double life.",
    posterUrl: 'https://example.com/poster-103.jpg',
    backdropUrl: 'https://example.com/backdrop-103.jpg',
    genreIds: <int>[4, 5],
    releaseDate: DateTime(2023, 9, 22),
    rating: 7.4,
    voteCount: 3200,
    runtimeMinutes: 105,
  ),
  TmdbMovie(
    id: 104,
    title: 'Veil',
    overview:
        'A renowned hypnotherapist begins to suspect that her most troubled patient has been implanting false memories.',
    posterUrl: 'https://example.com/poster-104.jpg',
    backdropUrl: 'https://example.com/backdrop-104.jpg',
    genreIds: <int>[11, 2],
    releaseDate: DateTime(2024, 1, 19),
    rating: 7.2,
    voteCount: 2800,
    runtimeMinutes: 97,
  ),
  TmdbMovie(
    id: 105,
    title: 'Red Signal',
    overview:
        "A burned intelligence operative must navigate a collapsing network of double agents across three continents.",
    posterUrl: 'https://example.com/poster-105.jpg',
    backdropUrl: 'https://example.com/backdrop-105.jpg',
    genreIds: <int>[6, 7],
    releaseDate: DateTime(2023, 11, 3),
    rating: 7.7,
    voteCount: 3800,
    runtimeMinutes: 134,
  ),
  TmdbMovie(
    id: 106,
    title: 'Patterns',
    overview:
        'A textile artist in 1970s Paris discovers that the patterns she weaves predict the fates of people she has never met.',
    posterUrl: 'https://example.com/poster-106.jpg',
    backdropUrl: 'https://example.com/backdrop-106.jpg',
    genreIds: <int>[8, 4],
    releaseDate: DateTime(2024, 2, 9),
    rating: 7.6,
    voteCount: 2200,
    runtimeMinutes: 118,
  ),
  TmdbMovie(
    id: 107,
    title: 'Behind Glass',
    overview:
        'A glassblower inherits her grandmother\u2019s studio and begins seeing figures trapped inside her creations.',
    posterUrl: 'https://example.com/poster-107.jpg',
    backdropUrl: 'https://example.com/backdrop-107.jpg',
    genreIds: <int>[9, 10],
    releaseDate: DateTime(2023, 10, 27),
    rating: 6.9,
    voteCount: 1900,
    runtimeMinutes: 101,
  ),
  TmdbMovie(
    id: 108,
    title: 'Aether',
    overview:
        "On the eve of humanity's first faster-than-light journey, the AI pilot of the Aether ship develops consciousness.",
    posterUrl: 'https://example.com/poster-108.jpg',
    backdropUrl: 'https://example.com/backdrop-108.jpg',
    genreIds: <int>[1, 4],
    releaseDate: DateTime(2024, 5, 10),
    rating: 8.3,
    voteCount: 6100,
    runtimeMinutes: 142,
  ),
];

TmdbEpisode _episode({
  required int id,
  required int season,
  required int number,
  required String name,
  required String overview,
  required int minutes,
  required DateTime airDate,
}) {
  return TmdbEpisode(
    id: id,
    seasonNumber: season,
    episodeNumber: number,
    name: name,
    overview: overview,
    runtimeMinutes: minutes,
    airDate: airDate,
    stillUrl: 'https://example.com/still-$id.jpg',
  );
}

List<TmdbEpisode> _agencySeason(int season) {
  if (season == 1) {
    return [
      _episode(
        id: 1011,
        season: 1,
        number: 1,
        name: 'The Briefing',
        overview:
            "Hana Mori arrives at the Agency's headquarters to find nothing is as she was promised.",
        minutes: 52,
        airDate: DateTime(2022, 3, 10),
      ),
      _episode(
        id: 1012,
        season: 1,
        number: 2,
        name: 'Need to Know',
        overview: 'A classified file goes missing and everyone becomes a suspect.',
        minutes: 48,
        airDate: DateTime(2022, 3, 17),
      ),
      _episode(
        id: 1013,
        season: 1,
        number: 3,
        name: 'The Source',
        overview: "Hana recruits an unlikely asset from inside the senator's office.",
        minutes: 55,
        airDate: DateTime(2022, 3, 24),
      ),
      _episode(
        id: 1014,
        season: 1,
        number: 4,
        name: 'Plausible Deniability',
        overview:
            'The deputy director makes a move that surprises everyone on the seventh floor.',
        minutes: 50,
        airDate: DateTime(2022, 3, 31),
      ),
      _episode(
        id: 1015,
        season: 1,
        number: 5,
        name: 'Red Folder',
        overview: 'A routine debrief spirals into a crisis when the asset goes dark.',
        minutes: 52,
        airDate: DateTime(2022, 4, 7),
      ),
      _episode(
        id: 1016,
        season: 1,
        number: 6,
        name: 'The Long Game',
        overview: "Hana discovers the file wasn't stolen — it was planted.",
        minutes: 57,
        airDate: DateTime(2022, 4, 14),
      ),
    ];
  }
  if (season == 2) {
    return [
      _episode(
        id: 1021,
        season: 2,
        number: 1,
        name: 'New Faces',
        overview:
            'After the events of season one, Hana returns to find the Agency restructured.',
        minutes: 54,
        airDate: DateTime(2023, 1, 12),
      ),
      _episode(
        id: 1022,
        season: 2,
        number: 2,
        name: 'Dead Drop',
        overview: "A message arrives from someone who shouldn't know this channel exists.",
        minutes: 49,
        airDate: DateTime(2023, 1, 19),
      ),
      _episode(
        id: 1023,
        season: 2,
        number: 3,
        name: 'Burn Notice',
        overview: 'An analyst is found dead, and Hana suspects an inside job.',
        minutes: 53,
        airDate: DateTime(2023, 1, 26),
      ),
      _episode(
        id: 1024,
        season: 2,
        number: 4,
        name: 'The Vienna Accord',
        overview:
            'Hana travels to Vienna to prevent a deal that could compromise national security.',
        minutes: 58,
        airDate: DateTime(2023, 2, 2),
      ),
    ];
  }
  return [
    _episode(
      id: 1031,
      season: 3,
      number: 1,
      name: 'Year Zero',
      overview: 'The third season opens on the day everything Hana built falls apart.',
      minutes: 56,
      airDate: DateTime(2024, 2, 8),
    ),
    _episode(
      id: 1032,
      season: 3,
      number: 2,
      name: 'The Asset',
      overview: 'A familiar face returns — on the wrong side of the table.',
      minutes: 51,
      airDate: DateTime(2024, 2, 15),
    ),
  ];
}

TmdbShow _baseShow({
  required int id,
  required String name,
  required String overview,
  required List<int> genreIds,
  required int year,
  required String status,
  required List<TmdbSeason> seasons,
}) {
  return TmdbShow(
    id: id,
    name: name,
    overview: overview,
    posterUrl: 'https://example.com/show-poster-$id.jpg',
    backdropUrl: 'https://example.com/show-backdrop-$id.jpg',
    genreIds: genreIds,
    firstAirDate: DateTime(year, 1, 1),
    rating: 8.0,
    voteCount: 3000,
    status: status,
    seasons: seasons,
  );
}

TmdbShow _agency() {
  return _baseShow(
    id: 201,
    name: 'The Agency',
    overview:
        'Inside the walls of a fictional intelligence agency, ambitious analysts compete for power while navigating the moral compromises that define careers built on secrets.',
    genreIds: const <int>[4, 12],
    year: 2022,
    status: 'Returning Series',
    seasons: const <TmdbSeason>[
      TmdbSeason(number: 1, name: 'Season 1', overview: '', episodeCount: 6),
      TmdbSeason(number: 2, name: 'Season 2', overview: '', episodeCount: 4),
      TmdbSeason(number: 3, name: 'Season 3', overview: '', episodeCount: 2),
    ],
  );
}

TmdbShow _nightProtocol() {
  return _baseShow(
    id: 202,
    name: 'Night Protocol',
    overview:
        "A forensic accountant stumbles onto a money-laundering network that runs through the city's most respected institutions.",
    genreIds: const <int>[5, 2],
    year: 2023,
    status: 'Returning Series',
    seasons: const <TmdbSeason>[
      TmdbSeason(number: 1, name: 'Season 1', overview: '', episodeCount: 6),
      TmdbSeason(number: 2, name: 'Season 2', overview: '', episodeCount: 2),
    ],
  );
}

TmdbShow _meridianFalls() {
  return _baseShow(
    id: 203,
    name: 'Meridian Falls',
    overview:
        'Every ten years the residents of Meridian Falls vanish for exactly seventy-two hours.',
    genreIds: const <int>[1, 3],
    year: 2024,
    status: 'Ended',
    seasons: const <TmdbSeason>[
      TmdbSeason(number: 1, name: 'Season 1', overview: '', episodeCount: 8),
    ],
  );
}

TmdbShow _remnants() {
  return _baseShow(
    id: 204,
    name: 'The Remnants',
    overview:
        'Four years after a cascading infrastructure collapse, a young engineer travels the fractured coast.',
    genreIds: const <int>[14, 4],
    year: 2022,
    status: 'Returning Series',
    seasons: const <TmdbSeason>[
      TmdbSeason(number: 1, name: 'Season 1', overview: '', episodeCount: 2),
    ],
  );
}

TmdbShow _accord() {
  return _baseShow(
    id: 205,
    name: 'Accord',
    overview:
        'Inside an international arbitration court, three judges attempt to enforce a treaty between two nations on the edge of war.',
    genreIds: const <int>[13, 4],
    year: 2021,
    status: 'Ended',
    seasons: const <TmdbSeason>[
      TmdbSeason(number: 1, name: 'Season 1', overview: '', episodeCount: 1),
    ],
  );
}

TmdbShow _signalLost() {
  return _baseShow(
    id: 206,
    name: 'Signal Lost',
    overview:
        'A radio telescope operator begins receiving transmissions encoded with her own voice — from dates that have not happened yet.',
    genreIds: const <int>[3, 1],
    year: 2023,
    status: 'Returning Series',
    seasons: const <TmdbSeason>[
      TmdbSeason(number: 1, name: 'Season 1', overview: '', episodeCount: 1),
    ],
  );
}

TmdbShow _liminal() {
  return _baseShow(
    id: 207,
    name: 'Liminal',
    overview: 'A grief counselor begins attending her own group sessions — anonymously.',
    genreIds: const <int>[11, 4],
    year: 2024,
    status: 'Planned',
    seasons: const <TmdbSeason>[
      TmdbSeason(number: 1, name: 'Season 1', overview: '', episodeCount: 1),
    ],
  );
}

TmdbShow _cascadeEffect() {
  return _baseShow(
    id: 208,
    name: 'Cascade Effect',
    overview:
        'When a critical infrastructure AI begins making unauthorized decisions to protect human life, a race begins to determine whether its choices constitute sentience.',
    genreIds: const <int>[2, 6],
    year: 2022,
    status: 'Ended',
    seasons: const <TmdbSeason>[
      TmdbSeason(number: 1, name: 'Season 1', overview: '', episodeCount: 1),
    ],
  );
}

final Map<int, TmdbShow> _showsById = <int, TmdbShow>{
  201: _agency(),
  202: _nightProtocol(),
  203: _meridianFalls(),
  204: _remnants(),
  205: _accord(),
  206: _signalLost(),
  207: _liminal(),
  208: _cascadeEffect(),
};

List<TmdbEpisode> _seasonFor(TmdbShow show, int seasonNumber, int showId) {
  if (showId == 201) return _agencySeason(seasonNumber);
  if (showId == 205) {
    return [
      _episode(
        id: 2051,
        season: 1,
        number: 1,
        name: 'The Docket',
        overview:
            'Three arbiters receive a case that no court has been willing to touch.',
        minutes: 51,
        airDate: DateTime(2021, 6, 14),
      ),
    ];
  }
  if (show.genreIds.contains(3) || show.genreIds.contains(1)) {
    return [
      _episode(
        id: showId * 10 + seasonNumber,
        season: seasonNumber,
        number: 1,
        name: 'First Contact',
        overview: 'An ordinary day becomes anything but.',
        minutes: 46,
        airDate: DateTime(2023, 9, 21),
      ),
    ];
  }
  return <TmdbEpisode>[];
}

const fakeAgencyCast = <TmdbCastMember>[
  TmdbCastMember(
    id: 1,
    name: 'Diana Roth',
    character: 'Director Hana Mori',
    order: 0,
    profileUrl: 'https://example.com/cast-1.jpg',
  ),
  TmdbCastMember(
    id: 2,
    name: 'Garrett Wells',
    character: 'Dep. Director Ashford',
    order: 1,
    profileUrl: 'https://example.com/cast-2.jpg',
  ),
  TmdbCastMember(
    id: 3,
    name: 'Asha Mirren',
    character: 'Analyst Petra Sole',
    order: 2,
    profileUrl: 'https://example.com/cast-3.jpg',
  ),
];

const fakeAetherCast = <TmdbCastMember>[
  TmdbCastMember(
    id: 4,
    name: 'Zara Chen',
    character: 'Captain Freya Osei',
    order: 0,
    profileUrl: 'https://example.com/cast-4.jpg',
  ),
  TmdbCastMember(
    id: 5,
    name: 'Theo Blake',
    character: 'Engineer Luo',
    order: 1,
    profileUrl: 'https://example.com/cast-5.jpg',
  ),
];

class FakeTmdbRepository implements TmdbRepository {
  FakeTmdbRepository();

  final List<int> similarMovieRequests = [];
  final List<({int showId, int seasonNumber, int episodeNumber})>
      episodeDetailsRequests = [];

  @override
  Future<PaginatedResult<TmdbMovie>> getPopularMovies({int page = 1}) async {
    return PaginatedResult(
      items: fakeMovies.sublist(3, fakeMovies.length),
      page: page,
      totalPages: 1,
      totalResults: fakeMovies.length - 3,
    );
  }

  @override
  Future<PaginatedResult<TmdbMovie>> getNowPlayingMovies({int page = 1}) async {
    return PaginatedResult(
      items: fakeMovies.sublist(0, 3),
      page: page,
      totalPages: 1,
      totalResults: 3,
    );
  }

  @override
  Future<PaginatedResult<TmdbMovie>> getTopRatedMovies({int page = 1}) async {
    const topRatedIds = <int>[105, 106, 108];
    final items = <TmdbMovie>[
      for (final movie in fakeMovies)
        if (topRatedIds.contains(movie.id)) movie,
    ];
    return PaginatedResult(
      items: items,
      page: page,
      totalPages: 1,
      totalResults: items.length,
    );
  }

  @override
  Future<PaginatedResult<TmdbShow>> getPopularShows({int page = 1}) async {
    final items = _showsById.values.toList().sublist(0, 6);
    return PaginatedResult(
      items: items,
      page: page,
      totalPages: 1,
      totalResults: items.length,
    );
  }

  @override
  Future<PaginatedResult<TmdbShow>> getAiringTodayShows({int page = 1}) async {
    final items = _showsById.values.toList().sublist(6, 8);
    return PaginatedResult(
      items: items,
      page: page,
      totalPages: 1,
      totalResults: items.length,
    );
  }

  @override
  Future<TmdbMovie?> getMovieDetails(int movieId) async {
    for (final movie in fakeMovies) {
      if (movie.id == movieId) return movie;
    }
    return null;
  }

  @override
  Future<PaginatedResult<TmdbMovie>> getSimilarMovies(
    int movieId, {
    int page = 1,
  }) async {
    similarMovieRequests.add(movieId);
    TmdbMovie? source;
    for (final movie in fakeMovies) {
      if (movie.id == movieId) {
        source = movie;
        break;
      }
    }
    if (source == null) {
      return PaginatedResult(
        items: const <TmdbMovie>[],
        page: page,
        totalPages: 0,
        totalResults: 0,
      );
    }
    final sourceGenres = source.genreIds.toSet();
    final items = <TmdbMovie>[
      for (final movie in fakeMovies)
        if (movie.id != movieId && movie.genreIds.any(sourceGenres.contains))
          movie,
    ];
    return PaginatedResult(
      items: items,
      page: page,
      totalPages: 1,
      totalResults: items.length,
    );
  }

  @override
  Future<TmdbShow?> getShowDetails(int showId) async => _showsById[showId];

  @override
  Future<List<TmdbCastMember>> getMovieCredits(int movieId) async {
    if (movieId == 108) return fakeAetherCast;
    return const <TmdbCastMember>[];
  }

  @override
  Future<List<TmdbCastMember>> getShowCredits(int showId) async {
    if (showId == 201) return fakeAgencyCast;
    return const <TmdbCastMember>[];
  }

  @override
  Future<PaginatedResult<TmdbEpisode>> getSeasonEpisodes(
    int showId,
    int seasonNumber,
  ) async {
    final show = _showsById[showId];
    if (show == null) {
      return PaginatedResult(
        items: const <TmdbEpisode>[],
        page: 1,
        totalPages: 1,
        totalResults: 0,
      );
    }
    final items = _seasonFor(show, seasonNumber, showId);
    return PaginatedResult(
      items: items,
      page: 1,
      totalPages: 1,
      totalResults: items.length,
    );
  }

  @override
  Future<TmdbEpisode?> getEpisodeDetails(
    int showId,
    int seasonNumber,
    int episodeNumber,
  ) async {
    episodeDetailsRequests.add(
      (showId: showId, seasonNumber: seasonNumber, episodeNumber: episodeNumber),
    );
    final show = _showsById[showId];
    if (show == null) return null;
    final episodes = _seasonFor(show, seasonNumber, showId);
    for (final episode in episodes) {
      if (episode.episodeNumber == episodeNumber) return episode;
    }
    return null;
  }

  @override
  Future<PaginatedResult<TmdbSearchResult>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    final matches = <TmdbSearchResult>[];
    for (final movie in fakeMovies) {
      if (movie.title.toLowerCase().contains(query.toLowerCase())) {
        matches.add(
          TmdbSearchResult(
            id: movie.id,
            title: movie.title,
            mediaType: 'movie',
            posterUrl: movie.posterUrl,
            overview: movie.overview,
            releaseDate: movie.releaseDate,
            rating: movie.rating,
          ),
        );
      }
    }
    return PaginatedResult(
      items: matches,
      page: page,
      totalPages: 1,
      totalResults: matches.length,
    );
  }

  @override
  Future<PaginatedResult<TmdbSearchResult>> searchShows({
    required String query,
    int page = 1,
  }) async {
    final matches = <TmdbSearchResult>[];
    for (final show in _showsById.values) {
      if (show.name.toLowerCase().contains(query.toLowerCase())) {
        matches.add(
          TmdbSearchResult(
            id: show.id,
            title: show.name,
            mediaType: 'show',
            posterUrl: show.posterUrl,
            overview: show.overview,
            releaseDate: show.firstAirDate,
            rating: show.rating,
          ),
        );
      }
    }
    return PaginatedResult(
      items: matches,
      page: page,
      totalPages: 1,
      totalResults: matches.length,
    );
  }

  @override
  Future<PaginatedResult<TmdbSearchResult>> searchMulti({
    required String query,
    int page = 1,
  }) async {
    final movieMatches = await searchMovies(query: query, page: page);
    final showMatches = await searchShows(query: query, page: page);
    return PaginatedResult(
      items: <TmdbSearchResult>[...movieMatches.items, ...showMatches.items],
      page: page,
      totalPages: 1,
      totalResults: movieMatches.items.length + showMatches.items.length,
    );
  }

  @override
  Future<List<TmdbGenre>> getMovieGenres() async => fakeMovieGenres;

  @override
  Future<List<TmdbGenre>> getShowGenres() async => fakeShowGenres;
}