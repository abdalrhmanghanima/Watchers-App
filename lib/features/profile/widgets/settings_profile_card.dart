import 'package:flutter/material.dart';

import 'package:watchers/core/constants/app_constants.dart';
import 'package:watchers/core/responsive/responsive.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_text_styles.dart';
import 'package:watchers/shared/widgets/profile_avatar.dart';

import 'profile_header.dart';

class SettingsProfileCard extends StatelessWidget {
  const SettingsProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final sizes = context.sizes;
    return Padding(
      padding: EdgeInsets.fromLTRB(sizes.pagePadding, 0, sizes.pagePadding, 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: palette.surface2,
          borderRadius: BorderRadius.circular(AppConstants.radiusCard),
        ),
        child: Row(
          children: [
            ProfileAvatar(
              photoUrl: ProfileHeader.avatarUrl,
              size: sizes.settingsAvatar,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'celestialwatcher',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body(
                      16,
                      weight: FontWeight.w600,
                    ).copyWith(color: palette.text),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'celestial@example.com',
                    style: AppTextStyles.body(
                      13,
                    ).copyWith(color: palette.textSec),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: palette.accentBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Edit',
                style: AppTextStyles.body(
                  12,
                  weight: FontWeight.w600,
                ).copyWith(color: palette.accentBright),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
