import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/episode.dart';
import '../../../../data/models/season.dart';
import '../../../../data/models/show.dart';
import '../../../../shared/widgets/gradient_button.dart';
import 'episode_description.dart';
import 'episode_detail_cast.dart';
import 'episode_detail_comments_button.dart';
import 'episode_detail_hero.dart';
import 'episode_meta_row.dart';
import 'episode_navigation_row.dart';
import 'episode_show_bar.dart';
import 'episode_watched_check.dart';

class EpisodeDetailPage extends StatelessWidget {
  const EpisodeDetailPage({
    super.key,
    required this.show,
    required this.season,
    required this.episode,
    required this.watched,
    required this.onWatch,
    required this.onToggleWatched,
    required this.onShowTap,
    required this.onComments,
    required this.hasNext,
    required this.hasPrevious,
    this.onNext,
    this.onPrevious,
  });

  final Show show;
  final Season season;
  final Episode episode;
  final bool watched;
  final VoidCallback onWatch;
  final VoidCallback onToggleWatched;
  final VoidCallback onShowTap;
  final VoidCallback onComments;
  final bool hasNext;
  final bool hasPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final sizes = context.sizes;
    final episodeCast = episode.cast.isNotEmpty ? episode.cast : show.cast;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        EpisodeDetailHero(show: show, season: season, episode: episode),
        Padding(
          padding: EdgeInsets.fromLTRB(
            sizes.pagePadding,
            sizes.itemGap,
            sizes.pagePadding,
            sizes.itemGap,
          ),
          child: EpisodeNavigationRow(
            hasPrevious: hasPrevious,
            hasNext: hasNext,
            onPrevious: onPrevious,
            onNext: onNext,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(sizes.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EpisodeWatchedCheck(watched: watched, onToggle: onToggleWatched),
              SizedBox(height: sizes.blockGap),
              Text(
                episode.title,
                style: AppTextStyles.displayTitle.copyWith(color: palette.text),
              ),
              SizedBox(height: sizes.blockGap),
              EpisodeShowBar(show: show, onTap: onShowTap),
              SizedBox(height: sizes.blockGap),
              GradientButton(
                label: 'Watch Episode',
                icon: Icons.play_arrow_rounded,
                onPressed: onWatch,
              ),
              SizedBox(height: sizes.blockGap),
              EpisodeMetaRow(
                duration: episode.duration,
                airDate: episode.airDate,
              ),
              if (episode.synopsis.isNotEmpty) ...[
                SizedBox(height: sizes.sectionGap),
                EpisodeDescription(text: episode.synopsis),
              ],
              SizedBox(height: sizes.sectionGap),
              EpisodeDetailCast(
                cast: episodeCast,
                heading: episode.cast.isNotEmpty ? 'Episode Cast' : 'Cast',
              ),
              SizedBox(height: sizes.sectionGap),
              EpisodeDetailCommentsButton(onTap: onComments),
            ],
          ),
        ),
      ],
    );
  }
}
