import 'dart:math';
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/vocab_item.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'audio_speaker_button.dart';

class FlashcardWidget extends StatefulWidget {
  final VocabItem item;
  final VoidCallback onBookmarkToggle;
  final Function(bool isLearned) onMasteryToggle;

  const FlashcardWidget({
    super.key,
    required this.item,
    required this.onBookmarkToggle,
    required this.onMasteryToggle,
  });

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant FlashcardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.id != widget.item.id) {
      if (!_isFront) {
        _controller.reset();
        _isFront = true;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() => _isFront = !_isFront);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final catInfo = LearningCategory.fromType(widget.item.category);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle = _animation.value * pi;
        final isFrontSide = angle <= (pi / 2);

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          alignment: Alignment.center,
          child: isFrontSide
              ? _buildCardSide(
                  isFront: true,
                  isDark: isDark,
                  catInfo: catInfo,
                )
              : Transform(
                  transform: Matrix4.identity()..rotateY(pi),
                  alignment: Alignment.center,
                  child: _buildCardSide(
                    isFront: false,
                    isDark: isDark,
                    catInfo: catInfo,
                  ),
                ),
        );
      },
    );
  }

  Widget _buildCardSide({
    required bool isFront,
    required bool isDark,
    required LearningCategory catInfo,
  }) {
    return GestureDetector(
      onTap: _flipCard,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: widget.item.isLearned
                ? AppColors.success.withValues(alpha: 0.6)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: widget.item.isLearned ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Action Bar
            Row(
              children: [
                // Category Chip
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: catInfo.primaryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(catInfo.icon, size: 14, color: catInfo.primaryColor),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            catInfo.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: catInfo.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Spacer(),
                // Mastery indicator pill
                if (widget.item.isLearned)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded, color: AppColors.success, size: 13),
                        SizedBox(width: 4),
                        Text(
                          'Mastered',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Bookmark button
                IconButton(
                  icon: Icon(
                    widget.item.isBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: widget.item.isBookmarked
                        ? AppColors.primary
                        : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    size: 22,
                  ),
                  onPressed: widget.onBookmarkToggle,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Middle Content: Centered & Scrollable to prevent any overflow on mobile
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isFront) ...[
                        // Front: Target Language Term
                        Text(
                          widget.item.term,
                          textAlign: TextAlign.center,
                          style: AppTypography.getDisplayFont(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Phonetic Guide
                        if (widget.item.phonetic.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.item.phonetic,
                              style: const TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        // Audio Pronunciation Controls
                        AudioSpeakerButton(
                          textToSpeak: widget.item.term,
                          size: 48,
                          showSlowOption: true,
                        ),
                      ] else ...[
                        // Back: English Meaning & Examples
                        Text(
                          widget.item.translation,
                          textAlign: TextAlign.center,
                          style: AppTypography.getDisplayFont(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.item.partOfSpeech,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Example Sentence Container
                        if (widget.item.exampleSentence.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.item.exampleSentence,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                        ),
                                      ),
                                    ),
                                    AudioSpeakerButton(
                                      textToSpeak: widget.item.exampleSentence,
                                      size: 30,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.item.exampleTranslation,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (widget.item.grammarTip != null && widget.item.grammarTip!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.secondary.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.lightbulb_outline_rounded,
                                  size: 16,
                                  color: AppColors.secondary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    widget.item.grammarTip!,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? const Color(0xFFC7D2FE) : const Color(0xFF3730A3),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Bottom Flip Hint & Mastery Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app_rounded,
                      size: 16,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isFront ? 'Tap to flip' : 'Tap to flip back',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => widget.onMasteryToggle(!widget.item.isLearned),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: widget.item.isLearned
                          ? AppColors.success.withValues(alpha: 0.15)
                          : (isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.item.isLearned ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                          size: 15,
                          color: widget.item.isLearned ? AppColors.success : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.item.isLearned ? 'Learned' : 'Mark Learned',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: widget.item.isLearned ? AppColors.success : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
