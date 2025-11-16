import 'dart:ui';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/game_provider.dart';
import '../utils/asset_links.dart';
import '../widgets/bird_selection_dialog.dart';
import '../widgets/play_button.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int selectedBirdIndex = -1;

  late AudioPool swooshSound;

  @override
  void initState() {
    loadSound();
    super.initState();
  }

  loadSound() async {
    swooshSound = await FlameAudio.createPool(Assets.swoosh, maxPlayers: 1);
    swooshSound.audioCache.load(Assets.swoosh);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Responsive sizing
    final logoWidth = screenWidth * 0.6;

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
                  image: AssetImage(Assets.backgroundDay),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.ground),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: screenHeight * 0.1,
                children: [
                  // Logo
                  SizedBox(
                    width: logoWidth.clamp(200.0, 300.0),
                    child: Image.asset(Assets.logo, fit: BoxFit.contain),
                  ),

                  /// Play Button
                  BouncePlayButton(
                    onTap: () => _showBirdSelectionDialog(context),
                  ),

                  // Consumer<GameState>(
                  //   builder: (context, state, child) {
                  //     return (state.highScore != 0)
                  //         ? Column(
                  //             children: [
                  //               Stack(
                  //                 children: [
                  //                   // OUTLINE
                  //                   Text(
                  //                     "high score",
                  //                     style: TextStyle(
                  //                       fontSize: 14,
                  //                       fontWeight: FontWeight.bold,
                  //                       fontFamily: "Botsmatic",
                  //                       foreground: Paint()
                  //                         ..style = PaintingStyle.stroke
                  //                         ..strokeWidth = 4
                  //                         ..color = Colors.black,
                  //                     ),
                  //                   ),
                  //
                  //                   // FILL
                  //                   const Text(
                  //                     "high score",
                  //                     style: TextStyle(
                  //                       fontSize: 14,
                  //                       fontWeight: FontWeight.bold,
                  //                       fontFamily: "Botsmatic",
                  //                       color: Colors.white,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //               const SizedBox(height: 12),
                  //               ScoreDisplay(
                  //                 score: state.highScore,
                  //                 digitWidth: 20,
                  //                 digitHeight: 30,
                  //               ),
                  //             ],
                  //           )
                  //         : const Offstage(child: SizedBox());
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBirdSelectionDialog(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final cardWidth = kIsWeb ? 500.0 : screenWidth * 0.9;
    final cardHeight = screenHeight * 0.2;
    final birdSize = screenWidth * 0.2;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return BirdSelectionDialog(
          cardWidth: cardWidth,
          cardHeight: cardHeight,
          screenHeight: screenHeight,
          birdSize: birdSize,
          initialSelectedIndex: selectedBirdIndex,
          swooshSound: swooshSound,
          onBirdSelected: (index) {
            setState(() => selectedBirdIndex = index);

            final gameState = Provider.of<GameState>(context, listen: false);
            gameState.selectedBird = Assets.birds[index];
            Future.delayed(Duration(milliseconds: 500), () {
              gameState.setGameLaunched();
              Navigator.of(dialogContext).pop();
            });
          },
        );
      },
    );
  }
}
