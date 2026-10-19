import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/languages_data.dart';
import '../data/seed_data_provider.dart';
import '../models/category.dart';
import '../models/language.dart';
import '../models/lesson.dart';
import '../models/quiz_question.dart';
import '../models/user_profile.dart';
import '../models/user_progress.dart';
import '../models/vocab_item.dart';
import 'storage_service.dart';
import 'tts_service.dart';

class LearningState extends ChangeNotifier {
  final StorageService _storage = StorageService();
  final TtsService _tts = TtsService();
  final Uuid _uuid = const Uuid();

  bool _isInitialized = false;
  Language _selectedLanguage = LanguagesData.defaultLanguage;
  UserProgress _progress = const UserProgress();
  UserProfile _userProfile = UserProfile();

  Set<String> _bookmarkedIds = {};
  Set<String> _learnedIds = {};
  List<VocabItem> _customVocabList = [];
  Map<String, Map<String, int>> _reviewStats = {}; // id -> {reviewed, correct}

  bool _isSyncing = false;
  String? _lastSyncMessage;

  // Getters
  bool get isInitialized => _isInitialized;
  Language get selectedLanguage => _selectedLanguage;
  UserProgress get progress => _progress;
  UserProfile get userProfile => _userProfile;
  bool get isSyncing => _isSyncing;
  String? get lastSyncMessage => _lastSyncMessage;

  LearningState() {
    initialize();
  }

  Future<void> initialize() async {
    final savedLangId = await _storage.loadActiveLanguageId();
    if (savedLangId != null) {
      _selectedLanguage = LanguagesData.getById(savedLangId);
    }

    _progress = await _storage.loadUserProgress();
    _userProfile = await _storage.loadUserProfile();
    _bookmarkedIds = await _storage.loadBookmarkedIds();
    _learnedIds = await _storage.loadLearnedIds();
    _customVocabList = await _storage.loadCustomVocab();
    _reviewStats = await _storage.loadReviewStats();

    // Check & update streak and daily reset
    _checkDailyActivity();

    await _tts.setLanguage(_selectedLanguage.ttsLocale);

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    _userProfile = profile;
    notifyListeners();
    await _storage.saveUserProfile(profile);
  }

