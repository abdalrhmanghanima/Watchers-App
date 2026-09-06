import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/watcher_back_button.dart';

class ProfilePageHeader extends StatelessWidget {
  const ProfilePageHeader({super.key, required this.title});

  final String title;

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
              title,
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
