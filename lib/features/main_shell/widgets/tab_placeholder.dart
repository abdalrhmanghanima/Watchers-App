import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TemporaryTabPlaceholder extends StatelessWidget {
  const TemporaryTabPlaceholder({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Scaffold(
      body: Center(
        child: Text(
          title,
          style: AppTextStyles.pageTitle.copyWith(color: palette.text),
        ),
      ),
    );
  }
}
