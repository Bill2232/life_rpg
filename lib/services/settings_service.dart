import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages app settings and preferences
class SettingsService extends ChangeNotifier {
  late SharedPreferences _prefs;

  bool _isDarkMode = true;
  bool _soundEnabled = true;
  bool _notificationsEnabled = true;
  String _language = 'en';

  bool get isDarkMode => _isDarkMode;
  bool get soundEnabled => _soundEnabled;
  bool get notificationsEnabled => _notificationsEnabled;
  String get language => _language;

  /// Initialize settings from persistent storage
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('darkMode') ?? true;
    _soundEnabled = _prefs.getBool('soundEnabled') ?? true;
    _notificationsEnabled = _prefs.getBool('notificationsEnabled') ?? true;
    _language = _prefs.getString('language') ?? 'en';
    notifyListeners();
  }

  /// Toggle dark mode
  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    await _prefs.setBool('darkMode', value);
    notifyListeners();
  }

  /// Toggle sound
  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    await _prefs.setBool('soundEnabled', value);
    notifyListeners();
  }

  /// Toggle notifications
  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    await _prefs.setBool('notificationsEnabled', value);
    notifyListeners();
  }

  /// Set language
  Future<void> setLanguage(String language) async {
    _language = language;
    await _prefs.setString('language', language);
    notifyListeners();
  }
}
