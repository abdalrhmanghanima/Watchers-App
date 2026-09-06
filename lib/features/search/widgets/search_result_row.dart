import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/search_result.dart';
import '../../../shared/widgets/genre_chip.dart';
import '../../../shared/widgets/watchers_image.dart';

class SearchResultRow extends StatelessWidget {
  const SearchResultRow({super.key, required this.result, this.onTap});

  final SearchResult result;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: context.sizes.rowThumb.width,
              height: context.sizes.rowThumb.height,
              child: WatchersImage(imageUrl: result.posterUrl),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyRegular.copyWith(
                    color: palette.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${result.year} · ${result.type == ContentType.movie ? 'Movie' : 'Show'}',
                  style: AppTextStyles.caption.copyWith(color: palette.textSec),
                ),
                if (result.genres.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    children: [
                      for (final genre in result.genres.take(2))
                        GenreChip(label: genre),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.chevron_right, size: 16, color: palette.textSec),
        ],
      ),
    );
  }
}
