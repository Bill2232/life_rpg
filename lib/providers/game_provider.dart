import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/player.dart';
import '../models/task.dart';
import '../config/app_config.dart';
import '../services/audio_service.dart';
import '../services/notification_service.dart';

/// Manages game state and player progression
class GameProvider extends ChangeNotifier {
  final Player _player = Player();
  List<Task> _tasks = [];
  AudioService? _audioService;

  final String _today = DateTime.now().toIso8601String().substring(0, 10);
  bool _isLoading = true;
  String? _error;

  // Getters
  Player get player => _player;
  List<Task> get tasks => _tasks;
  List<Task> get dailyTasks =>
      _tasks.where((t) => t.type == TaskType.daily).toList();
  List<Task> get mainQuests =>
      _tasks.where((t) => t.type == TaskType.main).toList();
  List<Task> get sideTasks =>
      _tasks.where((t) => t.type == TaskType.side).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialize provider with audio service
  void setAudioService(AudioService audioService) {
    _audioService = audioService;
  }

  /// Initialize game data
  Future<void> initialize() async {
    _isLoading = true;
    _error = null;

    try {
      // Open Hive boxes
      await Hive.openBox(AppConfig.userBox);
      await Hive.openBox(AppConfig.tasksBox);
      await Hive.openBox(AppConfig.settingsBox);

      // Load player
      _player.load();

      // Load tasks
      _loadTasks();

      // Check if it's a new day
      _resetIfNewDay();

      _isLoading = false;
    } catch (e) {
      _error = 'Failed to initialize game: $e';
      _isLoading = false;
    }

    notifyListeners();
  }

  /// Load tasks from storage
  void _loadTasks() {
    final box = Hive.box(AppConfig.tasksBox);
    final saved = box.get('tasks');

    if (saved != null) {
      _tasks = List<Map>.from(
        saved,
      ).map((e) => Task.fromMap(e as Map<String, dynamic>)).toList();
    } else {
      // Start with no tasks; user must add quests manually.
      _tasks = [];
      _saveTasks();
    }
  }

  /// Save tasks to storage
  void _saveTasks() {
    final box = Hive.box(AppConfig.tasksBox);
    box.put('tasks', _tasks.map((e) => e.toMap()).toList());
    box.put('lastDate', _today);
  }

  /// Reset tasks if it's a new day
  void _resetIfNewDay() {
    final box = Hive.box(AppConfig.tasksBox);
    String? lastDate = box.get('lastDate');

    if (lastDate != _today) {
      for (var task in _tasks) {
        if (task.type == TaskType.daily) {
          if (!task.completed) {
            // Streak reset penalty
            if (task.streak > 0) {
              _player.removeXP(10);
            }
            task.streak = 0;
          }
          task.completed = false;
        }
      }
      _player.updateStreak(false);
      _saveTasks();
      _player.save();

      NotificationService.showNotification(
        "Daily Reset",
        "Your daily quests have been reset. Good luck today!",
      );
    }
  }

  /// Complete a task
  Future<void> completeTask(Task task) async {
    if (task.completed) return;

    // Check if main quest and player level requirement
    if (task.type == TaskType.main && _player.level < 2) {
      _error = "Main quests unlocked at Level 2";
      notifyListeners();
      return;
    }

    task.completed = true;
    int oldLevel = _player.level;
    int xpGained = 0;

    if (task.type == TaskType.daily) {
      task.streak++;
      xpGained = task.xp + (task.streak * AppConfig.streakBonus);
    } else {
      xpGained = task.xp;
    }

    _player.addXP(xpGained);
    _player.completeTask(task);

    // Check for level up
    if (_player.level > oldLevel) {
      await _audioService?.playLevelUp();
      _checkAndUnlockBadges();

      NotificationService.showNotification(
        "Level Up! 🎉",
        "You reached Level ${_player.level}",
      );
    } else {
      await _audioService?.playTaskComplete();
    }

    // Check for special achievements
    if (_player.level == 2) {
      NotificationService.showNotification(
        "Achievement Unlocked: First Growth",
        "Welcome to your next chapter!",
      );
    }

    _saveTasks();
    notifyListeners();
  }

  /// Add a new task
  void addTask(Task task) {
    _tasks.add(task);
    _saveTasks();
    notifyListeners();
  }

  /// Remove a task
  void removeTask(Task task) {
    _tasks.remove(task);
    _saveTasks();
    notifyListeners();
  }

  /// Edit a task
  void editTask(Task oldTask, Task newTask) {
    final index = _tasks.indexOf(oldTask);
    if (index != -1) {
      _tasks[index] = newTask;
      _saveTasks();
      notifyListeners();
    }
  }

  /// Check and unlock badges
  void _checkAndUnlockBadges() {
    for (var badge in _player.badges) {
      if (!badge.isUnlocked && _player.level >= badge.requiredLevel) {
        _player.unlockBadge(badge.id);
        _audioService?.playBadgeUnlock();

        NotificationService.showNotification("Badge Unlocked! 🏆", badge.title);
      }
    }
  }

  /// Update player username
  Future<void> updateUsername(String newName) async {
    _player.username = newName;
    _player.save();
    notifyListeners();
  }

  /// Reset all progress
  Future<void> resetProgress() async {
    _player.resetProgress();
    for (final task in _tasks) {
      task.completed = false;
      task.streak = 0;
    }
    _saveTasks();
    notifyListeners();

    NotificationService.showNotification(
      "Progress Reset",
      "Your progress has been reset. Starting fresh!",
    );
  }
}
