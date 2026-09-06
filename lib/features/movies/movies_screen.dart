import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/movie.dart';
import '../../data/repositories/content_repository.dart';
import '../../data/sources/mock_content_repository.dart';
import 'widgets/movies_content.dart';
import 'widgets/movies_status.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key, this.repository});

  final ContentRepository? repository;

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late final ContentRepository _repository =
      widget.repository ?? MockContentRepository();
  late Future<List<Movie>> _future;
  bool? _featuredInWatchlist;

  @override
  void initState() {
    super.initState();
    _future = _repository.getMovies();
  }

  void _reload() {
    setState(() {
      _future = _repository.getMovies();
    });
  }

  void _toggleFeaturedWatchlist() {
    setState(() {
      _featuredInWatchlist = !(_featuredInWatchlist ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Scaffold(
      backgroundColor: palette.bg,
      body: FutureBuilder<List<Movie>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return MoviesStatus(
              icon: Icons.cloud_off_outlined,
              title: 'Something went wrong',
              message:
                  "We couldn't load movies. Check your connection and try again.",
              actionLabel: 'Try again',
              onAction: _reload,
            );
          }
          final movies = snapshot.data ?? const <Movie>[];
          if (movies.isEmpty) {
            return MoviesStatus(
              icon: Icons.local_movies_outlined,
              title: 'No movies yet',
              message:
                  'There are no movies to explore right now. Check back soon.',
            );
          }
          return MoviesContent(
            movies: movies,
            featuredInWatchlist: _featuredInWatchlist,
            onToggleFeaturedWatchlist: _toggleFeaturedWatchlist,
          );
        },
      ),
    );
  }
}
