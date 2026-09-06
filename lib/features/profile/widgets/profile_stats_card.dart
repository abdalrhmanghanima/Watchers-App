import 'package:flutter/material.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_text_styles.dart';
import 'package:watchers/core/constants/app_constants.dart';

class ProfileStatsCard extends StatelessWidget {
  const ProfileStatsCard({
    super.key,
    required this.label,
    required this.value,
    this.supportingLabel,
    this.icon,
  });

  final String label;
  final String value;
  final String? supportingLabel;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Container(
      width: 168,
      height: 116,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: palette.surface2,
        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.badge.copyWith(
                    color: palette.textSec,
                    fontSize: 12,
                  ),
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 6),
                Icon(icon, size: 16, color: palette.textSec),
              ],
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(
              height: 1,
              color: palette.textSec.withValues(alpha: 0.2),
            ),
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body(
              20,
              weight: FontWeight.w700,
            ).copyWith(color: palette.text),
          ),
          if (supportingLabel != null) ...[
            const SizedBox(height: 2),
            Text(
              supportingLabel!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body(
                11,
                weight: FontWeight.w500,
              ).copyWith(color: palette.textSec),
            ),
          ],
        ],
      ),
    );
  }
}
