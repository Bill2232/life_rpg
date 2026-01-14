// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_rpg/main.dart';
import 'package:life_rpg/providers/auth_provider.dart';
import 'package:life_rpg/providers/game_provider.dart';
import 'package:life_rpg/services/settings_service.dart';

void main() {
  testWidgets('App boots successfully', (WidgetTester tester) async {
    // Ensure the widget test binding is initialized
    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock SharedPreferences and register GetIt dependencies for the test.
    SharedPreferences.setMockInitialValues({});
    await getIt.reset();

    final settingsService = SettingsService();
    await settingsService.initialize();
    getIt.registerSingleton<SettingsService>(settingsService);

    final gameProvider = GameProvider();
    // Avoid GameProvider.initialize() here to keep the test lightweight.
    getIt.registerSingleton<GameProvider>(gameProvider);

    final authProvider = AuthProvider();
    await authProvider.initialize();
    getIt.registerSingleton<AuthProvider>(authProvider);

    // Build our app
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // Verify that app has loaded
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
