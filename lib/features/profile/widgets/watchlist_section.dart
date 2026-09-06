import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watchers/core/responsive/responsive.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_text_styles.dart';
import 'package:watchers/data/models/movie.dart';
import 'package:watchers/data/models/show.dart';
import 'package:watchers/shared/widgets/poster_card.dart';

import 'profile_section_title.dart';

class WatchlistSection extends StatelessWidget {
  const WatchlistSection({
    super.key,
    required this.movies,
    required this.shows,
    this.onSeeAll,
  });

  final List<Movie> movies;
  final List<Show> shows;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty && shows.isEmpty) {
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
              const ProfileSectionTitle(title: 'Watchlist'),
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
                for (final movie in movies)
                  PosterCard(
                    title: movie.title,
                    posterUrl: movie.posterUrl,
                    year: movie.year,
                    genres: movie.genres,
                    size: PosterCardSize.sm,
                    onTap: () => context.push('/movies/detail/${movie.id}'),
                  ),
                for (final show in shows)
                  PosterCard(
                    title: show.title,
                    posterUrl: show.posterUrl,
                    year: show.year,
                    genres: show.genres,
                    progress: show.progress,
                    unwatched: show.unwatchedEpisodes,
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
