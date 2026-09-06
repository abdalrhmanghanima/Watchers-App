import 'package:flutter/material.dart';

import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import 'watchers_image.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.photoUrl,
    this.size,
    this.showEditBadge = false,
    this.onEdit,
  });

  final String? photoUrl;
  final double? size;
  final bool showEditBadge;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final avatarSize = size ?? context.sizes.profileAvatar;
    final avatar = ClipOval(
      child: SizedBox(
        width: avatarSize,
        height: avatarSize,
        child: Stack(
          fit: StackFit.expand,
          children: [
            WatchersImage(imageUrl: photoUrl),
            if (photoUrl == null || photoUrl!.isEmpty)
              Icon(Icons.person, color: palette.textSec),
          ],
        ),
      ),
    );
    final circle = Container(
      width: avatarSize,
      height: avatarSize,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: palette.surface2,
        border: Border.all(color: palette.accent, width: 2),
      ),
      child: avatar,
    );
    if (!showEditBadge) return circle;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        circle,
        Positioned(
          right: -2,
          bottom: -2,
          child: GestureDetector(
            onTap: onEdit,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: palette.accent,
                shape: BoxShape.circle,
                border: Border.all(color: palette.bg, width: 2),
              ),
              child: const Icon(Icons.add, size: 9, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
