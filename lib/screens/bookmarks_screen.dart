import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/learning_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/audio_speaker_button.dart';

class BookmarksScreen extends StatelessWidget {
  final LearningState learningState;

  const BookmarksScreen({super.key, required this.learningState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bookmarked = learningState.bookmarkedItems;

    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Vocabulary (${bookmarked.length})'),
      ),
      body: bookmarked.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 14),
                  Text(
                    'No saved words yet',
                    style: AppTypography.getDisplayFont(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tap the bookmark icon on any flashcard to save difficult words for revision.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: bookmarked.length,
              itemBuilder: (context, index) {
                final item = bookmarked[index];
                final cat = LearningCategory.fromType(item.category);

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                    ),
                  ),
                  child: Row(
                    children: [
                      AudioSpeakerButton(textToSpeak: item.term, size: 40),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  item.term,
                                  style: AppTypography.getDisplayFont(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: cat.primaryColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    cat.title,
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: cat.primaryColor),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.translation,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            if (item.phonetic.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                item.phonetic,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark_remove_rounded, color: AppColors.primary),
                        onPressed: () => learningState.toggleBookmark(item.id),
                        tooltip: 'Remove from saved',
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
