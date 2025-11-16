import 'dart:math';
import 'dart:ui' as ui;
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import '../models/pipe.dart';
import '../provider/game_provider.dart';
import '../utils/asset_links.dart';

class FirstGame extends FlameGame {
  final GameState gameState;

  FirstGame(this.gameState);

  // Sounds
  late AudioPool jumpSound;
  late AudioPool hitSound;
  late AudioPool dieSound;
  late AudioPool pointSound;
  bool isBackgroundMusicPlaying = false;

  // Images
  late ui.Image backgroundImage;
  late ui.Image groundImage;
  late ui.Image pipeTopImage;
  late ui.Image pipeBottomImage;
  late ui.Image gameOverImage;

  late List<ui.Image> birdFrames;
  late final List<ui.Image> backgrounds;

  // Smooth background transition
  late ui.Image previousBackground;
  late ui.Image targetBackground;
  double backgroundTransition = 0.0;
  double backgroundTransitionSpeed = 0.5;
  double backgroundChangeTimer = 0;
  double backgroundChangeInterval = 120;

  // Bird
  double birdX = 0;
  double birdY = 300;
  double birdSize = 45;
  double velocityY = 0;
  double gravity = 800;
  double jumpForce = -350;
  int currentFrame = 0;
  double flapTimer = 0;
  double flapInterval = 0.1;
  double birdRotationZ = 0; // rotation for tilt

  // Ground and pipes
  double groundHeight = 150;
  double groundOffset = 0;
  double backgroundOffset = 0;

  double pipeSpeed = 200;
  double pipeSpawnTimer = 0;
  double pipeSpawnInterval = 2.0;
  List<Pipe> pipes = [];

  // Cached dimensions
  late double backgroundWidth;
  late double groundWidth;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    images.prefix = '';

    birdX = size.x * 0.2;

    // Load backgrounds
    backgrounds = await Future.wait(
      Assets.backgrounds.map((path) => images.load(path)).toList(),
    );

    backgroundImage = backgrounds[0];
    previousBackground = backgrounds[0];
    targetBackground = backgrounds[0];
    backgroundTransition = 1.0;
    backgroundChangeTimer = 0;

    groundImage = await images.load(Assets.ground);
    pipeTopImage = await images.load(Assets.pipeTop);
    pipeBottomImage = await images.load(Assets.pipeBottom);

    // Load bird frames based on user selection
    final birdIndex = Assets.birds.indexOf(gameState.selectedBird);
    birdFrames = await Future.wait(
      Assets.birdAnimations[birdIndex]
          .map((path) => images.load(path))
          .toList(),
    );

    // Cache dimensions
    backgroundWidth = backgroundImage.width.toDouble();
    groundWidth = groundImage.width.toDouble();

    // Load sounds
    jumpSound = await FlameAudio.createPool(Assets.wing, maxPlayers: 3);
    pointSound = await FlameAudio.createPool(Assets.point, maxPlayers: 1);
    hitSound = await FlameAudio.createPool(Assets.hit, maxPlayers: 1);
    dieSound = await FlameAudio.createPool(Assets.die, maxPlayers: 1);

    await FlameAudio.audioCache.loadAll([
      Assets.wing,
      Assets.hit,
      Assets.die,
      Assets.point,
    ]);

