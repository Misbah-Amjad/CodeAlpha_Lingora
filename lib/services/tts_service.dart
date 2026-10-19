import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService with ChangeNotifier {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal() {
    _initTts();
  }

  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  bool _isAvailable = true;
  double _speechRate = 0.45; // comfortable learning rate
  String _currentLanguage = 'es-ES';

  bool get isSpeaking => _isSpeaking;
  bool get isAvailable => _isAvailable;
  double get speechRate => _speechRate;
  String get currentLanguage => _currentLanguage;

  Future<void> _initTts() async {
    try {
      _flutterTts.setStartHandler(() {
        _isSpeaking = true;
        notifyListeners();
      });

      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
        notifyListeners();
      });

      _flutterTts.setErrorHandler((msg) {
        debugPrint('TTS Error: $msg');
        _isSpeaking = false;
        notifyListeners();
      });

      await _flutterTts.setSpeechRate(_speechRate);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
    } catch (e) {
      debugPrint('TTS initialization warning: $e');
      _isAvailable = false;
    }
  }

  Future<void> setLanguage(String bcp47Locale) async {
    _currentLanguage = bcp47Locale;
    try {
      await _flutterTts.setLanguage(bcp47Locale);
    } catch (e) {
      debugPrint('TTS setLanguage error: $e');
    }
  }

  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate;
    try {
      await _flutterTts.setSpeechRate(rate);
      notifyListeners();
    } catch (e) {
      debugPrint('TTS setSpeechRate error: $e');
    }
  }

  Future<void> speak(String text, {String? locale, bool slow = false}) async {
    if (text.trim().isEmpty) return;
    try {
      await stop();

      if (locale != null && locale != _currentLanguage) {
        await _flutterTts.setLanguage(locale);
      } else {
        await _flutterTts.setLanguage(_currentLanguage);
      }

      await _flutterTts.setSpeechRate(slow ? 0.25 : _speechRate);
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint('TTS speak error: $e');
      _isSpeaking = false;
      notifyListeners();
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
      _isSpeaking = false;
      notifyListeners();
    } catch (e) {
      debugPrint('TTS stop error: $e');
    }
  }
}
