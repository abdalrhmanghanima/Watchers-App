import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class SettingRow extends StatelessWidget {
  const SettingRow({
    super.key,
    required this.icon,
    required this.label,
    this.sub,
    this.right,
    this.danger = false,
    this.onTap,
  });

  final Widget icon;
  final String label;
  final String? sub;
  final Widget? right;
  final bool danger;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final labelColor = danger ? AppColors.danger : palette.text;
    final hintColor = danger ? AppColors.danger : palette.textSec;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: palette.border)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: palette.surface3,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: SizedBox(width: 16, height: 16, child: icon),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodyMedium.copyWith(color: labelColor),
                  ),
                  if (sub != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      sub!,
                      style: AppTextStyles.caption.copyWith(
                        color: palette.textSec,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (right != null)
              right!
            else
              Icon(Icons.chevron_right, size: 16, color: hintColor),
          ],
        ),
      ),
    );
  }
}
