import 'package:flutter/material.dart';

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
      body: Center(
        child: Text('Setting'),
      ),
    );
  }
}