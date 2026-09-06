import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/responsive/responsive.dart';
import '../../../data/models/movie.dart';
import '../../../shared/widgets/poster_card.dart';

class MovieRow extends StatelessWidget {
  const MovieRow({
    super.key,
    required this.movies,
    required this.size,
    this.onMovieTap,
  });

  final List<Movie> movies;
  final PosterCardSize size;
  final ValueChanged<Movie>? onMovieTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: context.sizes.pagePadding),
      child: Row(
        children: [
          for (var i = 0; i < movies.length; i++) ...[
            if (i > 0) const SizedBox(width: AppConstants.itemGap),
            PosterCard(
              title: movies[i].title,
              year: movies[i].year,
              posterUrl: movies[i].posterUrl,
              watched: movies[i].watched ?? false,
              size: size,
              onTap: onMovieTap == null ? null : () => onMovieTap!(movies[i]),
            ),
          ],
        ],
      ),
    );
  }
}
