import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../config/app_config.dart';

/// Manages local notifications
class NotificationService {
  static late FlutterLocalNotificationsPlugin _notificationsPlugin;
  static bool _enabled = true;

  static void initialize(FlutterLocalNotificationsPlugin plugin) {
    _notificationsPlugin = plugin;
  }

  static void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  static Future<void> showNotification(
    String title,
    String body, {
    String? payload,
  }) async {
    if (!_enabled) return;

    const androidDetails = AndroidNotificationDetails(
      AppConfig.notificationChannelId,
      AppConfig.notificationChannelName,
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    try {
      await _notificationsPlugin.show(
        0,
        title,
        body,
        details,
        payload: payload,
      );
    } catch (e) {
      // Ignore notification errors in environments where platform channels
      // aren't available (tests, some CI runners).
    }
  }

  static Future<void> showDailyReminder({
    required String title,
    required String body,
    required Duration time,
  }) async {
    if (!_enabled) return;

    const androidDetails = AndroidNotificationDetails(
      AppConfig.notificationChannelId,
      AppConfig.notificationChannelName,
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    try {
      await _notificationsPlugin.periodicallyShow(
        1,
        title,
        body,
        RepeatInterval.daily,
        details,
      );
    } catch (e) {
      // Ignore errors
    }
  }

  static Future<void> cancelNotification(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
    } catch (e) {
      // Ignore errors
    }
  }

  static Future<void> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
    } catch (e) {
      // Ignore errors
    }
  }
}
