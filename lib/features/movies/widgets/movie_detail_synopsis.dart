import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MovieDetailSynopsis extends StatelessWidget {
  const MovieDetailSynopsis({super.key, required this.synopsis});

  final String synopsis;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Synopsis',
          style: AppTextStyles.smallLabel.copyWith(
            color: palette.textSec,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          synopsis,
          style: AppTextStyles.bodyRegular.copyWith(
            color: palette.text,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
