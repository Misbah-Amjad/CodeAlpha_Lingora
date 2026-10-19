\# 🌐 Lingora — Speak a New World

### Interactive Language Learning Mobile Application

**Lingora** is a Flutter-based language learning application developed as part of my **CodeAlpha Mobile App Development Internship**. It combines interactive lessons, vocabulary practice, flashcards, quizzes, and learning progress tracking in a modern, engaging interface.

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev/)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-4CAF50)](#)
[![Internship](https://img.shields.io/badge/CodeAlpha-Internship%20Project-FF4B3E)](https://www.codealpha.tech/)

**Speak. Practice. Progress.**

*Built with Flutter and Dart | CodeAlpha Internship — October 2026*

</div>

---

## 📖 Project Overview

Lingora is designed to make language learning more accessible, interactive, and enjoyable. It helps learners explore new languages, build vocabulary, practice pronunciation, complete lessons, and monitor their learning progress.

The application features a distinctive **Electric Coral and Indigo** design system, light and dark themes, reusable Flutter components, and offline-first local data persistence.

This project demonstrates my practical experience in Flutter UI development, Dart programming, state management, local storage, interactive learning experiences, and responsive application design.

## ✨ Key Features

### 🌍 1. Multi-Language Learning

- Learn Spanish 🇪🇸, French 🇫🇷, German 🇩🇪, Japanese 🇯🇵, and Italian 🇮🇹.
- Switch between target languages.
- Explore categorized content, including vocabulary, grammar, daily phrases, travel, food, business, and culture.

### 📚 2. Interactive Lessons

- Follow structured lessons from beginner vocabulary to conversational practice.
- Listen to word pronunciations using text-to-speech (TTS).
- Save useful vocabulary for later revision.

### 🃏 3. Flashcard Practice

- Review words, translations, pronunciation guides, and example sentences.
- Mark vocabulary as mastered or needing revision.
- Practice vocabulary by category or across the available collection.

### 🎯 4. Quizzes and Gamification

- Test language comprehension through multiple-choice quizzes.
- Receive feedback on answers.
- Track experience points (XP), streaks, levels, and learning milestones.
- Enjoy celebratory animations after quiz completion.

### 👤 5. Personalized Learner Profile

- Customize your name, age, gender, avatar, biography, learning goals, and interests.
- Save profile information locally using SharedPreferences.
- Access profile information through the app navigation.

### 🎨 6. Light and Dark Themes

- **Light mode:** clean surfaces with Electric Coral and Indigo accents.
- **Dark mode:** a deep navy interface designed for comfortable viewing.
- Switch themes from the app navigation.

### 📊 7. Learning Analytics

- View learning progress, XP, streaks, and level information.
- Monitor progress toward learning goals.
- Use progress information to support consistent study habits.

### 🚀 8. Custom Launch and Splash Screens

- Branded application launch and splash screens.
- Custom Lingora emblem and animated visual elements.
- Language-inspired landmark illustrations and smooth transitions.

### 💾 9. Offline-First Local Storage

- Persist supported profile, progress, theme, and vocabulary data locally.
- Continue using core learning features without requiring a cloud connection.
- Includes a sync/settings screen designed to support future cloud backup and restoration integration.

---

## 🎨 Design System

Lingora uses a custom color palette to create a recognizable, modern learning experience.

| Design Token | Hex Code | Purpose |
|---|---|---|
| Electric Coral | `#FF4B3E` | Primary buttons and active states |
| Coral Light | `#FF7266` | Highlights and interactive accents |
| Coral Dark | `#E02B1D` | Strong emphasis |
| Electric Indigo | `#4F46E5` | Secondary actions and indicators |
| Indigo Light | `#6366F1` | Secondary highlights |
| Radiant Amber | `#F59E0B` | XP, achievements, and milestones |
| Success Emerald | `#10B981` | Correct answers and mastery |
| Light Background | `#F8FAFC` | Light theme surfaces |
| Dark Background | `#0A0E1A` | Dark theme background |
| Dark Surface | `#131B2E` | Elevated dark theme cards |

The interface uses reusable widgets, consistent spacing, custom typography, and Material Design components to maintain a cohesive user experience.

---

## 📱 App Screenshots

Explore Lingora's interface, including the launch experience, vocabulary tools, flashcards, lessons, quizzes, and learner profile.

### 🚀 Launch & Getting Started

| Launch Screen | Splash Screen | Choose Target Language |
|---|---|---|
| ![Launch Screen](screenshots/launch%20screen.jpeg) | ![Splash Screen](screenshots/splash%20screen.jpeg) | ![Choose Target Language](screenshots/choose%20target%20language%20screen.jpeg) |

### 🏠 Home & Navigation

| Home Screen | App Drawer |
|---|---|
| ![Home Screen](screenshots/home%20screen.jpeg) | ![App Drawer](screenshots/app%20drawer.jpeg) |

### 📚 Vocabulary & Learning

| Vocabulary Screen | Add Vocabulary | Saved Vocabulary |
|---|---|---|
| ![Vocabulary Screen](screenshots/vocab%20screen.jpeg) | ![Add Vocabulary Screen](screenshots/Add%20vocab%20sreen.jpeg) | ![Saved Vocabulary Screen](screenshots/saved%20vocab%20screen.jpeg) |

### 🃏 Flashcards & Lessons

| Flashcard Screen | Lesson Screen | Quiz Screen |
|---|---|---|
| ![Flashcard Screen](screenshots/flashcard%20sceen.jpeg) | ![Lesson Screen](screenshots/Lesson%20screen.jpeg) | ![Quiz Screen](screenshots/quizz%20screen.jpeg) |

### 📊 Analytics & Personalization

| Learning Analytics | Profile Screen | Settings Screen |
|---|---|---|
| ![Learning Analytics](screenshots/learning%20analytics%20screen.jpeg) | ![Profile Screen](screenshots/profile%20screen.jpeg) | ![Settings Screen](screenshots/settings%20screen.jpeg) |

---

## 🛠️ Technology Stack

| Technology / Package | Purpose |
|---|---|
| **Flutter** | Cross-platform application UI |
| **Dart** | Application programming language |
| **Material Design 3** | UI components and theming |
| **Provider-style ChangeNotifier state management** | Managing learning and application state |
| **SharedPreferences** | Local persistence for supported application data |
| **flutter_tts** | Text-to-speech pronunciation |
| **google_fonts** | Custom typography |
| **confetti** | Quiz completion animations |
| **intl** | Date formatting and internationalization utilities |
| **uuid** | Unique identifier generation |

---

## 🏗️ Project Architecture

The project follows a feature-oriented structure that separates data, models, screens, services, themes, and reusable widgets.

```text
lib/
├── data/
│   └── language_data.dart
├── models/
│   ├── category.dart
│   ├── language.dart
│   ├── lesson.dart
│   ├── quiz_question.dart
│   ├── user_profile.dart
│   ├── user_progress.dart
│   └── vocab_item.dart
├── screens/
│   ├── bookmarks_screen.dart
│   ├── flashcards_screen.dart
│   ├── home_screen.dart
│   ├── lessons_screen.dart
│   ├── main_navigation_screen.dart
│   ├── profile_screen.dart
│   ├── progress_screen.dart
│   ├── quiz_screen.dart
│   ├── settings_sync_screen.dart
│   ├── splash_screen.dart
│   └── vocabulary_screen.dart
├── services/
│   ├── audio_service.dart
│   ├── learning_state.dart
│   ├── storage_service.dart
│   └── theme_service.dart
├── theme/
│   ├── app_colors.dart
│   ├── app_theme.dart
│   └── app_typography.dart
├── widgets/
│   ├── app_header.dart
│   ├── custom_card.dart
│   ├── progress_streak_header.dart
│   └── tactile_button.dart
└── main.dart
```

*Note: This tree highlights the main application files; it may not list every file in the repository.*

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Dart SDK compatible with your installed Flutter version
- [Visual Studio Code](https://code.visualstudio.com/) with the Flutter and Dart extensions, or another supported Flutter IDE
- An Android emulator or connected device for running the application

### 1. Clone the Repository

```bash
git clone https://github.com/Misbah-Amjad/CodeAlpha_Lingora.git
cd CodeAlpha_Lingora
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Check the Project

```bash
flutter analyze
flutter test
```

### 4. Run the Application

```bash
flutter run
```

### 5. Build a Release APK

```bash
flutter build apk --release
```

When the build succeeds, the APK is normally generated at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## 🧪 Testing and Code Quality

Run Flutter's static analysis and automated tests before submitting changes:

```bash
flutter analyze
flutter test
```

Review the command output to confirm the current analysis and test results. Test coverage depends on the tests implemented in the project.

---

## 🎓 Internship Project

**Program:** CodeAlpha Mobile App Development Internship  
**Project:** Lingora — Language Learning Mobile Application  
**Project Type:** Flutter Application Development  
**Development Period:** October 2026  
**Purpose:** Practical application development, portfolio development, and internship task submission

This project gave me the opportunity to apply Flutter and Dart concepts in a complete application, with particular attention to interface design, reusable components, local persistence, state management, and interactive learning features.

---

## 👩‍💻 Developer

**Misbah Amjad**  
Flutter Developer | Mobile App Development

- **GitHub:** [github.com/Misbah-Amjad](https://github.com/Misbah-Amjad)
- **LinkedIn:** [linkedin.com/in/misbahh-amjad](https://www.linkedin.com/in/misbahh-amjad/)

I enjoy building clean, user-friendly mobile applications and continuously improving my skills in Flutter, Dart, Firebase, and application development.

---

## 🙌 Acknowledgments

- **[CodeAlpha](https://www.codealpha.tech/)** — Internship program and project opportunity.
- **[Flutter](https://flutter.dev/)** — Cross-platform application development framework.
- The open-source Flutter ecosystem and package contributors.

---

<div align="center">

**Lingora — Learn new words, build confidence, and make every lesson count.**

*Designed and developed with Flutter and Dart by Misbah Amjad.*

</div>
