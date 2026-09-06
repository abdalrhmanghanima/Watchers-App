import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class WatcherStatusBar extends StatelessWidget {
  const WatcherStatusBar({super.key, this.overlay = false});

  final bool overlay;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final color = overlay ? Colors.white : palette.text;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
      child: Row(
        children: [
          Text(
            '9:41',
            style: AppTextStyles.body(
              13,
              weight: FontWeight.w600,
            ).copyWith(color: color),
          ),
          const Spacer(),
          _SignalBars(color: color),
          const SizedBox(width: 6),
          Icon(Icons.wifi, size: 14, color: color),
          const SizedBox(width: 6),
          _Battery(color: color),
        ],
      ),
    );
  }
}

class _SignalBars extends StatelessWidget {
  const _SignalBars({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    const heights = <double>[4, 6, 8, 10];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < heights.length; i++)
          Container(
            width: 3,
            height: heights[i],
            margin: const EdgeInsets.only(left: 1.5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.3 + (i + 1) * 0.175),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
      ],
    );
  }
}

class _Battery extends StatelessWidget {
  const _Battery({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 11,
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: 0.7,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ),
      ),
    );
  }
}
