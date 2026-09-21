import 'package:flutter/material.dart';

/// Difficulty ramp: green (easiest) through to red (hardest).
///
/// Every colour clears WCAG AA — `onAccentFor` picks the readable foreground,
/// which is dark for N5-N3 and white for the deeper N2/N1.
///
/// `basics` and `kana` sit outside the JLPT scale.
///
/// Known issue: N2 burnt orange and N1 brick red are neighbouring hues at
/// similar darkness, so they drop to ~20-26 separation under red-green colour
/// blindness — close to indistinguishable. Pulling them apart means changing
/// lightness, not hue. `basics` vs N4 is the next weakest at ~33.
Color levelColor(String level) => switch (level) {
  'basics' => const Color(0xFF795548), // brown: introductory content
  'kana' => const Color(0xFF26A69A), // teal: pre-JLPT alphabet
  'N5' => const Color(0xFF8AAB85), // sage: easiest
  'N4' => const Color(0xFF5B9A4C), // green
  'N3' => const Color(0xFFFFB000), // amber
  'N2' => const Color(0xFFAA5500), // burnt orange
  'N1' => const Color(0xFFC4281C), // brick: hardest
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
