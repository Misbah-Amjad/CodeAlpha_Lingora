import 'quiz_question.dart';

class UserProgress {
  final int streakDays;
  final DateTime? lastActiveDate;
  final int totalXp;
  final int dailyGoalWords;
  final int wordsLearnedToday;
  final DateTime? todayDate;
  final List<String> completedLessonIds;
  final List<QuizResult> recentQuizResults;
  final DateTime? lastCloudSyncTime;
  final bool isCloudSyncEnabled;

  const UserProgress({
    this.streakDays = 1,
    this.lastActiveDate,
    this.totalXp = 50,
    this.dailyGoalWords = 10,
    this.wordsLearnedToday = 0,
    this.todayDate,
    this.completedLessonIds = const [],
    this.recentQuizResults = const [],
    this.lastCloudSyncTime,
    this.isCloudSyncEnabled = true,
  });

  int get level => (totalXp / 100).floor() + 1;

  int get xpForNextLevel => level * 100;

  int get currentLevelXp => totalXp % 100;

  double get levelProgressFraction => (currentLevelXp / 100.0).clamp(0.0, 1.0);

  String get levelTitle {
    if (level < 3) return 'Curious Beginner';
    if (level < 6) return 'Active Explorer';
    if (level < 10) return 'Fluent Apprentice';
    if (level < 15) return 'Conversationalist';
    return 'Polyglot Master';
  }

  UserProgress copyWith({
    int? streakDays,
    DateTime? lastActiveDate,
    int? totalXp,
    int? dailyGoalWords,
    int? wordsLearnedToday,
    DateTime? todayDate,
    List<String>? completedLessonIds,
    List<QuizResult>? recentQuizResults,
    DateTime? lastCloudSyncTime,
    bool? isCloudSyncEnabled,
  }) {
    return UserProgress(
      streakDays: streakDays ?? this.streakDays,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      totalXp: totalXp ?? this.totalXp,
      dailyGoalWords: dailyGoalWords ?? this.dailyGoalWords,
      wordsLearnedToday: wordsLearnedToday ?? this.wordsLearnedToday,
      todayDate: todayDate ?? this.todayDate,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      recentQuizResults: recentQuizResults ?? this.recentQuizResults,
      lastCloudSyncTime: lastCloudSyncTime ?? this.lastCloudSyncTime,
      isCloudSyncEnabled: isCloudSyncEnabled ?? this.isCloudSyncEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
    'streakDays': streakDays,
    'lastActiveDate': lastActiveDate?.toIso8601String(),
    'totalXp': totalXp,
    'dailyGoalWords': dailyGoalWords,
    'wordsLearnedToday': wordsLearnedToday,
    'todayDate': todayDate?.toIso8601String(),
    'completedLessonIds': completedLessonIds,
    'recentQuizResults': recentQuizResults.map((q) => q.toJson()).toList(),
    'lastCloudSyncTime': lastCloudSyncTime?.toIso8601String(),
    'isCloudSyncEnabled': isCloudSyncEnabled,
  };

  factory UserProgress.fromJson(Map<String, dynamic> json) => UserProgress(
    streakDays: json['streakDays'] as int? ?? 1,
    lastActiveDate: json['lastActiveDate'] != null
        ? DateTime.parse(json['lastActiveDate'] as String)
        : null,
    totalXp: json['totalXp'] as int? ?? 50,
    dailyGoalWords: json['dailyGoalWords'] as int? ?? 10,
    wordsLearnedToday: json['wordsLearnedToday'] as int? ?? 0,
    todayDate: json['todayDate'] != null
        ? DateTime.parse(json['todayDate'] as String)
        : null,
    completedLessonIds: List<String>.from(json['completedLessonIds'] as List? ?? []),
    recentQuizResults: (json['recentQuizResults'] as List? ?? [])
        .map((q) => QuizResult.fromJson(q as Map<String, dynamic>))
        .toList(),
    lastCloudSyncTime: json['lastCloudSyncTime'] != null
        ? DateTime.parse(json['lastCloudSyncTime'] as String)
        : null,
    isCloudSyncEnabled: json['isCloudSyncEnabled'] as bool? ?? true,
  );
}
