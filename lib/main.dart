import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

import 'config/app_config.dart';
import 'providers/game_provider.dart';
import 'providers/auth_provider.dart';
import 'services/audio_service.dart';
import 'services/settings_service.dart';
import 'services/notification_service.dart';
import 'screens/auth_screens.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

final getIt = GetIt.instance;
final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize notifications
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: android);
  await notificationsPlugin.initialize(initSettings);
  NotificationService.initialize(notificationsPlugin);

  // Setup dependency injection
  await _setupDependencies();

  runApp(const MyApp());
}

Future<void> _setupDependencies() async {
  // Initialize services
  final audioService = AudioService();
  await audioService.initialize();
  getIt.registerSingleton<AudioService>(audioService);

  final settingsService = SettingsService();
  await settingsService.initialize();
  getIt.registerSingleton<SettingsService>(settingsService);

  // Apply user settings to services.
  audioService.setMuted(!settingsService.soundEnabled);
  NotificationService.setEnabled(settingsService.notificationsEnabled);
  settingsService.addListener(() {
    audioService.setMuted(!settingsService.soundEnabled);
    NotificationService.setEnabled(settingsService.notificationsEnabled);
  });

  // Initialize providers
  final gameProvider = GameProvider();
  await gameProvider.initialize();
  gameProvider.setAudioService(audioService);
  getIt.registerSingleton<GameProvider>(gameProvider);

  final authProvider = AuthProvider();
  await authProvider.initialize();
  getIt.registerSingleton<AuthProvider>(authProvider);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: getIt<GameProvider>()),
        ChangeNotifierProvider.value(value: getIt<AuthProvider>()),
        ChangeNotifierProvider.value(value: getIt<SettingsService>()),
      ],
      child: Consumer2<SettingsService, AuthProvider>(
        builder: (context, settingsService, authProvider, _) {
          final startScreen = authProvider.isAuthenticated
              ? const HomeScreen()
              : const SignInScreen();

          return MaterialApp(
            title: AppConfig.appName,
            theme: lightTheme(),
            darkTheme: darkTheme(),
            themeMode: settingsService.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            routes: {
              '/home': (_) => const HomeScreen(),
              '/sign-in': (_) => const SignInScreen(),
              '/sign-up': (_) => const SignUpScreen(),
              '/forgot-password': (_) => const ForgotPasswordScreen(),
            },
            home: startScreen,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
