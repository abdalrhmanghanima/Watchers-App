import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/episode.dart';
import '../../../../data/models/season.dart';
import '../../../../data/models/show.dart';
import '../adapters/tmdb_content_adapters.dart';
import 'tmdb_detail_providers.dart';
import 'tmdb_episode_providers.dart';

class SeasonEpisodesData {
  const SeasonEpisodesData({
    required this.show,
    required this.seasons,
    required this.activeSeason,
    required this.episodes,
  });

  final Show show;
  final List<Season> seasons;
  final Season activeSeason;
  final List<Episode> episodes;
}

final seasonEpisodesDataProvider =
    FutureProvider.autoDispose.family<SeasonEpisodesData?, ({int showId, int seasonNumber})>((ref, key) async {
  final show = await ref.watch(showDetailBundleProvider(key.showId).future);
  final tmdbShow = show.show;
  if (tmdbShow == null) return null;

  final tmdbEpisodes =
      await ref.watch(seasonEpisodesProvider(key).future);

  final episodes = tmdbEpisodes
      .map((episode) => tmdbEpisodeToEpisode(episode))
      .toList();

  final seasons = tmdbShow.seasons
      .map((season) => tmdbSeasonToSeason(season, tmdbShow))
      .toList();

  final activeSeason = seasons.isEmpty
      ? Season(number: key.seasonNumber, episodes: episodes)
      : Season(number: key.seasonNumber, episodes: episodes);

  return SeasonEpisodesData(
    show: tmdbShowToShow(tmdbShow),
    seasons: seasons,
    activeSeason: activeSeason,
    episodes: episodes,
  );
});
