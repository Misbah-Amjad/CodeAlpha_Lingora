import 'package:flutter_test/flutter_test.dart';
import 'package:codealpha_language_learning_app/data/languages_data.dart';
import 'package:codealpha_language_learning_app/data/seed_data_provider.dart';
import 'package:codealpha_language_learning_app/models/category.dart';
import 'package:codealpha_language_learning_app/models/user_progress.dart';
import 'package:codealpha_language_learning_app/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Data Model & Curriculum Tests', () {
    test('Supported languages include Spanish, French, German, Japanese, Italian', () {
      expect(LanguagesData.supportedLanguages.length, greaterThanOrEqualTo(5));
      final codes = LanguagesData.supportedLanguages.map((l) => l.code).toList();
      expect(codes, containsAll(['es', 'fr', 'de', 'ja', 'it']));
    });

    test('Each language has rich vocabulary, daily lessons, and quizzes', () {
      for (final lang in LanguagesData.supportedLanguages) {
        final vocab = SeedDataProvider.getVocabForLanguage(lang.id);
        final lessons = SeedDataProvider.getLessonsForLanguage(lang.id);
        final quizzes = SeedDataProvider.getQuizzesForLanguage(lang.id);

        expect(vocab.isNotEmpty, isTrue, reason: '${lang.name} should have vocabulary');
        expect(lessons.isNotEmpty, isTrue, reason: '${lang.name} should have lessons');
        expect(quizzes.isNotEmpty, isTrue, reason: '${lang.name} should have quizzes');
      }
    });

    test('Category mappings exist for vocabulary, grammar, and phrases', () {
      expect(LearningCategory.allCategories.length, greaterThanOrEqualTo(5));
      final vocabCat = LearningCategory.fromType(CategoryType.vocabulary);
      expect(vocabCat.title, equals('Vocabulary'));
      final grammarCat = LearningCategory.fromType(CategoryType.grammar);
      expect(grammarCat.title, equals('Grammar'));
    });

    test('UserProgress calculates level and XP accurately', () {
      const p1 = UserProgress(totalXp: 50);
      expect(p1.level, equals(1));
      expect(p1.levelTitle, equals('Curious Beginner'));

      const p2 = UserProgress(totalXp: 250);
      expect(p2.level, equals(3));
      expect(p2.levelTitle, equals('Active Explorer'));

      const p3 = UserProgress(totalXp: 650);
      expect(p3.level, equals(7));
      expect(p3.levelTitle, equals('Fluent Apprentice'));
    });
  });

  group('Widget Smoke Tests', () {
    testWidgets('LingoPulseApp launches and displays Splash branding', (WidgetTester tester) async {
      await tester.pumpWidget(const LingoPulseApp());
      expect(find.text('Lingora'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });
  });
}
