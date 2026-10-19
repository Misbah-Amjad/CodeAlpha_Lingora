import '../models/language.dart';

class LanguagesData {
  static const List<Language> supportedLanguages = [
    Language(
      id: 'es',
      name: 'Spanish',
      nativeName: 'Español',
      flagEmoji: '🇪🇸',
      code: 'es',
      ttsLocale: 'es-ES',
      description: 'Spoken across 21 countries, rich in warmth, music & culture.',
      greeting: '¡Hola! Bienvenido.',
    ),
    Language(
      id: 'fr',
      name: 'French',
      nativeName: 'Français',
      flagEmoji: '🇫🇷',
      code: 'fr',
      ttsLocale: 'fr-FR',
      description: 'The language of diplomacy, gastronomy, romance & art.',
      greeting: 'Bonjour ! Bienvenue.',
    ),
    Language(
      id: 'de',
      name: 'German',
      nativeName: 'Deutsch',
      flagEmoji: '🇩🇪',
      code: 'de',
      ttsLocale: 'de-DE',
      description: 'Language of innovation, philosophy, science & literature.',
      greeting: 'Hallo! Willkommen.',
    ),
    Language(
      id: 'ja',
      name: 'Japanese',
      nativeName: '日本語',
      flagEmoji: '🇯🇵',
      code: 'ja',
      ttsLocale: 'ja-JP',
      description: 'Fascinating blend of tradition, nuance, Kanji & modern culture.',
      greeting: 'こんにちは！ようこそ。',
    ),
    Language(
      id: 'it',
      name: 'Italian',
      nativeName: 'Italiano',
      flagEmoji: '🇮🇹',
      code: 'it',
      ttsLocale: 'it-IT',
      description: 'Musical, expressive language of cuisine, architecture & opera.',
      greeting: 'Ciao! Benvenuto.',
    ),
  ];

  static Language get defaultLanguage => supportedLanguages.first;

  static Language getById(String id) {
    return supportedLanguages.firstWhere(
      (lang) => lang.id == id,
      orElse: () => supportedLanguages.first,
    );
  }
}
