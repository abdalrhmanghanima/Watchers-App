import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MovieDetailActions extends StatelessWidget {
  const MovieDetailActions({
    super.key,
    required this.watched,
    required this.inWatchlist,
    required this.onToggleWatched,
    required this.onToggleWatchlist,
  });

  final bool watched;
  final bool inWatchlist;
  final VoidCallback onToggleWatched;
  final VoidCallback onToggleWatchlist;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Row(
      children: [
        Expanded(
          child: _ToggleActionButton(
            label: watched ? 'Watched' : 'Mark Watched',
            icon: watched ? Icons.check_circle : Icons.check_circle_outline,
            active: watched,
            activeBackground: palette.accent,
            activeForeground: Colors.white,
            onPressed: onToggleWatched,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ToggleActionButton(
            label: inWatchlist ? 'In Watchlist' : 'Add to Watchlist',
            icon: inWatchlist ? Icons.bookmark : Icons.bookmark_border,
            active: inWatchlist,
            activeBackground: palette.accentBg,
            activeForeground: palette.accentBright,
            onPressed: onToggleWatchlist,
          ),
        ),
      ],
    );
  }
}

class _ToggleActionButton extends StatelessWidget {
  const _ToggleActionButton({
    required this.label,
    required this.icon,
    required this.active,
    required this.activeBackground,
    required this.activeForeground,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool active;
  final Color activeBackground;
  final Color activeForeground;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final background = active ? activeBackground : Colors.transparent;
    final foreground = active ? activeForeground : palette.text;
    final borderColor = active ? palette.accent : palette.borderStrong;
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(AppConstants.radiusButton),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppConstants.radiusButton),
        child: Container(
          height: context.sizes.buttonHeight,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusButton),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: foreground),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body(
                    14,
                    weight: FontWeight.w600,
                  ).copyWith(color: foreground),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
