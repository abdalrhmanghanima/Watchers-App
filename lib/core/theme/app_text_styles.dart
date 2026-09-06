import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography tokens for WATCHERS, sourced from the Figma design.
///
/// - Display/heading text uses the `DM Serif Display` family.
/// - Body and all other text uses the `DM Sans` family.
///
/// These styles are light/dark agnostic; callers pass the resolved color from
/// the active [WatchersPalette] (or a fixed color for overlaid-on-image text).
abstract final class AppTextStyles {
  static const double display = 400;

  static TextStyle get displayTitle =>
      GoogleFonts.dmSerifDisplay(fontSize: 26, height: 1.1);

  static TextStyle displayTitleBig(double size) =>
      GoogleFonts.dmSerifDisplay(fontSize: size, height: 1.1);

  static TextStyle get splashWordmark => GoogleFonts.dmSerifDisplay(
    fontSize: 36,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  static TextStyle get authWordmark =>
      GoogleFonts.dmSerifDisplay(fontSize: 22, letterSpacing: 0.14);

  // ---- DM Sans based styles ----

  static TextStyle body(double size, {FontWeight weight = FontWeight.w400}) =>
      GoogleFonts.dmSans(fontSize: size, fontWeight: weight);

  static TextStyle get tabLabel => GoogleFonts.dmSans(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.08,
  );

  static TextStyle get sectionHeader =>
      GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600);

  static TextStyle get sectionAction =>
      GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w500);

  static TextStyle get smallLabel =>
      GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600);

  static TextStyle get badge =>
      GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w600);

  static TextStyle get title =>
      GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.w600);

  static TextStyle get pageTitle =>
      GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.w600);

  static TextStyle get bodyMedium =>
      GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500);

  static TextStyle get bodyRegular => GoogleFonts.dmSans(fontSize: 14);

  static TextStyle get caption => GoogleFonts.dmSans(fontSize: 12);

  static TextStyle get captionSmall => GoogleFonts.dmSans(fontSize: 11);

  static TextStyle get input => GoogleFonts.dmSans(fontSize: 15);
}
