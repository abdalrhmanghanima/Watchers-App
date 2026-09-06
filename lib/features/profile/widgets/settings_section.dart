import 'package:flutter/material.dart';

import 'package:watchers/core/theme/app_colors.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return ColoredBox(
      color: palette.surface,
      child: Column(children: children),
    );
  }
}
