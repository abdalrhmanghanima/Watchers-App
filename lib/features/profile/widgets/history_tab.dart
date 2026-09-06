import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watchers/core/responsive/responsive.dart';
import 'package:watchers/data/models/movie.dart';

import 'profile_empty_state.dart';
import 'profile_list_item.dart';
import 'profile_section_title.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key, required this.movies});

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const ProfileEmptyState(
        title: 'No history yet',
        message: 'Start watching to build your history',
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
          const ProfileSectionTitle(title: 'Recently Watched'),
          for (final movie in movies)
            ProfileListItem(
              imageUrl: movie.posterUrl,
              title: movie.title,
              subtitle: 'Watched 3 days ago',
              showChevron: false,
              showCheck: true,
              onTap: () => context.push('/movies/detail/${movie.id}'),
            ),
        ],
      ),
    );
  }
}
