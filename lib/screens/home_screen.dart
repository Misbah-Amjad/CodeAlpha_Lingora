import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/learning_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/category_card.dart';
import '../widgets/custom_word_dialog.dart';
import '../widgets/tactile_button.dart';

class HomeScreen extends StatelessWidget {
  final LearningState learningState;
  final Function(int tabIndex) onNavigateTab;
  final Function(CategoryType category)? onSelectCategory;

  const HomeScreen({
    super.key,
    required this.learningState,
    required this.onNavigateTab,
    this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progress = learningState.progress;
    final lang = learningState.selectedLanguage;
    final allItems = learningState.currentVocabItems;
    final lessons = learningState.currentLessons;

    // Next uncompleted lesson or first lesson
    final nextLesson = lessons.firstWhere(
      (l) => !l.isCompleted,
      orElse: () => lessons.isNotEmpty ? lessons.first : lessons.first,
    );

    final dailyGoalProgress = (progress.wordsLearnedToday / progress.dailyGoalWords).clamp(0.0, 1.0);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Greeting Card
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(lang.flagEmoji, style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 6),
                            Text(
                              lang.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () => learningState.pronounce(lang.greeting),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.volume_up_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    lang.greeting,
                    style: AppTypography.getDisplayFont(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ready to continue your language journey today?',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Daily Goal & Streak Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.accentGold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Text('🎯', style: TextStyle(fontSize: 22)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daily Word Goal',
                              style: AppTypography.getDisplayFont(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${progress.wordsLearnedToday} of ${progress.dailyGoalWords} words mastered today',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${(dailyGoalProgress * 100).round()}%',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: dailyGoalProgress,
                      backgroundColor: isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text('🔥 ', style: TextStyle(fontSize: 14)),
                          Text(
                            '${progress.streakDays}-day streak',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('🏆 ', style: TextStyle(fontSize: 14)),
                          Text(
                            progress.levelTitle,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Recommended Lesson Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1.4,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'DAY ${nextLesson.dayNumber} LESSON',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.secondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined, size: 14, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            '${nextLesson.estimatedMinutes}m',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.stars_rounded, size: 14, color: AppColors.accentGold),
                          const SizedBox(width: 4),
                          Text(
                            '+${nextLesson.xpReward} XP',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.accentGold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    nextLesson.title,
                    style: AppTypography.getDisplayFont(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    nextLesson.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TactileButton(
                    onPressed: () => onNavigateTab(1), // Go to Lessons tab
                    backgroundColor: AppColors.primary,
                    height: 46,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          nextLesson.isCompleted ? Icons.replay_rounded : Icons.play_arrow_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          nextLesson.isCompleted ? 'Review Lesson' : 'Start Today\'s Lesson',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Quick Actions Row
            Row(
              children: [
                Expanded(
                  child: _buildActionTile(
                    context: context,
                    icon: Icons.style_rounded,
                    color: AppColors.primary,
                    title: 'Flashcards',
                    subtitle: '${allItems.length} cards',
                    onTap: () => onNavigateTab(2), // Flashcards tab
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildActionTile(
                    context: context,
                    icon: Icons.quiz_rounded,
                    color: AppColors.secondary,
                    title: 'Take Quiz',
                    subtitle: 'Test progress',
                    onTap: () => onNavigateTab(3), // Quizzes tab
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildActionTile(
                    context: context,
                    icon: Icons.add_circle_outline_rounded,
                    color: AppColors.accentGold,
                    title: 'Add Word',
                    subtitle: 'Custom card',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => CustomWordDialog(learningState: learningState),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Categories Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Explore by Category',
                  style: AppTypography.getDisplayFont(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () => onNavigateTab(4), // Vocabulary tab
                  child: const Text('View All', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Category Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                final ratio = constraints.maxWidth > 400 ? 1.15 : 1.08;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: ratio,
                  ),
                  itemCount: LearningCategory.allCategories.length,
                  itemBuilder: (context, index) {
                    final cat = LearningCategory.allCategories[index];
                    final catItems = learningState.getItemsByCategory(cat.type);
                    final masteredInCat = catItems.where((i) => i.isLearned).length;

                    return CategoryCard(
                      category: cat,
                      totalWords: catItems.length,
                      masteredWords: masteredInCat,
                      onTap: () {
                        if (onSelectCategory != null) {
                          onSelectCategory!(cat.type);
                        } else {
                          onNavigateTab(4); // Go to vocabulary explorer
                        }
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
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
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.getDisplayFont(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
