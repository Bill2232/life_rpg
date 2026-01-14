/// Application configuration constants
class AppConfig {
  static const String appName = 'Solo Leveling';
  static const String appVersion = '1.0.0';

  // Hive boxes
  static const String userBox = 'user';
  static const String tasksBox = 'tasks';
  static const String settingsBox = 'settings';

  // XP Configuration
  static const int baseXpToLevel = 150;
  static const int xpIncrement = 25; // XP increase per level
  static const int streakBonus = 5; // XP bonus per streak day

  // Avatar thresholds (levels)
  static const int avatarStage1Threshold = 3;
  static const int avatarStage2Threshold = 6;
  static const int avatarStage3Threshold = 10;

  // Notification channels
  static const String notificationChannelId = 'solo_leveling_notifications';
  static const String notificationChannelName = 'Solo Leveling';
}
