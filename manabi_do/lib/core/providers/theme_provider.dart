import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_palette.dart';
import 'shared_preferences_provider.dart';

const _keyThemeMode = 'theme_mode';
const _keyPalette = 'theme_palette';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return switch (prefs.getString(_keyThemeMode)) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };
  }

  Future<void> setMode(ThemeMode mode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_keyThemeMode, switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
    });
    state = mode;
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

/// Which colour theme the app is drawn in. Light or dark is [themeModeProvider]'s
/// call; this picks the family both are drawn from.
class PaletteNotifier extends Notifier<AppPalette> {
  @override
  AppPalette build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final String? saved = prefs.getString(_keyPalette);
    return AppPalette.values.asNameMap()[saved] ?? AppPalette.fallback;
  }

  Future<void> setPalette(AppPalette palette) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_keyPalette, palette.name);
    state = palette;
  }
}

final paletteProvider = NotifierProvider<PaletteNotifier, AppPalette>(
  PaletteNotifier.new,
);
