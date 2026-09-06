import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class EpisodeMetaRow extends StatelessWidget {
  const EpisodeMetaRow({
    super.key,
    required this.duration,
    required this.airDate,
  });

  final int duration;
  final String airDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MetaItem(icon: Icons.schedule, label: '$duration min'),
        const SizedBox(width: 20),
        _MetaItem(icon: Icons.calendar_today_outlined, label: airDate),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: palette.textSec),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.body(12).copyWith(color: palette.textSec),
        ),
      ],
    );
  }
}
