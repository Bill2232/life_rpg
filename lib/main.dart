import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('gameBox');

  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: android);

  await notificationsPlugin.initialize(initSettings);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final Widget? homeOverride;
  const MyApp({super.key, this.homeOverride});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life RPG',
      theme: ThemeData.dark(),
      home: homeOverride ?? HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
