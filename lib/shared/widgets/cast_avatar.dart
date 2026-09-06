import 'package:flutter/material.dart';

import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'watchers_image.dart';

class CastAvatar extends StatelessWidget {
  const CastAvatar({
    super.key,
    required this.name,
    required this.role,
    this.photoUrl,
    this.size,
  });

  final String name;
  final String role;
  final String? photoUrl;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final avatarSize = size ?? context.sizes.castAvatar;
    return SizedBox(
      width: avatarSize + 16,
      child: Column(
        children: [
          ClipOval(
            child: SizedBox(
              width: avatarSize,
              height: avatarSize,
              child: WatchersImage(imageUrl: photoUrl),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body(
              11,
              weight: FontWeight.w600,
            ).copyWith(color: palette.text, height: 1.15),
          ),
          const SizedBox(height: 2),
          Text(
            role,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.captionSmall.copyWith(
              color: palette.textSec,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}
