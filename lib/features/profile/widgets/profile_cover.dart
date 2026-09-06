import 'package:flutter/material.dart';

import 'package:watchers/core/theme/app_gradients.dart';
import 'package:watchers/core/theme/app_text_styles.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/responsive/responsive.dart';
import 'package:watchers/shared/widgets/watchers_image.dart';
import 'package:watchers/shared/widgets/profile_avatar.dart';

class ProfileCover extends StatelessWidget {
  const ProfileCover({super.key, this.onSettings});

  final VoidCallback? onSettings;

  static const String coverImageUrl =
      'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=800&h=300&fit=crop&auto=format';

  static const String avatarUrl =
      'https://images.unsplash.com/photo-1525547843489-d0aab95e5ce1?w=144&h=144&fit=crop&auto=format';

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final sizes = context.sizes;
    final coverHeight = sizes.screenWidth * 0.38;
    final avatarSize = sizes.profileAvatar;
    return SizedBox(
      width: double.infinity,
      height: coverHeight + avatarSize / 2,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: coverHeight,
            child: Container(
              decoration: BoxDecoration(gradient: AppGradients.heroOverlay),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: WatchersImage(
                      imageUrl: coverImageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          palette.bg.withValues(alpha: 0.7),
                          palette.bg,
                        ],
                        stops: const [0.0, 0.4, 0.7, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: coverHeight - avatarSize / 2,
            left: context.sizes.pagePadding,
            child: ProfileAvatar(
              photoUrl: avatarUrl,
              showEditBadge: false,
              onEdit: onSettings,
              size: avatarSize,
            ),
          ),
          Positioned(
            top: coverHeight - 12,
            left: context.sizes.pagePadding + avatarSize + 16,
            child: Text(
              'celestialwatcher',
              style: AppTextStyles.body(
                18,
                weight: FontWeight.w600,
              ).copyWith(color: palette.text),
            ),
          ),
          Positioned(
            top: 16,
            right: context.sizes.pagePadding,
            child: Material(
              color: palette.surface2,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onSettings,
                customBorder: const CircleBorder(),
                child: SizedBox(
                  width: context.sizes.iconButtonSize,
                  height: context.sizes.iconButtonSize,
                  child: Icon(
                    Icons.settings_outlined,
                    size: 18,
                    color: palette.textSec,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
