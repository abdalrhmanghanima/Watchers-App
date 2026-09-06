import 'package:flutter/material.dart';

import 'package:watchers/core/constants/app_constants.dart';
import 'package:watchers/core/responsive/responsive.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_text_styles.dart';
import 'package:watchers/shared/widgets/watchers_image.dart';

class CommentsInput extends StatelessWidget {
  const CommentsInput({
    super.key,
    required this.avatarUrl,
    required this.controller,
    required this.canSend,
    required this.onChanged,
    required this.onSend,
  });

  final String avatarUrl;
  final TextEditingController controller;
  final bool canSend;
  final ValueChanged<String> onChanged;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final sizes = context.sizes;
    return Container(
      margin: EdgeInsets.fromLTRB(
        sizes.pagePadding,
        0,
        sizes.pagePadding,
        sizes.itemGap,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: palette.surface2,
        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          ClipOval(
            child: SizedBox(
              width: context.sizes.commentInputAvatar,
              height: context.sizes.commentInputAvatar,
              child: WatchersImage(imageUrl: avatarUrl),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              cursorColor: palette.accent,
              style: AppTextStyles.body(14).copyWith(color: palette.text),
              decoration: InputDecoration(
                hintText: 'Share your thoughts...',
                hintStyle: AppTextStyles.body(
                  14,
                ).copyWith(color: palette.textSec),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: canSend ? palette.accent : palette.surface3,
            borderRadius: BorderRadius.circular(AppConstants.radiusRounded),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppConstants.radiusRounded),
              onTap: canSend ? onSend : null,
              child: Opacity(
                opacity: canSend ? 1 : 0.5,
                child: const SizedBox(
                  width: 32,
                  height: 32,
                  child: Icon(Icons.send, size: 14, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
