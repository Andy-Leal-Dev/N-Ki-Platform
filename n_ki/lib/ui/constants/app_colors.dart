import 'package:flutter/material.dart';

class AppPalette {
  const AppPalette({
    required this.primaryStart,
    required this.primaryEnd,
    required this.accent,
    required this.accentDark,
    required this.accentSoft,
    required this.pageBackground,
    required this.cardBackground,
    required this.primaryText,
    required this.secondaryText,
    required this.mutedText,
    required this.dashedBorder,
    required this.divider,
    required this.subtleGreenBackground,
    required this.subtleBlueBackground,
    required this.shadow,
  });

  final Color primaryStart;
  final Color primaryEnd;
  final Color accent;
  final Color accentDark;
  final Color accentSoft;
  final Color pageBackground;
  final Color cardBackground;
  final Color primaryText;
  final Color secondaryText;
  final Color mutedText;
  final Color dashedBorder;
  final Color divider;
  final Color subtleGreenBackground;
  final Color subtleBlueBackground;
  final Color shadow;

  List<Color> get primaryGradient => [primaryStart, primaryEnd];
  List<Color> get accentGradient => [accent, accentDark];
}

class AppColors {
  const AppColors._();

  static const AppPalette light = AppPalette(
    primaryStart: Color(0xFF0A2540),
    primaryEnd: Color(0xFF123A5A),
    accent: Color(0xFF2ECC71),
    accentDark: Color(0xFF27B863),
    accentSoft: Color(0xFFBEEFD4),
    pageBackground: Color(0xFFF3F7FA),
    cardBackground: Colors.white,
    primaryText: Color(0xFF102338),
    secondaryText: Color(0xFF405065),
    mutedText: Color(0xFF7E8FA4),
    dashedBorder: Color(0xFFC9D6E2),
    divider: Color(0xFFDDE6ED),
    subtleGreenBackground: Color(0xFFE9F9F1),
    subtleBlueBackground: Color(0xFFE7EFF7),
    shadow: Color(0x140A2540),
  );

  static const AppPalette dark = AppPalette(
    primaryStart: Color(0xFF061426),
    primaryEnd: Color(0xFF0D1F35),
    accent: Color(0xFF2ECC71),
    accentDark: Color(0xFF27B863),
    accentSoft: Color(0xFF1A3C2A),
    pageBackground: Color(0xFF0B1422),
    cardBackground: Color(0xFF111E32),
    primaryText: Color(0xFFE1ECFF),
    secondaryText: Color(0xFF9DB2D1),
    mutedText: Color(0xFF6F8099),
    dashedBorder: Color(0xFF24344A),
    divider: Color(0xFF1E2F44),
    subtleGreenBackground: Color(0xFF13241D),
    subtleBlueBackground: Color(0xFF131E2E),
    shadow: Color(0x66000000),
  );

  static AppPalette of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }
}

extension AppColorPaletteX on BuildContext {
  AppPalette get palette => AppColors.of(this);
}
