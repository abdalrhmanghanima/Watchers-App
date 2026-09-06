import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/watchers_image.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.label,
    required this.color,
    required this.imageUrl,
    required this.onTap,
  });

  final String label;
  final Color color;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: color),
            Opacity(opacity: 0.3, child: WatchersImage(imageUrl: imageUrl)),
            Container(color: Colors.black.withValues(alpha: 0.3)),
            Positioned(
              left: 12,
              bottom: 12,
              child: Text(
                label,
                style: AppTextStyles.body(
                  14,
                  weight: FontWeight.bold,
                ).copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
