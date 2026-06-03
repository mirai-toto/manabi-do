import 'package:flutter/material.dart';

Color levelColor(String level) => switch (level) {
      'kana' => const Color(0xFF00897B),
      'N5' => const Color(0xFF43A047),
      'N4' => const Color(0xFF039BE5),
      'N3' => const Color(0xFF7B1FA2),
      'N2' => const Color(0xFFE65100),
      'N1' => const Color(0xFFC62828),
      _ => const Color(0xFF607D8B),
    };

int levelDifficulty(String level) => switch (level) {
      'kana' => 0,
      'N5' => 1,
      'N4' => 2,
      'N3' => 3,
      'N2' => 4,
      'N1' => 5,
      _ => -1,
    };
