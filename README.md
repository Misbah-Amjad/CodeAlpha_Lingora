<div align="center">

# 🌐 Lingora — Speak a new world.
### *Interactive Language Learning Mobile Application*

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-4CAF50)](#)
[![CodeAlpha](https://img.shields.io/badge/CodeAlpha-Internship%20Task-FF4B3E)](https://www.codealpha.tech/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

*Developed for the **CodeAlpha Mobile Development Internship** submission and developer portfolio.*

---

</div>

## 📖 Project Overview

**Lingora** is a feature-rich, beautifully designed language learning application crafted with **Flutter** and **Dart**. The app empowers users to master new languages through structured daily lessons, interactive flashcards with native audio pronunciation, categorized vocabulary explorers, gamified quizzes, learning analytics, and customizable learner profiles.

Designed with a distinct, refreshing visual identity, Lingora features a custom color system, modern typography, responsive multi-device layouts (Mobile & Tablet/Desktop), and local persistence that works 100% offline.

---

## ✨ Key Features

### 1. 🌍 Multi-Language Curriculum
- Learn **Spanish 🇪🇸**, **French 🇫🇷**, **German 🇩🇪**, **Japanese 🇯🇵**, and **Italian 🇮🇹**.
- Switch target languages on the fly; curriculum and vocabulary dynamically adapt.
- Curated categories: **Vocabulary**, **Grammar & Sentence Patterns**, **Daily Phrases**, **Travel**, **Food & Dining**, **Business**, and **Culture**.

### 2. 📚 Interactive Daily Lessons
- Step-by-step modular lessons ranging from beginner greetings to conversational mastery.
- Real-time text-to-speech (**TTS**) audio pronunciation so learners can hear authentic native intonation.
- Instant bookmarking of unfamiliar words to a dedicated Saved Vocabulary library.

### 3. 🃏 Tactile Flashcard Practice
- Swipeable/flippable flashcards showing target language terms, phonetic pronunciation, translations, and contextual example sentences.
- Mark cards as "Mastered" or "Review Needed" with real-time progress calculations.
- Filter flashcards by specific category or study all items simultaneously.

### 4. 🎯 Progress Quizzes & Gamification
- Multiple-choice testing engine evaluating comprehension, translations, and grammatical structures.
- Instant feedback with animated explanations for correct and incorrect answers.
- XP (Experience Points), Streak tracking, level milestones (*Beginner → Active Explorer → Fluent Apprentice → Polyglot Master*), and celebratory confetti upon quiz completion.

### 5. 👤 Personalized Learner Profile
- Accessible directly from the navigation drawer.
- Customizable profile including **Name**, **Age**, **Gender**, **Avatar**, **Learning Goal**, **Bio**, and **Interest tags** (*Travel, Tech, Anime, Cuisine, Literature, etc.*).
- Fully persisted offline via `SharedPreferences`.

### 6. 🎨 Dual Theme System (Light & Dark)
- **Light Theme (Default):** Crisp Ice & Slate (`#F8FAFC`) surfaces with Electric Coral (`#FF4B3E`) and Iris Indigo (`#4F46E5`) brand accents.
- **Dark Theme:** Deep Cosmic Navy (`#0A0E1A`) glass surfaces with elevated contrast and reduced eye strain.
- Quick one-tap toggle switch located in the app drawer.

### 7. 🚀 Native Launch & Custom Splash Screen
- **Native Android 12+ / iOS Launch Screen:** Displays the high-resolution Lingora emblem centered on a branded `#F8FAFC` background.
- **Custom Flutter Splash Screen:** Features the vibrant Lingora emblem, twinkling star animations, tagline, and custom-drawn vector silhouettes of global landmarks (Eiffel Tower, Pagoda, Taj Mahal, Big Ben, and Colosseum).
- Zero-blur rendering architecture with isolated repaint boundaries and smooth cross-fade navigation.

### 8. ☁️ Offline-First & Data Sync Ready
- Complete offline functionality utilizing `SharedPreferences` for local progress, profiles, and bookmarks.
- Built-in data sync screen prepared for cloud backup and restoration (e.g., Firebase).

---

## 🎨 Design System & Color Palette

Lingora uses an original, vibrant design system that stands out with modern contrast and energetic tones:

| Token | Hex Code | Visual Swatch | Usage |
|:---|:---:|:---:|:---|
| **Primary (Electric Coral)** | `#FF4B3E` | 🔴 | Primary buttons, active tabs, streak counters |
| **Secondary (Electric Indigo)** | `#4F46E5` | 🟣 | Badges, level indicators, secondary accents |
| **Accent Gold (Radiant Amber)** | `#F59E0B` | 🟡 | XP badges, star ratings, milestones |
| **Success Emerald** | `#10B981` | 🟢 | Correct answers, mastery indicators |
| **Light Background** | `#F8FAFC` | ⚪ | Default crisp app background & splash screen |
| **Light Surface** | `#FFFFFF` | ⬜ | Card surfaces, modals, elevated sheets |
| **Dark Background** | `#0A0E1A` | ⚫ | Cosmic navy dark mode background |
| **Dark Surface** | `#131B2E` | ⬛ | Elevated dark mode cards |

---

## 🏗️ Project Architecture & Directory Structure

```text
lib/
├── data/
│   └── language_data.dart        # Complete curriculum, vocabulary & quiz banks
├── models/
│   ├── category.dart             # Category enum & metadata
│   ├── language.dart             # Supported languages & flag assets
│   ├── lesson.dart               # Structured lesson models
│   ├── quiz_question.dart        # Quiz questions, options & answer logic
│   ├── user_profile.dart         # User profile data class with JSON serialization
│   ├── user_progress.dart        # XP, streaks, levels & completion tracking
│   └── vocab_item.dart           # Vocabulary term data class with audio keys
├── screens/
│   ├── bookmarks_screen.dart     # Saved words library with audio playback
│   ├── flashcards_screen.dart    # Flippable flashcard practice screen
│   ├── home_screen.dart          # Dashboard with daily goals, streaks & shortcuts
│   ├── lessons_screen.dart       # Interactive lesson walkthrough
│   ├── main_navigation_screen.dart # Responsive drawer & tab navigation
│   ├── profile_screen.dart       # User profile viewer and editor
│   ├── progress_screen.dart      # XP analytics, level tiers & learning stats
│   ├── quiz_screen.dart          # Gamified quiz engine with confetti
│   ├── settings_sync_screen.dart # Data backup, language selection & reset
│   ├── splash_screen.dart        # Zero-blur animated splash screen
│   └── vocabulary_screen.dart    # Categorized vocabulary explorer
├── services/
│   ├── audio_service.dart        # Text-To-Speech (TTS) integration
│   ├── learning_state.dart       # Core ChangeNotifier state management
│   ├── storage_service.dart      # SharedPreferences persistence layer
│   └── theme_service.dart        # Light / Dark theme mode controller
├── theme/
│   ├── app_colors.dart           # Brand palette, tokens & gradients
│   ├── app_theme.dart            # ThemeData definitions for Material 3
│   └── app_typography.dart       # Typography styles (GoogleFonts Plus Jakarta Sans)
├── widgets/
│   ├── app_header.dart           # Reusable branded app headers
│   ├── custom_card.dart          # Styled container cards
│   ├── progress_streak_header.dart # Global streak & XP status bar
│   └── tactile_button.dart       # Bouncy, tactile interactive button widget
└── main.dart                     # Application root with splash cross-fade
```

---

## 🛠️ Tech Stack & Dependencies

| Dependency | Version | Purpose |
|:---|:---:|:---|
| **Flutter SDK** | `^3.10.0+` | Core UI framework |
| **shared_preferences** | `^2.5.5` | Fast, persistent key-value storage for offline learning state |
| **flutter_tts** | `^4.2.5` | Native Text-To-Speech engine for authentic pronunciation |
| **google_fonts** | `^8.2.1` | Modern Plus Jakarta Sans typography |
| **confetti** | `^0.8.0` | Celebration particle animations upon quiz completion |
| **intl** | `^0.20.3` | Internationalization and date formatting |
| **uuid** | `^4.6.0` | Unique ID generation for state items |

---

## 🚀 Getting Started & Installation

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.10 or higher)
- [Android Studio](https://developer.android.com/studio) / [VS Code](https://code.visualstudio.com/) with Flutter extensions
- Connected Android/iOS physical device or emulator

### Setup Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/codealpha_language_learning_app.git
   cd codealpha_language_learning_app
   ```

2. **Install project dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify project code health:**
   ```bash
   flutter analyze
   flutter test
   ```

4. **Run on your connected device:**
   ```bash
   flutter run
   ```

To build a release APK:
```bash
flutter build apk --release
```
The APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`.

---

## 🧪 Testing & Code Quality

Lingora maintains clean, warning-free code adhering to official Flutter linting standards (`flutter_lints`).

- Run static analysis:
  ```bash
  flutter analyze
  ```
  *Result: `No issues found!`*

- Run automated test suite:
  ```bash
  flutter test
  ```
  *Result: `All tests passed!` (Curriculum integrity, XP calculation, model serialization, and widget smoke tests).*

---

## 👤 Author & Acknowledgments

- **Developer:** [Your Name / Portfolio Link]
- **Internship Program:** [CodeAlpha](https://www.codealpha.tech/)
- **Task:** Language Learning Mobile App
- **Submission Date:** October 2026

*Crafted with passion for language learning and modern mobile UI design.*
