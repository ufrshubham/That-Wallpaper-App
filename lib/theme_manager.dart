import 'package:flutter/material.dart';

class ThemeManager extends ValueNotifier<ThemeMode> {
  // Private constructor.
  ThemeManager._internal(ThemeMode themeMode) : super(themeMode);

  // Single instance of theme manager.
  static ThemeManager _themeManager = ThemeManager._internal(ThemeMode.light);

  // Returns the theme manager instance.
  static ThemeManager get notifier => _themeManager;

  /// Sets the input [themeMode] as current theme mode.
  static void setTheme(ThemeMode themeMode) {
    _themeManager.value = themeMode;
  }
}
