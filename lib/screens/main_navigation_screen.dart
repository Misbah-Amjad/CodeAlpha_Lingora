import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/learning_state.dart';
import '../services/theme_service.dart';
import '../theme/app_colors.dart';
import '../widgets/progress_streak_header.dart';
import 'bookmarks_screen.dart';
import 'flashcards_screen.dart';
import 'home_screen.dart';
import 'lessons_screen.dart';
import 'profile_screen.dart';
import 'progress_screen.dart';
import 'quiz_screen.dart';
import 'settings_sync_screen.dart';
import 'vocabulary_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final LearningState learningState;
  final ThemeService themeService;

  const MainNavigationScreen({
    super.key,
    required this.learningState,
    required this.themeService,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  CategoryType? _selectedCategoryFilter;

  void _onSelectTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onCategorySelected(CategoryType cat) {
    setState(() {
      _selectedCategoryFilter = cat;
      _currentIndex = 2; // Jump to Flashcards with that category
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final pages = [
      HomeScreen(
        learningState: widget.learningState,
        onNavigateTab: _onSelectTab,
        onSelectCategory: _onCategorySelected,
      ),
      LessonsScreen(
        learningState: widget.learningState,
      ),
      FlashcardsScreen(
        learningState: widget.learningState,
        initialCategory: _selectedCategoryFilter,
      ),
      QuizScreen(
        learningState: widget.learningState,
      ),
      VocabularyScreen(
        learningState: widget.learningState,
        initialCategory: _selectedCategoryFilter,
      ),
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(66),
        child: ProgressStreakHeader(
          learningState: widget.learningState,
          themeService: widget.themeService,
        ),
      ),
      drawer: _buildAppDrawer(context, isDark),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive: if screen is wide (desktop/tablet > 768px), use NavigationRail
          if (constraints.maxWidth > 768) {
            return Row(
              children: [
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: _onSelectTab,
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  indicatorColor: AppColors.primary.withValues(alpha: 0.15),
                  selectedIconTheme: const IconThemeData(color: AppColors.primary),
                  selectedLabelTextStyle: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.auto_stories_outlined),
                      selectedIcon: Icon(Icons.auto_stories_rounded),
                      label: Text('Lessons'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.style_outlined),
                      selectedIcon: Icon(Icons.style_rounded),
                      label: Text('Flashcards'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.quiz_outlined),
                      selectedIcon: Icon(Icons.quiz_rounded),
                      label: Text('Quizzes'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.menu_book_outlined),
                      selectedIcon: Icon(Icons.menu_book_rounded),
                      label: Text('Vocab'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: pages,
                  ),
                ),
              ],
            );
          }

          // Mobile View: IndexedStack with bottom NavigationBar
          return IndexedStack(
            index: _currentIndex,
            children: pages,
          );
        },
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 768) {
            return const SizedBox.shrink(); // NavigationRail handles desktop
          }
          return NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: _onSelectTab,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            indicatorColor: AppColors.primary.withValues(alpha: 0.18),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.auto_stories_outlined),
                selectedIcon: Icon(Icons.auto_stories_rounded, color: AppColors.primary),
                label: 'Lessons',
              ),
              NavigationDestination(
                icon: Icon(Icons.style_outlined),
                selectedIcon: Icon(Icons.style_rounded, color: AppColors.primary),
                label: 'Flashcards',
              ),
              NavigationDestination(
                icon: Icon(Icons.quiz_outlined),
                selectedIcon: Icon(Icons.quiz_rounded, color: AppColors.primary),
                label: 'Quizzes',
              ),
              NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                selectedIcon: Icon(Icons.menu_book_rounded, color: AppColors.primary),
                label: 'Vocab',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppDrawer(BuildContext context, bool isDark) {
    final progress = widget.learningState.progress;
    final lang = widget.learningState.selectedLanguage;
    final profile = widget.learningState.userProfile;

    return Drawer(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header - Learner Profile Card
            Material(
              color: isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileScreen(learningState: widget.learningState),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.primary, width: 1.5),
                        ),
                        child: Center(
                          child: Text(profile.avatarEmoji, style: const TextStyle(fontSize: 26)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${profile.age} yrs • ${profile.gender}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Learning ${lang.name} ${lang.flagEmoji}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Navigation Items
            ListTile(
              leading: const Icon(Icons.person_rounded, color: AppColors.primary),
              title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(
                '${profile.interests.length} interests • ${profile.learningGoal}',
                style: const TextStyle(fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileScreen(learningState: widget.learningState),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_rounded, color: AppColors.primary),
              title: const Text('Saved Vocabulary', style: TextStyle(fontWeight: FontWeight.w700)),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${widget.learningState.bookmarkedItems.length}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookmarksScreen(learningState: widget.learningState),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.insights_rounded, color: AppColors.secondary),
              title: const Text('Learning Analytics', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(
                'Level ${progress.level} • ${progress.totalXp} XP',
                style: const TextStyle(fontSize: 11),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProgressScreen(learningState: widget.learningState),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.cloud_sync_rounded, color: AppColors.accentGold),
              title: const Text('Settings & Data Sync', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text(
                'Firebase & Local Backup',
                style: TextStyle(fontSize: 11),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SettingsSyncScreen(learningState: widget.learningState),
                  ),
                );
              },
            ),

            ListTile(
              leading: Icon(
                widget.themeService.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: widget.themeService.isDarkMode ? AppColors.accentGold : AppColors.primary,
              ),
              title: Text(
                widget.themeService.isDarkMode ? 'Dark Theme' : 'Light Theme',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                widget.themeService.isDarkMode ? 'Tap to switch to Light Theme' : 'Tap to switch to Dark Theme',
                style: const TextStyle(fontSize: 11),
              ),
              trailing: Switch.adaptive(
                value: widget.themeService.isDarkMode,
                activeThumbColor: AppColors.primary,
                activeTrackColor: AppColors.primary.withValues(alpha: 0.4),
                onChanged: (_) {
                  widget.themeService.toggleTheme();
                },
              ),
              onTap: () {
                widget.themeService.toggleTheme();
              },
            ),

            const Spacer(),
            const Divider(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'LingoPulse v1.0.0 • CodeAlpha Internship Project',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
