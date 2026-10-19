import '../models/lesson.dart';
import '../models/quiz_question.dart';
import '../models/vocab_item.dart';
import 'french_data.dart';
import 'german_data.dart';
import 'italian_data.dart';
import 'japanese_data.dart';
import 'spanish_data.dart';

class SeedDataProvider {
  static List<VocabItem> getVocabForLanguage(String langId) {
    switch (langId.toLowerCase()) {
      case 'es':
        return SpanishData.vocabItems;
      case 'fr':
        return FrenchData.vocabItems;
      case 'de':
        return GermanData.vocabItems;
      case 'ja':
        return JapaneseData.vocabItems;
      case 'it':
        return ItalianData.vocabItems;
      default:
        return SpanishData.vocabItems;
    }
  }

  static List<DailyLesson> getLessonsForLanguage(String langId) {
    switch (langId.toLowerCase()) {
      case 'es':
        return SpanishData.dailyLessons;
      case 'fr':
        return FrenchData.dailyLessons;
      case 'de':
        return GermanData.dailyLessons;
      case 'ja':
        return JapaneseData.dailyLessons;
      case 'it':
        return ItalianData.dailyLessons;
      default:
        return SpanishData.dailyLessons;
    }
  }

  static List<QuizQuestion> getQuizzesForLanguage(String langId) {
    switch (langId.toLowerCase()) {
      case 'es':
        return SpanishData.quizQuestions;
      case 'fr':
        return FrenchData.quizQuestions;
      case 'de':
        return GermanData.quizQuestions;
      case 'ja':
        return JapaneseData.quizQuestions;
      case 'it':
        return ItalianData.quizQuestions;
      default:
        return SpanishData.quizQuestions;
    }
  }
}
