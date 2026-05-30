import 'package:flutter/material.dart';

Color levelColor(String level) => switch (level) {
  'kana' => const Color(0xFF00897B), // teal — pre-JLPT alphabet
  'N5' => const Color(0xFF1E88E5), // srsExpert    — easy, mastered territory
  'N4' => const Color(0xFF43A047), // srsMastered
  'N3' => const Color(0xFFF9A825), // srsFamiliar
  'N2' => const Color(0xFFFF8F00), // srsApprentice
  'N1' => const Color(
    0xFFE53935,
  ), // srsLearning  — hardest, still being learned
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
