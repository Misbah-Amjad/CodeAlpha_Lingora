import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/learning_state.dart';
import '../services/tts_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/tactile_button.dart';

class SettingsSyncScreen extends StatefulWidget {
  final LearningState learningState;

  const SettingsSyncScreen({super.key, required this.learningState});

  @override
  State<SettingsSyncScreen> createState() => _SettingsSyncScreenState();
}

class _SettingsSyncScreenState extends State<SettingsSyncScreen> {
  final TtsService _tts = TtsService();

  void _showBackupDialog() async {
    final jsonString = await widget.learningState.exportBackupJson();
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;

        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: Row(
            children: [
              const Icon(Icons.cloud_download_rounded, color: AppColors.primary),
              const SizedBox(width: 10),
              Text(
                'Cloud Backup Package',
                style: AppTypography.getDisplayFont(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'JSON Snapshot formatted for Firebase Cloud Firestore / Storage:',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        jsonString,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: jsonString));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Backup JSON copied to clipboard!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              icon: const Icon(Icons.copy_rounded, size: 16),
              label: const Text('Copy to Clipboard'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _confirmResetData() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset All Data?'),
        content: const Text(
          'This will clear your local streak, mastered words, quiz records, and custom flashcards. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              Navigator.pop(ctx);
              await widget.learningState.resetAllData();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All data has been reset to defaults.'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: const Text('Reset All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progress = widget.learningState.progress;
    final lang = widget.learningState.selectedLanguage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Data Sync'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Backend & Cloud Sync Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.cloud_sync_rounded, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Backend Cloud Sync',
                              style: AppTypography.getDisplayFont(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Firebase Protocol & Local Offline Cache',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            progress.lastCloudSyncTime != null
                                ? 'Last synced: ${progress.lastCloudSyncTime!.month}/${progress.lastCloudSyncTime!.day} at ${progress.lastCloudSyncTime!.hour}:${progress.lastCloudSyncTime!.minute.toString().padLeft(2, '0')}'
                                : 'Ready to sync with cloud backend',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.learningState.lastSyncMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      widget.learningState.lastSyncMessage!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TactileButton(
                          onPressed: widget.learningState.isSyncing
                              ? null
                              : () => widget.learningState.syncWithCloud(),
                          backgroundColor: AppColors.primary,
                          height: 48,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.learningState.isSyncing)
                                const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              else ...[
                                const Icon(Icons.sync_rounded, color: Colors.white, size: 18),
                                const SizedBox(width: 8),
                                const Text('Sync with Cloud'),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton.filledTonal(
                        onPressed: _showBackupDialog,
                        icon: const Icon(Icons.code_rounded),
                        tooltip: 'Export JSON Backup',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Daily Goal Preference
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Learning Goal',
                    style: AppTypography.getDisplayFont(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select how many words you want to master every day.',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [5, 10, 15, 20].map((goal) {
                      final isSelected = progress.dailyGoalWords == goal;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            onTap: () => widget.learningState.setDailyGoal(goal),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : (isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  '$goal words',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected
                                        ? Colors.white
                                        : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Audio Speech Settings
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pronunciation Audio Settings',
                    style: AppTypography.getDisplayFont(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Adjust speaking pace and test audio output in ${lang.name}.',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Text('Pace:', style: TextStyle(fontWeight: FontWeight.w700)),
                      Expanded(
                        child: Slider(
                          value: _tts.speechRate,
                          min: 0.25,
                          max: 0.75,
                          divisions: 10,
                          label: '${(_tts.speechRate * 2).toStringAsFixed(1)}x',
                          activeColor: AppColors.primary,
                          onChanged: (val) {
                            setState(() {
                              _tts.setSpeechRate(val);
                            });
                          },
                        ),
                      ),
                      Text(
                        '${(_tts.speechRate * 2).toStringAsFixed(1)}x',
                        style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () {
                      _tts.speak(lang.greeting, locale: lang.ttsLocale);
                    },
                    icon: const Icon(Icons.volume_up_rounded, size: 18),
                    label: Text('Test Audio Voice: "${lang.greeting}"'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Danger Zone
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Management',
                    style: AppTypography.getDisplayFont(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Clear all offline progress, flashcard reviews, and custom words.',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: _confirmResetData,
                    icon: const Icon(Icons.delete_forever_rounded, color: AppColors.error, size: 18),
                    label: const Text('Reset All Local Learning Data', style: TextStyle(color: AppColors.error)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
