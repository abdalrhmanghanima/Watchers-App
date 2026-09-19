import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchers/features/tmdb/data/dtos/episode_dto.dart';
import 'package:watchers/features/tmdb/presentation/providers/tmdb_episode_providers.dart';
import 'package:watchers/features/tmdb/presentation/providers/tmdb_providers.dart';

import 'helpers/fake_tmdb_remote_data_source.dart';

void main() {
  late FakeTmdbRemoteDataSource dataSource;
  late ProviderContainer container;

  setUp(() {
    dataSource = FakeTmdbRemoteDataSource();
    container = ProviderContainer(
      overrides: [tmdbRemoteDataSourceProvider.overrideWithValue(dataSource)],
    );
    addTearDown(container.dispose);
  });

  group('seasonEpisodesProvider', () {
    test('resolves episodes for a season', () async {
      dataSource.seasonEpisodes = const [
        EpisodeDto(
          id: 1,
          seasonNumber: 2,
          episodeNumber: 3,
          name: 'Episode 3',
          overview: '',
        ),
      ];

      final result = await container
          .read(seasonEpisodesProvider((showId: 7, seasonNumber: 2)).future);

      expect(result.single.episodeNumber, 3);
      expect(result.single.name, 'Episode 3');
    });

    test('returns an empty list when the source has no episodes', () async {
      final result = await container
          .read(seasonEpisodesProvider((showId: 7, seasonNumber: 1)).future);

      expect(result, isEmpty);
    });

    test('keys are unique per show and season', () {
      expect(
        seasonEpisodesProvider((showId: 1, seasonNumber: 1)),
        isNot(seasonEpisodesProvider((showId: 1, seasonNumber: 2))),
      );
      expect(
        seasonEpisodesProvider((showId: 1, seasonNumber: 2)),
        isNot(seasonEpisodesProvider((showId: 2, seasonNumber: 2))),
      );
      expect(
        seasonEpisodesProvider((showId: 1, seasonNumber: 1)),
        seasonEpisodesProvider((showId: 1, seasonNumber: 1)),
      );
    });
  });
}