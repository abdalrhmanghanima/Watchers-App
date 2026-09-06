import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class EpisodeDetailCommentsButton extends StatelessWidget {
  const EpisodeDetailCommentsButton({
    super.key,
    this.onTap,
    this.discussionCount,
  });

  final VoidCallback? onTap;
  final int? discussionCount;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final count = discussionCount ?? 18;
    return Material(
      color: palette.surface2,
      borderRadius: BorderRadius.circular(AppConstants.radiusCard),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusCard),
            border: Border.all(color: palette.border),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: palette.accentBg,
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusRounded,
                  ),
                ),
                child: Icon(
                  Icons.chat_bubble_outline,
                  size: 18,
                  color: palette.accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comments',
                      style: AppTextStyles.body(
                        13,
                        weight: FontWeight.w600,
                      ).copyWith(color: palette.text),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$count discussions',
                      style: AppTextStyles.body(
                        11,
                      ).copyWith(color: palette.textSec),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, size: 16, color: palette.textSec),
            ],
          ),
        ),
      ),
    );
  }
}
