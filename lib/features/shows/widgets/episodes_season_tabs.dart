import 'package:flutter/material.dart';

import 'package:watchers/core/responsive/responsive.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_text_styles.dart';
import 'package:watchers/data/models/season.dart';

class EpisodesSeasonTabs extends StatelessWidget {
  const EpisodesSeasonTabs({
    super.key,
    required this.seasons,
    required this.activeSeason,
    required this.onSelect,
    required this.onMarkAll,
  });

  final List<Season> seasons;
  final int activeSeason;
  final ValueChanged<int> onSelect;
  final VoidCallback onMarkAll;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final sizes = context.sizes;
    return Container(
      padding: EdgeInsets.fromLTRB(
        sizes.pagePadding,
        0,
        sizes.pagePadding,
        sizes.itemGap,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: palette.border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: sizes.screenWidth - sizes.pagePadding * 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  for (var i = 0; i < seasons.length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    _pill(
                      background: seasons[i].number == activeSeason
                          ? palette.accent
                          : palette.surface2,
                      foreground: seasons[i].number == activeSeason
                          ? Colors.white
                          : palette.textSec,
                      label: 'S${seasons[i].number}',
                      onTap: () => onSelect(seasons[i].number),
                    ),
                  ],
                ],
              ),
              const SizedBox(width: 8),
              _pill(
                background: palette.accentBg,
                foreground: palette.accentBright,
                label: 'Mark All',
                onTap: onMarkAll,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pill({
    required Color background,
    required Color foreground,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: AppTextStyles.body(
            13,
            weight: FontWeight.w600,
          ).copyWith(color: foreground),
        ),
      ),
    );
  }
}
