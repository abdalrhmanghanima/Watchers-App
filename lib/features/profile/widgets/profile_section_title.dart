import 'package:flutter/material.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_text_styles.dart';

class ProfileSectionTitle extends StatelessWidget {
  const ProfileSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: AppTextStyles.body(
          13,
          weight: FontWeight.w600,
        ).copyWith(color: palette.textSec, letterSpacing: 1.0),
      ),
    );
  }
}
