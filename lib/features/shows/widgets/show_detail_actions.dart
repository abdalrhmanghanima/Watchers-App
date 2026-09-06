import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_text_styles.dart';

class ShowDetailActions extends StatelessWidget {
  const ShowDetailActions({
    super.key,
    required this.inWatchlist,
    required this.onToggleWatchlist,
    this.onViewEpisodes,
  });

  final bool inWatchlist;
  final VoidCallback onToggleWatchlist;
  final VoidCallback? onViewEpisodes;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _ViewEpisodesButton(onPressed: onViewEpisodes)),
        const SizedBox(width: AppConstants.itemGap - 4),
        _WatchlistToggleButton(
          inWatchlist: inWatchlist,
          onPressed: onToggleWatchlist,
        ),
      ],
    );
  }
}

class _ViewEpisodesButton extends StatelessWidget {
  const _ViewEpisodesButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(AppConstants.radiusButton),
      child: Ink(
        height: context.sizes.buttonHeight,
        decoration: BoxDecoration(
          gradient: AppGradients.cta,
          borderRadius: BorderRadius.circular(AppConstants.radiusButton),
        ),
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.play_arrow_rounded, size: 16, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  'View Episodes',
                  style: AppTextStyles.body(
                    14,
                    weight: FontWeight.w600,
                  ).copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WatchlistToggleButton extends StatelessWidget {
  const _WatchlistToggleButton({
    required this.inWatchlist,
    required this.onPressed,
  });

  final bool inWatchlist;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Material(
      clipBehavior: Clip.antiAlias,
      color: inWatchlist ? palette.accentBg : palette.surface2,
      borderRadius: BorderRadius.circular(AppConstants.radiusButton),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: context.sizes.iconActionSize,
          height: context.sizes.iconActionSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusButton),
            border: Border.all(
              color: inWatchlist ? palette.accent : palette.borderStrong,
              width: 1.5,
            ),
          ),
          child: Icon(
            inWatchlist ? Icons.bookmark : Icons.bookmark_border,
            size: 18,
            color: inWatchlist ? palette.accent : palette.text,
          ),
        ),
      ),
    );
  }
}
