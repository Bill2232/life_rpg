import 'package:flutter/material.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final VoidCallback onComplete;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const TaskCard({
    super.key,
    required this.task,
    required this.onComplete,
    this.onDelete,
    this.onEdit,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleComplete() {
    _controller.forward().then((_) {
      widget.onComplete();
    });
  }

  Color _getTaskColor() {
    if (widget.task.completed) return AppColors.success;
    return switch (widget.task.type) {
      TaskType.main => AppColors.accent,
      TaskType.daily => AppColors.primary,
      TaskType.side => AppColors.textMuted,
    };
  }

  String _getTaskIcon() {
    return switch (widget.task.type) {
      TaskType.main => '⚔️',
      TaskType.daily => '📋',
      TaskType.side => '🎯',
    };
  }

  String _getTaskTypeLabel() {
    return switch (widget.task.type) {
      TaskType.main => 'Main Quest',
      TaskType.daily => 'Daily',
      TaskType.side => 'Side Quest',
    };
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: InkWell(
          onTap: widget.task.completed ? null : _handleComplete,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                // Task type icon and checkbox
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getTaskColor().withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: widget.task.completed
                        ? Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 28,
                          )
                        : Text(_getTaskIcon(), style: TextStyle(fontSize: 24)),
                  ),
                ),
                SizedBox(width: 12),
                // Task details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.task.title,
                        style: AppTextStyles.body1.copyWith(
                          decoration: widget.task.completed
                              ? TextDecoration.lineThrough
                              : null,
                          color: widget.task.completed
                              ? AppColors.textMuted
                              : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          // Task type badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getTaskColor().withAlpha(38),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _getTaskTypeLabel(),
                              style: AppTextStyles.label.copyWith(
                                color: _getTaskColor(),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          // XP display
                          Text(
                            '${widget.task.xp} XP',
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // Streak display for daily tasks
                          if (widget.task.type == TaskType.daily &&
                              widget.task.streak > 0) ...[
                            SizedBox(width: 8),
                            Text(
                              '🔥 ${widget.task.streak}',
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.warning,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Action buttons
                if (!widget.task.completed)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: ElevatedButton(
                          onPressed: _handleComplete,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: _getTaskColor(),
                          ),
                          child: Icon(Icons.check, size: 18),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
