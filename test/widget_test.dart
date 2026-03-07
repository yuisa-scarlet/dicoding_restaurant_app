import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mocktail/mocktail.dart';

import 'package:dicoding_restaurant_app/core/app.dart';
import 'package:dicoding_restaurant_app/shared/services/shared_preference_service.dart';
import 'package:dicoding_restaurant_app/shared/services/local_notification_service.dart';
import 'package:dicoding_restaurant_app/shared/services/workmanager_service.dart';

class MockLocalNotificationService extends Mock
    implements LocalNotificationService {}

class MockWorkmanagerService extends Mock implements WorkmanagerService {}

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<SharedPreferenceService>(
            create: (_) => SharedPreferenceService(prefs),
          ),
          Provider<LocalNotificationService>(
            create: (_) => MockLocalNotificationService(),
          ),
          Provider<WorkmanagerService>(
            create: (_) => MockWorkmanagerService(),
          ),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
