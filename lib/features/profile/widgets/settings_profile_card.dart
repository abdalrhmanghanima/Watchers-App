import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:watchers/core/constants/app_constants.dart';
import 'package:watchers/core/responsive/responsive.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_text_styles.dart';
import 'package:watchers/features/auth/presentation/providers/auth_controller.dart';
import 'package:watchers/shared/widgets/profile_avatar.dart';

import '../presentation/providers/profile_controller.dart';

class SettingsProfileCard extends ConsumerWidget {
  const SettingsProfileCard({super.key, this.onEdit});

  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = WatchersPalette.of(context);
    final sizes = context.sizes;
    final profile = ref.watch(profileControllerProvider).value;
    final authUser = ref.watch(authControllerProvider).value;
    final displayName = profile?.displayName ?? authUser?.displayName ?? 'Watcher';
    final email = profile?.email ?? authUser?.email;
    final photoUrl = profile?.photoUrl ?? authUser?.photoUrl;
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
              photoUrl: photoUrl,
              size: sizes.settingsAvatar,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body(
                      16,
                      weight: FontWeight.w600,
                    ).copyWith(color: palette.text),
                  ),
                  const SizedBox(height: 2),
                  if (email != null && email.isNotEmpty)
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body(
                        13,
                      ).copyWith(color: palette.textSec),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onEdit,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
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
            ),
          ],
        ),
      ),
    );
  }
}