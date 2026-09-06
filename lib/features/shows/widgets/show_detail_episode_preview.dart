import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/episode.dart';
import '../../../data/models/season.dart';
import '../../../shared/widgets/episode_number_badge.dart';

class ShowDetailEpisodePreview extends StatelessWidget {
  const ShowDetailEpisodePreview({
    super.key,
    required this.season,
    this.onMoreEpisodes,
  });

  final Season season;
  final VoidCallback? onMoreEpisodes;

  static const int _previewCount = 3;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final episodes = season.episodes;
    final watched = episodes.where((e) => e.watched).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Season ${season.number}',
              style: AppTextStyles.body(
                13,
                weight: FontWeight.w600,
              ).copyWith(color: palette.text),
            ),
            Text(
              '$watched/${episodes.length} episodes',
              style: AppTextStyles.body(12).copyWith(color: palette.textSec),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: palette.surface2,
            borderRadius: BorderRadius.circular(999),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: episodes.isEmpty ? 0 : watched / episodes.length,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppGradients.progress,
                borderRadius: BorderRadius.all(Radius.circular(999)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        for (final episode in episodes.take(_previewCount))
          _EpisodeRow(episode: episode),
        if (episodes.length > _previewCount)
          InkWell(
            onTap: onMoreEpisodes,
            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  '+${episodes.length - _previewCount} more episodes',
                  style: AppTextStyles.body(
                    13,
                    weight: FontWeight.w500,
                  ).copyWith(color: palette.accent),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _EpisodeRow extends StatelessWidget {
  const _EpisodeRow({required this.episode});

  final Episode episode;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: palette.border)),
      ),
      child: Row(
        children: [
          EpisodeNumberBadge(
            number: episode.number,
            watched: episode.watched,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  episode.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body(13, weight: FontWeight.w600)
                      .copyWith(
                        color: episode.watched ? palette.textSec : palette.text,
                        height: 1.2,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${episode.duration}m',
                  style: AppTextStyles.captionSmall.copyWith(
                    color: palette.textSec,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
