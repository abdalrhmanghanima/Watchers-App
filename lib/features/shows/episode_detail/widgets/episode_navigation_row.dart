import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class EpisodeNavigationRow extends StatelessWidget {
  const EpisodeNavigationRow({
    super.key,
    required this.hasPrevious,
    required this.hasNext,
    required this.onPrevious,
    required this.onNext,
  });

  final bool hasPrevious;
  final bool hasNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _NavButton(
          icon: Icons.arrow_back_ios_new,
          label: 'Previous',
          enabled: hasPrevious,
          onPressed: onPrevious,
        ),
        _NavButton(
          icon: Icons.arrow_forward_ios,
          label: 'Next',
          enabled: hasNext,
          onPressed: onNext,
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final color = enabled
        ? palette.text
        : palette.textSec.withValues(alpha: 0.4);
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.body(
                  13,
                  weight: FontWeight.w600,
                ).copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
