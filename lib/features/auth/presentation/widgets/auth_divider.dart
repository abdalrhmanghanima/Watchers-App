import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: WatchersPalette.of(context).border);
  }
}