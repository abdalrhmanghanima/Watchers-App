import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class GenreChip extends StatelessWidget {
  const GenreChip({super.key, required this.label, this.onImage = false});

  final String label;
  final bool onImage;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final background = onImage ? AppColors.heroChipBg : palette.accentBg;
    final foreground = onImage ? AppColors.heroChipText : palette.accentBright;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.smallLabel.copyWith(color: foreground),
      ),
    );
  }
}
