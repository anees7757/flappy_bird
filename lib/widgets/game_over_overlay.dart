import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game/game.dart';
import '../provider/game_provider.dart';
import 'score_box.dart';

class GameOverOverlay extends StatelessWidget {
  final FirstGame game;

  const GameOverOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (_, state, __) {
        if (!state.isGameOver) return const SizedBox.shrink();

        return Container(
          color: Colors.black.withValues(alpha: 0.6),
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 60,
                children: [
                  Image.asset("assets/images/gameover.png", width: 200),

                  SizedBox(
                    width: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ScoreBox(title: "Score", value: state.score),
                        if (state.highScore != 0)
                          ScoreBox(title: "Best", value: state.highScore),
                      ],
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () => game.restart(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffDDD69F),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'play again',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Botsmatic",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
