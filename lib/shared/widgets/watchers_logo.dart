import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_text_styles.dart';

class WatchersLogo extends StatelessWidget {
  const WatchersLogo({super.key, this.size = 72, this.showWordmark = false});

  final double size;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            'assets/icons/watchers_logo.svg',
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        ),
        if (showWordmark) ...[
          SizedBox(height: size * 0.22),
          Text(
            'WATCHERS',
            style: AppTextStyles.displayTitleBig(
              size * 0.5,
            ).copyWith(color: Colors.white, letterSpacing: size * 0.1),
          ),
        ],
      ],
    );
  }
}
