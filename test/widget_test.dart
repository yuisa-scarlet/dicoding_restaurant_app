import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dicoding_restaurant_app/core/app.dart';
import 'package:dicoding_restaurant_app/shared/services/shared_preference_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      Provider<SharedPreferenceService>(
        create: (_) => SharedPreferenceService(prefs),
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    // Pastikan app setidaknya bisa dirender.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
