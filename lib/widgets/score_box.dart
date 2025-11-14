import 'package:flappy_bird/widgets/score_handler.dart';
import 'package:flutter/material.dart';

class ScoreBox extends StatelessWidget {
  final String title;
  final int value;

  const ScoreBox({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ScoreDisplay(
          score: value,
          digitWidth: 30,
          digitHeight: 40,
        ),
      ],
    );
  }
}
