import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/user_progress.dart';
import '../models/vocab_item.dart';

class StorageService {
  static const String _keyActiveLanguage = 'lingo_active_language';
  static const String _keyUserProgress = 'lingo_user_progress';
  static const String _keyUserProfile = 'lingo_user_profile';
  static const String _keyBookmarks = 'lingo_bookmarked_ids';
  static const String _keyLearned = 'lingo_learned_ids';
  static const String _keyCustomVocab = 'lingo_custom_vocab';
  static const String _keyReviewStats = 'lingo_review_stats';
  static const String _keyCloudBackup = 'lingo_cloud_backup_snapshot';

  Future<UserProfile> loadUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_keyUserProfile);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        return UserProfile.fromJson(map);
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
    return UserProfile();
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(profile.toJson());
      await prefs.setString(_keyUserProfile, jsonStr);
    } catch (e) {
      debugPrint('Error saving user profile: $e');
    }
  }

  Future<String?> loadActiveLanguageId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyActiveLanguage);
  }

  Future<void> saveActiveLanguageId(String langId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyActiveLanguage, langId);
  }

  Future<UserProgress> loadUserProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_keyUserProgress);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        return UserProgress.fromJson(map);
      }
    } catch (e) {
      debugPrint('Error loading user progress: $e');
    }
    return const UserProgress();
  }

  Future<void> saveUserProgress(UserProgress progress) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(progress.toJson());
      await prefs.setString(_keyUserProgress, jsonStr);
    } catch (e) {
      debugPrint('Error saving user progress: $e');
    }
  }

  Future<Set<String>> loadBookmarkedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyBookmarks) ?? [];
    return list.toSet();
  }

  Future<void> saveBookmarkedIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyBookmarks, ids.toList());
  }

  Future<Set<String>> loadLearnedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyLearned) ?? [];
    return list.toSet();
  }

  Future<void> saveLearnedIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyLearned, ids.toList());
  }

  Future<List<VocabItem>> loadCustomVocab() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_keyCustomVocab);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final list = jsonDecode(jsonStr) as List;
        return list.map((item) => VocabItem.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint('Error loading custom vocab: $e');
    }
    return [];
  }

  Future<void> saveCustomVocab(List<VocabItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(items.map((i) => i.toJson()).toList());
      await prefs.setString(_keyCustomVocab, jsonStr);
    } catch (e) {
      debugPrint('Error saving custom vocab: $e');
    }
  }

  Future<Map<String, Map<String, int>>> loadReviewStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_keyReviewStats);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        final result = <String, Map<String, int>>{};
        map.forEach((key, val) {
          if (val is Map) {
            result[key] = {
              'reviewed': (val['reviewed'] as num?)?.toInt() ?? 0,
              'correct': (val['correct'] as num?)?.toInt() ?? 0,
            };
          }
        });
        return result;
      }
    } catch (e) {
      debugPrint('Error loading review stats: $e');
    }
    return {};
  }

  Future<void> saveReviewStats(Map<String, Map<String, int>> stats) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(stats);
      await prefs.setString(_keyReviewStats, jsonStr);
    } catch (e) {
      debugPrint('Error saving review stats: $e');
    }
  }

  // --- Cloud Sync Simulator (Firebase-ready JSON serialization) ---
  Future<String> exportFullDataPackage(UserProgress progress, List<VocabItem> customVocab, Set<String> bookmarks, Set<String> learned) async {
    final payload = {
      'version': '1.0.0',
      'syncedAt': DateTime.now().toIso8601String(),
      'progress': progress.toJson(),
      'bookmarks': bookmarks.toList(),
      'learned': learned.toList(),
      'customVocab': customVocab.map((v) => v.toJson()).toList(),
    };
    final jsonString = const JsonEncoder.withIndent('  ').convert(payload);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCloudBackup, jsonString);
    return jsonString;
  }

  Future<String?> getLatestCloudSnapshot() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCloudBackup);
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
