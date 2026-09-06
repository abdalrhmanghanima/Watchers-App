import 'package:flutter/material.dart';

import 'package:watchers/core/responsive/responsive.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_text_styles.dart';
import 'package:watchers/shared/widgets/watcher_back_button.dart';

class CommentsHeader extends StatelessWidget {
  const CommentsHeader({
    super.key,
    required this.title,
    required this.commentCount,
    required this.hideSpoilers,
    required this.onToggleSpoilers,
  });

  final String title;
  final int commentCount;
  final bool hideSpoilers;
  final VoidCallback onToggleSpoilers;

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
                  '$commentCount comments',
                  style: AppTextStyles.caption.copyWith(color: palette.textSec),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: hideSpoilers ? palette.accentBg : palette.surface2,
            shape: StadiumBorder(
              side: BorderSide(
                color: hideSpoilers ? palette.accent : palette.border,
              ),
            ),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: onToggleSpoilers,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      hideSpoilers ? Icons.close : Icons.visibility_outlined,
                      size: 12,
                      color: hideSpoilers ? palette.accent : palette.textSec,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      hideSpoilers ? 'Show All' : 'Hide Spoilers',
                      style: AppTextStyles.smallLabel.copyWith(
                        color: hideSpoilers ? palette.accent : palette.textSec,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
