import 'package:flutter/material.dart';

import 'package:watchers/core/responsive/responsive.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_text_styles.dart';
import 'package:watchers/shared/widgets/watcher_back_button.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final sizes = context.sizes;
    return Padding(
      padding: EdgeInsets.fromLTRB(sizes.pagePadding, 4, sizes.pagePadding, 16),
      child: Row(
        children: [
          const WatcherBackButton(),
          SizedBox(width: sizes.itemGap),
          Expanded(
            child: Text(
              'Settings',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.pageTitle.copyWith(color: palette.text),
            ),
          ),
        ],
      ),
    );
  }
}
