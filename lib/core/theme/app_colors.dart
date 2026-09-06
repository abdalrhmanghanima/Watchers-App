import 'package:flutter/material.dart';

/// Design tokens for the WATCHERS app, sourced from `design_reference/watchers`.
///
/// There are two palettes (dark and light) which share the same token names.
/// Widgets should read the active palette via `WatchersPalette.of(context)` so
/// the app switches theme without threading color objects through every widget.
@immutable
class WatchersPalette extends ThemeExtension<WatchersPalette> {
  const WatchersPalette({
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.surface3,
    required this.text,
    required this.textSec,
    required this.accent,
    required this.accentBright,
    required this.accentBg,
    required this.border,
    required this.borderStrong,
  });

  final Color bg;
  final Color surface;
  final Color surface2;
  final Color surface3;
  final Color text;
  final Color textSec;
  final Color accent;
  final Color accentBright;
  final Color accentBg;
  final Color border;
  final Color borderStrong;

  /// Convenience accessor for screens and widgets.
  static WatchersPalette of(BuildContext context) =>
      Theme.of(context).extension<WatchersPalette>()!;

  /// The WATCHERS dark palette.
  static const dark = WatchersPalette(
    bg: Color(0xFF0A0A0F),
    surface: Color(0xFF111118),
    surface2: Color(0xFF18182A),
    surface3: Color(0xFF222238),
    text: Color(0xFFFFFFFF),
    textSec: Color(0xFF8A8AA8),
    accent: Color(0xFF7C3AED),
    accentBright: Color(0xFFA78BFA),
    accentBg: Color(0x2E7C3AED), // rgba(124,58,237,0.18)
    border: Color(0x0FFFFFFF), // rgba(255,255,255,0.06)
    borderStrong: Color(0x1FFFFFFF), // rgba(255,255,255,0.12)
  );

  /// The WATCHERS light palette.
  static const light = WatchersPalette(
    bg: Color(0xFFF0F0F6),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFF7F7FD),
    surface3: Color(0xFFEAEAF4),
    text: Color(0xFF0A0A0F),
    textSec: Color(0xFF6A6A84),
    accent: Color(0xFF7C3AED),
    accentBright: Color(0xFF5B21B6),
    accentBg: Color(0x1A7C3AED), // rgba(124,58,237,0.10)
    border: Color(0x0F000000), // rgba(0,0,0,0.06)
    borderStrong: Color(0x1F000000), // rgba(0,0,0,0.12)
  );

  @override
  WatchersPalette copyWith({
    Color? bg,
    Color? surface,
    Color? surface2,
    Color? surface3,
    Color? text,
    Color? textSec,
    Color? accent,
    Color? accentBright,
    Color? accentBg,
    Color? border,
    Color? borderStrong,
  }) {
    return WatchersPalette(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      surface3: surface3 ?? this.surface3,
      text: text ?? this.text,
      textSec: textSec ?? this.textSec,
      accent: accent ?? this.accent,
      accentBright: accentBright ?? this.accentBright,
      accentBg: accentBg ?? this.accentBg,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
    );
  }

  @override
  WatchersPalette lerp(WatchersPalette? other, double t) {
    if (other is! WatchersPalette) return this;
    return WatchersPalette(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      surface3: Color.lerp(surface3, other.surface3, t)!,
      text: Color.lerp(text, other.text, t)!,
      textSec: Color.lerp(textSec, other.textSec, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentBright: Color.lerp(accentBright, other.accentBright, t)!,
      accentBg: Color.lerp(accentBg, other.accentBg, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
    );
  }
}

/// Status badge colors mapped from Show.status (from the figma design).
class StatusColors {
  const StatusColors(this.background, this.foreground);

  final Color background;
  final Color foreground;

  static const ongoing = StatusColors(
    Color(0x2610B981), // rgba(16,185,129,0.15)
    Color(0xFF10B981),
  );
  static const ended = StatusColors(
    Color(0x266B7280), // rgba(107,114,128,0.15)
    Color(0xFF9CA3AF),
  );
  static const upcoming = StatusColors(
    Color(0x26F59E0B), // rgba(245,158,11,0.15)
    Color(0xFFF59E0B),
  );
}

/// Fixed accent colors used across both themes.
abstract final class AppColors {
  static const accent = Color(0xFF7C3AED);
  static const accentBrightDark = Color(0xFFA78BFA);
  static const gradientStart = Color(0xFF7C3AED);
  static const gradientEnd = Color(0xFFA855F7);

  // Spoiler badge
  static const spoilerBg = Color(0x1FEF4444); // rgba(239,68,68,0.12)
  static const spoilerText = Color(0xFFF87171);

  // Danger
  static const danger = Color(0xFFEF4444);

  // Genre chips on the movies hero (dark-only presentation in the design)
  static const heroChipBg = Color(0x597C3AED); // rgba(124,58,237,0.35)
  static const heroChipText = Color(0xFFC4B5FD);
}
