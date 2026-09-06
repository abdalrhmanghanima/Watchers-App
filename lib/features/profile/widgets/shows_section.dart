import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watchers/core/responsive/responsive.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_text_styles.dart';
import 'package:watchers/data/models/show.dart';
import 'package:watchers/shared/widgets/poster_card.dart';

import 'profile_section_title.dart';

class ShowsSection extends StatelessWidget {
  const ShowsSection({super.key, required this.shows, this.onSeeAll});

  final List<Show> shows;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    if (shows.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.sizes.pagePadding,
        context.sizes.blockGap,
        context.sizes.pagePadding,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ProfileSectionTitle(title: 'Shows'),
              InkWell(
                onTap: onSeeAll,
                child: Text(
                  'See all',
                  style: AppTextStyles.sectionAction.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 240,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 1),
              children: [
                for (final show in shows)
                  PosterCard(
                    title: show.title,
                    posterUrl: show.posterUrl,
                    year: show.year,
                    genres: show.genres,
                    progress: show.progress,
                    size: PosterCardSize.sm,
                    onTap: () => context.push('/shows/detail/${show.id}'),
                  ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
