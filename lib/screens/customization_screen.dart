import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/game_provider.dart';
import '../utils/asset_links.dart';
import '../widgets/play_button.dart';
import 'game_screen.dart';

class CustomizationScreen extends StatefulWidget {
  const CustomizationScreen({super.key});

  @override
  State<CustomizationScreen> createState() => _CustomizationScreenState();
}

class _CustomizationScreenState extends State<CustomizationScreen> {
  int selectedBirdIndex = 0;

  late AudioPool swooshSound;

  @override
  void initState() {
    loadSound();
    super.initState();
  }

  loadSound() async {
    swooshSound = await FlameAudio.createPool('swoosh.wav', maxPlayers: 1);
    swooshSound.audioCache.load('swoosh.wav');
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    final screenSize = MediaQuery.sizeOf(context);
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Responsive sizing
    final logoWidth = screenWidth * 0.6; // 60% of screen width
    final cardWidth = kIsWeb ? 500.0 : screenWidth * 0.9; // 90% of screen width
    final cardHeight = screenHeight * 0.2; // 20% of screen height
    final birdSize = screenWidth * 0.2; // 20% of screen width, max 100

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgrounds[0]),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  SizedBox(
                    width: logoWidth.clamp(200.0, 300.0),
                    child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // Bird selection card
                  Container(
                    width: cardWidth,
                    margin: EdgeInsets.symmetric(horizontal: kIsWeb ? 30 : 20),
                    padding: EdgeInsets.all(
                      screenHeight * 0.03,
                    ),
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage("assets/images/select_bird.png"),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SizedBox(
                      height: cardHeight.clamp(120.0, 180.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(birdImages.length, (index) {
                              final isSelected = selectedBirdIndex == index;
                              final clampedBirdSize = birdSize.clamp(
                                60.0,
                                90.0,
                              );

                              return MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (p) {
                                  setState(() => selectedBirdIndex = index);
                                  swooshSound.start();
                                },
                                child: GestureDetector(
                                  onTap: () {
                                    // swooshSound.start();

                                    setState(() => selectedBirdIndex = index);
                                  },
                                  child: Container(
                                    height: clampedBirdSize,
                                    width: clampedBirdSize,
                                    padding: EdgeInsets.all(
                                      clampedBirdSize * 0.08,
                                    ),
                                    child: ColorFiltered(
                                      colorFilter: isSelected
                                          ? const ColorFilter.mode(
                                              Color(0xFFD4C4A0),
                                              BlendMode.modulate,
                                            )
                                          : const ColorFilter.mode(
                                              Colors.transparent,
                                              BlendMode.multiply,
                                            ),
                                      child: Image.asset(
                                        birdImages[index],
                                        width: clampedBirdSize * 0.7,
                                        height: clampedBirdSize * 0.7,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.2),

                  /// Play Button
                  BouncePlayButton(
                    onTap: () {
                      gameState.selectedBird = birdImages[selectedBirdIndex];
                      gameState.setGameLaunched();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
