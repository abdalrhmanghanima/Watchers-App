import 'package:flutter/material.dart';
import 'package:watchers/core/responsive/responsive.dart';
import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/app_text_styles.dart';

class ListsTab extends StatelessWidget {
  const ListsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.sizes.pagePadding,
        context.sizes.blockGap,
        context.sizes.pagePadding,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: palette.accentBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.notes_outlined, size: 24, color: palette.accent),
          ),
          const SizedBox(height: 16),
          Text(
            'Create a list',
            style: AppTextStyles.body(
              15,
              weight: FontWeight.w600,
            ).copyWith(color: palette.text),
          ),
          const SizedBox(height: 4),
          Text(
            'Organize your favorites into custom lists',
            textAlign: TextAlign.center,
            style: AppTextStyles.body(13).copyWith(color: palette.textSec),
          ),
          const SizedBox(height: 20),
          Material(
            color: palette.accent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Text(
                  'New List',
                  style: AppTextStyles.body(
                    14,
                    weight: FontWeight.w600,
                  ).copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
