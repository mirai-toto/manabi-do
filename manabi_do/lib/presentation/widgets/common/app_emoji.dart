import 'package:flutter/material.dart';

class AppEmoji extends StatelessWidget {
  final String emoji;
  final double size;

  const AppEmoji(this.emoji, {super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Text(
      emoji,
      style: TextStyle(
        fontSize: size,
        fontFamilyFallback: const [
          'NotoColorEmoji',
          'Apple Color Emoji',
          'Segoe UI Emoji',
        ],
      ),
    );
  }
}
