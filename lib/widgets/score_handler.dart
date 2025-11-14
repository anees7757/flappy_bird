import 'package:flutter/material.dart';

class ScoreDisplay extends StatelessWidget {
  final int score;
  final double digitWidth;
  final double digitHeight;

  const ScoreDisplay({
    super.key,
    required this.score,
    this.digitWidth = 30,
    this.digitHeight = 45,
  });

  @override
  Widget build(BuildContext context) {
    String scoreString = score.toString();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: scoreString.split('').map((digit) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Image.asset(
            'assets/images/$digit.png',
            width: digitWidth,
            height: digitHeight,
            fit: BoxFit.contain,
          ),
        );
      }).toList(),
    );
  }
}
