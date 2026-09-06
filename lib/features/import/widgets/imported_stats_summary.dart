import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/imported_stats.dart';
import '../../profile/widgets/profile_duration.dart';

class ImportedStatsSummary extends StatelessWidget {
  const ImportedStatsSummary({super.key, required this.stats});

  final ImportedUserStats stats;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.surface2,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _SummaryPill(label: 'Imported stats')),
              const SizedBox(width: 12),
              Text(
                'Ready',
                style: AppTextStyles.smallLabel.copyWith(
                  color: palette.accentBright,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _StatTile(
                  icon: Icons.live_tv_outlined,
                  label: 'Shows watched',
                  value: '${stats.showsWatched}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  icon: Icons.movie_outlined,
                  label: 'Movies watched',
                  value: '${stats.moviesWatched}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _StatTile(
                  icon: Icons.smart_display_outlined,
                  label: 'Episodes watched',
                  value: '${stats.episodesWatched}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  icon: Icons.schedule,
                  label: 'Total watch time',
                  value: formatDuration(stats.totalWatchTime.inMinutes),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: palette.border, height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              _MiniStat(label: 'Comments', value: '${stats.comments}'),
              const SizedBox(width: 8),
              _MiniStat(label: 'Ratings', value: '${stats.totalRatings}'),
              const SizedBox(width: 8),
              _MiniStat(label: 'Followed', value: '${stats.followedShows}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: palette.accentBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.download_done,
            size: 16,
            color: palette.accentBright,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.smallLabel.copyWith(color: palette.text),
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Column(
      children: [
        Icon(icon, size: 20, color: palette.accentBright),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTextStyles.captionSmall.copyWith(color: palette.textSec),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.body(20, weight: FontWeight.w700).copyWith(
            color: palette.text,
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: palette.surface3,
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall * 2),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.body(15, weight: FontWeight.w700).copyWith(
                color: palette.text,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.captionSmall.copyWith(
                color: palette.textSec,
              ),
            ),
          ],
        ),
      ),
    );
  }
}