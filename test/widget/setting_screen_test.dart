import 'package:dicoding_restaurant_app/feature/setting/providers/daily_reminder_provider.dart';
import 'package:dicoding_restaurant_app/feature/setting/providers/theme_provider.dart';
import 'package:dicoding_restaurant_app/feature/setting/screens/setting_screen.dart';
import 'package:dicoding_restaurant_app/shared/services/local_notification_service.dart';
import 'package:dicoding_restaurant_app/shared/services/shared_preference_service.dart';
import 'package:dicoding_restaurant_app/shared/services/workmanager_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

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

  Widget createSettingScreen() {
    when(() => mockPrefs.getTheme()).thenReturn(false);
    when(() => mockPrefs.getDailyReminder()).thenReturn(false);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(mockPrefs),
        ),
        ChangeNotifierProvider<DailyReminderProvider>(
          create: (_) => DailyReminderProvider(
            mockPrefs,
            mockNotification,
            mockWorkmanager,
          ),
        ),
      ],
      child: const MaterialApp(
        home: SettingScreen(),
      ),
    );
  }

  group('SettingScreen Widget Tests', () {
    testWidgets('should display Dark Mode and Daily Reminder toggles',
        (tester) async {
      await tester.pumpWidget(createSettingScreen());
      await tester.pumpAndSettle();

      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('Daily Reminder'), findsOneWidget);
      expect(find.text('APPEARANCE'), findsOneWidget);
      expect(find.text('NOTIFICATIONS'), findsOneWidget);
    });

    testWidgets('Daily Reminder toggle should call toggleDailyReminder when tapped',
        (tester) async {
      when(() => mockNotification.requestPermissions())
          .thenAnswer((_) async => true);
      when(() => mockWorkmanager.registerDailyReminder())
          .thenAnswer((_) async {});
      when(() => mockNotification.pendingNotificationRequests())
          .thenAnswer((_) async => <PendingNotificationRequest>[]);
      when(() => mockPrefs.saveDailyReminder(true))
          .thenAnswer((_) async {});

      await tester.pumpWidget(createSettingScreen());
      await tester.pumpAndSettle();

      final dailyReminderSwitch = find.widgetWithText(
        SwitchListTile,
        'Daily Reminder',
      );
      expect(dailyReminderSwitch, findsOneWidget);

      await tester.tap(dailyReminderSwitch);
      await tester.pumpAndSettle();

      verify(() => mockWorkmanager.registerDailyReminder()).called(1);
    });
  });
}
