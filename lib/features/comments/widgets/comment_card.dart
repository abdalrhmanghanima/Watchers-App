import 'package:flutter/material.dart';

import 'package:watchers/core/constants/app_constants.dart';
import 'package:watchers/core/responsive/responsive.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_text_styles.dart';
import 'package:watchers/data/models/comment.dart';
import 'package:watchers/shared/widgets/watchers_image.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    super.key,
    required this.comment,
    required this.liked,
    required this.revealed,
    required this.onToggleLike,
    required this.onRevealSpoiler,
  });

  final Comment comment;
  final bool liked;
  final bool revealed;
  final VoidCallback onToggleLike;
  final VoidCallback onRevealSpoiler;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final sizes = context.sizes;
    return Container(
      padding: EdgeInsets.fromLTRB(
        sizes.pagePadding,
        16,
        sizes.pagePadding,
        16,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: palette.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: SizedBox(
                  width: context.sizes.commentAvatar,
                  height: context.sizes.commentAvatar,
                  child: WatchersImage(imageUrl: comment.avatar),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body(
                        13,
                        weight: FontWeight.w600,
                      ).copyWith(color: palette.text),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      comment.time,
                      style: AppTextStyles.body(
                        11,
                      ).copyWith(color: palette.textSec),
                    ),
                  ],
                ),
              ),
              if (comment.spoiler) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.spoilerBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'SPOILER',
                    style: AppTextStyles.badge.copyWith(
                      letterSpacing: 0.5,
                      color: AppColors.spoilerText,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          if (comment.spoiler && !revealed)
            _SpoilerReveal(onTap: onRevealSpoiler)
          else
            Text(
              comment.text,
              style: AppTextStyles.bodyRegular.copyWith(
                color: palette.text,
                height: 1.45,
              ),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              InkWell(
                onTap: onToggleLike,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        liked ? Icons.thumb_up : Icons.thumb_up_outlined,
                        size: 16,
                        color: liked ? palette.accent : palette.textSec,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${comment.likes + (liked ? 1 : 0)}',
                        style: AppTextStyles.body(12).copyWith(
                          color: liked ? palette.accent : palette.textSec,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 16),
                      SizedBox(width: 6),
                      Text('Reply'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpoilerReveal extends StatelessWidget {
  const _SpoilerReveal({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusRounded),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: palette.surface2,
          borderRadius: BorderRadius.circular(AppConstants.radiusRounded),
        ),
        child: Row(
          children: [
            Icon(Icons.visibility_outlined, size: 16, color: palette.textSec),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Contains spoilers · Tap to reveal',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body(13).copyWith(color: palette.textSec),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
