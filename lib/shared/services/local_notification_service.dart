import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

class LocalNotificationService {
  tz.TZDateTime _nextInstanceOfTenAM() {
   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
   tz.TZDateTime scheduledDate =
       tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
   if (scheduledDate.isBefore(now)) {
     scheduledDate = scheduledDate.add(const Duration(days: 1));
   }
   return scheduledDate;
 }

 Future<bool> _requestExactAlarmsPermission() async {
   return await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestExactAlarmsPermission() ??
  false;
 }
}