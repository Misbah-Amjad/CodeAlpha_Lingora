import 'package:flutter/material.dart';

enum CategoryType {
  vocabulary,
  grammar,
  phrases,
  travel,
  numbers,
  culture,
}

class LearningCategory {
  final CategoryType type;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;

  const LearningCategory({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
  });

  static const List<LearningCategory> allCategories = [
    LearningCategory(
      type: CategoryType.vocabulary,
      title: 'Vocabulary',
      subtitle: 'Core words, nouns & essentials',
      icon: Icons.auto_stories_rounded,
      primaryColor: Color(0xFFFF5A36), // Sunset Coral
      secondaryColor: Color(0xFFFF8A3D),
    ),
    LearningCategory(
      type: CategoryType.grammar,
      title: 'Grammar',
      subtitle: 'Tenses, sentence structure & rules',
      icon: Icons.menu_book_rounded,
      primaryColor: Color(0xFF4338CA), // Royal Iris Indigo
      secondaryColor: Color(0xFF6366F1),
    ),
    LearningCategory(
      type: CategoryType.phrases,
      title: 'Everyday Phrases',
      subtitle: 'Greetings, chit-chat & expressions',
      icon: Icons.chat_bubble_rounded,
      primaryColor: Color(0xFFFFB020), // Honey Amber
      secondaryColor: Color(0xFFFF7A00),
    ),
    LearningCategory(
      type: CategoryType.travel,
      title: 'Travel & Dining',
      subtitle: 'Ordering food, hotels & transit',
      icon: Icons.flight_takeoff_rounded,
      primaryColor: Color(0xFF0284C7), // Azure Sky
      secondaryColor: Color(0xFF38BDF8),
    ),
    LearningCategory(
      type: CategoryType.numbers,
      title: 'Numbers & Time',
      subtitle: 'Clock, dates, counting & calendar',
      icon: Icons.access_time_filled_rounded,
      primaryColor: Color(0xFF059669), // Sage Mint
      secondaryColor: Color(0xFF34D399),
    ),
    LearningCategory(
      type: CategoryType.culture,
      title: 'Culture & Idioms',
      subtitle: 'Native idioms & cultural nuances',
      icon: Icons.lightbulb_rounded,
      primaryColor: Color(0xFFE11D48), // Crimson Rose
      secondaryColor: Color(0xFFF43F5E),
    ),
  ];

  static LearningCategory fromType(CategoryType type) {
    return allCategories.firstWhere(
      (cat) => cat.type == type,
      orElse: () => allCategories.first,
    );
  }

  static LearningCategory fromString(String name) {
    return allCategories.firstWhere(
      (cat) => cat.type.name.toLowerCase() == name.toLowerCase(),
      orElse: () => allCategories.first,
    );
  }
}
