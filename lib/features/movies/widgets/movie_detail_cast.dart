import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/cast_member.dart';
import '../../../shared/widgets/cast_avatar.dart';

class MovieDetailCast extends StatelessWidget {
  const MovieDetailCast({super.key, required this.cast});

  final List<CastMember> cast;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Cast',
          style: AppTextStyles.smallLabel.copyWith(
            color: palette.textSec,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < cast.length; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                CastAvatar(
                  name: cast[i].name,
                  role: cast[i].role,
                  photoUrl: cast[i].photoUrl,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
