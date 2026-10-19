import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import '../services/learning_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/audio_speaker_button.dart';
import '../widgets/quiz_option_tile.dart';
import '../widgets/tactile_button.dart';
import '../widgets/word_scramble_widget.dart';

class QuizScreen extends StatefulWidget {
  final LearningState learningState;

  const QuizScreen({super.key, required this.learningState});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late ConfettiController _confettiController;

  bool _isQuizActive = false;
  bool _isQuizCompleted = false;

  List<QuizQuestion> _activeQuestions = [];
  int _currentQuestionIndex = 0;
  String? _selectedOption;
  List<String> _currentScrambleOrder = [];
  bool _isAnswerSubmitted = false;
  bool _isCurrentCorrect = false;

  int _scoreCount = 0;
  final List<String> _missedQuestionIds = [];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _startQuiz({QuizType? filterType}) {
    final allQuestions = widget.learningState.currentQuizQuestions;
    List<QuizQuestion> questions;
    if (filterType != null) {
      questions = allQuestions.where((q) => q.type == filterType).toList();
      if (questions.isEmpty) questions = allQuestions;
    } else {
      questions = List.from(allQuestions);
    }
    questions.shuffle();

    setState(() {
      _activeQuestions = questions.take(6).toList();
      _currentQuestionIndex = 0;
      _scoreCount = 0;
      _missedQuestionIds.clear();
      _selectedOption = null;
      _currentScrambleOrder = [];
      _isAnswerSubmitted = false;
      _isCurrentCorrect = false;
      _isQuizActive = true;
      _isQuizCompleted = false;
    });
  }

