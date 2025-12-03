import 'package:flutter/material.dart';

class AppThemeScope extends InheritedWidget {
  const AppThemeScope({
    super.key,
    required this.mode,
    required this.onModeChanged,
    required super.child,
  });

  final ThemeMode mode;
  final ValueChanged<ThemeMode> onModeChanged;

  static AppThemeScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppThemeScope>();
  }

  static AppThemeScope of(BuildContext context) {
    final AppThemeScope? scope = maybeOf(context);
    assert(scope != null, 'AppThemeScope not found in widget tree');
    return scope!;
  }

  bool isDark(BuildContext context) {
    if (mode == ThemeMode.dark) {
      return true;
    }
    if (mode == ThemeMode.light) {
      return false;
    }
    final Brightness? platformBrightness = MediaQuery.maybeOf(
      context,
    )?.platformBrightness;
    return platformBrightness == Brightness.dark;
  }

  @override
  bool updateShouldNotify(AppThemeScope oldWidget) => oldWidget.mode != mode;
}
