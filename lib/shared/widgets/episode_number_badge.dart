import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class EpisodeNumberBadge extends StatelessWidget {
  const EpisodeNumberBadge({
    super.key,
    required this.number,
    this.watched = false,
    this.size = 22,
    this.onImage = false,
  });

  final int number;
  final bool watched;
  final double size;
  final bool onImage;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final background = watched
        ? AppColors.accent
        : onImage
        ? const Color(0x99000000)
        : palette.surface3;
    return Container(
      constraints: BoxConstraints(minWidth: size),
      height: size,
      padding: EdgeInsets.symmetric(horizontal: size * 0.3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Center(
        child: watched
            ? Icon(Icons.check, size: size * 0.55, color: Colors.white)
            : Text(
                '$number',
                style: AppTextStyles.badge.copyWith(
                  color: onImage ? Colors.white : palette.text,
                  fontSize: size * 0.5,
                ),
              ),
      ),
    );
  }
}
