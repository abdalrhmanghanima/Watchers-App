import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/movie.dart';
import '../../../shared/widgets/watcher_back_button.dart';
import '../../../shared/widgets/watcher_status_bar.dart';
import '../../../shared/widgets/watchers_image.dart';

class MovieDetailHero extends StatelessWidget {
  const MovieDetailHero({
    super.key,
    required this.movie,
    required this.inWatchlist,
    required this.onToggleWatchlist,
  });

  final Movie movie;
  final bool inWatchlist;
  final VoidCallback onToggleWatchlist;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    return SizedBox(
      height: sizes.movieDetailHeroHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          WatchersImage(imageUrl: movie.backdropUrl),
          const DecoratedBox(
            decoration: BoxDecoration(gradient: AppGradients.detailHeroOverlay),
          ),
          const WatcherStatusBar(overlay: true),
          Positioned(
            top: sizes.pagePadding + 20,
            left: sizes.pagePadding,
            child: const WatcherBackButton(overlay: true),
          ),
          Positioned(
            top: sizes.pagePadding + 20,
            right: sizes.pagePadding,
            child: _HeroBookmarkButton(
              inWatchlist: inWatchlist,
              onPressed: onToggleWatchlist,
            ),
          ),
          Positioned(
            left: sizes.pagePadding,
            bottom: sizes.pagePadding,
            child: _PosterThumbnail(movie: movie),
          ),
          Positioned(
            left: sizes.pagePadding + sizes.detailPoster.width + 8,
            right: sizes.pagePadding,
            bottom: sizes.pagePadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: AppTextStyles.displayTitleBig(
                    22,
                  ).copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  '${movie.year} · ${movie.runtime ~/ 60}h ${movie.runtime % 60}m',
                  style: AppTextStyles.body(
                    12,
                  ).copyWith(color: Colors.white.withValues(alpha: 0.6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBookmarkButton extends StatelessWidget {
  const _HeroBookmarkButton({
    required this.inWatchlist,
    required this.onPressed,
  });

  final bool inWatchlist;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0x66000000),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: context.sizes.iconButtonSize,
          height: context.sizes.iconButtonSize,
          child: Icon(
            inWatchlist ? Icons.bookmark : Icons.bookmark_border,
            size: 18,
            color: inWatchlist ? AppColors.accent : Colors.white,
          ),
        ),
      ),
    );
  }
}

class _PosterThumbnail extends StatelessWidget {
  const _PosterThumbnail({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final poster = context.sizes.detailPoster;
    return Container(
      width: poster.width,
      height: poster.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x26FFFFFF), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: WatchersImage(imageUrl: movie.posterUrl),
      ),
    );
  }
}
