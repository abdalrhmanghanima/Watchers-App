import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SearchRecentList extends StatelessWidget {
  const SearchRecentList({
    super.key,
    required this.items,
    required this.onSelect,
    required this.onRemove,
    required this.onClear,
  });

  final List<String> items;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onRemove;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.sizes.pagePadding,
        0,
        context.sizes.pagePadding,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Recent',
                  style: AppTextStyles.body(
                    14,
                    weight: FontWeight.w600,
                  ).copyWith(color: palette.text),
                ),
              ),
              GestureDetector(
                onTap: onClear,
                child: Text(
                  'Clear',
                  style: AppTextStyles.sectionAction.copyWith(
                    color: palette.accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          for (final item in items) _buildRow(context, palette, item),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, WatchersPalette palette, String item) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: palette.border)),
      ),
      child: InkWell(
        onTap: () => onSelect(item),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(Icons.history, size: 16, color: palette.textSec),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item,
                  style: AppTextStyles.bodyRegular.copyWith(
                    color: palette.text,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => onRemove(item),
                child: Icon(Icons.close, size: 14, color: palette.textSec),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
