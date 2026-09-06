import 'package:flutter/material.dart';
import 'package:watchers/core/responsive/responsive.dart';
import 'package:watchers/data/models/comment.dart';
import 'package:watchers/data/models/movie.dart';
import 'package:watchers/data/models/show.dart';
import 'package:watchers/features/profile/widgets/profile_duration.dart';
import 'package:watchers/features/profile/widgets/profile_section_title.dart';
import 'package:watchers/features/profile/widgets/profile_stats_card.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({
    super.key,
    required this.movies,
    required this.shows,
    required this.comments,
  });

  final List<Movie> movies;
  final List<Show> shows;
  final List<Comment> comments;

  @override
  Widget build(BuildContext context) {
    final watchedMovies = movies.where((m) => m.watched == true).length;
    final watchedShows = shows.where((s) => (s.progress ?? 0) > 0).length;
    final moviesTime = calculateMoviesTimeWasted(movies);
    final showsTime = calculateShowsTimeWasted(shows);

    final cards = [
      ProfileStatsCard(
        label: 'TV Shows',
        value: '$watchedShows',
        icon: Icons.tv,
      ),
      ProfileStatsCard(
        label: 'Episodes Time',
        value: formatDuration(showsTime),
        icon: Icons.timer_outlined,
      ),
      ProfileStatsCard(
        label: 'Movies',
        value: '$watchedMovies',
        icon: Icons.movie,
      ),
      ProfileStatsCard(
        label: 'Movies Time',
        value: formatDuration(moviesTime),
        icon: Icons.schedule,
      ),
      ProfileStatsCard(
        label: 'Comments',
        value: '${comments.length}',
        icon: Icons.chat_bubble_outline,
      ),
    ];

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
          const ProfileSectionTitle(title: 'Stats'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final card in cards) ...[card, const SizedBox(width: 12)],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