  void _checkDailyActivity() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_progress.todayDate == null) {
      _progress = _progress.copyWith(
        todayDate: today,
        lastActiveDate: today,
        streakDays: 1,
        wordsLearnedToday: 0,
      );
      _storage.saveUserProgress(_progress);
      return;
    }

    final lastActiveDay = DateTime(
      _progress.lastActiveDate!.year,
      _progress.lastActiveDate!.month,
      _progress.lastActiveDate!.day,
    );

    final differenceInDays = today.difference(lastActiveDay).inDays;

    if (differenceInDays == 0) {
      // Same day, streak intact
    } else if (differenceInDays == 1) {
      // Active next consecutive day!
      _progress = _progress.copyWith(
        streakDays: _progress.streakDays + 1,
        lastActiveDate: today,
        todayDate: today,
        wordsLearnedToday: 0,
      );
      _storage.saveUserProgress(_progress);
    } else if (differenceInDays > 1) {
      // Streak broken, reset to 1
      _progress = _progress.copyWith(
        streakDays: 1,
        lastActiveDate: today,
        todayDate: today,
        wordsLearnedToday: 0,
      );
      _storage.saveUserProgress(_progress);
    }
  }

  Future<void> selectLanguage(Language language) async {
    _selectedLanguage = language;
    await _storage.saveActiveLanguageId(language.id);
    await _tts.setLanguage(language.ttsLocale);
    notifyListeners();
  }

  // Current items for the selected language
  List<VocabItem> get currentVocabItems {
    final seedItems = SeedDataProvider.getVocabForLanguage(_selectedLanguage.id);
    final customItems = _customVocabList.where((item) => item.languageId == _selectedLanguage.id).toList();

    final all = <VocabItem>[...seedItems, ...customItems];
    return all.map((item) {
      final isBookmarked = _bookmarkedIds.contains(item.id);
      final isLearned = _learnedIds.contains(item.id);
      final stat = _reviewStats[item.id];
      final reviewed = stat?['reviewed'] ?? item.timesReviewed;
      final correct = stat?['correct'] ?? item.timesCorrect;

      return item.copyWith(
        isBookmarked: isBookmarked,
        isLearned: isLearned,
        timesReviewed: reviewed,
        timesCorrect: correct,
      );
    }).toList();
  }

  List<DailyLesson> get currentLessons {
    final lessons = SeedDataProvider.getLessonsForLanguage(_selectedLanguage.id);
    return lessons.map((l) {
      final isCompleted = _progress.completedLessonIds.contains(l.id);
      return l.copyWith(isCompleted: isCompleted);
    }).toList();
  }

  List<QuizQuestion> get currentQuizQuestions {
    return SeedDataProvider.getQuizzesForLanguage(_selectedLanguage.id);
  }

  List<VocabItem> get bookmarkedItems {
    return currentVocabItems.where((v) => v.isBookmarked).toList();
  }

  List<VocabItem> get masteredItems {
    return currentVocabItems.where((v) => v.isLearned).toList();
  }

  List<VocabItem> get learningItems {
    return currentVocabItems.where((v) => !v.isLearned).toList();
  }

  List<VocabItem> getItemsByCategory(CategoryType category) {
    return currentVocabItems.where((v) => v.category == category).toList();
  }

  // Vocabulary Actions
  Future<void> toggleBookmark(String vocabId) async {
    if (_bookmarkedIds.contains(vocabId)) {
      _bookmarkedIds.remove(vocabId);
    } else {
      _bookmarkedIds.add(vocabId);
    }
    await _storage.saveBookmarkedIds(_bookmarkedIds);
    notifyListeners();
  }

  Future<void> markItemLearned(String vocabId, bool isLearned) async {
    if (isLearned) {
      _learnedIds.add(vocabId);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      _progress = _progress.copyWith(
        wordsLearnedToday: _progress.wordsLearnedToday + 1,
        totalXp: _progress.totalXp + 10,
        lastActiveDate: today,
      );
      await _storage.saveUserProgress(_progress);
    } else {
      _learnedIds.remove(vocabId);
    }
    await _storage.saveLearnedIds(_learnedIds);
    notifyListeners();
  }

  Future<void> recordItemReview(String vocabId, bool correct) async {
    final current = _reviewStats[vocabId] ?? {'reviewed': 0, 'correct': 0};
    _reviewStats[vocabId] = {
      'reviewed': (current['reviewed'] ?? 0) + 1,
      'correct': (current['correct'] ?? 0) + (correct ? 1 : 0),
    };
    await _storage.saveReviewStats(_reviewStats);

    if (correct && !_learnedIds.contains(vocabId)) {
      if ((_reviewStats[vocabId]!['correct'] ?? 0) >= 2) {
        await markItemLearned(vocabId, true);
      }
    }
    notifyListeners();
  }

  Future<void> addCustomVocabItem({
    required CategoryType category,
    required String term,
    required String phonetic,
    required String translation,
    required String partOfSpeech,
    required String exampleSentence,
    required String exampleTranslation,
    String? grammarTip,
    DifficultyLevel difficultyLevel = DifficultyLevel.beginner,
  }) async {
    final newItem = VocabItem(
      id: 'custom_${_uuid.v4()}',
      languageId: _selectedLanguage.id,
      category: category,
      term: term.trim(),
      phonetic: phonetic.trim().isNotEmpty ? phonetic.trim() : '[${term.trim()}]',
      translation: translation.trim(),
      partOfSpeech: partOfSpeech.trim(),
      exampleSentence: exampleSentence.trim(),
      exampleTranslation: exampleTranslation.trim(),
      grammarTip: grammarTip?.trim(),
      difficultyLevel: difficultyLevel,
      isCustom: true,
    );

    _customVocabList.add(newItem);
    await _storage.saveCustomVocab(_customVocabList);
    addXp(15);
    notifyListeners();
  }

  Future<void> deleteCustomVocabItem(String vocabId) async {
    _customVocabList.removeWhere((i) => i.id == vocabId);
    _bookmarkedIds.remove(vocabId);
    _learnedIds.remove(vocabId);
    await _storage.saveCustomVocab(_customVocabList);
    await _storage.saveBookmarkedIds(_bookmarkedIds);
    await _storage.saveLearnedIds(_learnedIds);
    notifyListeners();
  }

  // Lesson Completion
  Future<void> completeLesson(String lessonId, int xpReward) async {
    if (!_progress.completedLessonIds.contains(lessonId)) {
      final updatedLessons = [..._progress.completedLessonIds, lessonId];
      _progress = _progress.copyWith(
        completedLessonIds: updatedLessons,
        totalXp: _progress.totalXp + xpReward,
        lastActiveDate: DateTime.now(),
      );
      await _storage.saveUserProgress(_progress);
      notifyListeners();
    }
  }

  // Quiz Handling
  Future<void> recordQuizResult({
    required int totalQuestions,
    required int correctAnswers,
    required int xpEarned,
    required List<String> missedQuestionIds,
  }) async {
    final scorePercentage = totalQuestions > 0
        ? ((correctAnswers / totalQuestions) * 100).round()
        : 0;

    final result = QuizResult(
      id: _uuid.v4(),
      timestamp: DateTime.now(),
      languageId: _selectedLanguage.id,
      totalQuestions: totalQuestions,
      correctAnswers: correctAnswers,
      scorePercentage: scorePercentage,
      xpEarned: xpEarned,
      missedQuestionIds: missedQuestionIds,
    );

    final recent = [result, ..._progress.recentQuizResults];
    if (recent.length > 20) {
      recent.removeLast();
    }

    _progress = _progress.copyWith(
      totalXp: _progress.totalXp + xpEarned,
      recentQuizResults: recent,
      lastActiveDate: DateTime.now(),
    );

    await _storage.saveUserProgress(_progress);
    notifyListeners();
  }

  void addXp(int points) {
    _progress = _progress.copyWith(
      totalXp: _progress.totalXp + points,
    );
    _storage.saveUserProgress(_progress);
    notifyListeners();
  }

  Future<void> setDailyGoal(int goal) async {
    _progress = _progress.copyWith(dailyGoalWords: goal);
    await _storage.saveUserProgress(_progress);
    notifyListeners();
  }

  // Pronunciation
  Future<void> pronounce(String text, {bool slow = false}) async {
    await _tts.speak(text, locale: _selectedLanguage.ttsLocale, slow: slow);
  }

  // Cloud Sync Simulator
  Future<void> syncWithCloud() async {
    _isSyncing = true;
    _lastSyncMessage = 'Connecting to Cloud Backend...';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));

    try {
      final jsonSnapshot = await _storage.exportFullDataPackage(
        _progress,
        _customVocabList,
        _bookmarkedIds,
        _learnedIds,
      );

      _progress = _progress.copyWith(
        lastCloudSyncTime: DateTime.now(),
        isCloudSyncEnabled: true,
      );
      await _storage.saveUserProgress(_progress);

      _isSyncing = false;
      _lastSyncMessage = 'Synced successfully! (${(jsonSnapshot.length / 1024).toStringAsFixed(1)} KB backup secured)';
      notifyListeners();
    } catch (e) {
      _isSyncing = false;
      _lastSyncMessage = 'Sync failed: $e';
      notifyListeners();
    }
  }

  Future<String> exportBackupJson() async {
    return await _storage.exportFullDataPackage(
      _progress,
      _customVocabList,
      _bookmarkedIds,
      _learnedIds,
    );
  }

  Future<void> resetAllData() async {
    await _storage.clearAllData();
    _bookmarkedIds.clear();
    _learnedIds.clear();
    _customVocabList.clear();
    _reviewStats.clear();
    _progress = const UserProgress();
    _selectedLanguage = LanguagesData.defaultLanguage;
    notifyListeners();
  }
}
