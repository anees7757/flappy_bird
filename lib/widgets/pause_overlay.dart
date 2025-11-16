import 'package:flutter/material.dart';
import 'game_button.dart';
import 'game_overlay.dart';
import 'outlined_text.dart';

class PauseOverlay extends StatelessWidget {
  final VoidCallback onResume;

  const PauseOverlay({super.key, required this.onResume});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GameOverlayContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 60,
          children: [
            const OutlinedText(text: "paused", fontSize: 36),

            GameButton(text: "resume", onPressed: onResume),
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
