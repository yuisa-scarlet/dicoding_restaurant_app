import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_restaurant_app/core/app_color.dart';
import 'package:dicoding_restaurant_app/feature/setting/providers/theme_provider.dart';
import 'package:dicoding_restaurant_app/feature/setting/providers/daily_reminder_provider.dart';

class SettingScreen extends StatefulWidget {
  static const String routePath = '/setting';
  static const String routeName = 'setting';

  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'APPEARANCE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.grey,
              ),
            ),
          ),
          Consumer<ThemeProvider>(
            builder: (context, provider, _) {
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: provider.isDarkMode
                        ? Colors.white12
                        : const Color(0xFFE0E0E0),
                  ),
                ),
                child: SwitchListTile(
                  title: const Text(
                    'Dark Mode',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: const Text(
                    'Switch between light and dark theme',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  secondary: const Icon(Icons.dark_mode_outlined),
                  activeThumbColor: AppColor.selected,
                  value: provider.isDarkMode,
                  onChanged: provider.toggleTheme,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'NOTIFICATIONS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.grey,
              ),
            ),
          ),
          Consumer<DailyReminderProvider>(
            builder: (context, provider, _) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isDark ? Colors.white12 : const Color(0xFFE0E0E0),
                  ),
                ),
                child: SwitchListTile(
                  title: const Text(
                    'Daily Reminder',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: const Text(
                    'Get a random restaurant recommendation at 11:00 AM',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  secondary: const Icon(Icons.notifications_outlined),
                  activeThumbColor: AppColor.selected,
                  value: provider.isDailyReminderEnabled,
                  onChanged: provider.toggleDailyReminder,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
