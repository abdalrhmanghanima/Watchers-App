import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_text_styles.dart';

class _NavItem {
  const _NavItem(this.label, this.inactiveIcon, this.activeIcon);

  final String label;
  final IconData inactiveIcon;
  final IconData activeIcon;
}

const _items = <_NavItem>[
  _NavItem('SHOWS', Icons.tv_outlined, Icons.tv),
  _NavItem('MOVIES', Icons.movie_outlined, Icons.movie),
  _NavItem('SEARCH', Icons.search, Icons.search),
  _NavItem('PROFILE', Icons.person_outline, Icons.person),
];

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onSelect,
  });

  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppGradients.bottomNav(dark: dark),
        border: Border(top: BorderSide(color: palette.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: _NavItemButton(
                    item: _items[i],
                    active: currentIndex == i,
                    color: currentIndex == i ? palette.accent : palette.text,
                    onTap: () => onSelect(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItemButton extends StatelessWidget {
  const _NavItemButton({
    required this.item,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final _NavItem item;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: active ? 1 : 0.45,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              active ? item.activeIcon : item.inactiveIcon,
              size: 24,
              color: color,
            ),
            const SizedBox(height: 3),
            Text(
              item.label,
              style: AppTextStyles.tabLabel.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
