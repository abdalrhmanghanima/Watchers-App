import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/search_result.dart';
import 'search_result_row.dart';

class SearchContent extends StatelessWidget {
  const SearchContent({super.key, required this.query, required this.results});

  final String query;
  final List<SearchResult> results;

  void _openResult(BuildContext context, SearchResult result) {
    if (result.type == ContentType.movie) {
      context.push('/movies/detail/${result.id}');
    } else {
      context.push('/shows/detail/${result.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final suffix = results.length == 1 ? '' : 's';
    return ListView(
      padding: const EdgeInsets.only(bottom: AppConstants.bottomNavOffset),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.sizes.pagePadding),
          child: Text(
            '${results.length} result$suffix for "$query"',
            style: AppTextStyles.caption.copyWith(color: palette.textSec),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.sizes.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final result in results)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SearchResultRow(
                    result: result,
                    onTap: () => _openResult(context, result),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
