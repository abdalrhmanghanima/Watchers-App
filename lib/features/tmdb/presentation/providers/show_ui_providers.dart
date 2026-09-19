import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/show.dart';
import '../adapters/tmdb_content_adapters.dart';
import 'show_catalog_providers.dart';

final showsPopularProviderAdapter = FutureProvider<List<Show>>((ref) async {
  final tmdb = await ref.watch(showsPopularProvider.future);
  final genres = await ref.watch(showGenresProvider.future);
  return tmdb
      .map((show) => tmdbShowToShow(show, genres: genres))
      .toList();
});

final showsAiringTodayProviderAdapter =
    FutureProvider<List<Show>>((ref) async {
  final tmdb = await ref.watch(showsAiringTodayProvider.future);
  final genres = await ref.watch(showGenresProvider.future);
  return tmdb
      .map((show) => tmdbShowToShow(show, genres: genres))
      .toList();
});
