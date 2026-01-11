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
    return Task(
      title: map['title'],
      type: TaskType.values[map['type']],
      xp: map['xp'],
      completed: map['completed'],
      streak: map['streak'] ?? 0,
    );
  }
}
