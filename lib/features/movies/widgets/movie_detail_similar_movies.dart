import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/movie.dart';
import '../../../shared/widgets/watchers_image.dart';

class MovieDetailSimilarMovies extends StatelessWidget {
  const MovieDetailSimilarMovies({
    super.key,
    required this.movies,
    this.onMovieTap,
  });

  final List<Movie> movies;
  final ValueChanged<Movie>? onMovieTap;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Similar Movies',
          style: AppTextStyles.smallLabel.copyWith(
            color: palette.textSec,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < movies.length; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                _SimilarMovieCard(
                  movie: movies[i],
                  onTap: onMovieTap == null
                      ? null
                      : () => onMovieTap!(movies[i]),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SimilarMovieCard extends StatelessWidget {
  const _SimilarMovieCard({required this.movie, this.onTap});

  final Movie movie;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final card = context.sizes.similarCard;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      child: SizedBox(
        width: card.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusCover),
              child: SizedBox(
                width: card.width,
                height: card.height,
                child: WatchersImage(imageUrl: movie.posterUrl),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body(
                11,
                weight: FontWeight.w500,
              ).copyWith(color: palette.text, height: 1.25),
            ),
          ],
        ),
      ),
    );
  }
}
