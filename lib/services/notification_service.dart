import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';

class NotificationService {
  static Future showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'life_rpg_channel',
      'Life RPG',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    try {
      await notificationsPlugin.show(0, title, body, details);
    } catch (_) {
      // Ignore notification errors in environments where platform channels
      // aren't available (tests, some CI runners).
    }
  }
}
