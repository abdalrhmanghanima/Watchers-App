import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../features/tmdb/presentation/providers/movie_ui_providers.dart';
import 'widgets/movies_content.dart';
import 'widgets/movies_status.dart';

class MoviesScreen extends ConsumerStatefulWidget {
  const MoviesScreen({super.key});

  @override
  ConsumerState<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends ConsumerState<MoviesScreen> {
  bool? _featuredInWatchlist;

  void _toggleFeaturedWatchlist() {
    setState(() {
      _featuredInWatchlist = !(_featuredInWatchlist ?? false);
    });
  }

  void _reload() {
    ref.invalidate(moviesScreenProvider);
  }

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final data = ref.watch(moviesScreenProvider);
    return Scaffold(
      backgroundColor: palette.bg,
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => MoviesStatus(
          icon: Icons.cloud_off_outlined,
          title: 'Something went wrong',
          message:
              "We couldn't load movies. Check your connection and try again.",
          actionLabel: 'Try again',
          onAction: _reload,
        ),
        data: (value) {
          final featured = value.featured;
          if (featured == null &&
              value.nowPlaying.isEmpty &&
              value.popular.isEmpty &&
              value.topRated.isEmpty) {
            return MoviesStatus(
              icon: Icons.local_movies_outlined,
              title: 'No movies yet',
              message:
                  'There are no movies to explore right now. Check back soon.',
            );
          }
          return MoviesContent(
            featured: featured,
            nowPlaying: value.nowPlaying,
            popular: value.popular,
            topRated: value.topRated,
            genres: value.genres,
            featuredInWatchlist: _featuredInWatchlist,
            onToggleFeaturedWatchlist: _toggleFeaturedWatchlist,
          );
        },
      ),
    );
  }
}
