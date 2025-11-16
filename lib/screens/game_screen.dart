import 'dart:async';
import 'dart:ui';

import 'package:flappy_bird/utils/asset_links.dart';
import 'package:flappy_bird/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';

import '../game/game.dart';
import '../provider/game_provider.dart';
import '../utils/shared_prefs.dart';
import '../widgets/game_over_overlay.dart';
import '../widgets/pause_overlay.dart';
import '../widgets/score_handler.dart';
import 'main_menu.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late FirstGame game;
  late GameState gameState;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    gameState = Provider.of<GameState>(context, listen: false);
    game = FirstGame(gameState);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheAssets();
      _loadHighScore();
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _precacheAssets() {
    precacheImage(const AssetImage(Assets.selectBirdMenu), context);
    precacheImage(const AssetImage(Assets.message), context);
  }

  void _loadHighScore() {
    final highScore = SharedPrefsManager.getHighScore();
    gameState.setHighScore(highScore);
  }

  void _togglePause() {
    if (gameState.isPaused) {
      _startCountdownAndResume();
    } else {
      game.pauseEngine();
      gameState.pauseGame();
    }
  }

  void _startCountdownAndResume() {
    gameState.startCountdown();

    int countdown = 3;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 1) {
        countdown--;
        gameState.updateCountdown(countdown);
      } else {
        timer.cancel();
        gameState.endCountdown();
        game.resumeEngine();
        gameState.resumeGame();
      }
    });
  }

  bool _shouldShowPauseButton(GameState state) {
    return !state.isGameLoading &&
        state.hasStarted &&
        !state.isGameOver &&
        !state.isCountingDown;
  }

  bool _shouldShowScore(GameState state) {
    return state.hasStarted && !state.isGameOver;
  }

  bool _shouldShowStartMessage(GameState state) {
    return !state.isGameLoading && !state.hasStarted && !state.isGameOver;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: _buildAppBar(screenHeight),
          body: Consumer<GameState>(
            builder: (_, state, __) {
              return state.isGameLaunched
                  ? _buildGameView(state)
                  : const MainMenu();
            },
          ),
        ),
        _buildPauseOverlay(),
        _buildCountdownOverlay(),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar(double screenHeight) {
    return AppBar(
      toolbarHeight: screenHeight * 0.1,
      backgroundColor: Colors.transparent,
      leadingWidth: screenHeight * 0.1,
      leading: _buildPauseButton(),
      actions: [_buildScoreDisplay()],
    );
  }

  Widget _buildPauseButton() {
    return Consumer<GameState>(
      builder: (_, state, __) {
        if (!_shouldShowPauseButton(state)) {
          return const SizedBox.shrink();
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: _togglePause,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 3),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 0,
                        blurRadius: 0,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      state.isPaused ? Icons.play_arrow : Icons.pause,
                      color: Colors.black87,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScoreDisplay() {
    return Consumer<GameState>(
      builder: (_, state, __) {
        if (!_shouldShowScore(state)) {
          return const SizedBox.shrink();
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(right: 20, top: 20),
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
    );
  }

  Widget _buildGameView(GameState state) {
    return GestureDetector(
      onTapDown: (_) =>
          (state.isPaused || state.isCountingDown) ? null : game.handleTap(),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          GameWidget(game: game),
          if (!state.isGameLoading) GameOverOverlay(game: game),
          if (_shouldShowStartMessage(state)) _buildStartMessage(),
          if (state.isGameLoading) loadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildStartMessage() {
    return Center(
      child: Container(
        width: 250,
        height: 230,
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage(Assets.message),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget _buildPauseOverlay() {
    return Consumer<GameState>(
      builder: (_, state, __) {
        if (!state.isPaused || state.isGameLoading || state.isCountingDown) {
          return const SizedBox.shrink();
        }
        return PauseOverlay(onResume: _togglePause);
      },
    );
  }

  Widget _buildCountdownOverlay() {
    return Consumer<GameState>(
      builder: (_, state, __) {
        if (!state.isCountingDown) {
          return const SizedBox.shrink();
        }

        return Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: Center(
                child: TweenAnimationBuilder<double>(
                  key: ValueKey(state.countdownValue),
                  duration: const Duration(milliseconds: 800),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 0.5 + (value * 0.5),
                      child: Opacity(
                        opacity: value,
                        child: Center(
                          child: Image.asset(
                            Assets.number(state.countdownValue.toString()),
                            height: 70,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
