import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'category_tile.dart';

const List<(String, Color, String)> _categories = [
  (
    'Drama',
    Color(0xFF4C1D95),
    'https://images.unsplash.com/photo-1787878025205-99b327b6a85b?w=200&h=120&fit=crop&auto=format',
  ),
  (
    'Sci-Fi',
    Color(0xFF1E3A5F),
    'https://images.unsplash.com/photo-1614201842267-206a09286c3b?w=200&h=120&fit=crop&auto=format',
  ),
  (
    'Thriller',
    Color(0xFF3B1515),
    'https://images.unsplash.com/photo-1462715412043-8d09205be605?w=200&h=120&fit=crop&auto=format',
  ),
  (
    'Crime',
    Color(0xFF1A1A1A),
    'https://images.unsplash.com/photo-1453396450673-3fe83d2db2c4?w=200&h=120&fit=crop&auto=format',
  ),
  (
    'Mystery',
    Color(0xFF1C3035),
    'https://images.unsplash.com/photo-1778710878550-04ef905c163a?w=200&h=120&fit=crop&auto=format',
  ),
  (
    'Action',
    Color(0xFF3D1A00),
    'https://images.unsplash.com/photo-1678918549313-cbaf32e5a1c5?w=200&h=120&fit=crop&auto=format',
  ),
  (
    'Horror',
    Color(0xFF1F0015),
    'https://images.unsplash.com/photo-1778585040075-0991abfd4ed9?w=200&h=120&fit=crop&auto=format',
  ),
  (
    'Romance',
    Color(0xFF2D0A2D),
    'https://images.unsplash.com/photo-1776275459073-25a6b864c483?w=200&h=120&fit=crop&auto=format',
  ),
];

class BrowseCategories extends StatelessWidget {
  const BrowseCategories({super.key, required this.onCategoryTap});

  final ValueChanged<String> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final sizes = context.sizes;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sizes.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Browse Categories',
            style: AppTextStyles.body(
              14,
              weight: FontWeight.w600,
            ).copyWith(color: palette.text),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: sizes.browseGenreColumns,
              crossAxisSpacing: sizes.browseGenreSpacing,
              mainAxisSpacing: sizes.browseGenreSpacing,
              mainAxisExtent: 72,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return CategoryTile(
                label: category.$1,
                color: category.$2,
                imageUrl: category.$3,
                onTap: () => onCategoryTap(category.$1),
              );
            },
          ),
        ],
      ),
    );
  }
}
