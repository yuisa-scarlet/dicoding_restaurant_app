import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dicoding_restaurant_app/core/app.dart';
import 'package:dicoding_restaurant_app/shared/services/shared_preference_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();

  runApp(
    Provider<SharedPreferenceService>(
      create: (_) => SharedPreferenceService(prefs),
      child: const App(),
    ),
  );
}
