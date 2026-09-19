import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/cast_member.dart';
import '../../../../data/models/episode.dart';
import '../../../../data/models/season.dart';
import '../../../../data/models/show.dart';
import '../../../../data/providers/content_repository_provider.dart';
import '../../domain/entities/tmdb_episode.dart';
import '../../domain/entities/tmdb_show.dart';
import '../adapters/tmdb_content_adapters.dart';
import 'show_catalog_providers.dart';
import 'tmdb_detail_providers.dart';
import 'tmdb_episode_providers.dart';

class ShowDetailForScreen {
  const ShowDetailForScreen({
    required this.show,
    required this.cast,
    required this.genres,
    required this.activeSeason,
    required this.activeSeasonName,
  });

  final Show show;
  final List<CastMember> cast;
  final List<String> genres;
  final int activeSeason;
  final String activeSeasonName;
}

final showDetailForScreenProvider =
    FutureProvider.autoDispose.family<ShowDetailForScreen?, int>((ref, showId) {
  return ref.watch(
    showDetailForActiveSeasonProvider((showId: showId, seasonNumber: 1)).future,
  );
});

final showDetailForActiveSeasonProvider =
    FutureProvider.autoDispose.family<ShowDetailForScreen?, SeasonEpisodeKey>(
          (ref, key) async {
        final bundle = await ref.watch(showDetailBundleProvider(key.showId).future);
        final tmdbShow = bundle.show;
        if (tmdbShow == null) return null;

        final genres = await ref.watch(showGenresProvider.future);
        final baseShow = tmdbShowToShow(tmdbShow, genres: genres, cast: bundle.cast);

        final seasonEpisodes = await ref.watch(seasonEpisodesProvider(key).future);
        var episodes = seasonEpisodes.map(tmdbEpisodeToEpisode).toList();
        final userShow = await ref
            .watch(contentRepositoryProvider)
            .getShow(key.showId.toString());
        final userSeason = _userSeasonFor(userShow, key.seasonNumber);
        if (userSeason != null) {
          episodes = _overlayWatched(episodes, userSeason.episodes);
        }
        final active = Season(number: key.seasonNumber, episodes: episodes);

        return ShowDetailForScreen(
          show: _copyShowWithActiveSeason(baseShow, key.seasonNumber, active),
          cast: bundle.cast.map(tmdbCastMemberToCastMember).toList(),
          genres: genreNamesFor(genres, tmdbShow.genreIds),
          activeSeason: key.seasonNumber,
          activeSeasonName: _seasonName(tmdbShow, key.seasonNumber),
        );
      },
    );

String _seasonName(TmdbShow show, int number) {
  for (final season in show.seasons) {
    if (season.number == number) return season.name;
  }
  return 'Season $number';
}

final fullShowWithEpisodesProvider =
    FutureProvider.autoDispose.family<Show?, int>((ref, showId) async {
  final bundle = await ref.watch(showDetailBundleProvider(showId).future);
  final tmdbShow = bundle.show;
  if (tmdbShow == null) return null;
  final genres = await ref.watch(showGenresProvider.future);
  final baseShow = tmdbShowToShow(tmdbShow, genres: genres, cast: bundle.cast);
  final userShow = await ref
      .watch(contentRepositoryProvider)
      .getShow(showId.toString());

  final seasons = <Season>[];
  for (final tmdbSeason in tmdbShow.seasons) {
    final key = (showId: showId, seasonNumber: tmdbSeason.number);
    final tmdbEpisodes = await ref.watch(seasonEpisodesProvider(key).future);
    var episodes = tmdbEpisodes.map(tmdbEpisodeToEpisode).toList();
    final userSeason = _userSeasonFor(userShow, tmdbSeason.number);
    if (userSeason != null) {
      episodes = _overlayWatched(episodes, userSeason.episodes);
    }
    seasons.add(Season(number: tmdbSeason.number, episodes: episodes));
  }
  return _copyShowWithAllSeasons(baseShow, seasons);
});

final episodeDetailContentProvider =
    FutureProvider.autoDispose.family<Episode?, EpisodeDetailKey>((
      ref,
      key,
    ) async {
      final show = await ref
          .watch(fullShowWithEpisodesProvider(key.showId).future);
      if (show == null) return null;
      Episode? base;
      for (final season in show.episodeData) {
        if (season.number != key.seasonNumber) continue;
        for (final episode in season.episodes) {
          if (episode.number != key.episodeNumber) continue;
          base = episode;
          break;
        }
        if (base != null) break;
      }
      if (base == null) return null;
      TmdbEpisode? details;
      try {
        details = await ref.watch(episodeDetailsProvider(key).future);
      } on Object {
        details = null;
      }
      if (details == null) return base;
      final mapped = tmdbEpisodeToEpisode(details);
      return Episode(
        number: base.number,
        title: mapped.title.isEmpty ? base.title : mapped.title,
        duration: mapped.duration == 0 ? base.duration : mapped.duration,
        synopsis: mapped.synopsis.isEmpty ? base.synopsis : mapped.synopsis,
        watched: base.watched,
        airDate: mapped.airDate.isEmpty ? base.airDate : mapped.airDate,
        id: details.id == 0 ? base.id : details.id.toString(),
        imageUrl: mapped.imageUrl ?? base.imageUrl,
        cast: base.cast,
      );
    });

Show _copyShowWithAllSeasons(Show base, List<Season> seasons) {
  return Show(
    id: base.id,
    title: base.title,
    year: base.year,
    genres: base.genres,
    synopsis: base.synopsis,
    posterUrl: base.posterUrl,
    backdropUrl: base.backdropUrl,
    seasons: base.seasons,
    episodes: base.episodes,
    status: base.status,
    cast: base.cast,
    episodeData: seasons,
    progress: base.progress,
    unwatchedEpisodes: base.unwatchedEpisodes,
    inWatchlist: base.inWatchlist,
  );
}

Season? _userSeasonFor(Show? show, int seasonNumber) {
  if (show == null) return null;
  for (final season in show.episodeData) {
    if (season.number == seasonNumber) return season;
  }
  return null;
}

List<Episode> _overlayWatched(List<Episode> catalog, List<Episode> user) {
  final byNumber = <int, bool>{
    for (final episode in user) episode.number: episode.watched,
  };
  return [
    for (final episode in catalog)
      Episode(
        number: episode.number,
        title: episode.title,
        duration: episode.duration,
        synopsis: episode.synopsis,
        watched: byNumber[episode.number] ?? false,
        airDate: episode.airDate,
        id: episode.id,
        imageUrl: episode.imageUrl,
        cast: episode.cast,
      ),
  ];
}

Show _copyShowWithActiveSeason(Show base, int activeSeason, Season active) {
  final seasons = <Season>[];
  for (final season in base.episodeData) {
    if (season.number == activeSeason) {
      seasons.add(active);
    } else {
      seasons.add(season);
    }
  }
  return Show(
    id: base.id,
    title: base.title,
    year: base.year,
    genres: base.genres,
    synopsis: base.synopsis,
    posterUrl: base.posterUrl,
    backdropUrl: base.backdropUrl,
    seasons: base.seasons,
    episodes: base.episodes,
    status: base.status,
    cast: base.cast,
    episodeData: seasons,
    progress: base.progress,
    unwatchedEpisodes: base.unwatchedEpisodes,
    inWatchlist: base.inWatchlist,
  );
}