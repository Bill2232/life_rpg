import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onComplete;

  const TaskCard({super.key, required this.task, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(task.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (task.type == TaskType.main)
              Text("Main Quest", style: TextStyle(color: Colors.orange)),
            Text("${task.xp} XP | Streak: ${task.streak}"),
          ],
        ),
        trailing: task.completed
            ? Icon(Icons.check, color: Colors.green)
            : ElevatedButton(onPressed: onComplete, child: Text("Complete")),
      ),
    );
  }
}
