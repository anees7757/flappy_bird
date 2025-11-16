import 'package:flutter/material.dart';
import 'game_button.dart';
import 'outlined_text.dart';

class GameOverlayContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const GameOverlayContainer({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.symmetric(horizontal: 30),
    this.padding = const EdgeInsets.symmetric(vertical: 30),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.6),
      child: Center(
        child: Container(
          width: double.infinity,
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: child,
        ),
      ),
    );
  }
}

// Pause Overlay
class PauseOverlay extends StatelessWidget {
  final VoidCallback onResume;

  const PauseOverlay({
    super.key,
    required this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GameOverlayContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 60,
          children: [
            const OutlinedText(
              text: "paused",
              fontSize: 36,
            ),

            GameButton(
              text: "resume",
              onPressed: onResume,
            ),
          ],
        ),
      ),
    );
  }
}

// Helper function for backward compatibility
Widget pauseOverlay(VoidCallback onPressPause) {
  return PauseOverlay(onResume: onPressPause);
}