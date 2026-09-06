import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';
import '../../../data/models/movie.dart';
import 'grid_cell.dart';

class MovieGrid extends StatelessWidget {
  const MovieGrid({super.key, required this.movies, this.onMovieTap});

  final List<Movie> movies;
  final ValueChanged<Movie>? onMovieTap;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sizes.pagePadding),
      child: Column(
        children: [
          for (var i = 0; i < movies.length; i += sizes.gridColumns) ...[
            if (i > 0) SizedBox(height: sizes.gridSpacing),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var slot = 0; slot < sizes.gridColumns; slot++) ...[
                  if (slot > 0) SizedBox(width: sizes.gridSpacing),
                  Expanded(
                    child: i + slot < movies.length
                        ? GridCell(
                            movie: movies[i + slot],
                            onTap: onMovieTap == null
                                ? null
                                : () => onMovieTap!(movies[i + slot]),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
