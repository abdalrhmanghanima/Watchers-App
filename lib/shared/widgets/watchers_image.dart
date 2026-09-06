import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class WatchersImage extends StatelessWidget {
  const WatchersImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.color,
  });

  final String? imageUrl;
  final BoxFit fit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    final fallback = color ?? palette.surface2;
    final url = imageUrl;
    if (url == null || url.isEmpty) {
      return ColoredBox(color: fallback);
    }
    return Image.network(
      url,
      fit: fit,
      gaplessPlayback: true,
      errorBuilder: (context, error, stackTrace) => ColoredBox(color: fallback),
    );
  }
}
