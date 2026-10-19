import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum OptionStatus { normal, selected, correct, incorrect }

class QuizOptionTile extends StatelessWidget {
  final String text;
  final String optionLabel;
  final OptionStatus status;
  final VoidCallback? onTap;

  const QuizOptionTile({
    super.key,
    required this.text,
    required this.optionLabel,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color bgColor;
    Color borderColor;
    Color textColor;
    IconData? trailingIcon;
    Color iconColor;

    switch (status) {
      case OptionStatus.correct:
        bgColor = AppColors.success.withValues(alpha: 0.15);
        borderColor = AppColors.success;
        textColor = isDark ? Colors.white : const Color(0xFF065F46);
        trailingIcon = Icons.check_circle_rounded;
        iconColor = AppColors.success;
        break;
      case OptionStatus.incorrect:
        bgColor = AppColors.error.withValues(alpha: 0.12);
        borderColor = AppColors.error;
        textColor = isDark ? Colors.white : const Color(0xFF991B1B);
        trailingIcon = Icons.cancel_rounded;
        iconColor = AppColors.error;
        break;
      case OptionStatus.selected:
        bgColor = AppColors.primary.withValues(alpha: 0.12);
        borderColor = AppColors.primary;
        textColor = AppColors.primary;
        trailingIcon = Icons.radio_button_checked_rounded;
        iconColor = AppColors.primary;
        break;
      case OptionStatus.normal:
        bgColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
        borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
        textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
        trailingIcon = Icons.radio_button_unchecked_rounded;
        iconColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 1.8),
              boxShadow: status == OptionStatus.selected || status == OptionStatus.correct
                  ? [
                      BoxShadow(
                        color: borderColor.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                // Label pill (A, B, C, D)
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: status == OptionStatus.correct
                        ? AppColors.success
                        : (status == OptionStatus.incorrect
                            ? AppColors.error
                            : (status == OptionStatus.selected
                                ? AppColors.primary
                                : (isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt))),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      optionLabel,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: status != OptionStatus.normal
                            ? Colors.white
                            : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Text
                Expanded(
                  child: Text(
                    text,
                    style: AppTypography.getBodyFont(
                      fontSize: 15,
                      fontWeight: status != OptionStatus.normal ? FontWeight.w700 : FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
                Icon(
                  trailingIcon,
                  color: iconColor,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
