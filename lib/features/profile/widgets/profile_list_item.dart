import 'package:flutter/material.dart';
import 'package:watchers/core/responsive/responsive.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_text_styles.dart';
import 'package:watchers/shared/widgets/watchers_image.dart';

class ProfileListItem extends StatelessWidget {
  const ProfileListItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.showChevron = true,
    this.showCheck = false,
    this.onTap,
  });

  final String imageUrl;
  final String title;
  final String subtitle;
  final bool showChevron;
  final bool showCheck;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final thumb = context.sizes.listThumb;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: thumb.width,
              height: thumb.height,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    WatchersImage(imageUrl: imageUrl),
                    if (showCheck)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.accent,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 8,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body(
                      14,
                      weight: FontWeight.w600,
                    ).copyWith(color: palette.text),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body(
                      12,
                    ).copyWith(color: palette.textSec),
                  ),
                ],
              ),
            ),
            if (showChevron)
              Icon(Icons.chevron_right, size: 16, color: palette.textSec),
          ],
        ),
      ),
    );
  }
}
