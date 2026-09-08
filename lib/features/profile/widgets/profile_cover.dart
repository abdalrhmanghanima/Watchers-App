import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/providers/auth_controller.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/responsive/responsive.dart';
import '../../../shared/widgets/watchers_image.dart';
import '../../../shared/widgets/profile_avatar.dart';
import '../domain/enums/profile_image_type.dart';
import '../presentation/providers/profile_controller.dart';

import 'photo_source_sheet.dart';

class ProfileCover extends ConsumerWidget {
  const ProfileCover({super.key, this.onSettings});

  final VoidCallback? onSettings;

  Future<void> _changePhoto(
    BuildContext context,
    WidgetRef ref,
    ProfileImageType type,
  ) async {
    final source = await showPhotoSourceSheet(context);
    if (source == null || !context.mounted) return;
    final controller = ref.read(profileControllerProvider.notifier);
    if (type == ProfileImageType.profilePhoto) {
      await controller.updateProfilePhoto(source);
    } else {
      await controller.updateCoverPhoto(source);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = WatchersPalette.of(context);
    final sizes = context.sizes;
    final coverHeight = sizes.screenWidth * 0.38;
    final avatarSize = sizes.profileAvatar;

    ref.listen<String?>(profileErrorProvider, (_, message) {
      if (message == null) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    });

    final authUser = ref.watch(authControllerProvider).value;
    final profile = ref.watch(profileControllerProvider).value;
    final busy = ref.watch(profileBusyProvider);

    final displayName = profile?.displayName ?? authUser?.displayName ?? 'Watcher';
    final email = profile?.email ?? authUser?.email;
    final photoUrl = profile?.photoUrl ?? authUser?.photoUrl;
    final coverUrl = profile?.coverUrl;

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
            child: GestureDetector(
              onTap: busy
                  ? null
                  : () =>
                        _changePhoto(context, ref, ProfileImageType.coverPhoto),
              child: Container(
                decoration: BoxDecoration(gradient: AppGradients.heroOverlay),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (coverUrl != null && coverUrl.isNotEmpty)
                      WatchersImage(imageUrl: coverUrl, fit: BoxFit.cover),
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
                    if (busy)
                      ColoredBox(
                        color: Colors.black.withValues(alpha: 0.35),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: coverHeight - avatarSize / 2,
            left: context.sizes.pagePadding,
            child: GestureDetector(
              onTap: busy
                  ? null
                  : () => _changePhoto(
                      context,
                      ref,
                      ProfileImageType.profilePhoto,
                    ),
              child: ProfileAvatar(
                photoUrl: photoUrl,
                showEditBadge: false,
                size: avatarSize,
              ),
            ),
          ),
          Positioned(
            top: coverHeight - 12,
            left: context.sizes.pagePadding + avatarSize + 16,
            right: context.sizes.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body(
                    18,
                    weight: FontWeight.w600,
                  ).copyWith(color: palette.text),
                ),
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