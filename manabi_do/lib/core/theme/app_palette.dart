import 'package:flutter/material.dart';

import 'app_tokens.dart';

part 'app_palettes.dart';

/// The colour themes the user can pick from, each with a light and a dark
/// side. The colours live in `app_palettes.dart`, generated and checked for
/// contrast by `scripts/design/theme_palettes.py`.
///
/// Named in Japanese after what they look like; the names are the same in
/// every language, like a brand.
enum AppPalette {
  fuji('Fuji', '藤', _fujiLight, _fujiDark),
  ai('Ai', '藍', _aiLight, _aiDark),
  sakura('Sakura', '桜', _sakuraLight, _sakuraDark),
  matcha('Matcha', '抹茶', _matchaLight, _matchaDark),
  kuri('Kuri', '栗', _kuriLight, _kuriDark),
  sumi('Sumi', '墨', _sumiLight, _sumiDark);

  final String romaji;
  final String kanji;
  final AppTokens light;
  final AppTokens dark;

  const AppPalette(this.romaji, this.kanji, this.light, this.dark);

  /// Shown in the picker, e.g. "Fuji 藤".
  String get label => '$romaji $kanji';

  AppTokens tokens(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  /// The theme the app opens with until the user picks another.
  static const AppPalette fallback = AppPalette.fuji;
}
