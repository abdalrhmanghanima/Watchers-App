import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/tmdb_episode.dart';
import 'tmdb_providers.dart';

typedef SeasonEpisodeKey = ({int showId, int seasonNumber});

typedef EpisodeDetailKey = ({int showId, int seasonNumber, int episodeNumber});

final seasonEpisodesProvider =
    FutureProvider.autoDispose.family<List<TmdbEpisode>, SeasonEpisodeKey>((
      ref,
      key,
    ) async {
      final result = await ref.watch(tmdbRepositoryProvider).getSeasonEpisodes(
            key.showId,
            key.seasonNumber,
          );
      return result.items;
    });

final episodeDetailsProvider =
    FutureProvider.autoDispose.family<TmdbEpisode?, EpisodeDetailKey>((
      ref,
      key,
    ) async {
      return ref.watch(tmdbRepositoryProvider).getEpisodeDetails(
            key.showId,
            key.seasonNumber,
            key.episodeNumber,
          );
    }, retry: (retryCount, error) => null);