import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_restaurant_app/features/setting/providers/theme_provider.dart';

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
      body: Consumer<ThemeProvider>(
        builder: (context, provider, _) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: provider.isDarkMode,
                onChanged: (value) {
                  provider.toggleTheme(value);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
