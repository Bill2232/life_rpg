import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../providers/game_provider.dart';
import '../theme/app_theme.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        final player = gameProvider.player;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overview cards
              _buildStatCard(
                label: 'Total Level',
                value: '${player.level}',
                icon: '👑',
              ),
              SizedBox(height: 12),
              _buildStatCard(
                label: 'Total XP Gained',
                value: '${player.totalXpGained}',
                icon: '⭐',
              ),
              SizedBox(height: 12),
              _buildStatCard(
                label: 'Current Streak',
                value: '${player.currentStreak}',
                icon: '🔥',
              ),
              SizedBox(height: 12),
              _buildStatCard(
                label: 'Longest Streak',
                value: '${player.longestStreak}',
                icon: '🏆',
              ),
              SizedBox(height: 24),
              // Task statistics
              Text('Task Statistics', style: AppTextStyles.heading3),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMiniStatCard(
                      label: 'Daily Tasks',
                      value: '${player.dailyTasksCompleted}',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildMiniStatCard(
                      label: 'Main Quests',
                      value: '${player.mainQuestsCompleted}',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildMiniStatCard(
                      label: 'Side Quests',
                      value: '${player.sideQuestsCompleted}',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _buildMiniStatCard(
                label: 'Total Tasks Completed',
                value: '${player.totalTasksCompleted}',
              ),
              SizedBox(height: 24),
              // Weekly chart
              Text('Weekly Performance', style: AppTextStyles.heading3),
              SizedBox(height: 12),
              _buildWeeklyChart(player.totalTasksCompleted),
              SizedBox(height: 24),
              // Account info
              Text('Account', style: AppTextStyles.heading3),
              SizedBox(height: 12),
              _buildInfoRow(
                'Member Since',
                DateFormat('MMM dd, yyyy').format(player.createdAt),
              ),
              _buildInfoRow(
                'Last Active',
                DateFormat(
                  'MMM dd, yyyy - HH:mm',
                ).format(player.lastActivityAt),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required String icon,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Text(icon, style: TextStyle(fontSize: 32)),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                SizedBox(height: 4),
                Text(value, style: AppTextStyles.heading2),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStatCard({required String label, required String value}) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.heading3.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body2),
          Text(
            value,
            style: AppTextStyles.body2.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(int totalTasks) {
    // Mock data - in production, track daily task completions
    final weekData = [
      FlSpot(0, totalTasks > 0 ? (totalTasks * 0.15).toDouble() : 0),
      FlSpot(1, totalTasks > 0 ? (totalTasks * 0.25).toDouble() : 0),
      FlSpot(2, totalTasks > 0 ? (totalTasks * 0.20).toDouble() : 0),
      FlSpot(3, totalTasks > 0 ? (totalTasks * 0.30).toDouble() : 0),
      FlSpot(4, totalTasks > 0 ? (totalTasks * 0.35).toDouble() : 0),
      FlSpot(5, totalTasks > 0 ? (totalTasks * 0.40).toDouble() : 0),
      FlSpot(6, totalTasks > 0 ? (totalTasks * 0.25).toDouble() : 0),
    ];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const days = [
                      'Mon',
                      'Tue',
                      'Wed',
                      'Thu',
                      'Fri',
                      'Sat',
                      'Sun',
                    ];
                    return Text(
                      days[value.toInt()],
                      style: AppTextStyles.label,
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: weekData,
                isCurved: true,
                color: AppColors.primary,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColors.primary.withAlpha(26),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
