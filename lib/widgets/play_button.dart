import 'package:flutter/material.dart';

class BouncePlayButton extends StatefulWidget {
  final VoidCallback onTap;

  const BouncePlayButton({super.key, required this.onTap});

  @override
  State<BouncePlayButton> createState() => _BouncePlayButtonState();
}

class _BouncePlayButtonState extends State<BouncePlayButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.9); // shrink button
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0); // return to normal
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (p) => _onTapDown,
      onExit: (p) => _onTapUp,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: SizedBox(
            height: MediaQuery.sizeOf(context).width / 5.4,
            child: Image.asset("assets/images/play_btn.png"),
          ),
        ),
      ),
    );
  }
}
