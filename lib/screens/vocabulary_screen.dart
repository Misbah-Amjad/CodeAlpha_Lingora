import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/vocab_item.dart';
import '../services/learning_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/audio_speaker_button.dart';
import '../widgets/custom_word_dialog.dart';

class VocabularyScreen extends StatefulWidget {
  final LearningState learningState;
  final CategoryType? initialCategory;

  const VocabularyScreen({
    super.key,
    required this.learningState,
    this.initialCategory,
  });

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  final TextEditingController _searchController = TextEditingController();
  CategoryType? _selectedCategory;
  String _statusFilter = 'all'; // all, bookmarked, mastered, custom

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  @override
  void didUpdateWidget(covariant VocabularyScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategory != null && widget.initialCategory != oldWidget.initialCategory) {
      _selectedCategory = widget.initialCategory;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showWordDetails(VocabItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final isDark = theme.brightness == Brightness.dark;
        final cat = LearningCategory.fromType(item.category);

        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: cat.primaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      cat.title,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: cat.primaryColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  AudioSpeakerButton(textToSpeak: item.term, size: 42, showSlowOption: true),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                item.term,
                style: AppTypography.getDisplayFont(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              if (item.phonetic.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  item.phonetic,
                  style: const TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Text(
                item.translation,
                style: AppTypography.getDisplayFont(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.partOfSpeech,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              if (item.exampleSentence.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.exampleSentence,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                          ),
                          AudioSpeakerButton(textToSpeak: item.exampleSentence, size: 30),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.exampleTranslation,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (item.grammarTip != null && item.grammarTip!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb_rounded, color: AppColors.secondary, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.grammarTip!,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? const Color(0xFFC7D2FE) : const Color(0xFF3730A3),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final allItems = widget.learningState.currentVocabItems;
    final currentLang = widget.learningState.selectedLanguage;

    final query = _searchController.text.trim().toLowerCase();

    final filteredList = allItems.where((item) {
      if (_selectedCategory != null && item.category != _selectedCategory) {
        return false;
      }
      if (_statusFilter == 'bookmarked' && !item.isBookmarked) return false;
      if (_statusFilter == 'mastered' && !item.isLearned) return false;
      if (_statusFilter == 'custom' && !item.isCustom) return false;

      if (query.isNotEmpty) {
        final matchesTerm = item.term.toLowerCase().contains(query);
        final matchesTrans = item.translation.toLowerCase().contains(query);
        final matchesPhonetic = item.phonetic.toLowerCase().contains(query);
        return matchesTerm || matchesTrans || matchesPhonetic;
      }
      return true;
    }).toList();

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Search Bar & Add Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search ${currentLang.name} words or meanings...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => CustomWordDialog(learningState: widget.learningState),
                      );
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.all(12),
                    ),
                    icon: const Icon(Icons.add_rounded, color: Colors.white),
                    tooltip: 'Add Custom Word',
                  ),
                ],
              ),
            ),

            // Category Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All Categories'),
                    selected: _selectedCategory == null,
                    onSelected: (sel) => setState(() => _selectedCategory = null),
                  ),
                  const SizedBox(width: 8),
                  ...LearningCategory.allCategories.map((c) {
                    final isSel = _selectedCategory == c.type;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        avatar: Icon(c.icon, size: 14, color: isSel ? c.primaryColor : Colors.grey),
                        label: Text(c.title),
                        selected: isSel,
                        onSelected: (sel) => setState(() => _selectedCategory = sel ? c.type : null),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Status Filter Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Text(
                    '${filteredList.length} items',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const Spacer(),
                  _buildStatusPill('All', 'all', isDark),
                  const SizedBox(width: 6),
                  _buildStatusPill('★ Saved', 'bookmarked', isDark),
                  const SizedBox(width: 6),
                  _buildStatusPill('✓ Mastered', 'mastered', isDark),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // Vocabulary Items List
            Expanded(
              child: filteredList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🔍', style: TextStyle(fontSize: 42)),
                          const SizedBox(height: 12),
                          Text(
                            'No matching words found',
                            style: AppTypography.getDisplayFont(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Try clearing search or filters',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        final cat = LearningCategory.fromType(item.category);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _showWordDetails(item),
                              borderRadius: BorderRadius.circular(18),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: item.isLearned
                                        ? AppColors.success.withValues(alpha: 0.5)
                                        : (isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Audio speaker button
                                    AudioSpeakerButton(textToSpeak: item.term, size: 40),
                                    const SizedBox(width: 14),
                                    // Word & Translation
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.term,
                                                  style: AppTypography.getDisplayFont(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w800,
                                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: cat.primaryColor.withValues(alpha: 0.12),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  cat.title,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                    color: cat.primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item.translation,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
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
                                    const SizedBox(width: 6),
                                    // Bookmark button
                                    IconButton(
                                      icon: Icon(
                                        item.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                        color: item.isBookmarked ? AppColors.primary : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                        size: 20,
                                      ),
                                      onPressed: () => widget.learningState.toggleBookmark(item.id),
                                      visualDensity: VisualDensity.compact,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                    ),
                                    // Learned toggle
                                    IconButton(
                                      icon: Icon(
                                        item.isLearned ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                                        color: item.isLearned ? AppColors.success : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                        size: 20,
                                      ),
                                      onPressed: () => widget.learningState.markItemLearned(item.id, !item.isLearned),
                                      visualDensity: VisualDensity.compact,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                    ),
                                    // Delete if custom
                                    if (item.isCustom)
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 18),
                                        onPressed: () => widget.learningState.deleteCustomVocabItem(item.id),
                                        visualDensity: VisualDensity.compact,
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPill(String title, String value, bool isDark) {
    final isSelected = _statusFilter == value;
    return InkWell(
      onTap: () => setState(() => _statusFilter = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : (isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isSelected ? AppColors.primary : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }
}
