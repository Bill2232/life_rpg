import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/xp_bar.dart';
import '../widgets/task_card.dart';
import 'badges_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';

enum _TaskFilter { all, daily, main, side }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentTabIndex = 0;
  _TaskFilter _taskFilter = _TaskFilter.all;

  late AnimationController levelController;
  late Animation<double> levelAnim;

  @override
  void initState() {
    super.initState();
    levelController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    levelAnim = Tween<double>(
      begin: 1,
      end: 1.2,
    ).animate(CurvedAnimation(parent: levelController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    levelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 100,
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: EdgeInsets.only(left: 12, top: 8, right: 12),
              child: _buildProfileHeader(gameProvider),
            ),
          ),
          body: _buildBody(gameProvider),
          floatingActionButton: _currentTabIndex == 0
              ? FloatingActionButton(
                  onPressed: () => _showAddTaskDialog(context, gameProvider),
                  child: Icon(Icons.add),
                )
              : null,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentTabIndex,
            onTap: (index) {
              setState(() {
                _currentTabIndex = index;
                if (_currentTabIndex != 0) {
                  _taskFilter = _TaskFilter.all;
                }
              });
            },
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textMuted,
            backgroundColor: Theme.of(context).colorScheme.surface,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Tasks'),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Stats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.emoji_events),
                label: 'Badges',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(GameProvider gameProvider) {
    return switch (_currentTabIndex) {
      0 => _buildTasksTab(gameProvider),
      1 => StatsScreen(),
      2 => BadgesScreen(),
      3 => SettingsScreen(),
      _ => _buildTasksTab(gameProvider),
    };
  }

  Widget _buildTasksTab(GameProvider gameProvider) {
    if (gameProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final visibleTasks = switch (_taskFilter) {
      _TaskFilter.all => gameProvider.tasks,
      _TaskFilter.daily => gameProvider.dailyTasks,
      _TaskFilter.main => gameProvider.mainQuests,
      _TaskFilter.side => gameProvider.sideTasks,
    };

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Task type tabs
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.bgDarkSecondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildTabButton(
                  'All',
                  gameProvider.tasks.length,
                  isSelected: _taskFilter == _TaskFilter.all,
                  onTap: () => setState(() => _taskFilter = _TaskFilter.all),
                ),
                _buildTabButton(
                  'Daily',
                  gameProvider.dailyTasks.length,
                  isSelected: _taskFilter == _TaskFilter.daily,
                  onTap: () => setState(() => _taskFilter = _TaskFilter.daily),
                ),
                _buildTabButton(
                  'Main',
                  gameProvider.mainQuests.length,
                  isSelected: _taskFilter == _TaskFilter.main,
                  onTap: () => setState(() => _taskFilter = _TaskFilter.main),
                ),
                _buildTabButton(
                  'Side',
                  gameProvider.sideTasks.length,
                  isSelected: _taskFilter == _TaskFilter.side,
                  onTap: () => setState(() => _taskFilter = _TaskFilter.side),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Task list or empty state
          Expanded(
            child: visibleTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('📋 No tasks yet', style: AppTextStyles.heading2),
                        SizedBox(height: 12),
                        Text(
                          'Add your first quest to begin your journey',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: visibleTasks.length,
                    itemBuilder: (context, index) {
                      final task = visibleTasks[index];
                      return TaskCard(
                        task: task,
                        onComplete: () => gameProvider.completeTask(task),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    String label,
    int count, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: isSelected
            ? AppColors.primary.withAlpha(26)
            : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text('$label ($count)', style: AppTextStyles.label),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddTaskDialog(
    BuildContext context,
    GameProvider gameProvider,
  ) async {
    final titleController = TextEditingController();
    final xpController = TextEditingController(text: '25');
    var selectedType = TaskType.daily;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Quest'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Quest title'),
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<TaskType>(
                initialValue: selectedType,
                decoration: InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(value: TaskType.daily, child: Text('Daily')),
                  DropdownMenuItem(
                    value: TaskType.main,
                    child: Text('Main Quest'),
                  ),
                  DropdownMenuItem(
                    value: TaskType.side,
                    child: Text('Side Quest'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) selectedType = value;
                },
              ),
              SizedBox(height: 12),
              TextField(
                controller: xpController,
                decoration: InputDecoration(labelText: 'XP Reward'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final xp = int.tryParse(xpController.text.trim()) ?? 0;

                if (title.isEmpty || xp <= 0) {
                  return;
                }

                gameProvider.addTask(
                  Task(title: title, type: selectedType, xp: xp),
                );
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileHeader(GameProvider gameProvider) {
    final player = gameProvider.player;
    return Container(
      padding: EdgeInsets.fromLTRB(9, 8, 20, 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(26),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.primary.withAlpha(77)),
      ),
      constraints: BoxConstraints(maxWidth: 520),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _showAvatarOptions(context, gameProvider),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary.withAlpha(26),
                  backgroundImage:
                      player.avatarImagePath != null &&
                          player.avatarImagePath!.isNotEmpty
                      ? FileImage(File(player.avatarImagePath!))
                            as ImageProvider
                      : (player.getAvatar().isNotEmpty
                            ? AssetImage(player.getAvatar())
                            : null),
                  child:
                      player.avatarImagePath == null &&
                          player.getAvatar().isEmpty
                      ? Icon(Icons.person, color: AppColors.textMuted)
                      : null,
                ),
                if (player.selectedBorderId != null &&
                    player.selectedBorderId != 'default')
                  Image.asset(
                    'assets/avatars/${player.selectedBorderId}-rank.png',
                    width: 76,
                    height: 76,
                    fit: BoxFit.contain,
                  ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      player.username,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      player.getTitle(),
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textMuted,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                XPBar(xp: player.xp, max: player.xpToNext),
              ],
            ),
          ),
          SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: levelAnim,
                child: Text(
                  '${player.level}',
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'LEVEL',
                style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAvatarOptions(BuildContext context, GameProvider gameProvider) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Take Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                    maxWidth: 800,
                    maxHeight: 800,
                    imageQuality: 85,
                  );
                  if (picked != null) {
                    await gameProvider.setAvatarImagePath(picked.path);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 800,
                    maxHeight: 800,
                    imageQuality: 85,
                  );
                  if (picked != null) {
                    await gameProvider.setAvatarImagePath(picked.path);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.border_all),
                title: Text('Select Border'),
                onTap: () {
                  Navigator.pop(context);
                  _showBorderSelector(context, gameProvider);
                },
              ),
              ListTile(
                leading: Icon(Icons.close),
                title: Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBorderSelector(BuildContext context, GameProvider gameProvider) {
    final borders = [
      {'id': 'default', 'name': 'Default'},
      {'id': 'wood', 'name': 'Wood'},
      {'id': 'iron', 'name': 'Iron'},
      {'id': 'bronz', 'name': 'Bronze'},
      {'id': 'silver', 'name': 'Silver'},
      {'id': 'gold', 'name': 'Gold'},
      {'id': 'champion', 'name': 'Champion'},
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Choose Border', style: AppTextStyles.heading3),
                SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  children: borders.map((b) {
                    final id = b['id']!;
                    final unlocked = gameProvider.player.unlockedBorders
                        .contains(id);
                    return GestureDetector(
                      onTap: unlocked
                          ? () => gameProvider.selectBorder(id)
                          : null,
                      child: Opacity(
                        opacity: unlocked ? 1.0 : 0.35,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 64,
                              height: 64,
                              child: id == 'default'
                                  ? CircleAvatar(
                                      radius: 32,
                                      backgroundColor: AppColors.bgDark,
                                    )
                                  : Image.asset(
                                      'assets/avatars/$id-rank.png',
                                      fit: BoxFit.contain,
                                    ),
                            ),
                            SizedBox(height: 6),
                            Text(b['name']!, style: AppTextStyles.label),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 12),
                Text('Locked borders unlock as you level up.'),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Done'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
