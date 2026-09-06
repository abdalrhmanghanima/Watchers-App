import 'package:flutter/material.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_text_styles.dart';

class ProfileEmptyState extends StatelessWidget {
  const ProfileEmptyState({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.body(
              15,
              weight: FontWeight.w500,
            ).copyWith(color: palette.textSec),
          ),
          const SizedBox(height: 4),
          Opacity(
            opacity: 0.6,
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body(13).copyWith(color: palette.textSec),
            ),
          ),
        ],
      ),
    );
  }
}
