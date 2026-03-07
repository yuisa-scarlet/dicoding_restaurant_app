import 'package:dicoding_restaurant_app/feature/setting/providers/daily_reminder_provider.dart';
import 'package:dicoding_restaurant_app/shared/services/local_notification_service.dart';
import 'package:dicoding_restaurant_app/shared/services/shared_preference_service.dart';
import 'package:dicoding_restaurant_app/shared/services/workmanager_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSharedPreferenceService extends Mock
    implements SharedPreferenceService {}

class MockLocalNotificationService extends Mock
    implements LocalNotificationService {}

class MockWorkmanagerService extends Mock implements WorkmanagerService {}

void main() {
  late MockSharedPreferenceService mockPrefs;
  late MockLocalNotificationService mockNotification;
  late MockWorkmanagerService mockWorkmanager;

  setUp(() {
    mockPrefs = MockSharedPreferenceService();
    mockNotification = MockLocalNotificationService();
    mockWorkmanager = MockWorkmanagerService();
  });

  group('DailyReminderProvider', () {
    test('initial state should be false when no preference saved', () {
      when(() => mockPrefs.getDailyReminder()).thenReturn(false);

      final provider = DailyReminderProvider(
        mockPrefs,
        mockNotification,
        mockWorkmanager,
      );

      expect(provider.isDailyReminderEnabled, false);
    });

    test('initial state should be true when preference is saved as true', () {
      when(() => mockPrefs.getDailyReminder()).thenReturn(true);

      final provider = DailyReminderProvider(
        mockPrefs,
        mockNotification,
        mockWorkmanager,
      );

      expect(provider.isDailyReminderEnabled, true);
    });

    test('toggleDailyReminder(true) should enable reminder and register workmanager', () async {
      when(() => mockPrefs.getDailyReminder()).thenReturn(false);
      when(() => mockNotification.requestPermissions())
          .thenAnswer((_) async => true);
      when(() => mockWorkmanager.registerDailyReminder())
          .thenAnswer((_) async {});
      when(() => mockNotification.pendingNotificationRequests())
          .thenAnswer((_) async => <PendingNotificationRequest>[]);
      when(() => mockPrefs.saveDailyReminder(true))
          .thenAnswer((_) async {});

      final provider = DailyReminderProvider(
        mockPrefs,
        mockNotification,
        mockWorkmanager,
      );

      await provider.toggleDailyReminder(true);

      expect(provider.isDailyReminderEnabled, true);
      verify(() => mockNotification.requestPermissions()).called(1);
      verify(() => mockWorkmanager.registerDailyReminder()).called(1);
      verify(() => mockPrefs.saveDailyReminder(true)).called(1);
    });

    test('toggleDailyReminder(false) should disable reminder and cancel workmanager', () async {
      when(() => mockPrefs.getDailyReminder()).thenReturn(true);
      when(() => mockWorkmanager.cancelDailyReminder())
          .thenAnswer((_) async {});
      when(() => mockNotification.cancelNotification(0))
          .thenAnswer((_) async {});
      when(() => mockNotification.pendingNotificationRequests())
          .thenAnswer((_) async => <PendingNotificationRequest>[]);
      when(() => mockPrefs.saveDailyReminder(false))
          .thenAnswer((_) async {});

      final provider = DailyReminderProvider(
        mockPrefs,
        mockNotification,
        mockWorkmanager,
      );

      await provider.toggleDailyReminder(false);

      expect(provider.isDailyReminderEnabled, false);
      verify(() => mockWorkmanager.cancelDailyReminder()).called(1);
      verify(() => mockNotification.cancelNotification(0)).called(1);
      verify(() => mockPrefs.saveDailyReminder(false)).called(1);
    });
  });
}
