import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/episode.dart';
import '../../../../data/models/season.dart';
import '../../../../data/models/show.dart';
import '../../../../shared/widgets/watcher_back_button.dart';
import '../../../../shared/widgets/watcher_status_bar.dart';
import '../../../../shared/widgets/watchers_image.dart';

class EpisodeDetailHero extends StatelessWidget {
  const EpisodeDetailHero({
    super.key,
    required this.show,
    required this.season,
    required this.episode,
  });

  final Show show;
  final Season season;
  final Episode episode;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    final imageUrl = episode.imageUrl?.isNotEmpty == true
        ? episode.imageUrl
        : show.backdropUrl;
    return SizedBox(
      height: sizes.showDetailHeroHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          WatchersImage(imageUrl: imageUrl),
          const DecoratedBox(
            decoration: BoxDecoration(gradient: AppGradients.detailHeroOverlay),
          ),
          const WatcherStatusBar(overlay: true),
          Positioned(
            top: sizes.pagePadding + 20,
            left: sizes.pagePadding,
            child: const WatcherBackButton(overlay: true),
          ),
          Positioned(
            left: sizes.pagePadding,
            right: sizes.pagePadding,
            bottom: sizes.pagePadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Season ${season.number} • Episode ${episode.number}',
                  style: AppTextStyles.body(
                    12,
                    weight: FontWeight.w600,
                  ).copyWith(color: Colors.white.withValues(alpha: 0.85)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