  void _submitAnswer() {
    final currentQ = _activeQuestions[_currentQuestionIndex];
    bool isCorrect = false;

    if (currentQ.type == QuizType.wordScramble) {
      final userOrder = _currentScrambleOrder.join(' ').trim();
      final targetOrder = currentQ.correctAnswer.trim();
      isCorrect = userOrder == targetOrder;
    } else {
      isCorrect = _selectedOption?.trim() == currentQ.correctAnswer.trim();
    }

    setState(() {
      _isAnswerSubmitted = true;
      _isCurrentCorrect = isCorrect;
      if (isCorrect) {
        _scoreCount++;
      } else {
        _missedQuestionIds.add(currentQ.id);
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _activeQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOption = null;
        _currentScrambleOrder = [];
        _isAnswerSubmitted = false;
        _isCurrentCorrect = false;
      });
    } else {
      // Quiz complete!
      final total = _activeQuestions.length;
      final xp = _scoreCount * 15;
      widget.learningState.recordQuizResult(
        totalQuestions: total,
        correctAnswers: _scoreCount,
        xpEarned: xp,
        missedQuestionIds: _missedQuestionIds,
      );

      setState(() {
        _isQuizActive = false;
        _isQuizCompleted = true;
      });

      if (_scoreCount >= (total * 0.6)) {
        _confettiController.play();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lang = widget.learningState.selectedLanguage;

    return Scaffold(
      body: Stack(
        children: [
          if (!_isQuizActive && !_isQuizCompleted)
            _buildQuizLobby(isDark, lang)
          else if (_isQuizActive)
            _buildActiveQuiz(isDark, lang)
          else
            _buildQuizResults(isDark, lang),

          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                AppColors.primary,
                AppColors.secondary,
                AppColors.accentGold,
                AppColors.accentEmerald,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizLobby(bool isDark, dynamic lang) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.irisGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.28),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${lang.flagEmoji} ${lang.name} Testing Center',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Challenge Your Knowledge',
                  style: AppTypography.getDisplayFont(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Earn up to +90 XP, test ear-training, and track memory retention.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Select Quiz Challenge Mode',
            style: AppTypography.getDisplayFont(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Test Mode Options
          _buildModeCard(
            isDark: isDark,
            icon: Icons.checklist_rounded,
            color: AppColors.primary,
            title: 'Full Comprehensive Test',
            subtitle: 'Mixed questions covering vocabulary, listening, and sentence building.',
            xp: '+75 XP',
            onTap: () => _startQuiz(),
          ),
          _buildModeCard(
            isDark: isDark,
            icon: Icons.headphones_rounded,
            color: AppColors.secondary,
            title: 'Listening Ear-Training',
            subtitle: 'Listen to native pronunciations and identify the correct meaning.',
            xp: '+50 XP',
            onTap: () => _startQuiz(filterType: QuizType.listening),
          ),
          _buildModeCard(
            isDark: isDark,
            icon: Icons.extension_rounded,
            color: AppColors.accentGold,
            title: 'Sentence Builder / Scramble',
            subtitle: 'Construct correct grammatical sentences by rearranging words.',
            xp: '+60 XP',
            onTap: () => _startQuiz(filterType: QuizType.wordScramble),
          ),
          _buildModeCard(
            isDark: isDark,
            icon: Icons.bolt_rounded,
            color: AppColors.accentEmerald,
            title: 'Speed Recall (True or False)',
            subtitle: 'Rapid fire true or false accuracy check for quick revision.',
            xp: '+45 XP',
            onTap: () => _startQuiz(filterType: QuizType.trueFalse),
          ),

          const SizedBox(height: 16),

          // Recent Quiz History
          if (widget.learningState.progress.recentQuizResults.isNotEmpty) ...[
            Text(
              'Recent Quiz Records',
              style: AppTypography.getDisplayFont(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 10),
            ...widget.learningState.progress.recentQuizResults.take(3).map((result) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: result.scorePercentage >= 70
                            ? AppColors.success.withValues(alpha: 0.15)
                            : AppColors.error.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${result.scorePercentage}%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: result.scorePercentage >= 70 ? AppColors.success : AppColors.error,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${result.correctAnswers} of ${result.totalQuestions} Correct',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          Text(
                            '${result.timestamp.month}/${result.timestamp.day} • +${result.xpEarned} XP',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle_outline_rounded, size: 18, color: AppColors.success),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildModeCard({
    required bool isDark,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String xp,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.getDisplayFont(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              xp,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveQuiz(bool isDark, dynamic lang) {
    if (_activeQuestions.isEmpty) {
      return Center(
        child: TactileButton(
          onPressed: () => setState(() => _isQuizActive = false),
          child: const Text('Back to Quiz Menu'),
        ),
      );
    }

    final currentQ = _activeQuestions[_currentQuestionIndex];
    final progressFraction = (_currentQuestionIndex + 1) / _activeQuestions.length;

    return SafeArea(
      top: false,
      child: Column(
        children: [
          // Top Progress Bar & Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () {
                        setState(() {
                          _isQuizActive = false;
                        });
                      },
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progressFraction,
                          backgroundColor: isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          minHeight: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      '${_currentQuestionIndex + 1}/${_activeQuestions.length}',
                      style: AppTypography.getDisplayFont(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Scrollable Question Container
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Prompt Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                currentQ.type == QuizType.listening
                                    ? '🎧 LISTENING'
                                    : (currentQ.type == QuizType.wordScramble
                                        ? '🧩 SENTENCE BUILDER'
                                        : '🎯 MULTIPLE CHOICE'),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                            const Spacer(),
                            if (currentQ.audioTerm != null)
                              AudioSpeakerButton(
                                textToSpeak: currentQ.audioTerm!,
                                size: 38,
                              ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          currentQ.prompt,
                          style: AppTypography.getDisplayFont(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        if (currentQ.phonetic != null && currentQ.phonetic!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            currentQ.phonetic!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Option Types
                  if (currentQ.type == QuizType.wordScramble)
                    WordScrambleWidget(
                      initialWords: currentQ.scrambleWords ?? [],
                      isSubmitted: _isAnswerSubmitted,
                      isCorrect: _isCurrentCorrect,
                      onOrderChanged: (order) {
                        setState(() => _currentScrambleOrder = order);
                      },
                    )
                  else
                    ...List.generate(currentQ.options.length, (idx) {
                      final opt = currentQ.options[idx];
                      final label = String.fromCharCode(65 + idx); // A, B, C, D

                      OptionStatus status = OptionStatus.normal;
                      if (_isAnswerSubmitted) {
                        if (opt == currentQ.correctAnswer) {
                          status = OptionStatus.correct;
                        } else if (_selectedOption == opt) {
                          status = OptionStatus.incorrect;
                        }
                      } else {
                        if (_selectedOption == opt) {
                          status = OptionStatus.selected;
                        }
                      }

                      return QuizOptionTile(
                        text: opt,
                        optionLabel: label,
                        status: status,
                        onTap: _isAnswerSubmitted
                            ? null
                            : () => setState(() => _selectedOption = opt),
                      );
                    }),

                  const SizedBox(height: 14),

                  // Feedback Explanation Banner
                  if (_isAnswerSubmitted)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _isCurrentCorrect
                            ? AppColors.success.withValues(alpha: 0.15)
                            : AppColors.error.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isCurrentCorrect ? AppColors.success : AppColors.error,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _isCurrentCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                                color: _isCurrentCorrect ? AppColors.success : AppColors.error,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isCurrentCorrect ? 'Correct! (+15 XP)' : 'Incorrect',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: _isCurrentCorrect ? AppColors.success : AppColors.error,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentQ.explanation,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          if (!_isCurrentCorrect) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Correct answer: "${currentQ.correctAnswer}"',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Bottom Action Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                ),
              ),
            ),
            child: !_isAnswerSubmitted
                ? TactileButton(
                    onPressed: (_selectedOption != null ||
                            (currentQ.type == QuizType.wordScramble &&
                                _currentScrambleOrder.isNotEmpty))
                        ? _submitAnswer
                        : null,
                    backgroundColor: AppColors.primary,
                    child: const Text('Check Answer'),
                  )
                : TactileButton(
                    onPressed: _nextQuestion,
                    backgroundColor: _isCurrentCorrect ? AppColors.success : AppColors.secondary,
                    child: Text(
                      _currentQuestionIndex < _activeQuestions.length - 1
                          ? 'Continue'
                          : 'View Test Results',
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizResults(bool isDark, dynamic lang) {
    final total = _activeQuestions.length;
    final percentage = total > 0 ? ((_scoreCount / total) * 100).round() : 0;
    final earnedXp = _scoreCount * 15;

    return SafeArea(
      top: false,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Result Trophy / Icon
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: percentage >= 70
                      ? AppColors.success.withValues(alpha: 0.15)
                      : AppColors.accentGold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    percentage >= 80 ? '🏆' : (percentage >= 50 ? '🌟' : '💪'),
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                percentage >= 80
                    ? 'Outstanding Mastery!'
                    : (percentage >= 50 ? 'Great Practice!' : 'Keep Learning!'),
                style: AppTypography.getDisplayFont(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'You answered $_scoreCount out of $total questions correctly in ${lang.name}.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: _buildResultPill('Accuracy', '$percentage%', AppColors.primary, isDark),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildResultPill('XP Earned', '+$earnedXp', AppColors.accentGold, isDark),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              TactileButton(
                onPressed: () => _startQuiz(),
                backgroundColor: AppColors.primary,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.replay_rounded, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('Try Another Quiz'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _isQuizCompleted = false;
                    _isQuizActive = false;
                  });
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Return to Quiz Hub'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultPill(String label, String value, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
