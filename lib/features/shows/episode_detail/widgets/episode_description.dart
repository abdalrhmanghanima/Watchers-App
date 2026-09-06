import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class EpisodeDescription extends StatelessWidget {
  const EpisodeDescription({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About this episode',
          style: AppTextStyles.smallLabel.copyWith(
            color: palette.textSec,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: AppTextStyles.bodyRegular.copyWith(
            color: palette.text,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
