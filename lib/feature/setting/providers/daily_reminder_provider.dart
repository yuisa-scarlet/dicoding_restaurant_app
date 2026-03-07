import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/shared/services/shared_preference_service.dart';
import 'package:dicoding_restaurant_app/shared/services/local_notification_service.dart';
import 'package:dicoding_restaurant_app/shared/services/workmanager_service.dart';

class DailyReminderProvider extends ChangeNotifier {
  final SharedPreferenceService _preferenceService;
  final LocalNotificationService _notificationService;
  final WorkmanagerService _workmanagerService;

  bool _isDailyReminderEnabled = false;

  DailyReminderProvider(
    this._preferenceService,
    this._notificationService,
    this._workmanagerService,
  ) {
    _isDailyReminderEnabled = _preferenceService.getDailyReminder();
  }

  bool get isDailyReminderEnabled => _isDailyReminderEnabled;

  Future<void> toggleDailyReminder(bool value) async {
    _isDailyReminderEnabled = value;
    notifyListeners();

    if (value) {
      final permResult = await _notificationService.requestPermissions();
      debugPrint('Permission result: $permResult');

      // Register WorkManager for background API fetch + notification
      await _workmanagerService.registerDailyReminder();
      debugPrint('WorkManager periodic task registered');

      final pending = await _notificationService.pendingNotificationRequests();
      debugPrint('Pending notifications: ${pending.length}');
      for (final p in pending) {
        debugPrint('   - id: ${p.id}, title: ${p.title}, body: ${p.body}');
      }
    } else {
      await _workmanagerService.cancelDailyReminder();
      await _notificationService.cancelNotification(0);
      debugPrint('Daily reminder cancelled');

      final pending = await _notificationService.pendingNotificationRequests();
      debugPrint('Pending notifications after cancel: ${pending.length}');
    }

    await _preferenceService.saveDailyReminder(value);
    debugPrint('Saved daily reminder preference: $value');
  }
}
