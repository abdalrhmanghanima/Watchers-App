import 'package:flutter/material.dart';

import 'package:watchers/core/responsive/responsive.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_text_styles.dart';
import 'package:watchers/shared/widgets/watcher_back_button.dart';

class EpisodesHeader extends StatelessWidget {
  const EpisodesHeader({
    super.key,
    required this.title,
    required this.seasonNumber,
    required this.watchedCount,
    required this.total,
  });

  final String title;
  final int seasonNumber;
  final int watchedCount;
  final int total;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final sizes = context.sizes;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        sizes.pagePadding,
        4,
        sizes.pagePadding,
        sizes.itemGap,
      ),
      child: Row(
        children: [
          const WatcherBackButton(),
          SizedBox(width: sizes.itemGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title.copyWith(color: palette.text),
                ),
                const SizedBox(height: 2),
                Text(
                  'Season $seasonNumber · $watchedCount/$total watched',
                  style: AppTextStyles.caption.copyWith(color: palette.textSec),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