    gameState.setGameLoading(false);
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    birdX = newSize.x * 0.2;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!gameState.hasStarted || gameState.isGameOver) return;

    // Handle background change timer
    backgroundChangeTimer += dt;
    if (backgroundChangeTimer >= backgroundChangeInterval) {
      backgroundChangeTimer = 0;

      // Pick a new background different from current
      ui.Image newBg;
      do {
        newBg = backgrounds[Random().nextInt(backgrounds.length)];
      } while (newBg == targetBackground && backgrounds.length > 1);

      previousBackground = targetBackground;
      targetBackground = newBg;
      backgroundTransition = 0.0;
    }

    // Update background transition
    if (backgroundTransition < 1.0) {
      backgroundTransition += backgroundTransitionSpeed * dt;
      if (backgroundTransition > 1.0) backgroundTransition = 1.0;
    }

    // Animate ground
    groundOffset -= pipeSpeed * dt;
    if (groundOffset <= -groundWidth) groundOffset = 0;

    // Animate background offset
    backgroundOffset -= pipeSpeed * dt * 0.1;
    if (backgroundOffset <= -backgroundWidth) backgroundOffset = 0;

    // Bird physics
    velocityY += gravity * dt;
    birdY += velocityY * dt;

    // Bird tilt based on velocity
    birdRotationZ = velocityY * 0.0015;
    birdRotationZ = birdRotationZ.clamp(-0.5, 0.5);

    // Bird flap animation
    flapTimer += dt;
    if (flapTimer >= flapInterval) {
      flapTimer = 0;
      currentFrame = (currentFrame + 1) % birdFrames.length;
    }

    // Ground and ceiling collision
    if (birdY <= 0 || birdY + birdSize >= size.y - groundHeight) {
      dieSound.start();
      gameState.setGameOver(true);
      return;
    }

    // Spawn pipes
    pipeSpawnTimer += dt;
    if (pipeSpawnTimer >= pipeSpawnInterval) {
      pipeSpawnTimer = 0;
      double gapY = Random().nextDouble() * (size.y - groundHeight - 400) + 100;
      pipes.add(Pipe(size.x, gapY));
    }

    // Update pipes
    for (var pipe in pipes.toList()) {
      pipe.x -= pipeSpeed * dt;

      if (!pipe.passed && pipe.x + pipe.width < birdX) {
        pipe.passed = true;
        pointSound.start();
        gameState.increaseScore();
      }

      if (pipe.x + pipe.width < 0) pipes.remove(pipe);

      // Collision detection
      double collisionMargin = 5;
      Rect birdRect = Rect.fromLTWH(
        birdX + collisionMargin,
        birdY + collisionMargin,
        birdSize - collisionMargin * 2,
        birdSize - collisionMargin * 2,
      );

      double capHeight = 24.0;
      Rect topPipe = Rect.fromLTWH(
        pipe.x,
        0,
        pipe.width,
        pipe.gapY - capHeight / 2,
      );
      Rect bottomPipe = Rect.fromLTWH(
        pipe.x,
        pipe.gapY + pipe.gapHeight + capHeight / 2,
        pipe.width,
        size.y - groundHeight - pipe.gapY - pipe.gapHeight - capHeight / 2,
      );

      if (birdRect.overlaps(topPipe) || birdRect.overlaps(bottomPipe)) {
        hitSound.start();
        gameState.setGameOver(true);
        return;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    _drawScrollingBackground(canvas);

    for (var pipe in pipes) {
      _drawPipe(canvas, pipe);
    }

    canvas.save();
    canvas.translate(birdX + birdSize / 2, birdY + birdSize / 2);
    canvas.rotate(birdRotationZ);
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(-birdSize / 2, -birdSize / 2, birdSize, birdSize),
      image: birdFrames[currentFrame],
      fit: BoxFit.contain,
    );
    canvas.restore();

    _drawScrollingGround(canvas);
  }

  void _drawScrollingBackground(Canvas canvas) {
    double scale = size.y / previousBackground.height;
    double scaledWidth = previousBackground.width * scale;
    int tilesNeeded = (size.x / scaledWidth).ceil() + 2;

    Paint paint = Paint();

    for (int i = 0; i < tilesNeeded; i++) {
      // Previous background
      paint.color = Colors.white.withValues(alpha: 1.0 - backgroundTransition);
      canvas.drawImageRect(
        previousBackground,
        Rect.fromLTWH(
          0,
          0,
          previousBackground.width.toDouble(),
          previousBackground.height.toDouble(),
        ),
        Rect.fromLTWH(
          backgroundOffset + (i * scaledWidth),
          0,
          scaledWidth,
          size.y,
        ),
        paint,
      );

      // Target background
      paint.color = Colors.white.withValues(alpha: backgroundTransition);
      canvas.drawImageRect(
        targetBackground,
        Rect.fromLTWH(
          0,
          0,
          targetBackground.width.toDouble(),
          targetBackground.height.toDouble(),
        ),
        Rect.fromLTWH(
          backgroundOffset + (i * scaledWidth),
          0,
          scaledWidth,
          size.y,
        ),
        paint,
      );
    }
  }

  void _drawScrollingGround(Canvas canvas) {
    double groundY = size.y - groundHeight;
    int tilesNeeded = (size.x / groundWidth).ceil() + 2;

    for (int i = 0; i < tilesNeeded; i++) {
      paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(
          groundOffset + (i * groundWidth),
          groundY,
          groundWidth,
          groundHeight,
        ),
        image: groundImage,
        fit: BoxFit.fill,
      );
    }
  }

  void _drawPipe(Canvas canvas, Pipe pipe) {
    double capHeight = 24.0;

    Rect topCapRect = Rect.fromLTWH(
      pipe.x - 2,
      pipe.gapY - capHeight,
      pipe.width + 4,
      capHeight,
    );
    Rect topBodyRect = Rect.fromLTWH(
      pipe.x,
      0,
      pipe.width,
      pipe.gapY - capHeight,
    );

    canvas.drawImageRect(
      pipeTopImage,
      Rect.fromLTWH(
        0,
        0,
        pipeTopImage.width.toDouble(),
        pipeTopImage.height.toDouble() - capHeight,
      ),
      topBodyRect,
      Paint(),
    );
    canvas.drawImageRect(
      pipeTopImage,
      Rect.fromLTWH(
        0,
        pipeTopImage.height.toDouble() - capHeight,
        pipeTopImage.width.toDouble(),
        capHeight,
      ),
      topCapRect,
      Paint(),
    );

    double bottomPipeStart = pipe.gapY + pipe.gapHeight;
    double bottomPipeHeight = size.y - groundHeight - bottomPipeStart;

    Rect bottomCapRect = Rect.fromLTWH(
      pipe.x - 2,
      bottomPipeStart,
      pipe.width + 4,
      capHeight,
    );
    Rect bottomBodyRect = Rect.fromLTWH(
      pipe.x,
      bottomPipeStart + capHeight,
      pipe.width,
      bottomPipeHeight - capHeight,
    );

    canvas.drawImageRect(
      pipeBottomImage,
      Rect.fromLTWH(0, 0, pipeBottomImage.width.toDouble(), capHeight),
      bottomCapRect,
      Paint(),
    );
    canvas.drawImageRect(
      pipeBottomImage,
      Rect.fromLTWH(
        0,
        capHeight,
        pipeBottomImage.width.toDouble(),
        pipeBottomImage.height.toDouble() - capHeight,
      ),
      bottomBodyRect,
      Paint(),
    );
  }

  void handleTap() {
    if (!gameState.hasStarted) {
      gameState.startGame();
      birdY = size.y / 2;
    }
    if (!gameState.isGameOver) {
      velocityY = jumpForce;
      jumpSound.start();
    }
  }

  void restart() {
    birdY = size.y / 2;
    velocityY = 0;
    birdRotationZ = 0;
    pipes.clear();
    pipeSpawnTimer = 0;
    groundOffset = 0;
    backgroundOffset = 0;
    gameState.resetScore();
    gameState.setGameOver(false);
    gameState.resetStart();

    backgroundImage = backgrounds[0];
    previousBackground = backgrounds[0];
    targetBackground = backgrounds[0];

    backgroundTransition = 1.0;
    backgroundChangeTimer = 0;
  }
}
