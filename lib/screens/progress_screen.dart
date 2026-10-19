import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/learning_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class ProgressScreen extends StatelessWidget {
  final LearningState learningState;

  const ProgressScreen({super.key, required this.learningState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progress = learningState.progress;
    final allItems = learningState.currentVocabItems;
    final masteredCount = allItems.where((i) => i.isLearned).length;
    final totalCount = allItems.length;

    // Quiz stats calculation
    final quizResults = progress.recentQuizResults;
    final totalQuizzes = quizResults.length;
    final avgScore = totalQuizzes > 0
        ? (quizResults.map((q) => q.scorePercentage).reduce((a, b) => a + b) / totalQuizzes).round()
        : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Level & XP Progress Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'LEVEL ${progress.level}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Text('💎 ', style: TextStyle(fontSize: 16)),
                      Text(
                        '${progress.totalXp} Total XP',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    progress.levelTitle,
                    style: AppTypography.getDisplayFont(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${progress.currentLevelXp} / 100 XP to Level ${progress.level + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress.levelProgressFraction,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 7,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Metrics Grid
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    isDark: isDark,
                    emoji: '🔥',
                    value: '${progress.streakDays}',
                    unit: 'Days',
                    label: 'Daily Streak',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricTile(
                    isDark: isDark,
                    emoji: '🧠',
                    value: '$masteredCount',
                    unit: '/ $totalCount',
                    label: 'Mastered Words',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricTile(
                    isDark: isDark,
                    emoji: '🎯',
                    value: '$avgScore%',
                    unit: 'Avg',
                    label: 'Quiz Accuracy',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Category Mastery Rates
            Text(
              'Mastery Rate by Category',
              style: AppTypography.getDisplayFont(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),

            ...LearningCategory.allCategories.map((cat) {
              final catItems = learningState.getItemsByCategory(cat.type);
              final learnedInCat = catItems.where((i) => i.isLearned).length;
              final fraction = catItems.isNotEmpty ? (learnedInCat / catItems.length) : 0.0;
              final percent = (fraction * 100).round();

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(cat.icon, size: 18, color: cat.primaryColor),
                        const SizedBox(width: 10),
                        Text(
                          cat.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$learnedInCat / ${catItems.length} ($percent%)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: cat.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: fraction,
                        backgroundColor: isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt,
                        valueColor: AlwaysStoppedAnimation<Color>(cat.primaryColor),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            // Quiz History List
            if (quizResults.isNotEmpty) ...[
              Text(
                'Complete Quiz History',
                style: AppTypography.getDisplayFont(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ...quizResults.map((q) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: q.scorePercentage >= 70
                              ? AppColors.success.withValues(alpha: 0.15)
                              : AppColors.error.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${q.scorePercentage}%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: q.scorePercentage >= 70 ? AppColors.success : AppColors.error,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${q.correctAnswers} / ${q.totalQuestions} Questions Correct',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              '${q.timestamp.year}-${q.timestamp.month.toString().padLeft(2, '0')}-${q.timestamp.day.toString().padLeft(2, '0')} ${q.timestamp.hour.toString().padLeft(2, '0')}:${q.timestamp.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '+${q.xpEarned} XP',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.accentGold,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required bool isDark,
    required String emoji,
    required String value,
    required String unit,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: AppTypography.getDisplayFont(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
