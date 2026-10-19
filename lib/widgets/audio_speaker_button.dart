import 'package:flutter/material.dart';
import '../services/tts_service.dart';
import '../theme/app_colors.dart';

class AudioSpeakerButton extends StatefulWidget {
  final String textToSpeak;
  final String? locale;
  final double size;
  final Color? color;
  final Color? iconColor;
  final bool showSlowOption;

  const AudioSpeakerButton({
    super.key,
    required this.textToSpeak,
    this.locale,
    this.size = 46,
    this.color,
    this.iconColor,
    this.showSlowOption = false,
  });

  @override
  State<AudioSpeakerButton> createState() => _AudioSpeakerButtonState();
}

class _AudioSpeakerButtonState extends State<AudioSpeakerButton>
    with SingleTickerProviderStateMixin {
  final TtsService _tts = TtsService();
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _speak({bool slow = false}) async {
    setState(() => _isPlaying = true);
    _animController.repeat(reverse: true);
    await _tts.speak(widget.textToSpeak, locale: widget.locale, slow: slow);
    if (mounted) {
      _animController.reset();
      setState(() => _isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.color ?? AppColors.primary.withValues(alpha: 0.12);
    final fgColor = widget.iconColor ?? AppColors.primary;

    final mainSpeaker = ScaleTransition(
      scale: _scaleAnimation,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _speak(slow: false),
          borderRadius: BorderRadius.circular(widget.size / 2),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: _isPlaying ? fgColor : Colors.transparent,
                width: 2,
              ),
            ),
            child: Icon(
              _isPlaying ? Icons.volume_up_rounded : Icons.volume_up_outlined,
              color: fgColor,
              size: widget.size * 0.52,
            ),
          ),
        ),
      ),
    );

    if (!widget.showSlowOption) {
      return mainSpeaker;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mainSpeaker,
        const SizedBox(width: 8),
        InkWell(
          onTap: () => _speak(slow: true),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.accentGold.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.slow_motion_video_rounded,
                  size: 15,
                  color: AppColors.accentGold,
                ),
                const SizedBox(width: 4),
                Text(
                  '0.5x Slow',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentGold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
