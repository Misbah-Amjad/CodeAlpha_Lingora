import 'category.dart';

enum DifficultyLevel { beginner, intermediate, advanced }

class VocabItem {
  final String id;
  final String languageId;
  final CategoryType category;
  final String term;
  final String phonetic;
  final String translation;
  final String partOfSpeech;
  final String exampleSentence;
  final String exampleTranslation;
  final String? grammarTip;
  final DifficultyLevel difficultyLevel;
  final bool isBookmarked;
  final bool isLearned;
  final bool isCustom;
  final int timesReviewed;
  final int timesCorrect;

  const VocabItem({
    required this.id,
    required this.languageId,
    required this.category,
    required this.term,
    required this.phonetic,
    required this.translation,
    required this.partOfSpeech,
    required this.exampleSentence,
    required this.exampleTranslation,
    this.grammarTip,
    this.difficultyLevel = DifficultyLevel.beginner,
    this.isBookmarked = false,
    this.isLearned = false,
    this.isCustom = false,
    this.timesReviewed = 0,
    this.timesCorrect = 0,
  });

  VocabItem copyWith({
    String? id,
    String? languageId,
    CategoryType? category,
    String? term,
    String? phonetic,
    String? translation,
    String? partOfSpeech,
    String? exampleSentence,
    String? exampleTranslation,
    String? grammarTip,
    DifficultyLevel? difficultyLevel,
    bool? isBookmarked,
    bool? isLearned,
    bool? isCustom,
    int? timesReviewed,
    int? timesCorrect,
  }) {
    return VocabItem(
      id: id ?? this.id,
      languageId: languageId ?? this.languageId,
      category: category ?? this.category,
      term: term ?? this.term,
      phonetic: phonetic ?? this.phonetic,
      translation: translation ?? this.translation,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      exampleSentence: exampleSentence ?? this.exampleSentence,
      exampleTranslation: exampleTranslation ?? this.exampleTranslation,
      grammarTip: grammarTip ?? this.grammarTip,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isLearned: isLearned ?? this.isLearned,
      isCustom: isCustom ?? this.isCustom,
      timesReviewed: timesReviewed ?? this.timesReviewed,
      timesCorrect: timesCorrect ?? this.timesCorrect,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'languageId': languageId,
    'category': category.name,
    'term': term,
    'phonetic': phonetic,
    'translation': translation,
    'partOfSpeech': partOfSpeech,
    'exampleSentence': exampleSentence,
    'exampleTranslation': exampleTranslation,
    'grammarTip': grammarTip,
    'difficultyLevel': difficultyLevel.name,
    'isBookmarked': isBookmarked,
    'isLearned': isLearned,
    'isCustom': isCustom,
    'timesReviewed': timesReviewed,
    'timesCorrect': timesCorrect,
  };

  factory VocabItem.fromJson(Map<String, dynamic> json) => VocabItem(
    id: json['id'] as String,
    languageId: json['languageId'] as String,
    category: CategoryType.values.firstWhere(
      (c) => c.name == (json['category'] as String?),
      orElse: () => CategoryType.vocabulary,
    ),
    term: json['term'] as String,
    phonetic: json['phonetic'] as String? ?? '',
    translation: json['translation'] as String,
    partOfSpeech: json['partOfSpeech'] as String? ?? 'Noun',
    exampleSentence: json['exampleSentence'] as String? ?? '',
    exampleTranslation: json['exampleTranslation'] as String? ?? '',
    grammarTip: json['grammarTip'] as String?,
    difficultyLevel: DifficultyLevel.values.firstWhere(
      (d) => d.name == (json['difficultyLevel'] as String?),
      orElse: () => DifficultyLevel.beginner,
    ),
    isBookmarked: json['isBookmarked'] as bool? ?? false,
    isLearned: json['isLearned'] as bool? ?? false,
    isCustom: json['isCustom'] as bool? ?? false,
    timesReviewed: json['timesReviewed'] as int? ?? 0,
    timesCorrect: json['timesCorrect'] as int? ?? 0,
  );
}
