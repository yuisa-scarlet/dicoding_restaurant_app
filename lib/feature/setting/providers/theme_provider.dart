import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/shared/services/shared_preference_service.dart';

class ThemeProvider extends ChangeNotifier {
  final SharedPreferenceService _service;

  ThemeProvider(this._service) {
    _loadTheme();
  }

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void _loadTheme() {
    final isDark = _service.getTheme();
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _service.saveTheme(isDark);
    notifyListeners();
  }
}
