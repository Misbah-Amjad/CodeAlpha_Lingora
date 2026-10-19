import 'package:flutter/material.dart';

class TactileButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Color? foregroundColor;
  final double height;
  final double? width;
  final double depth;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;

  const TactileButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.shadowColor,
    this.foregroundColor,
    this.height = 54,
    this.width,
    this.depth = 4,
    this.borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  @override
  State<TactileButton> createState() => _TactileButtonState();
}

class _TactileButtonState extends State<TactileButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = widget.backgroundColor ?? theme.colorScheme.primary;
    final shadow = widget.shadowColor ?? HSLColor.fromColor(bg).withLightness((HSLColor.fromColor(bg).lightness - 0.15).clamp(0.0, 1.0)).toColor();
    final radius = widget.borderRadius ?? BorderRadius.circular(16);

    final isEnabled = widget.onPressed != null;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 70),
        width: widget.width,
        height: widget.height,
        margin: EdgeInsets.only(
          top: _isPressed ? widget.depth : 0,
          bottom: _isPressed ? 0 : widget.depth,
        ),
        decoration: BoxDecoration(
          color: isEnabled ? bg : Colors.grey.shade400,
          borderRadius: radius,
          boxShadow: isEnabled && !_isPressed
              ? [
                  BoxShadow(
                    color: shadow,
                    offset: Offset(0, widget.depth),
                    blurRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: widget.padding,
          child: Center(
            child: DefaultTextStyle(
              style: TextStyle(
                color: widget.foregroundColor ?? Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
