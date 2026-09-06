import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class EpisodeWatchedCheck extends StatelessWidget {
  const EpisodeWatchedCheck({super.key, required this.watched, this.onToggle});

  final bool watched;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onToggle,
          customBorder: const CircleBorder(),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: watched ? AppColors.accent : Colors.transparent,
              border: Border.all(
                color: watched ? AppColors.accent : palette.borderStrong,
                width: 1.5,
              ),
            ),
            child: watched
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          watched ? 'Watched' : 'Not watched',
          style: AppTextStyles.body(
            12,
            weight: FontWeight.w500,
          ).copyWith(color: watched ? palette.accentBright : palette.textSec),
        ),
      ],
    );
  }
}
