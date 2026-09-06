import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.showClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final bool showClear;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Container(
      height: context.sizes.searchFieldHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: palette.surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 18, color: palette.textSec),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              cursorColor: palette.accent,
              style: AppTextStyles.input.copyWith(color: palette.text),
              decoration: InputDecoration(
                hintText: 'Movies, shows, genres...',
                hintStyle: AppTextStyles.input.copyWith(color: palette.textSec),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (showClear) ...[
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onClear,
              child: Icon(Icons.close, size: 16, color: palette.textSec),
            ),
          ],
        ],
      ),
    );
  }
}
