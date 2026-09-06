import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ShowsHeader extends StatelessWidget {
  const ShowsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.sizes.pagePadding,
        4,
        context.sizes.pagePadding,
        12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good evening',
                  style: AppTextStyles.body(12, weight: FontWeight.w500)
                      .copyWith(
                        color: palette.textSec,
                        letterSpacing: 1.4,
                        height: 1.2,
                      ),
                ),
                Text(
                  'Shows',
                  style: AppTextStyles.displayTitle.copyWith(
                    color: palette.text,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: context.sizes.iconButtonSize,
            height: context.sizes.iconButtonSize,
            decoration: BoxDecoration(
              color: palette.surface2,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.headphones_outlined,
              size: 18,
              color: palette.textSec,
            ),
          ),
        ],
      ),
    );
  }
}
