import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/show.dart';
import '../../../shared/widgets/watchers_image.dart';

class ShowGridCell extends StatelessWidget {
  const ShowGridCell({super.key, required this.show, this.onTap});

  final Show show;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusCover),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusCover),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  WatchersImage(imageUrl: show.posterUrl),
                  if (show.progress != null && show.progress! > 0)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 3,
                        color: const Color(0x33FFFFFF),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: show.progress!.clamp(0.0, 1.0),
                          child: const ColoredBox(color: AppColors.accent),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            show.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body(
              11,
              weight: FontWeight.w500,
            ).copyWith(color: palette.text, height: 1.25),
          ),
        ],
      ),
    );
  }
}
