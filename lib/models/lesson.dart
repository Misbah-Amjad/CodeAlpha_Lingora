import 'category.dart';

class DailyLesson {
  final String id;
  final String languageId;
  final int dayNumber;
  final String title;
  final String description;
  final CategoryType category;
  final int estimatedMinutes;
  final int xpReward;
  final List<String> vocabItemIds;
  final String? grammarNote;
  final bool isCompleted;

  const DailyLesson({
    required this.id,
    required this.languageId,
    required this.dayNumber,
    required this.title,
    required this.description,
    required this.category,
    this.estimatedMinutes = 5,
    this.xpReward = 25,
    required this.vocabItemIds,
    this.grammarNote,
    this.isCompleted = false,
  });

  DailyLesson copyWith({
    String? id,
    String? languageId,
    int? dayNumber,
    String? title,
    String? description,
    CategoryType? category,
    int? estimatedMinutes,
    int? xpReward,
    List<String>? vocabItemIds,
    String? grammarNote,
    bool? isCompleted,
  }) {
    return DailyLesson(
      id: id ?? this.id,
      languageId: languageId ?? this.languageId,
      dayNumber: dayNumber ?? this.dayNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      xpReward: xpReward ?? this.xpReward,
      vocabItemIds: vocabItemIds ?? this.vocabItemIds,
      grammarNote: grammarNote ?? this.grammarNote,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'languageId': languageId,
    'dayNumber': dayNumber,
    'title': title,
    'description': description,
    'category': category.name,
    'estimatedMinutes': estimatedMinutes,
    'xpReward': xpReward,
    'vocabItemIds': vocabItemIds,
    'grammarNote': grammarNote,
    'isCompleted': isCompleted,
  };

  factory DailyLesson.fromJson(Map<String, dynamic> json) => DailyLesson(
    id: json['id'] as String,
    languageId: json['languageId'] as String,
    dayNumber: json['dayNumber'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    category: CategoryType.values.firstWhere(
      (c) => c.name == (json['category'] as String?),
      orElse: () => CategoryType.vocabulary,
    ),
    estimatedMinutes: json['estimatedMinutes'] as int? ?? 5,
    xpReward: json['xpReward'] as int? ?? 25,
    vocabItemIds: List<String>.from(json['vocabItemIds'] as List? ?? []),
    grammarNote: json['grammarNote'] as String?,
    isCompleted: json['isCompleted'] as bool? ?? false,
  );
}
