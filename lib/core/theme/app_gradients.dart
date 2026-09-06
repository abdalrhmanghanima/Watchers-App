import 'package:flutter/material.dart';

/// Gradient tokens for WATCHERS, sourced from the Figma design.
abstract final class AppGradients {
  /// Primary CTA button gradient (135deg).
  static const cta = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7C3AED), Color(0xFFA855F7)],
  );

  /// Splash screen background (160deg).
  static const splash = LinearGradient(
    begin: Alignment(0.3, -0.8),
    end: Alignment(-0.3, 0.8),
    colors: [Color(0xFF0A0A0F), Color(0xFF120A22), Color(0xFF0A0A0F)],
  );

  /// Auth screen background (160deg) used in dark mode.
  static const auth = LinearGradient(
    begin: Alignment(0.3, -0.8),
    end: Alignment(-0.3, 0.8),
    colors: [Color(0xFF0A0A0F), Color(0xFF120A22), Color(0xFF0A0A0F)],
  );

  /// Outer app background (desktop preview).
  static const outerDark = RadialGradient(
    center: Alignment(0.4, 0.2),
    radius: 1.2,
    colors: [Color(0xFF130A22), Color(0xFF080810)],
  );

  static const outerLight = RadialGradient(
    center: Alignment(0.5, 0.2),
    radius: 1.4,
    colors: [Color(0xFFE2E0F0), Color(0xFFD8D8E8)],
  );

  /// Bottom navigation bar background (fades to transparent at the top).
  static LinearGradient bottomNav({required bool dark}) => LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: dark
        ? [const Color(0xFF0A0A0F), const Color(0xEB0A0A0F)]
        : [const Color(0xFFFFFFFF), const Color(0xEBFFFFFF)],
    stops: const [0.6, 1.0],
  );

  /// Gradient overlay on poster images (dark at bottom).
  static const posterOverlay = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [Color(0xB3000000), Colors.transparent],
    stops: [0.0, 0.5],
  );

  /// Enhanced dark gradient for Continue Watching and card overlays.
  static const cardOverlay = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [Color(0xC0000000), Colors.transparent],
    stops: [0.0, 0.55],
  );

  /// Movies hero backdrop overlay.
  static const heroOverlay = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [Color(0xFF0A0A0F), Color(0x800A0A0F), Color(0x330A0A0F)],
    stops: [0.0, 0.5, 1.0],
  );

  /// Detail hero overlay (show/movie).
  static const detailHeroOverlay = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [Color(0xF2000000), Color(0x4D000000), Color(0x1A000000)],
    stops: [0.0, 0.6, 1.0],
  );

  /// Progress bar accent gradient (episodes screen).
  static const progress = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF7C3AED), Color(0xFFA855F7)],
  );

  /// Cinephile badge gradient.
  static const cinephile = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7C3AED), Color(0xFFA855F7)],
  );
}
