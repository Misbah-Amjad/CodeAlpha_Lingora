import 'package:flutter/material.dart';

import 'screens/main_navigation_screen.dart';
import 'screens/splash_screen.dart';
import 'services/learning_state.dart';
import 'services/theme_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LingoPulseApp());
}

class LingoPulseApp extends StatefulWidget {
  const LingoPulseApp({super.key});

  @override
  State<LingoPulseApp> createState() => _LingoPulseAppState();
}

class _LingoPulseAppState extends State<LingoPulseApp> {
  final LearningState _learningState = LearningState();
  final ThemeService _themeService = ThemeService();
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _learningState.addListener(_onStateChange);
    _themeService.addListener(_onStateChange);
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _learningState.removeListener(_onStateChange);
    _themeService.removeListener(_onStateChange);
    _learningState.dispose();
    _themeService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lingora - Language Learning App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeService.themeMode,
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: _showSplash
            ? SplashScreen(
                key: const ValueKey('splash_screen'),
                onFinish: () {
                  if (mounted) {
                    setState(() => _showSplash = false);
                  }
                },
              )
            : MainNavigationScreen(
                key: const ValueKey('main_navigation'),
                learningState: _learningState,
                themeService: _themeService,
              ),
      ),
    );
  }
}
