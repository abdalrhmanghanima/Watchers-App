import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/show.dart';
import '../../../shared/widgets/watcher_back_button.dart';
import '../../../shared/widgets/watcher_status_bar.dart';
import '../../../shared/widgets/watchers_image.dart';

class ShowDetailHero extends StatelessWidget {
  const ShowDetailHero({
    super.key,
    required this.show,
    required this.inWatchlist,
    required this.onToggleWatchlist,
  });

  final Show show;
  final bool inWatchlist;
  final VoidCallback onToggleWatchlist;

  @override
  Widget build(BuildContext context) {
    final statusColors = switch (show.status) {
      ShowStatus.ongoing => StatusColors.ongoing,
      ShowStatus.ended => StatusColors.ended,
      ShowStatus.upcoming => StatusColors.upcoming,
    };
    final seasonLabel = show.seasons == 1 ? 'Season' : 'Seasons';
    final sizes = context.sizes;
    return SizedBox(
      height: sizes.showDetailHeroHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          WatchersImage(imageUrl: show.backdropUrl),
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
            right: sizes.pagePadding,
            bottom: sizes.pagePadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColors.background,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    show.status.label,
                    style: AppTextStyles.badge.copyWith(
                      color: statusColors.foreground,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  show.title,
                  style: AppTextStyles.displayTitle.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${show.year} · ${show.seasons} $seasonLabel · ${show.episodes} Episodes',
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
