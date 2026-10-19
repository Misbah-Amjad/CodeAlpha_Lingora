import 'dart:math';
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/vocab_item.dart';
import '../services/learning_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/custom_word_dialog.dart';
import '../widgets/flashcard_widget.dart';
import '../widgets/tactile_button.dart';

class FlashcardsScreen extends StatefulWidget {
  final LearningState learningState;
  final CategoryType? initialCategory;

  const FlashcardsScreen({
    super.key,
    required this.learningState,
    this.initialCategory,
  });

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  CategoryType? _selectedCategory;
  int _currentIndex = 0;
  bool _shuffle = false;
  late List<VocabItem> _deck;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _updateDeck();
  }

  @override
  void didUpdateWidget(covariant FlashcardsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.learningState.selectedLanguage.id != widget.learningState.selectedLanguage.id ||
        oldWidget.initialCategory != widget.initialCategory) {
      if (widget.initialCategory != null) {
        _selectedCategory = widget.initialCategory;
      }
      _currentIndex = 0;
      _updateDeck();
    }
  }

  void _updateDeck() {
    final all = widget.learningState.currentVocabItems;
    List<VocabItem> filtered;
    if (_selectedCategory == null) {
      filtered = List.from(all);
    } else {
      filtered = all.where((v) => v.category == _selectedCategory).toList();
    }

    if (_shuffle) {
      filtered.shuffle(Random());
    }

    setState(() {
      _deck = filtered;
      if (_currentIndex >= _deck.length && _deck.isNotEmpty) {
        _currentIndex = 0;
      }
    });
  }

  void _nextCard() {
    if (_deck.isNotEmpty) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _deck.length;
      });
    }
  }

  void _previousCard() {
    if (_deck.isNotEmpty) {
      setState(() {
        _currentIndex = (_currentIndex - 1 + _deck.length) % _deck.length;
      });
    }
  }

  void _recordPractice(bool known) {
    if (_deck.isEmpty) return;
    final currentItem = _deck[_currentIndex];
    widget.learningState.recordItemReview(currentItem.id, known);

    if (known) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Great job! "${currentItem.term}" marked as practiced.'),
          backgroundColor: AppColors.success,
          duration: const Duration(milliseconds: 900),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }

    _nextCard();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Refresh deck in case items changed in state
    final allItems = widget.learningState.currentVocabItems;
    final filteredItems = _selectedCategory == null
        ? allItems
        : allItems.where((v) => v.category == _selectedCategory).toList();
    _deck = filteredItems;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Category Filter Scrollable Chips
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All Categories'),
                      selected: _selectedCategory == null,
                      onSelected: (sel) {
                        setState(() {
                          _selectedCategory = null;
                          _currentIndex = 0;
                        });
                      },
                      selectedColor: AppColors.primary.withValues(alpha: 0.18),
                      checkmarkColor: AppColors.primary,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _selectedCategory == null
                            ? AppColors.primary
                            : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ...LearningCategory.allCategories.map((cat) {
                      final isSel = _selectedCategory == cat.type;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          avatar: Icon(cat.icon, size: 14, color: isSel ? cat.primaryColor : Colors.grey),
                          label: Text(cat.title),
                          selected: isSel,
                          onSelected: (sel) {
                            setState(() {
                              _selectedCategory = sel ? cat.type : null;
                              _currentIndex = 0;
                            });
                          },
                          selectedColor: cat.primaryColor.withValues(alpha: 0.18),
                          checkmarkColor: cat.primaryColor,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: isSel
                                ? cat.primaryColor
                                : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Controls Bar: Progress, Shuffle, Add Custom Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _deck.isNotEmpty
                          ? 'Card ${_currentIndex + 1} of ${_deck.length}'
                          : '0 cards',
                      style: AppTypography.getDisplayFont(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      _shuffle ? Icons.shuffle_on_rounded : Icons.shuffle_rounded,
                      color: _shuffle ? AppColors.primary : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    ),
                    tooltip: 'Shuffle Deck',
                    onPressed: () {
                      setState(() {
                        _shuffle = !_shuffle;
                        _updateDeck();
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                    tooltip: 'Add Custom Flashcard',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => CustomWordDialog(learningState: widget.learningState),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Main Flashcard Swiper Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: _deck.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('📭', style: TextStyle(fontSize: 48)),
                            const SizedBox(height: 14),
                            Text(
                              'No cards in this category yet',
                              style: AppTypography.getDisplayFont(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TactileButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => CustomWordDialog(learningState: widget.learningState),
                                );
                              },
                              width: 180,
                              height: 46,
                              child: const Text('Add a Card'),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: FlashcardWidget(
                            item: _deck[_currentIndex.clamp(0, _deck.length - 1)],
                            onBookmarkToggle: () {
                              widget.learningState.toggleBookmark(
                                _deck[_currentIndex.clamp(0, _deck.length - 1)].id,
                              );
                            },
                            onMasteryToggle: (isLearned) {
                              widget.learningState.markItemLearned(
                                _deck[_currentIndex.clamp(0, _deck.length - 1)].id,
                                isLearned,
                              );
                            },
                          ),
                        ),
                      ),
              ),
            ),

            // Practice Rating Action Buttons
            if (_deck.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    // Previous card icon button
                    IconButton.filledTonal(
                      onPressed: _previousCard,
                      icon: const Icon(Icons.arrow_back_rounded, size: 20),
                      tooltip: 'Previous Card',
                    ),
                    const SizedBox(width: 8),
                    // "Needs Review" Button
                    Expanded(
                      child: TactileButton(
                        onPressed: () => _recordPractice(false),
                        backgroundColor: isDark ? AppColors.darkSurfaceAlt : const Color(0xFFF1F5F9),
                        foregroundColor: isDark ? Colors.white70 : const Color(0xFF475569),
                        depth: 3,
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh_rounded, size: 16, color: AppColors.error),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'Review',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: AppColors.error, fontSize: 13, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // "I Know This!" Button
                    Expanded(
                      child: TactileButton(
                        onPressed: () => _recordPractice(true),
                        backgroundColor: AppColors.success,
                        depth: 3,
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_rounded, size: 18, color: Colors.white),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'Know it!',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Next card icon button
                    IconButton.filledTonal(
                      onPressed: _nextCard,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                      tooltip: 'Next Card',
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
