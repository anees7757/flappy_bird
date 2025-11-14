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
    // await Flame.load('background-day.png');

    swooshSound = await FlameAudio.createPool('swoosh.wav', maxPlayers: 1);
    swooshSound.audioCache.load('swoosh.wav');
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);

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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: MediaQuery.sizeOf(context).height * 0.1,
            children: [
              SizedBox(
                width: 260,
                child: Image.asset("assets/images/logo.png", fit: BoxFit.fill),
              ),

              SizedBox(),

              Container(
                width: kIsWeb ? 400 : double.infinity,
                margin: EdgeInsets.symmetric(horizontal: kIsWeb ? 30 : 20),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage("assets/images/select_bird.png"),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(birdImages.length, (index) {
                          final isSelected = selectedBirdIndex == index;
                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (p) {
                              setState(() => selectedBirdIndex = index);
                              swooshSound.start();
                            },
                            child: GestureDetector(
                              onTap: () {
                                setState(() => selectedBirdIndex = index);
                                swooshSound.start();
                              },
                              child: AnimatedContainer(
                                height: 100,
                                width: 100,
                                duration: const Duration(milliseconds: 150),
                                curve: Curves.easeInOut,
                                padding: const EdgeInsets.all(8),
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
                                  child: Transform.rotate(
                                    angle: 50,
                                    child: Image.asset(
                                      birdImages[index],
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.contain,
                                    ),
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

              /// Play Button
              BouncePlayButton(
                onTap: () {
                  gameState.selectedBird = birdImages[selectedBirdIndex];
                  gameState.setGameLaunched();
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(builder: (_) => const GameScreen()),
                  // );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
