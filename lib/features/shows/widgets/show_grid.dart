import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';
import '../../../data/models/show.dart';
import 'show_grid_cell.dart';

class ShowGrid extends StatelessWidget {
  const ShowGrid({super.key, required this.shows, this.onShowTap});

  final List<Show> shows;
  final ValueChanged<Show>? onShowTap;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sizes.pagePadding),
      child: Column(
        children: [
          for (var i = 0; i < shows.length; i += sizes.gridColumns) ...[
            if (i > 0) SizedBox(height: sizes.gridSpacing),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var slot = 0; slot < sizes.gridColumns; slot++) ...[
                  if (slot > 0) SizedBox(width: sizes.gridSpacing),
                  Expanded(
                    child: i + slot < shows.length
                        ? ShowGridCell(
                            show: shows[i + slot],
                            onTap: onShowTap == null
                                ? null
                                : () => onShowTap!(shows[i + slot]),
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
