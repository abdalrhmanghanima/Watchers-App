import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class WatcherBackButton extends StatelessWidget {
  const WatcherBackButton({super.key, this.overlay = false, this.onPressed});

  final bool overlay;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Material(
      color: overlay ? const Color(0x66000000) : palette.surface2,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed ?? () => Navigator.of(context).maybePop(),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: overlay ? Colors.white : palette.text,
          ),
        ),
      ),
    );
  }
}
