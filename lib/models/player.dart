import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import '../models/badge.dart';
import '../models/task.dart';
import '../config/app_config.dart';

/// Enhanced Player model with profile, stats, and badge system

class Player {
  int level;
  int xp;
  int xpToNext;
  String username;
  String? avatarImagePath; // User-selected image path
  List<String> unlockedBorders; // List of border IDs
  String? selectedBorderId;
  List<Badge> badges;
  int totalTasksCompleted;
  int totalXpGained;
  DateTime createdAt;
  DateTime lastActivityAt;

  // Statistics
  int dailyTasksCompleted;
  int mainQuestsCompleted;
  int sideQuestsCompleted;
  int currentStreak;
  int longestStreak;

  Player({
    this.username = 'Adventurer',
    this.level = 1,
    this.xp = 0,
    this.xpToNext = AppConfig.baseXpToLevel,
    this.avatarImagePath,
    List<String>? unlockedBorders,
    this.selectedBorderId,
    List<Badge>? badges,
    this.totalTasksCompleted = 0,
    this.totalXpGained = 0,
    DateTime? createdAt,
    DateTime? lastActivityAt,
    this.dailyTasksCompleted = 0,
    this.mainQuestsCompleted = 0,
    this.sideQuestsCompleted = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
  }) : createdAt = createdAt ?? DateTime.now(),
       lastActivityAt = lastActivityAt ?? DateTime.now(),
       badges = badges ?? Badge.getDefaultBadges(),
       unlockedBorders = unlockedBorders ?? ['default'];

  /// Add XP and handle level up
  int addXP(int amount) {
    int finalAmount = amount;
    xp += finalAmount;

    while (xp >= xpToNext) {
      xp -= xpToNext;
      level++;
      xpToNext = AppConfig.baseXpToLevel + (level - 1) * AppConfig.xpIncrement;
    }

    totalXpGained += finalAmount;
    lastActivityAt = DateTime.now();
    save();

    return finalAmount;
  }

  /// Deduct XP (for penalties)
  void removeXP(int amount) {
    xp -= amount;
    if (xp < 0) xp = 0;
    save();
  }

  /// Get current avatar path based on evolution stage
  String getAvatar() {
    // If the user selected an image, return it.
    if (avatarImagePath != null && avatarImagePath!.isNotEmpty) {
      return avatarImagePath!;
    }

    // No default avatar files — return empty to indicate "no avatar set".
    return '';
  }

  /// Get title based on level
  String getTitle() {
    if (level < AppConfig.avatarStage1Threshold) return 'Novice';
    if (level < AppConfig.avatarStage2Threshold) return 'Disciplined';
    if (level < 10) return 'Relentless';
    if (level < 20) return 'Legend';
    return 'Mythic';
  }

  /// Complete a task and update stats
  void completeTask(Task task) {
    totalTasksCompleted++;

    switch (task.type) {
      case TaskType.daily:
        dailyTasksCompleted++;
        break;
      case TaskType.main:
        mainQuestsCompleted++;
        break;
      case TaskType.side:
        sideQuestsCompleted++;
        break;
    }

    lastActivityAt = DateTime.now();
    save();
  }

  /// Update streak tracking
  void updateStreak(bool completed) {
    if (completed) {
      currentStreak++;
      if (currentStreak > longestStreak) {
        longestStreak = currentStreak;
      }
    } else {
      currentStreak = 0;
    }
    save();
  }

  /// Unlock a badge
  void unlockBadge(String badgeId) {
    final index = badges.indexWhere((b) => b.id == badgeId);
    if (index != -1 && !badges[index].isUnlocked) {
      badges[index] = badges[index].copyWith(unlockedAt: DateTime.now());
      save();
    }
  }

  /// Get unlocked badges
  List<Badge> getUnlockedBadges() {
    return badges.where((b) => b.isUnlocked).toList();
  }

  /// Get locked badges
  List<Badge> getLockedBadges() {
    return badges.where((b) => !b.isUnlocked).toList();
  }

