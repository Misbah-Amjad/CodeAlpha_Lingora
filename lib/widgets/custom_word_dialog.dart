import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/learning_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'tactile_button.dart';

class CustomWordDialog extends StatefulWidget {
  final LearningState learningState;

  const CustomWordDialog({
    super.key,
    required this.learningState,
  });

  @override
  State<CustomWordDialog> createState() => _CustomWordDialogState();
}

class _CustomWordDialogState extends State<CustomWordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _termController = TextEditingController();
  final _phoneticController = TextEditingController();
  final _translationController = TextEditingController();
  final _exampleSentenceController = TextEditingController();
  final _exampleTranslationController = TextEditingController();
  final _grammarTipController = TextEditingController();

  CategoryType _selectedCategory = CategoryType.vocabulary;
  String _selectedPartOfSpeech = 'Noun';

  final List<String> _partsOfSpeech = [
    'Noun',
    'Verb',
    'Adjective',
    'Phrase',
    'Greeting',
    'Idiom',
    'Adverb',
  ];

  @override
  void dispose() {
    _termController.dispose();
    _phoneticController.dispose();
    _translationController.dispose();
    _exampleSentenceController.dispose();
    _exampleTranslationController.dispose();
    _grammarTipController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.learningState.addCustomVocabItem(
        category: _selectedCategory,
        term: _termController.text,
        phonetic: _phoneticController.text,
        translation: _translationController.text,
        partOfSpeech: _selectedPartOfSpeech,
        exampleSentence: _exampleSentenceController.text,
        exampleTranslation: _exampleTranslationController.text,
        grammarTip: _grammarTipController.text,
      );

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Added "${_termController.text.trim()}" to your flashcards (+15 XP)!'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentLang = widget.learningState.selectedLanguage;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 680),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.add_circle_outline_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Custom Vocabulary',
                            style: AppTypography.getDisplayFont(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'For ${currentLang.name} ${currentLang.flagEmoji}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),

                // Scrollable fields
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Picker
                        Text(
                          'Category',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<CategoryType>(
                              value: _selectedCategory,
                              isExpanded: true,
                              dropdownColor: isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurface,
                              items: LearningCategory.allCategories.map((c) {
                                return DropdownMenuItem(
                                  value: c.type,
                                  child: Row(
                                    children: [
                                      Icon(c.icon, size: 18, color: c.primaryColor),
                                      const SizedBox(width: 8),
                                      Text(
                                        c.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedCategory = val);
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Term in Target Language
                        Text(
                          'Word or Phrase (${currentLang.name}) *',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _termController,
                          decoration: InputDecoration(
                            hintText: 'e.g. ${currentLang.greeting.split(" ").first}',
                          ),
                          validator: (val) => val == null || val.trim().isEmpty ? 'Please enter the word/phrase' : null,
                        ),

                        const SizedBox(height: 14),

                        // Phonetic Guide
                        Text(
                          'Pronunciation Guide / Phonetics',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _phoneticController,
                          decoration: const InputDecoration(
                            hintText: 'e.g. [pronunciation hint]',
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Translation in English
                        Text(
                          'English Translation *',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _translationController,
                          decoration: const InputDecoration(
                            hintText: 'e.g. Hello / Welcome',
                          ),
                          validator: (val) => val == null || val.trim().isEmpty ? 'Please enter English translation' : null,
                        ),

                        const SizedBox(height: 14),

                        // Part of speech
                        Text(
                          'Part of Speech',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          children: _partsOfSpeech.map((pos) {
                            final isSel = _selectedPartOfSpeech == pos;
                            return ChoiceChip(
                              label: Text(pos),
                              selected: isSel,
                              onSelected: (_) => setState(() => _selectedPartOfSpeech = pos),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 14),

                        // Example Sentence
                        Text(
                          'Example Sentence (Optional)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _exampleSentenceController,
                          decoration: InputDecoration(
                            hintText: 'Sentence in ${currentLang.name}',
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextFormField(
                          controller: _exampleTranslationController,
                          decoration: const InputDecoration(
                            hintText: 'Sentence in English',
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Grammar tip
                        Text(
                          'Grammar Tip / Usage Note (Optional)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _grammarTipController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            hintText: 'e.g. Takes feminine article "la"',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Submit Button
                TactileButton(
                  onPressed: _submit,
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark_add_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Save to My Vocabulary',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
