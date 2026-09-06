import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_text_styles.dart';
import 'watchers_image.dart';

enum PosterCardSize { sm, md, lg }

class PosterCard extends StatelessWidget {
  const PosterCard({
    super.key,
    required this.title,
    required this.posterUrl,
    this.year,
    this.genres,
    this.progress,
    this.unwatched,
    this.watched = false,
    this.size = PosterCardSize.md,
    this.onTap,
  });

  final String title;
  final String posterUrl;
  final int? year;
  final List<String>? genres;
  final double? progress;
  final int? unwatched;
  final bool watched;
  final PosterCardSize size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final sizes = context.sizes;
    final (width, height, titleSize) = switch (size) {
      PosterCardSize.sm => (sizes.posterSm.width, sizes.posterSm.height, 11.0),
      PosterCardSize.md => (sizes.posterMd.width, sizes.posterMd.height, 12.0),
      PosterCardSize.lg => (sizes.posterLg.width, sizes.posterLg.height, 13.0),
    };
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width,
              height: height,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusPoster),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    WatchersImage(imageUrl: posterUrl),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: AppGradients.posterOverlay,
                      ),
                    ),
                    if (watched)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      )
                    else if (unwatched != null && unwatched! > 0)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 20),
                          height: 20,
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.all(
                              Radius.circular(AppConstants.radiusLarge),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$unwatched',
                              style: AppTextStyles.badge.copyWith(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (progress != null && progress! > 0)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 3,
                          color: const Color(0x33FFFFFF),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: progress!.clamp(0.0, 1.0),
                            child: const ColoredBox(color: AppColors.accent),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body(
                  titleSize,
                  weight: FontWeight.w600,
                ).copyWith(color: palette.text, height: 1.25),
              ),
            ),
            if (year != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '$year',
                  style: AppTextStyles.captionSmall.copyWith(
                    color: palette.textSec,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
