import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/season.dart';

class ShowDetailSeasonSelector extends StatelessWidget {
  const ShowDetailSeasonSelector({
    super.key,
    required this.seasons,
    required this.activeSeason,
    required this.onSelect,
    this.onAllEpisodes,
  });

  final List<Season> seasons;
  final int activeSeason;
  final ValueChanged<int> onSelect;
  final VoidCallback? onAllEpisodes;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Seasons',
              style: AppTextStyles.smallLabel.copyWith(
                color: palette.textSec,
                letterSpacing: 1.2,
              ),
            ),
            if (onAllEpisodes != null)
              InkWell(
                onTap: onAllEpisodes,
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  child: Text(
                    'All Episodes',
                    style: AppTextStyles.body(
                      12,
                      weight: FontWeight.w500,
                    ).copyWith(color: palette.accent),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < seasons.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                _SeasonChip(
                  number: seasons[i].number,
                  watched: seasons[i].episodes.where((e) => e.watched).length,
                  total: seasons[i].episodes.length,
                  active: seasons[i].number == activeSeason,
                  onTap: () => onSelect(seasons[i].number),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SeasonChip extends StatelessWidget {
  const _SeasonChip({
    required this.number,
    required this.watched,
    required this.total,
    required this.active,
    required this.onTap,
  });

  final int number;
  final int watched;
  final int total;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Material(
      color: active ? palette.accent : palette.surface2,
      borderRadius: BorderRadius.circular(AppConstants.radiusRounded),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusRounded),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusRounded),
            border: Border.all(color: active ? palette.accent : palette.border),
          ),
          child: Column(
            children: [
              Text(
                'Season $number',
                style: AppTextStyles.body(
                  13,
                  weight: FontWeight.w600,
                ).copyWith(color: active ? Colors.white : palette.text),
              ),
              const SizedBox(height: 2),
              Text(
                '$watched/$total watched',
                style: AppTextStyles.captionSmall.copyWith(
                  color: active
                      ? Colors.white.withValues(alpha: 0.7)
                      : palette.textSec,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
