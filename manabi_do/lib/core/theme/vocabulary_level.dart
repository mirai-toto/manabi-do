import 'package:flutter/material.dart';

/// The five coverage levels vocabulary is grouped into.
///
/// A level is a share of **running Japanese**, measured on the BCCWJ corpus by
/// the content pipeline. Band 1 is the 750 commonest words, which are 49.5% of
/// everything written; level 5 is the long tail, which adds 1.5%.
///
/// Vocabulary has no JLPT level and this is why. The JLPT publishes an official
/// kanji list but no vocabulary list, so every dataset's "N5 word" is a guess
/// by whoever compiled it. Kanji keep [levelColor] and their real levels; words
/// get a measured level that says what it means.
///
/// The level replaced a `difficulty_tier` that banded words by share of our own
/// word list. A tier meant "the easiest fifth of whatever we happen to ship",
/// which is a fact about the app rather than about Japanese.
const int kVocabularyLevelCount = 5;

const List<int> kAllVocabularyLevels = [1, 2, 3, 4, 5];

/// A sequential ramp, dark to light, built from the app's own primary.
///
/// Sequential and not the green-to-red [levelColor] ramp, because a level is a
/// magnitude rather than a category: level 3 really does sit between level 2 and
/// level 4, and a single hue is the only honest way to draw that. The green-red
/// ramp also reads as good-to-bad, and the long tail is not bad.
///
/// Steps 3 and 4 are `AppTokens.primary` and `AppTokens.primaryLight` exactly.
/// Validated as an ordinal scale: lightness is monotone, every adjacent pair
/// differs by at least 0.06, the hue spread is 14 degrees, and the light end
/// holds 2.03:1 against the light surface.
const List<Color> _lightRamp = [
  Color(0xFF2E1A8C),
  Color(0xFF4B2FD1),
  Color(0xFF6B4EFF),
  Color(0xFF9B7FFF),
  Color(0xFFB9A4FF),
];

/// The dark-mode ramp is selected, not an inversion of the light one.
///
/// Flipping the light ramp puts its darkest step against a dark surface, where
/// it disappears. These steps run light to dark instead, and steps 1 and 2 are
/// the dark theme's own `primary` and `primaryLight`. Validated the same way:
/// monotone lightness, 2.26:1 at the light end, 9 degrees of hue spread.
const List<Color> _darkRamp = [
  Color(0xFFCFBCFF),
  Color(0xFFB39DFF),
  Color(0xFF9179EB),
  Color(0xFF6E58BC),
  Color(0xFF514293),
];

/// Near-black, matching `AppTokens.onSurface`, for the pale end of each ramp.
const Color _onLight = Color(0xFF1C1B1F);

/// The level's fill colour for [brightness].
Color vocabularyLevelColor(int level, Brightness brightness) {
  final ramp = brightness == Brightness.dark ? _darkRamp : _lightRamp;
  final index = (level - 1).clamp(0, ramp.length - 1);
  return ramp[index];
}

/// The readable foreground on [vocabularyLevelColor], chosen by true WCAG contrast.
///
/// Hard-coded per step rather than computed, because `estimateBrightnessForColor`
/// lands on the wrong side for the mid-tones of this ramp: it calls step 3 dark
/// and picks black, which fails against #6B4EFF.
Color onVocabularyLevelColor(int level, Brightness brightness) {
  final index = (level - 1).clamp(0, kVocabularyLevelCount - 1);
  return brightness == Brightness.dark
      ? (index <= 2 ? _onLight : Colors.white)
      : (index <= 2 ? Colors.white : _onLight);
}

/// Filled dots on a level card, 1 through 5.
int vocabularyLevelDifficulty(int level) =>
    level >= 1 && level <= kVocabularyLevelCount ? level : -1;
