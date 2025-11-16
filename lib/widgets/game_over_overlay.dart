import 'package:flappy_bird/widgets/score_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game/game.dart';
import '../provider/game_provider.dart';
import 'game_button.dart';
import 'game_overlay.dart';
import 'outlined_text.dart';

class GameOverOverlay extends StatelessWidget {
  final FirstGame game;

  const GameOverOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (_, state, __) {
        if (!state.isGameOver) return const SizedBox.shrink();

        return GameOverlayContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 60,
            children: [
              const OutlinedText(text: "game over", fontSize: 36),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.2,
                ),
                child: Row(
                  mainAxisAlignment: state.highScore > 0
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
                  children: [
                    ScoreBox(title: "Score", value: state.score),
                    if (state.highScore > 0)
                      ScoreBox(title: "Best", value: state.highScore),
                  ],
                ),
              ),

              GameButton(text: "restart", onPressed: () => game.restart()),
            ],
          ),
        );
      },
    );
  }
}
