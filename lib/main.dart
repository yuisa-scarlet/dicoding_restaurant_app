import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dicoding_restaurant_app/core/app.dart';
import 'package:dicoding_restaurant_app/shared/services/shared_preference_service.dart';
import 'package:dicoding_restaurant_app/shared/services/local_notification_service.dart';
import 'package:dicoding_restaurant_app/shared/services/workmanager_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final localNotificationService = LocalNotificationService();
  final workmanagerService = WorkmanagerService();

  await _initializeServices(localNotificationService, workmanagerService);

  runApp(
    MultiProvider(
      providers: [
        Provider<SharedPreferenceService>(
          create: (_) => SharedPreferenceService(prefs),
        ),
        Provider<LocalNotificationService>.value(
          value: localNotificationService,
        ),
        Provider<WorkmanagerService>.value(value: workmanagerService),
      ],
      child: const App(),
    ),
  );
}

Future<void> _initializeServices(
  LocalNotificationService notificationService,
  WorkmanagerService workmanagerService,
) async {
  try {
    await notificationService.init();
  } catch (e) {
    debugPrint('Notification init error: $e');
  }

  try {
    await notificationService.configureLocalTimeZone();
  } catch (e) {
    debugPrint('Timezone config error: $e');
  }

  try {
    await workmanagerService.init();
  } catch (e) {
    debugPrint('WorkManager init error: $e');
  }
}
