import 'package:flutter/material.dart';

import 'package:watchers/core/constants/app_constants.dart';
import 'package:watchers/core/responsive/responsive.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_text_styles.dart';
import 'package:watchers/data/models/episode.dart';
import 'package:watchers/shared/widgets/watchers_image.dart';

class EpisodeCard extends StatelessWidget {
  const EpisodeCard({
    super.key,
    required this.episode,
    required this.backdropUrl,
    required this.watched,
    required this.onToggleWatched,
    this.onTap,
  });

  final Episode episode;
  final String backdropUrl;
  final bool watched;
  final VoidCallback onToggleWatched;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final sizes = context.sizes;
    final thumb = sizes.episodeThumb;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: sizes.pagePadding,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: palette.border)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: thumb.width,
              height: thumb.height,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: palette.surface2,
                borderRadius: BorderRadius.circular(AppConstants.radiusButton),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Opacity(
                    opacity: 0.7,
                    child: WatchersImage(imageUrl: backdropUrl),
                  ),
                  Center(
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0x99000000),
                      ),
                      child: Center(
                        child: Text(
                          '${episode.number}',
                          style: AppTextStyles.body(
                            12,
                            weight: FontWeight.w700,
                          ).copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: sizes.itemGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body(14, weight: FontWeight.w600)
                        .copyWith(
                          color: watched ? palette.textSec : palette.text,
                          height: 1.2,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${episode.duration}m · ${episode.airDate}',
                    style: AppTextStyles.captionSmall.copyWith(
                      color: palette.textSec,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    episode.synopsis,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body(12).copyWith(
                      color: palette.textSec.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: sizes.itemGap),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: InkWell(
                key: ValueKey('episode-toggle-${episode.number}'),
                onTap: onToggleWatched,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: watched ? AppColors.accent : Colors.transparent,
                    border: Border.all(
                      color: watched ? AppColors.accent : palette.borderStrong,
                      width: 1.5,
                    ),
                  ),
                  child: watched
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
