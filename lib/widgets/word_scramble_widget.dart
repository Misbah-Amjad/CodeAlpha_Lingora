import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class WordScrambleWidget extends StatefulWidget {
  final List<String> initialWords;
  final Function(List<String> currentOrder) onOrderChanged;
  final bool isSubmitted;
  final bool isCorrect;

  const WordScrambleWidget({
    super.key,
    required this.initialWords,
    required this.onOrderChanged,
    this.isSubmitted = false,
    this.isCorrect = false,
  });

  @override
  State<WordScrambleWidget> createState() => _WordScrambleWidgetState();
}

class _WordScrambleWidgetState extends State<WordScrambleWidget> {
  late List<String> _availableWords;
  final List<String> _selectedWords = [];

  @override
  void initState() {
    super.initState();
    _availableWords = List.from(widget.initialWords);
  }

  @override
  void didUpdateWidget(covariant WordScrambleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialWords != widget.initialWords) {
      _availableWords = List.from(widget.initialWords);
      _selectedWords.clear();
    }
  }

  void _selectWord(int index) {
    if (widget.isSubmitted) return;
    setState(() {
      final word = _availableWords.removeAt(index);
      _selectedWords.add(word);
    });
    widget.onOrderChanged(_selectedWords);
  }

  void _unselectWord(int index) {
    if (widget.isSubmitted) return;
    setState(() {
      final word = _selectedWords.removeAt(index);
      _availableWords.add(word);
    });
    widget.onOrderChanged(_selectedWords);
  }

  void _resetWords() {
    if (widget.isSubmitted) return;
    setState(() {
      _availableWords = List.from(widget.initialWords);
      _selectedWords.clear();
    });
    widget.onOrderChanged(_selectedWords);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color containerBorder = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    if (widget.isSubmitted) {
      containerBorder = widget.isCorrect ? AppColors.success : AppColors.error;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Assembled Sentence Area
        Container(
          constraints: const BoxConstraints(minHeight: 110),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: containerBorder, width: 2),
          ),
          child: _selectedWords.isEmpty
              ? Center(
                  child: Text(
                    'Tap words below in the correct order to construct the sentence',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(_selectedWords.length, (idx) {
                    final word = _selectedWords[idx];
                    return InkWell(
                      onTap: () => _unselectWord(idx),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              word,
                              style: AppTypography.getBodyFont(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            if (!widget.isSubmitted) ...[
                              const SizedBox(width: 4),
                              Icon(
                                Icons.close_rounded,
                                size: 14,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
                ),
        ),

        const SizedBox(height: 12),

        // Action reset
        if (_selectedWords.isNotEmpty && !widget.isSubmitted)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _resetWords,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Clear all', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),

        const SizedBox(height: 8),

        // Available Words Bank
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(_availableWords.length, (idx) {
            final word = _availableWords[idx];
            return InkWell(
              onTap: () => _selectWord(idx),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      offset: const Offset(0, 2),
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Text(
                  word,
                  style: AppTypography.getBodyFont(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
