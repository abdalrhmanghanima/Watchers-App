import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Builds the [ThemeData] for the WATCHERS app.
///
/// The app exposes two full palettes (dark/light) through the
/// [WatchersPalette] theme extension, so every screen can resolve the active
/// colors via `WatchersPalette.of(context)`.
abstract final class AppTheme {
  static ThemeData dark() => _build(WatchersPalette.dark, Brightness.dark);

  static ThemeData light() => _build(WatchersPalette.light, Brightness.light);

  static ThemeData _build(WatchersPalette palette, Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: brightness,
    ).copyWith(surface: palette.surface, onSurface: palette.text);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: palette.bg,
      colorScheme: colorScheme,
      extensions: [palette],
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.standard,
    );
  }
}
