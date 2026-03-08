import 'dart:convert';
import 'dart:math';

import 'package:dicoding_restaurant_app/core/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';

const String dailyReminderTaskName = 'daily_restaurant_reminder';
const String dailyReminderUniqueId = 'daily_restaurant_reminder_id';

Duration _calculateDelayUntilElevenAM() {
  final now = DateTime.now();
  var scheduledTime = DateTime(now.year, now.month, now.day, 11, 0);
  if (scheduledTime.isBefore(now)) {
    scheduledTime = scheduledTime.add(const Duration(days: 1));
  }
  return scheduledTime.difference(now);
}

Future<void> _registerNextDailyReminder() async {
  final delay = _calculateDelayUntilElevenAM();
  await Workmanager().registerOneOffTask(
    dailyReminderUniqueId,
    dailyReminderTaskName,
    initialDelay: delay,
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
    existingWorkPolicy: ExistingWorkPolicy.replace,
  );
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('WorkManager task fired: $task');
    if (task == dailyReminderTaskName) {
      try {
        final response = await http.get(
          Uri.parse('${Config.baseUrl}/list'),
        );

        debugPrint('API response status: ${response.statusCode}');

        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          final restaurants = result['restaurants'] as List;

          debugPrint('Restaurants count: ${restaurants.length}');

          if (restaurants.isNotEmpty) {
            final random = Random();
            final restaurant = restaurants[random.nextInt(restaurants.length)];

            final name = restaurant['name'] ?? 'Restaurant';
            final city = restaurant['city'] ?? '';
            final rating = restaurant['rating']?.toString() ?? '';
            final id = restaurant['id'] ?? '';

            debugPrint('Selected restaurant: $name - $city');

            final flutterLocalNotificationsPlugin =
                FlutterLocalNotificationsPlugin();

            const initializationSettingsAndroid =
                AndroidInitializationSettings('@mipmap/ic_launcher');
            const initializationSettings = InitializationSettings(
              android: initializationSettingsAndroid,
            );
            await flutterLocalNotificationsPlugin.initialize(
              initializationSettings,
            );

            const androidDetails = AndroidNotificationDetails(
              'daily_reminder_channel',
              'Daily Reminder',
              importance: Importance.max,
              priority: Priority.high,
            );
            const notificationDetails = NotificationDetails(
              android: androidDetails,
            );

            await flutterLocalNotificationsPlugin.show(
              Random().nextInt(10000),
              'Rekomendasi Restoran Hari Ini 🍽️',
              '$name - $city ⭐ $rating',
              notificationDetails,
              payload: id,
            );
            debugPrint('Notification shown successfully');
          }
        }

        // Re-register for next day at 11:00 AM
        await _registerNextDailyReminder();
        debugPrint('Re-registered for next day');
      } catch (e) {
        debugPrint('WorkManager task error: $e');
        // Still re-register even on error
        await _registerNextDailyReminder();
        return Future.value(false);
      }
    }
    return Future.value(true);
  });
}

class WorkmanagerService {
  Future<void> init() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  Future<void> registerDailyReminder() async {
    final delay = _calculateDelayUntilElevenAM();

    debugPrint('⏰ Now: ${DateTime.now()}');
    debugPrint('⏰ Initial delay: ${delay.inHours}h ${delay.inMinutes % 60}m ${delay.inSeconds % 60}s');

    await _registerNextDailyReminder();
  }

  Future<void> cancelDailyReminder() async {
    await Workmanager().cancelByUniqueName(dailyReminderUniqueId);
  }
}
