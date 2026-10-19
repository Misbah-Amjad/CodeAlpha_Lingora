import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/lesson.dart';
import '../services/learning_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/audio_speaker_button.dart';
import '../widgets/tactile_button.dart';

class LessonsScreen extends StatefulWidget {
  final LearningState learningState;

  const LessonsScreen({super.key, required this.learningState});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _openLessonDetails(DailyLesson lesson) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _LessonStudySheet(
        lesson: lesson,
        learningState: widget.learningState,
        confettiController: _confettiController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lessons = widget.learningState.currentLessons;
    final currentLang = widget.learningState.selectedLanguage;

    final completedCount = lessons.where((l) => l.isCompleted).length;
    final progressFraction = lessons.isNotEmpty ? (completedCount / lessons.length) : 0.0;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Syllabus Banner
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
                          Text(
                            'Daily Curriculum',
                            style: AppTypography.getDisplayFont(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$completedCount / ${lessons.length} Completed',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Follow step-by-step daily modules designed to establish natural fluency in ${currentLang.name}.',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progressFraction,
                          backgroundColor: isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          minHeight: 7,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Lessons Timeline List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = lessons[index];
                    final catInfo = LearningCategory.fromType(lesson.category);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _openLessonDetails(lesson),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: lesson.isCompleted
                                    ? AppColors.success.withValues(alpha: 0.6)
                                    : (isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle),
                                width: lesson.isCompleted ? 1.8 : 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Day Number Badge
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: lesson.isCompleted
                                        ? AppColors.success
                                        : catInfo.primaryColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: lesson.isCompleted
                                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 26)
                                        : Text(
                                            '${lesson.dayNumber}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              color: catInfo.primaryColor,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: catInfo.primaryColor.withValues(alpha: 0.12),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              catInfo.title,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: catInfo.primaryColor,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '+${lesson.xpReward} XP',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.accentGold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        lesson.title,
                                        style: AppTypography.getDisplayFont(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        lesson.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                AppColors.primary,
                AppColors.secondary,
                AppColors.accentGold,
                AppColors.accentSky,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonStudySheet extends StatefulWidget {
  final DailyLesson lesson;
  final LearningState learningState;
  final ConfettiController confettiController;

  const _LessonStudySheet({
    required this.lesson,
    required this.learningState,
    required this.confettiController,
  });

  @override
  State<_LessonStudySheet> createState() => _LessonStudySheetState();
}

class _LessonStudySheetState extends State<_LessonStudySheet> {
  int _currentVocabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final allVocab = widget.learningState.currentVocabItems;

    // Filter items belonging to this lesson
    final lessonItems = allVocab.where((v) => widget.lesson.vocabItemIds.contains(v.id)).toList();
    final itemsToDisplay = lessonItems.isNotEmpty ? lessonItems : allVocab.take(3).toList();

    final currentItem = itemsToDisplay.isNotEmpty
        ? itemsToDisplay[_currentVocabIndex.clamp(0, itemsToDisplay.length - 1)]
        : null;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'DAY ${widget.lesson.dayNumber}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.lesson.title,
                  style: AppTypography.getDisplayFont(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          const SizedBox(height: 8),
          const Divider(),

          // Grammar / Culture Note Callout
          if (widget.lesson.grammarNote != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_rounded, color: AppColors.secondary, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.lesson.grammarNote!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFFC7D2FE) : const Color(0xFF3730A3),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Card Study View
          if (currentItem != null) ...[
            Text(
              'Word ${_currentVocabIndex + 1} of ${itemsToDisplay.length}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentItem.term,
                          textAlign: TextAlign.center,
                          style: AppTypography.getDisplayFont(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (currentItem.phonetic.isNotEmpty)
                          Text(
                            currentItem.phonetic,
                            style: const TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        const SizedBox(height: 14),
                        AudioSpeakerButton(
                          textToSpeak: currentItem.term,
                          size: 48,
                          showSlowOption: true,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          currentItem.translation,
                          textAlign: TextAlign.center,
                          style: AppTypography.getDisplayFont(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentItem.partOfSpeech,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        if (currentItem.exampleSentence.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurface : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  currentItem.exampleSentence,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  currentItem.exampleTranslation,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Navigation between words
            Row(
              children: [
                if (_currentVocabIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _currentVocabIndex--),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Previous Word'),
                    ),
                  ),
                if (_currentVocabIndex > 0) const SizedBox(width: 12),
                if (_currentVocabIndex < itemsToDisplay.length - 1)
                  Expanded(
                    child: TactileButton(
                      onPressed: () => setState(() => _currentVocabIndex++),
                      height: 50,
                      child: const Text('Next Word'),
                    ),
                  )
                else
                  Expanded(
                    child: TactileButton(
                      onPressed: () {
                        widget.learningState.completeLesson(
                          widget.lesson.id,
                          widget.lesson.xpReward,
                        );
                        widget.confettiController.play();
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.stars_rounded, color: Colors.amber, size: 24),
                                const SizedBox(width: 10),
                                Text('Lesson Completed! +${widget.lesson.xpReward} XP earned!'),
                              ],
                            ),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                      height: 50,
                      backgroundColor: AppColors.success,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('Complete & Claim XP'),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
