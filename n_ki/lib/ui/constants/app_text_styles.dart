import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle headerTitle(BuildContext context) => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static TextStyle headerSubtitle(BuildContext context) => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
    letterSpacing: 0.2,
  );

  static TextStyle sectionTitle(BuildContext context) => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: context.palette.primaryText,
  );

  static TextStyle sectionSubtitle(BuildContext context) => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: context.palette.secondaryText,
  );

  static TextStyle statValue(BuildContext context) => TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: context.palette.primaryText,
  );

  static TextStyle statLabel(BuildContext context) => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: context.palette.secondaryText,
  );

  static TextStyle emptyStateTitle(BuildContext context) => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: context.palette.secondaryText,
  );

  static TextStyle buttonLabel(BuildContext context) => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  static TextStyle ghostButtonLabel(BuildContext context) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: context.palette.accent,
  );
}

extension AppTextStyleX on BuildContext {
  TextStyle get headerTitleStyle => AppTextStyles.headerTitle(this);
  TextStyle get headerSubtitleStyle => AppTextStyles.headerSubtitle(this);
  TextStyle get sectionTitleStyle => AppTextStyles.sectionTitle(this);
  TextStyle get sectionSubtitleStyle => AppTextStyles.sectionSubtitle(this);
  TextStyle get statValueStyle => AppTextStyles.statValue(this);
  TextStyle get statLabelStyle => AppTextStyles.statLabel(this);
  TextStyle get emptyStateTitleStyle => AppTextStyles.emptyStateTitle(this);
  TextStyle get buttonLabelStyle => AppTextStyles.buttonLabel(this);
  TextStyle get ghostButtonLabelStyle => AppTextStyles.ghostButtonLabel(this);
}
