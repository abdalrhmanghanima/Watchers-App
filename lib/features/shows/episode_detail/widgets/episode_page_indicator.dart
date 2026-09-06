import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class EpisodePageIndicator extends StatelessWidget {
  const EpisodePageIndicator({
    super.key,
    required this.current,
    required this.total,
  });

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.chevron_left, size: 16, color: palette.textSec),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: palette.accentBg,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '${current + 1} / $total',
            style: AppTextStyles.body(
              12,
              weight: FontWeight.w600,
            ).copyWith(color: palette.accentBright),
          ),
        ),
        const SizedBox(width: 6),
        Icon(Icons.chevron_right, size: 16, color: palette.textSec),
      ],
    );
  }
}
