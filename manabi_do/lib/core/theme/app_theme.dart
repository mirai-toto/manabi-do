import 'package:flutter/material.dart';
import 'app_tokens.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(AppTokens.light, Brightness.light);
  static ThemeData get dark => _build(AppTokens.dark, Brightness.dark);

  /// Maps [tokens] onto Material's own colour roles.
  ///
  /// This used to be `ColorScheme.fromSeed(seedColor: tokens.primary)`, which
  /// quietly shipped two different purples: M3 tone-maps the seed, so a seed of
  /// `#6B4EFF` came back as `primary: #5E5791`. Custom widgets reading
  /// `context.tokens.primary` painted the vivid brand purple while anything
  /// falling back to the scheme — every bare `CircularProgressIndicator`, an
  /// unstyled `TextButton` — painted the muted generated one.
  ///
  /// Secondary is not a role this app designs for. Its second colour axis is
  /// the JLPT level ramp, which `AccentTheme` applies by rebinding `primary`
  /// itself, and which carries difficulty rather than mere emphasis. Material
  /// still requires a secondary, so it is derived from the primary container
  /// rather than invented — nothing should reach for it directly.
  static ThemeData _build(AppTokens t, Brightness brightness) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: t.primary,
      onPrimary: t.onPrimary,
      primaryContainer: t.primaryContainer,
      onPrimaryContainer: t.onPrimaryContainer,
      secondary: t.primaryContainer,
      onSecondary: t.onPrimaryContainer,
      secondaryContainer: t.surfaceContainerHigh,
      onSecondaryContainer: t.onSurface,
      error: t.error,
      onError: t.cardBackground,
      errorContainer: t.errorContainer,
      onErrorContainer: t.error,
      surface: t.surface,
      onSurface: t.onSurface,
      onSurfaceVariant: t.onSurfaceVariant,
      outline: t.outline,
      outlineVariant: t.outlineVariant,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: t.surface,
      extensions: [t],
    );
  }
}
