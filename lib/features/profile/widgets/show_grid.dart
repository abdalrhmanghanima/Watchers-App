import 'package:flutter/material.dart';

import '../../../data/models/show.dart';
import 'profile_grid.dart';
import 'show_grid_cell.dart';

class ShowGrid extends StatelessWidget {
  const ShowGrid({super.key, required this.shows, this.onShowTap});

  final List<Show> shows;
  final ValueChanged<Show>? onShowTap;

  @override
  Widget build(BuildContext context) {
    return ProfileGrid(
      children: [
        for (final show in shows)
          ShowGridCell(
            show: show,
            onTap: onShowTap == null ? null : () => onShowTap!(show),
          ),
      ],
    );
  }
}
