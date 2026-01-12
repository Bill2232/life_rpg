import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/player.dart';
import '../screens/badges_screen.dart';
import '../models/task.dart';
import '../widgets/xp_bar.dart';
import '../widgets/task_card.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Player player = Player();

  AudioPlayer? audioPlayer;

  late AnimationController levelController;
  late Animation<double> levelAnim;

  List<Task> tasks = [
    Task(title: "No porn today", type: TaskType.daily, xp: 40),
    Task(title: "Make bed", type: TaskType.daily, xp: 10),
    Task(title: "Workout", type: TaskType.daily, xp: 30),

    Task(title: "Build first app feature", type: TaskType.main, xp: 120),
    Task(title: "Apply for one job", type: TaskType.main, xp: 150),

    Task(title: "Clean litter box", type: TaskType.side, xp: 15),
  ];

  String today = DateTime.now().toIso8601String().substring(0, 10);

  @override
  void initState() {
    super.initState();
    player.load();
    loadTasks();
    resetIfNewDay();
    dailyReminder();

    levelController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    levelAnim = Tween<double>(
      begin: 1,
      end: 1.2,
    ).animate(CurvedAnimation(parent: levelController, curve: Curves.easeOut));
  }

  void completeTask(Task task) {
    if (task.completed) return;

    setState(() {
      if (task.type == TaskType.main && player.level < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Main quest locked. Reach Level 2.")),
        );
        return;
      }

      task.completed = true;

      int oldLevel = player.level;

      if (task.type == TaskType.daily) {
        task.streak++;
        int gained = task.xp + task.streak * 5;
        player.addXP(gained);
      } else {
        player.addXP(task.xp);
      }

      if (player.level > oldLevel) {
        (audioPlayer ??= AudioPlayer()).play(
          AssetSource('sounds/level_up.mp3'),
        );
      }

      if (player.level == 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Achievement Unlocked: First Growth")),
        );
      }

      player.save();
      saveTasks();
    });

    NotificationService.showNotification(
      "Quest Completed",
      "${task.title} finished. XP gained.",
    );
  }

  void saveTasks() {
    final box = Hive.box('gameBox');
    box.put('tasks', tasks.map((e) => e.toMap()).toList());
    box.put('lastDate', today);
  }

  void loadTasks() {
    final box = Hive.box('gameBox');
    final saved = box.get('tasks');

    if (saved != null) {
      tasks = List<Map>.from(saved).map((e) => Task.fromMap(e)).toList();
    }
  }

  void streakWarning(Task task) {
    if (task.type == TaskType.daily && task.streak > 0) {
      NotificationService.showNotification(
        "Streak Warning",
        "${task.title} streak will reset if skipped today.",
      );
    }
  }

  void dailyReminder() {
    NotificationService.showNotification(
      "Daily Quest Reminder",
      "Your quests are waiting. No XP earns itself.",
    );
  }

  void resetIfNewDay() {
    final box = Hive.box('gameBox');
    String? lastDate = box.get('lastDate');

    if (lastDate != today) {
      for (var task in tasks) {
        if (task.type == TaskType.daily) {
          streakWarning(task);
          if (!task.completed) {
            task.streak = 0;
            player.xp -= 20;
            if (player.xp < 0) player.xp = 0;
          }
          task.completed = false;
        }
      }
      box.put('lastDate', today);
      saveTasks();
      player.save();
    }
  }

  @override
  void dispose() {
    levelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Life RPG")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ScaleTransition(
              scale: levelAnim,
              child: Text(
                "Level ${player.level} — ${player.getTitle()}",
                style: TextStyle(fontSize: 22),
              ),
            ),
            SizedBox(height: 8),
            Image.asset(player.getAvatar(), height: 100),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BadgesScreen()),
                );
              },
              child: Text("View Badges"),
            ),
            XPBar(xp: player.xp, max: player.xpToNext),
            SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: tasks.map((task) {
                  return TaskCard(
                    task: task,
                    onComplete: () => completeTask(task),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
