import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/episode.dart';
import '../../../data/models/season.dart';
import '../../../data/models/show.dart';
import '../../../shared/widgets/watchers_image.dart';

class WatchHistoryItem extends StatelessWidget {
  const WatchHistoryItem({
    super.key,
    required this.show,
    required this.season,
    required this.episode,
    required this.onToggleWatched,
    this.onTap,
  });

  final Show show;
  final Season season;
  final Episode episode;
  final VoidCallback? onToggleWatched;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final sizes = context.sizes;
    final thumb = sizes.episodeThumb;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusCover),
              child: SizedBox(
                width: thumb.width,
                height: thumb.height,
                child: ColoredBox(
                  color: palette.surface2,
                  child: WatchersImage(imageUrl: show.backdropUrl),
                ),
              ),
            ),
            SizedBox(width: sizes.itemGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    show.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body(
                      13,
                      weight: FontWeight.w600,
                    ).copyWith(color: palette.text, height: 1.2),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    episode.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body(
                      12,
                    ).copyWith(color: palette.textSec, height: 1.2),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'S${season.number} • E${episode.number}',
                    style: AppTextStyles.captionSmall.copyWith(
                      color: palette.textSec,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: sizes.itemGap),
            InkWell(
              key: ValueKey(
                'shows-toggle-${show.id}-${season.number}-${episode.number}',
              ),
              onTap: onToggleWatched,
              customBorder: const CircleBorder(),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent,
                  border: Border.all(color: AppColors.accent, width: 1.5),
                ),
                child: const Icon(Icons.check, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
