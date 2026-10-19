enum QuizType {
  multipleChoice,
  listening,
  wordScramble,
  trueFalse,
}

class QuizQuestion {
  final String id;
  final QuizType type;
  final String prompt;
  final String? audioTerm; // The term to pronounce if listening or prompt
  final String? phonetic;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final List<String>? scrambleWords; // For sentence builder / scramble
  final List<String>? correctWordOrder;

  const QuizQuestion({
    required this.id,
    required this.type,
    required this.prompt,
    this.audioTerm,
    this.phonetic,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    this.scrambleWords,
    this.correctWordOrder,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'prompt': prompt,
    'audioTerm': audioTerm,
    'phonetic': phonetic,
    'options': options,
    'correctAnswer': correctAnswer,
    'explanation': explanation,
    'scrambleWords': scrambleWords,
    'correctWordOrder': correctWordOrder,
  };

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => QuizQuestion(
    id: json['id'] as String,
    type: QuizType.values.firstWhere(
      (t) => t.name == (json['type'] as String?),
      orElse: () => QuizType.multipleChoice,
    ),
    prompt: json['prompt'] as String,
    audioTerm: json['audioTerm'] as String?,
    phonetic: json['phonetic'] as String?,
    options: List<String>.from(json['options'] as List? ?? []),
    correctAnswer: json['correctAnswer'] as String,
    explanation: json['explanation'] as String,
    scrambleWords: json['scrambleWords'] != null
        ? List<String>.from(json['scrambleWords'] as List)
        : null,
    correctWordOrder: json['correctWordOrder'] != null
        ? List<String>.from(json['correctWordOrder'] as List)
        : null,
  );
}

class QuizResult {
  final String id;
  final DateTime timestamp;
  final String languageId;
  final int totalQuestions;
  final int correctAnswers;
  final int scorePercentage;
  final int xpEarned;
  final List<String> missedQuestionIds;

  const QuizResult({
    required this.id,
    required this.timestamp,
    required this.languageId,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.scorePercentage,
    required this.xpEarned,
    required this.missedQuestionIds,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'languageId': languageId,
    'totalQuestions': totalQuestions,
    'correctAnswers': correctAnswers,
    'scorePercentage': scorePercentage,
    'xpEarned': xpEarned,
    'missedQuestionIds': missedQuestionIds,
  };

  factory QuizResult.fromJson(Map<String, dynamic> json) => QuizResult(
    id: json['id'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    languageId: json['languageId'] as String,
    totalQuestions: json['totalQuestions'] as int,
    correctAnswers: json['correctAnswers'] as int,
    scorePercentage: json['scorePercentage'] as int,
    xpEarned: json['xpEarned'] as int,
    missedQuestionIds: List<String>.from(json['missedQuestionIds'] as List? ?? []),
  );
}
