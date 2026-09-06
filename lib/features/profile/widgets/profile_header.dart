import 'package:flutter/material.dart';
import 'package:watchers/core/responsive/responsive.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_gradients.dart';
import 'package:watchers/core/theme/app_text_styles.dart';
import 'package:watchers/shared/widgets/profile_avatar.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, this.onSettings});

  static const String avatarUrl =
      'https://images.unsplash.com/photo-1525547843489-d0aab95e5ce1?w=144&h=144&fit=crop&auto=format';

  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.sizes.pagePadding,
        8,
        context.sizes.pagePadding,
        context.sizes.sectionGap,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Profile',
                  style: AppTextStyles.displayTitle.copyWith(
                    color: palette.text,
                  ),
                ),
              ),
              Material(
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
            ],
          ),
          SizedBox(height: context.sizes.sectionGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileAvatar(
                photoUrl: avatarUrl,
                showEditBadge: true,
                onEdit: onSettings,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'celestialwatcher',
                      style: AppTextStyles.body(
                        18,
                        weight: FontWeight.w600,
                      ).copyWith(color: palette.text),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Member since Jan 2024',
                      style: AppTextStyles.body(
                        13,
                      ).copyWith(color: palette.textSec),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppGradients.cinephile,
                          ),
                          child: const Icon(
                            Icons.star,
                            size: 8,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Cinephile',
                          style: AppTextStyles.body(
                            11,
                            weight: FontWeight.w600,
                          ).copyWith(color: palette.accentBright),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
