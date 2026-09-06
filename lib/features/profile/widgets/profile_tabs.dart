import 'package:flutter/material.dart';
import 'package:watchers/core/responsive/responsive.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_text_styles.dart';

class ProfileTabs extends StatelessWidget {
  const ProfileTabs({
    super.key,
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<String> tabs;
  final int active;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: palette.border, width: 1)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.sizes.pagePadding,
          context.sizes.sectionGap,
          context.sizes.pagePadding,
          0,
        ),
        child: Row(
          children: [
            for (var i = 0; i < tabs.length; i++)
              Expanded(
                child: InkWell(
                  onTap: () => onChanged(i),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: i == active
                              ? palette.accent
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        tabs[i],
                        style: AppTextStyles.body(14, weight: FontWeight.w600)
                            .copyWith(
                              color: i == active
                                  ? palette.accent
                                  : palette.textSec,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
