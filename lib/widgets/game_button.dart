import 'package:flutter/material.dart';

class GameButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? outlineColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final List<BoxShadow>? boxShadow;
  final BorderRadius? borderRadius;
  final Duration? duration;
  final bool useOutline;

  const GameButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0xffDDD69F),
    this.textColor = Colors.white,
    this.outlineColor = Colors.black,
    this.fontSize = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    this.elevation = 5,
    this.boxShadow,
    this.borderRadius,
    this.duration = const Duration(milliseconds: 100),
    this.useOutline = true,
  });

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onPressed();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveShadow = widget.boxShadow ??
        [
          const BoxShadow(
            color: Colors.black,
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(4, 4),
          ),
        ];

    final shadowOffset = effectiveShadow.first.offset;
    final pressedOffset = Offset(
      shadowOffset.dx * 0.5,
      shadowOffset.dy * 0.5,
    );

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: widget.duration!,
        curve: Curves.easeInOut,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: widget.borderRadius,
          boxShadow: _isPressed ? null : effectiveShadow,
        ),
        transform: Matrix4.translationValues(
          _isPressed ? pressedOffset.dx : 0,
          _isPressed ? pressedOffset.dy : 0,
          0,
        ),
        child: widget.useOutline
            ? Stack(
          children: [
            // OUTLINE
            Text(
              widget.text,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.bold,
                fontFamily: "Botsmatic",
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 4
                  ..color = widget.outlineColor!,
              ),
            ),
            // FILL
            Text(
              widget.text,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.bold,
                fontFamily: "Botsmatic",
                color: widget.textColor,
              ),
            ),
          ],
        )
            : Text(
          widget.text,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.bold,
            fontFamily: "Botsmatic",
            color: widget.textColor,
          ),
        ),
      ),
    );
  }
}