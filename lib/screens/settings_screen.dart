import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/game_provider.dart';
import '../services/settings_service.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<SettingsService, GameProvider, AuthProvider>(
      builder: (context, settingsService, gameProvider, authProvider, _) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display settings
              Text('Display', style: AppTextStyles.heading3),
              SizedBox(height: 12),
              _buildSwitchTile(
                label: 'Dark Mode',
                value: settingsService.isDarkMode,
                onChanged: (value) async {
                  await settingsService.setDarkMode(value);
                },
              ),
              SizedBox(height: 24),
              // Sound & Notifications
              Text('Sound & Notifications', style: AppTextStyles.heading3),
              SizedBox(height: 12),
              _buildSwitchTile(
                label: 'Sound Effects',
                value: settingsService.soundEnabled,
                onChanged: (value) async {
                  await settingsService.setSoundEnabled(value);
                },
              ),
              SizedBox(height: 12),
              _buildSwitchTile(
                label: 'Notifications',
                value: settingsService.notificationsEnabled,
                onChanged: (value) async {
                  await settingsService.setNotificationsEnabled(value);
                },
              ),
              SizedBox(height: 24),
              // Language
              Text('Language', style: AppTextStyles.heading3),
              SizedBox(height: 12),
              _buildLanguageDropdown(settingsService),
              SizedBox(height: 24),
              // Profile settings
              Text('Profile', style: AppTextStyles.heading3),
              SizedBox(height: 12),
              Card(
                child: ListTile(
                  title: Text('Username'),
                  subtitle: Text(gameProvider.player.username),
                  trailing: Icon(Icons.edit),
                  onTap: () => _showEditUsernameDialog(context, gameProvider),
                ),
              ),
              SizedBox(height: 24),
              // Danger Zone
              Text(
                'Danger Zone',
                style: AppTextStyles.heading3.copyWith(color: AppColors.error),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      _showResetConfirmation(context, gameProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                  ),
                  child: Text('Reset All Progress'),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: authProvider.isLoading
                      ? null
                      : () async {
                          await authProvider.signOut();
                          if (!context.mounted) return;
                          Navigator.of(
                            context,
                          ).pushNamedAndRemoveUntil('/sign-in', (_) => false);
                        },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(color: AppColors.error),
                  ),
                  child: Text('Sign Out'),
                ),
              ),
              SizedBox(height: 24),
              // About
              Center(
                child: Column(
                  children: [
                    Text('Solo Leveling', style: AppTextStyles.heading3),
                    SizedBox(height: 4),
                    Text(
                      'v1.0.0',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textMuted,
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

  Widget _buildSwitchTile({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Switch(value: value, onChanged: onChanged),
      ),
    );
  }

  Widget _buildLanguageDropdown(SettingsService settingsService) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: DropdownButton<String>(
          value: settingsService.language,
          isExpanded: true,
          underline: SizedBox(),
          onChanged: (String? newValue) async {
            if (newValue != null) {
              await settingsService.setLanguage(newValue);
            }
          },
          items: [
            DropdownMenuItem(value: 'en', child: Text('English')),
            DropdownMenuItem(value: 'es', child: Text('Spanish')),
            DropdownMenuItem(value: 'fr', child: Text('French')),
            DropdownMenuItem(value: 'de', child: Text('German')),
            DropdownMenuItem(value: 'ja', child: Text('Japanese')),
          ],
        ),
      ),
    );
  }

  void _showEditUsernameDialog(
    BuildContext context,
    GameProvider gameProvider,
  ) {
    final controller = TextEditingController(
      text: gameProvider.player.username,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Username'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Enter new username'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                gameProvider.updateUsername(controller.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Username updated')));
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Progress?'),
        content: Text(
          'This will reset your level, XP, badges, and all progress. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              gameProvider.resetProgress();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Progress has been reset')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }
}
