import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watchers/core/responsive/responsive.dart';
import 'package:watchers/data/models/movie.dart';
import 'package:watchers/data/models/show.dart';

import 'profile_empty_state.dart';
import 'profile_list_item.dart';
import 'profile_section_title.dart';

class WatchlistTab extends StatelessWidget {
  const WatchlistTab({super.key, required this.movies, required this.shows});

  final List<Movie> movies;
  final List<Show> shows;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty && shows.isEmpty) {
      return const ProfileEmptyState(
        title: 'Your watchlist is empty',
        message: 'Add movies and shows to track them here',
      );
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
          if (movies.isNotEmpty) ...[
            const ProfileSectionTitle(title: 'Movies'),
            for (final movie in movies)
              ProfileListItem(
                imageUrl: movie.posterUrl,
                title: movie.title,
                subtitle: '${movie.year} · ${movie.genres.first}',
                onTap: () => context.push('/movies/detail/${movie.id}'),
              ),
          ],
          if (shows.isNotEmpty) ...[
            SizedBox(height: context.sizes.sectionGap),
            const ProfileSectionTitle(title: 'Shows'),
            for (final show in shows)
              ProfileListItem(
                imageUrl: show.posterUrl,
                title: show.title,
                subtitle:
                    '${show.year} · ${show.seasons} ${show.seasons == 1 ? 'Season' : 'Seasons'}',
                onTap: () => context.push('/shows/detail/${show.id}'),
              ),
          ],
        ],
      ),
    );
  }
}
