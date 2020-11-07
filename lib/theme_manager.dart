import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:that_wallpaper_app/constants.dart';

class ThemeManager extends ValueNotifier<ThemeMode> {
  // Private constructor.
  ThemeManager._internal(ThemeMode themeMode) : super(themeMode);

  // Single instance of theme manager.
  static ThemeManager _themeManager = ThemeManager._internal(
      (Hive.box(SETTINGS).get(DARK_THEME_KEY) == true)
          ? ThemeMode.dark
          : ThemeMode.light);

  // Returns the theme manager instance.
  static ThemeManager get notifier => _themeManager;

  /// Sets the input [themeMode] as current theme mode.
  static void setTheme(ThemeMode themeMode) {
    _themeManager.value = themeMode;
    Hive.box(SETTINGS)
        .put(DARK_THEME_KEY, (themeMode == ThemeMode.dark) ? true : false);
  }
}
