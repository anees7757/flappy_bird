import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';

import '../game/game.dart';
import '../provider/game_provider.dart';
import '../utils/shared_prefs.dart';
import '../widgets/game_over_overlay.dart';
import '../widgets/score_handler.dart';
import 'customization_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late FirstGame game;

  @override
  void initState() {
    super.initState();
    final gameState = Provider.of<GameState>(context, listen: false);
    game = FirstGame(gameState);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      int highScore = SharedPrefsManager.getHighScore();

      gameState.setHighScore(highScore);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // centerTitle: true,
        // title: Consumer<GameState>(
        //   builder: (_, state, __) {
        //     if (state.hasStarted || state.isGameOver) {
        //       return const SizedBox.shrink();
        //     }
        //     return Padding(
        //       padding: EdgeInsets.only(top: 10),
        //       child: Image.asset("assets/images/logo.png"),
        //     );
        //   },
        // ),
        actions: [
          // Score display (top center)
          Consumer<GameState>(
            builder: (_, state, __) {
              if (!state.hasStarted || state.isGameOver) {
                return const SizedBox.shrink();
              }
              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(right: 20, top: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: ScoreDisplay(
                      score: state.score,
                      digitWidth: 28,
                      digitHeight: 40,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<GameState>(
        builder: (_, state, __) {
          return !state.isGameLaunched
              ? const CustomizationScreen()
              : GestureDetector(
                  onTapDown: (_) => game.handleTap(),
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    children: [
                      // Game canvas
                      GameWidget(game: game),

                      // Game Over overlay
                      GameOverOverlay(game: game),

                      // Start instruction
                      Consumer<GameState>(
                        builder: (_, state, __) {
                          if (state.hasStarted || state.isGameOver) {
                            return const SizedBox.shrink();
                          }
                          return Center(
                            child: Container(
                              width: 250,
                              height: 230,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 60,
                                vertical: 40,
                              ),
                              decoration: BoxDecoration(
                                // color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/message.png",
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
