import 'package:flutter/material.dart';

import 'package:watchers/core/responsive/responsive.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_text_styles.dart';

class SettingsSectionLabel extends StatelessWidget {
  const SettingsSectionLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final sizes = context.sizes;
    return Padding(
      padding: EdgeInsets.fromLTRB(sizes.pagePadding, 24, sizes.pagePadding, 8),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.smallLabel.copyWith(
          color: palette.textSec,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
