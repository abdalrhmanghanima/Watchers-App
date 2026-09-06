import 'package:flutter/material.dart';

import 'package:watchers/core/responsive/responsive.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_text_styles.dart';
import 'package:watchers/shared/widgets/gradient_button.dart';

class CommentStatus extends StatelessWidget {
  const CommentStatus({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: context.sizes.statusIcon,
              height: context.sizes.statusIcon,
              decoration: BoxDecoration(
                color: palette.accentBg,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, size: 30, color: palette.accentBright),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.title.copyWith(color: palette.text),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: palette.textSec,
                height: 1.45,
              ),
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                child: GradientButton(label: actionLabel!, onPressed: onAction),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
