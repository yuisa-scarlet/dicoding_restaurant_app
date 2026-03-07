import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  final SharedPreferences _preferences;

  SharedPreferenceService(this._preferences);

  static const String _themeKey = 'THEME_KEY';
  static const String _dailyReminderKey = 'DAILY_REMINDER_KEY';

  Future<void> saveTheme(bool isDark) async {
    await _preferences.setBool(_themeKey, isDark);
  }

  bool getTheme() {
    return _preferences.getBool(_themeKey) ?? false;
  }

  Future<void> saveDailyReminder(bool isEnabled) async {
    await _preferences.setBool(_dailyReminderKey, isEnabled);
  }

  bool getDailyReminder() {
    return _preferences.getBool(_dailyReminderKey) ?? false;
  }
}
