import 'package:flutter/material.dart';

enum ThemeModeOption { systemDefault, darkMode, lightMode }

class ThemeNotifier extends ChangeNotifier {
  ThemeModeOption _themeMode = ThemeModeOption.systemDefault;

  ThemeModeOption get themeMode => _themeMode;

  set themeMode(ThemeModeOption newMode) {
    if (_themeMode != newMode) {
      _themeMode = newMode;
      notifyListeners();
    }
  }

  ThemeData getThemeData() {
    switch (_themeMode) {
      case ThemeModeOption.darkMode:
        return ThemeData.dark();
      case ThemeModeOption.lightMode:
        return ThemeData.light();
      case ThemeModeOption.systemDefault:
        return ThemeData.fallback();
    }
  }
}
