import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/show.dart';
import '../../../../shared/widgets/watchers_image.dart';

class EpisodeShowBar extends StatelessWidget {
  const EpisodeShowBar({super.key, required this.show, this.onTap});

  final Show show;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final sizes = context.sizes;
    return Material(
      color: palette.surface2,
      borderRadius: BorderRadius.circular(AppConstants.radiusCard),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusCard),
            border: Border.all(color: palette.border),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusCover),
                child: SizedBox(
                  width: 40,
                  height: 56,
                  child: ColoredBox(
                    color: palette.surface3,
                    child: WatchersImage(imageUrl: show.posterUrl),
                  ),
                ),
              ),
              SizedBox(width: sizes.itemGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From the series',
                      style: AppTextStyles.captionSmall.copyWith(
                        color: palette.textSec,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      show.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body(
                        14,
                        weight: FontWeight.w600,
                      ).copyWith(color: palette.text, height: 1.2),
                    ),
                  ],
                ),
              ),
              SizedBox(width: sizes.itemGap),
              Icon(Icons.chevron_right, size: 18, color: palette.textSec),
            ],
          ),
        ),
      ),
    );
  }
}
