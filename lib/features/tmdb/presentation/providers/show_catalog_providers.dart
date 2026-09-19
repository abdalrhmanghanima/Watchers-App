import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/tmdb_genre.dart';
import '../../domain/entities/tmdb_show.dart';
import 'tmdb_providers.dart';

enum ShowSection { popular, airingToday }

final showsPopularProvider = FutureProvider<List<TmdbShow>>((ref) async {
  final result = await ref.watch(tmdbRepositoryProvider).getPopularShows();
  return result.items;
});

final showsAiringTodayProvider = FutureProvider<List<TmdbShow>>((ref) async {
  final result = await ref.watch(tmdbRepositoryProvider).getAiringTodayShows();
  return result.items;
});

final showGenresProvider = FutureProvider<List<TmdbGenre>>((ref) async {
  return ref.watch(tmdbRepositoryProvider).getShowGenres();
});

final showsSectionProvider =
    FutureProvider.family<List<TmdbShow>, ShowSection>((
      ref,
      section,
    ) async {
      final repository = ref.watch(tmdbRepositoryProvider);
      switch (section) {
        case ShowSection.popular:
          return (await repository.getPopularShows()).items;
        case ShowSection.airingToday:
          return (await repository.getAiringTodayShows()).items;
      }
    });