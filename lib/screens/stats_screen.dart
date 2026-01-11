import 'package:flutter/material.dart';
import '../widgets/weekly_graph.dart';

class StatsScreen extends StatelessWidget {
  final int level;
  final int xp;

  const StatsScreen({super.key, required this.level, required this.xp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stats")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Level: $level"),
            Text("Total XP: $xp"),
            SizedBox(height: 20),
            WeeklyGraph(
              [10, 20, 30, 25, 40, 35, 50].map((e) => e.toDouble()).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
