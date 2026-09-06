import 'package:flutter/material.dart';

import 'package:watchers/core/responsive/responsive.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_gradients.dart';
import 'package:watchers/core/theme/app_text_styles.dart';

class EpisodesProgress extends StatelessWidget {
  const EpisodesProgress({
    super.key,
    required this.watchedCount,
    required this.total,
  });

  final int watchedCount;
  final int total;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final sizes = context.sizes;
    final percent = total == 0 ? 0 : (watchedCount / total * 100).round();
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: sizes.pagePadding,
        vertical: sizes.itemGap,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Season progress',
                style: AppTextStyles.body(
                  12,
                  weight: FontWeight.w500,
                ).copyWith(color: palette.textSec),
              ),
              Text(
                '$percent%',
                style: AppTextStyles.body(
                  12,
                  weight: FontWeight.w600,
                ).copyWith(color: palette.accent),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: palette.surface2,
              borderRadius: BorderRadius.circular(999),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: total == 0 ? 0 : watchedCount / total,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppGradients.progress,
                  borderRadius: BorderRadius.all(Radius.circular(999)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
