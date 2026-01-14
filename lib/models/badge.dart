/// Badge definitions for the gamification system
class Badge {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  final int requiredLevel;
  final int? requiredXp;
  final DateTime? unlockedAt;

  Badge({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.requiredLevel,
    this.requiredXp,
    this.unlockedAt,
  });

  bool get isUnlocked => unlockedAt != null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconPath': iconPath,
      'requiredLevel': requiredLevel,
      'requiredXp': requiredXp,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  static Badge fromMap(Map<String, dynamic> map) {
    return Badge(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      iconPath: map['iconPath'] as String,
      requiredLevel: map['requiredLevel'] as int,
      requiredXp: map['requiredXp'] as int?,
      unlockedAt: map['unlockedAt'] != null
          ? DateTime.parse(map['unlockedAt'] as String)
          : null,
    );
  }

  Badge copyWith({
    String? id,
    String? title,
    String? description,
    String? iconPath,
    int? requiredLevel,
    int? requiredXp,
    DateTime? unlockedAt,
  }) {
    return Badge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      requiredLevel: requiredLevel ?? this.requiredLevel,
      requiredXp: requiredXp ?? this.requiredXp,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  /// Default badges for the game
  static List<Badge> getDefaultBadges() {
    return [
      Badge(
        id: 'first_step',
        title: 'First Step',
        description: 'Complete your first task',
        iconPath: '🎯',
        requiredLevel: 1,
        requiredXp: 0,
      ),
      Badge(
        id: 'first_growth',
        title: 'First Growth',
        description: 'Reach Level 2',
        iconPath: '🌱',
        requiredLevel: 2,
      ),
      Badge(
        id: 'disciplined',
        title: 'Disciplined',
        description: 'Reach Level 5',
        iconPath: '💪',
        requiredLevel: 5,
      ),
      Badge(
        id: 'relentless',
        title: 'Relentless',
        description: 'Reach Level 10',
        iconPath: '🔥',
        requiredLevel: 10,
      ),
      Badge(
        id: 'legend',
        title: 'Legend',
        description: 'Reach Level 20',
        iconPath: '👑',
        requiredLevel: 20,
      ),
      Badge(
        id: 'streak_master',
        title: 'Streak Master',
        description: 'Maintain a 30-day streak',
        iconPath: '⚡',
        requiredLevel: 1,
      ),
      Badge(
        id: 'daily_warrior',
        title: 'Daily Warrior',
        description: 'Complete 100 daily tasks',
        iconPath: '⚔️',
        requiredLevel: 1,
      ),
      Badge(
        id: 'quest_master',
        title: 'Quest Master',
        description: 'Complete 50 main quests',
        iconPath: '🏆',
        requiredLevel: 5,
      ),
    ];
  }
}
