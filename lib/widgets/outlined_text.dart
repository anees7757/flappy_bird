import 'package:flutter/material.dart';

class OutlinedText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? fillColor;
  final Color? outlineColor;
  final double? strokeWidth;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;

  const OutlinedText({
    super.key,
    required this.text,
    this.fontSize = 32,
    this.fillColor = const Color(0xffFCA049),
    this.outlineColor = Colors.white,
    this.strokeWidth = 4,
    this.fontWeight = FontWeight.bold,
    this.fontFamily = "Botsmatic",
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // OUTLINE
        Text(
          text,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: fontFamily,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth!
              ..color = outlineColor!,
          ),
        ),

        // FILL
        Text(
          text,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: fontFamily,
            color: fillColor,
          ),
        ),
      ],
    );
  }
}