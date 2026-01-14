import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/game_provider.dart';
import '../theme/app_theme.dart';

class BadgesScreen extends StatefulWidget {
  const BadgesScreen({super.key});

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        final unlockedBadges = gameProvider.player.getUnlockedBadges();
        final lockedBadges = gameProvider.player.getLockedBadges();

        return SingleChildScrollView(
          child: Column(
            children: [
              // Header with badge count
              Container(
                padding: EdgeInsets.all(16),
                color: AppColors.primary.withAlpha(26),
                child: Column(
                  children: [
                    Text('🏆 Badges', style: AppTextStyles.heading2),
                    SizedBox(height: 12),
                    Text(
                      '${unlockedBadges.length} of ${gameProvider.player.badges.length} Unlocked',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value:
                            unlockedBadges.length /
                            gameProvider.player.badges.length,
                        minHeight: 8,
                        backgroundColor: AppColors.border.withAlpha(77),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Tab bar
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textMuted,
                indicatorColor: AppColors.primary,
                tabs: [
                  Tab(text: 'Unlocked (${unlockedBadges.length})'),
                  Tab(text: 'Locked (${lockedBadges.length})'),
                ],
              ),
              // Tab content
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Unlocked badges
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: unlockedBadges.isEmpty
                          ? Center(
                              child: Text(
                                'No badges unlocked yet.\nStart completing tasks!',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.body1.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            )
                          : GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                              itemCount: unlockedBadges.length,
                              itemBuilder: (context, index) {
                                final badge = unlockedBadges[index];
                                return _buildBadgeCard(badge, unlocked: true);
                              },
                            ),
                    ),
                    // Locked badges
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: lockedBadges.isEmpty
                          ? Center(
                              child: Text(
                                'All badges unlocked!\nYou are a legend!',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.body1.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            )
                          : GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                              itemCount: lockedBadges.length,
                              itemBuilder: (context, index) {
                                final badge = lockedBadges[index];
                                return _buildBadgeCard(badge, unlocked: false);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBadgeCard(dynamic badge, {required bool unlocked}) {
    return GestureDetector(
      onTap: () => _showBadgeDetail(context, badge),
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: unlocked
                ? AppColors.primary.withAlpha(26)
                : AppColors.textMuted.withAlpha(26),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      badge.iconPath,
                      style: TextStyle(fontSize: unlocked ? 48 : 32),
                      textScaler: TextScaler.linear(unlocked ? 1.0 : 0.3),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        badge.title,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.label.copyWith(
                          fontWeight: FontWeight.w600,
                          color: unlocked
                              ? AppColors.primary
                              : AppColors.textMuted,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (unlocked)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBadgeDetail(BuildContext context, dynamic badge) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(badge.iconPath, style: TextStyle(fontSize: 64)),
            SizedBox(height: 16),
            Text(badge.title, style: AppTextStyles.heading2),
            SizedBox(height: 12),
            Text(
              badge.description,
              style: AppTextStyles.body1.copyWith(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            if (badge.unlockedAt != null) ...[
              Text(
                'Unlocked on ${DateFormat('MMM dd, yyyy').format(badge.unlockedAt!)}',
                style: AppTextStyles.label.copyWith(color: AppColors.success),
              ),
            ] else ...[
              Text(
                'Unlock at Level ${badge.requiredLevel}',
                style: AppTextStyles.label.copyWith(color: AppColors.warning),
              ),
            ],
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
