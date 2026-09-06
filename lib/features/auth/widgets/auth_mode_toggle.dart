import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'auth_mode_button.dart';

class AuthModeToggle extends StatelessWidget {
  const AuthModeToggle({
    super.key,
    required this.signup,
    required this.onChanged,
  });

  final bool signup;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: palette.surface2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: AuthModeButton(
              label: 'Sign In',
              selected: !signup,
              onTap: () => onChanged(false),
            ),
          ),
          Expanded(
            child: AuthModeButton(
              label: 'Create Account',
              selected: signup,
              onTap: () => onChanged(true),
            ),
          ),
        ],
      ),
    );
  }
}
