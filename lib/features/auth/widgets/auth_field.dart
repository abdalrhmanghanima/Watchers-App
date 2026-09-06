import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboard = TextInputType.text,
    this.focusNode,
    this.nextFocus,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType keyboard;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboard,
      textInputAction: TextInputAction.next,
      onSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
      cursorColor: palette.accent,
      style: AppTextStyles.input.copyWith(color: palette.text),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.input.copyWith(color: palette.textSec),
        filled: true,
        fillColor: palette.surface2,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.borderStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.accent),
        ),
      ),
    );
  }
}
