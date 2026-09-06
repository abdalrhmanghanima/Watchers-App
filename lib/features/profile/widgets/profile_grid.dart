import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';

class ProfileGrid extends StatelessWidget {
  const ProfileGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sizes.pagePadding),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i += sizes.gridColumns) ...[
            if (i > 0) SizedBox(height: sizes.gridSpacing),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var slot = 0; slot < sizes.gridColumns; slot++) ...[
                  if (slot > 0) SizedBox(width: sizes.gridSpacing),
                  Expanded(
                    child: i + slot < children.length
                        ? children[i + slot]
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
