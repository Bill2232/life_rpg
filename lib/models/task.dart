enum TaskType { main, daily, side }

class Task {
  String title;
  TaskType type;
  int xp;
  bool completed;
  int streak;

  Task({
    required this.title,
    required this.type,
    required this.xp,
    this.completed = false,
    this.streak = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type.index,
      'xp': xp,
      'completed': completed,
      'streak': streak,
    };
  }

  static Task fromMap(Map map) {
    final data = Map<String, dynamic>.from(map);
    return Task(
      title: (data['title'] ?? '') as String,
      type: TaskType.values[(data['type'] as num).toInt()],
      xp: (data['xp'] as num).toInt(),
      completed: (data['completed'] as bool?) ?? false,
      streak: (data['streak'] as num?)?.toInt() ?? 0,
    );
  }
}
