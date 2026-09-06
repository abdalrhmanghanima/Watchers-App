import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/movie.dart';
import '../../shared/widgets/watcher_back_button.dart';
import '../../shared/widgets/watcher_status_bar.dart';
import 'widgets/movie_grid.dart';

class MovieListArgs {
  const MovieListArgs({required this.title, required this.movies});

  final String title;
  final List<Movie> movies;
}

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key, required this.title, required this.movies});

  final String title;
  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final sizes = context.sizes;
    return Scaffold(
      backgroundColor: palette.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const WatcherStatusBar(),
            Padding(
              padding: EdgeInsets.fromLTRB(
                sizes.pagePadding,
                4,
                sizes.pagePadding,
                16,
              ),
              child: Row(
                children: [
                  const WatcherBackButton(),
                  SizedBox(width: sizes.itemGap),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.pageTitle.copyWith(
                        color: palette.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 40),
                children: [
                  const SizedBox(height: 8),
                  MovieGrid(
                    movies: movies,
                    onMovieTap: (movie) =>
                        context.push('/movies/detail/${movie.id}'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
