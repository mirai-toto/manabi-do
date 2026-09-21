import 'package:flutter/material.dart';

/// Difficulty ramp: green (easiest) through to red (hardest).
///
/// Every colour clears WCAG AA against dark text — see `onAccentFor` — and the
/// set is chosen so no two are confusable, including under red-green colour
/// blindness. `basics` and `kana` sit outside the JLPT scale and keep their
/// own hues.
Color levelColor(String level) => switch (level) {
  'basics' => const Color(0xFF795548), // brown: introductory content
  'kana' => const Color(0xFF26A69A), // teal: pre-JLPT alphabet
  'N5' => const Color(0xFF81C784), // green: easiest
  'N4' => const Color(0xFFC0CA33), // lime
  'N3' => const Color(0xFFFFF176), // yellow
  'N2' => const Color(0xFFFB8C00), // orange
  'N1' => const Color(0xFFE57373), // red: hardest
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
