/// Layout and design constants for WATCHERS, sourced from the Figma design
/// (390x844 design viewport).
abstract final class AppConstants {
  /// The design reference viewport dimensions.
  static const double designWidth = 390;
  static const double designHeight = 844;

  // ---- Spacing ----
  /// Standard horizontal page padding (px-4 = 16).
  static const double pagePadding = 16;

  /// Gap between items in a horizontal list / column (gap-3 = 12).
  static const double itemGap = 12;

  /// Bottom padding above the bottom navigation bar to avoid overlap.
  static const double bottomNavOffset = 96;

  // ---- Radii ----
  static const double radiusSmall = 6;
  static const double radiusCover = 8;
  static const double radiusPoster = 10;
  static const double radiusInput = 12;
  static const double radiusRounded = 12;
  static const double radiusCard = 16;
  static const double radiusButton = 12;
  static const double radiusLarge = 20;

  // ---- Component sizes ----
  static const double statusBarHeight = 24;

  // ---- Fonts ----
  static const String fontBody = 'DM Sans';
  static const String fontDisplay = 'DM Serif Display';
}
