import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';

import '../game/game.dart';
import '../provider/game_provider.dart';
import '../utils/asset_links.dart';
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
        //     if (!state.hasStarted || state.isGameOver) {
        //       return const SizedBox.shrink();
        //     }
        //     return Padding(
        //       padding: EdgeInsets.only(top: 10),
        //       child: Image.asset("assets/images/logo.png", width: 150),
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
                      score: 0,
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
          return (!state.isGameLaunched)
              ? const CustomizationScreen()
              : GestureDetector(
                  onTapDown: (_) => game.handleTap(),
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    children: [
                      // Game canvas - ALWAYS rendered so onLoad() can execute
                      GameWidget(game: game),

                      // Game Over overlay
                      if (!state.isGameLoading) GameOverOverlay(game: game),

                      // Start instruction
                      if (!state.isGameLoading)
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

                      // Loading screen overlay (covers the black GameWidget)
                      if (state.isGameLoading)
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(backgrounds[0]),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: game.groundHeight,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/base.png"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "loading...",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontFamily: "Botsmatic",
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
