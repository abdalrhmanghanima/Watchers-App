import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/movie.dart';
import '../../../shared/widgets/genre_chip.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/watcher_status_bar.dart';
import '../../../shared/widgets/watchers_image.dart';
import 'hero_add_button.dart';

class MoviesHero extends StatelessWidget {
  const MoviesHero({
    super.key,
    required this.movie,
    this.onViewDetails,
    this.onToggleWatchlist,
  });

  final Movie movie;
  final VoidCallback? onViewDetails;
  final VoidCallback? onToggleWatchlist;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    return SizedBox(
      height: sizes.moviesHeroHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          WatchersImage(imageUrl: movie.backdropUrl),
          const DecoratedBox(
            decoration: BoxDecoration(gradient: AppGradients.heroOverlay),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: WatcherStatusBar(overlay: true),
            ),
          ),
          Positioned(
            left: sizes.pagePadding,
            right: sizes.pagePadding,
            bottom: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final genre in movie.genres)
                      GenreChip(label: genre, onImage: true),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  movie.title,
                  style: AppTextStyles.displayTitleBig(sizes.heroTitleSize)
                      .copyWith(
                        color: Colors.white,
                        height: 1.0,
                        shadows: const [
                          Shadow(
                            color: Color(0x80000000),
                            offset: Offset(0, 2),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${movie.year} · ${movie.runtime ~/ 60}h ${movie.runtime % 60}m',
                  style: AppTextStyles.body(12).copyWith(
                    color: Colors.white.withValues(alpha: 0.6),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GradientButton(
                        label: 'View Details',
                        onPressed: onViewDetails,
                      ),
                    ),
                    const SizedBox(width: 8),
                    HeroAddButton(onTap: onToggleWatchlist),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