  /// Save player to Hive
  void save() {
    final box = Hive.box(AppConfig.userBox);
    if (kDebugMode) {
      print(
        '[DEBUG] Saving player data: level=$level, xp=$xp, badges=${badges.map((b) => b.toMap()).toList()}',
      );
    }
    box.put('level', level);
    box.put('xp', xp);
    box.put('xpToNext', xpToNext);
    box.put('username', username);
    box.put('avatarImagePath', avatarImagePath);
    box.put('unlockedBorders', unlockedBorders);
    box.put('selectedBorderId', selectedBorderId);
    box.put('badges', badges.map((e) => e.toMap()).toList());
    box.put('totalTasksCompleted', totalTasksCompleted);
    box.put('totalXpGained', totalXpGained);
    box.put('createdAt', createdAt.toIso8601String());
    box.put('lastActivityAt', lastActivityAt.toIso8601String());
    box.put('dailyTasksCompleted', dailyTasksCompleted);
    box.put('mainQuestsCompleted', mainQuestsCompleted);
    box.put('sideQuestsCompleted', sideQuestsCompleted);
    box.put('currentStreak', currentStreak);
    box.put('longestStreak', longestStreak);
  }

  /// Load player from Hive
  void load() {
    final box = Hive.box(AppConfig.userBox);
    level = box.get('level', defaultValue: 1) as int;
    xp = box.get('xp', defaultValue: 0) as int;
    xpToNext =
        box.get(
              'xpToNext',
              defaultValue:
                  AppConfig.baseXpToLevel + (level - 1) * AppConfig.xpIncrement,
            )
            as int;
    username = box.get('username', defaultValue: 'Adventurer') as String;
    avatarImagePath = box.get('avatarImagePath') as String?;
    final borderList =
        box.get('unlockedBorders', defaultValue: ['default']) as List?;
    if (borderList != null && borderList.isNotEmpty) {
      unlockedBorders = List<String>.from(borderList);
    } else {
      unlockedBorders = ['default'];
    }
    selectedBorderId =
        box.get('selectedBorderId', defaultValue: 'default') as String?;

    final badgesRaw = box.get('badges');
    if (kDebugMode) {
      print(
        '[DEBUG] Loading player data: level=${box.get('level')}, xp=${box.get('xp')}, badges=$badgesRaw',
      );
    }

    // Merge persisted unlock state (unlockedAt) onto the current default badge list.
    // This prevents:
    // - load crashes due to Map<dynamic,dynamic> coming from Hive
    // - losing unlocks when new badges are added in future versions
    final defaults = Badge.getDefaultBadges();
    final Map<String, Badge> persistedById = {};
    if (badgesRaw is List) {
      for (final entry in badgesRaw) {
        if (entry is Map) {
          final persisted = Badge.fromMap(entry);
          persistedById[persisted.id] = persisted;
        }
      }
    }
    badges = defaults.map((b) {
      final persisted = persistedById[b.id];
      return persisted?.unlockedAt != null
          ? b.copyWith(unlockedAt: persisted!.unlockedAt)
          : b;
    }).toList();

    totalTasksCompleted =
        box.get('totalTasksCompleted', defaultValue: 0) as int;
    totalXpGained = box.get('totalXpGained', defaultValue: 0) as int;
    createdAt = DateTime.parse(
      box.get('createdAt', defaultValue: DateTime.now().toIso8601String())
          as String,
    );
    lastActivityAt = DateTime.parse(
      box.get('lastActivityAt', defaultValue: DateTime.now().toIso8601String())
          as String,
    );
    dailyTasksCompleted =
        box.get('dailyTasksCompleted', defaultValue: 0) as int;
    mainQuestsCompleted =
        box.get('mainQuestsCompleted', defaultValue: 0) as int;
    sideQuestsCompleted =
        box.get('sideQuestsCompleted', defaultValue: 0) as int;
    currentStreak = box.get('currentStreak', defaultValue: 0) as int;
    longestStreak = box.get('longestStreak', defaultValue: 0) as int;
  }

  /// Reset progress (for settings)
  void resetProgress() {
    level = 1;
    xp = 0;
    xpToNext = AppConfig.baseXpToLevel;
    username = 'Adventurer';
    avatarImagePath = null;
    unlockedBorders = ['default'];
    selectedBorderId = 'default';
    badges = Badge.getDefaultBadges();
    totalTasksCompleted = 0;
    totalXpGained = 0;
    createdAt = DateTime.now();
    lastActivityAt = DateTime.now();
    dailyTasksCompleted = 0;
    mainQuestsCompleted = 0;
    sideQuestsCompleted = 0;
    currentStreak = 0;
    longestStreak = 0;
    save();
  }
}
