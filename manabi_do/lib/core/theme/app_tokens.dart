import 'package:flutter/material.dart';

@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  // Surfaces
  final Color surface;
  final Color surfaceVariant;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color cardBackground;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;

  // Primary
  final Color primary;
  final Color primaryLight;
  final Color primaryContainer;
  final Color onPrimary;
  final Color onPrimaryContainer;

  // Semantic
  final Color error;
  final Color errorContainer;
  final Color success;
  final Color successContainer;
  final Color warning;
  final Color warningContainer;
  final Color info;
  final Color infoContainer;

  // Drawing
  final Color hintStroke;

  // Reading types
  final Color onyomi;
  final Color kunyomi;

  const AppTokens({
    required this.surface,
    required this.surfaceVariant,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.cardBackground,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.primary,
    required this.primaryLight,
    required this.primaryContainer,
    required this.onPrimary,
    required this.onPrimaryContainer,
    required this.error,
    required this.errorContainer,
    required this.success,
    required this.successContainer,
    required this.warning,
    required this.warningContainer,
    required this.info,
    required this.infoContainer,
    required this.hintStroke,
    required this.onyomi,
    required this.kunyomi,
  });

  static const light = AppTokens(
    surface: Color(0xFFFEF7FF),
    surfaceVariant: Color(0xFFE7E0EC),
    surfaceContainer: Color(0xFFF3EDF7),
    surfaceContainerHigh: Color(0xFFECE6F0),
    cardBackground: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1C1B1F),
    onSurfaceVariant: Color(0xFF49454F),
    outline: Color(0xFF79747E),
    outlineVariant: Color(0xFFCAC4D0),
    primary: Color(0xFF6B4EFF),
    primaryLight: Color(0xFF9B7FFF),
    primaryContainer: Color(0xFFE8E0FF),
    onPrimary: Color(0xFFFFFFFF),
    onPrimaryContainer: Color(0xFF1E0085),
    error: Color(0xFFB3261E),
    errorContainer: Color(0xFFFCE8E6),
    success: Color(0xFF146B3A),
    successContainer: Color(0xFFC8F5DA),
    warning: Color(0xFF7A5200),
    warningContainer: Color(0xFFFFDDB3),
    info: Color(0xFF1E88E5),
    infoContainer: Color(0xFFD6E9FB),
    hintStroke: Color(0xFFFF8F00),
    onyomi: Color(0xFF1565C0),
    kunyomi: Color(0xFFC62828),
  );

  static const dark = AppTokens(
    surface: Color(0xFF141218),
    surfaceVariant: Color(0xFF49454F),
    surfaceContainer: Color(0xFF141218),
    surfaceContainerHigh: Color(0xFF2B2930),
    cardBackground: Color(0xFF1E1B24),
    onSurface: Color(0xFFE6E1E5),
    onSurfaceVariant: Color(0xFFCAC4D0),
    outline: Color(0xFF938F99),
    outlineVariant: Color(0xFF49454F),
    primary: Color(0xFFCFBCFF),
    primaryLight: Color(0xFFB39DFF),
    primaryContainer: Color(0xFF4F378B),
    onPrimary: Color(0xFF381E72),
    onPrimaryContainer: Color(0xFFEADDFF),
    error: Color(0xFFF2B8B5),
    errorContainer: Color(0xFF8C1D18),
    success: Color(0xFF6CDFAB),
    successContainer: Color(0xFF0A3D22),
    warning: Color(0xFFFFBA60),
    warningContainer: Color(0xFF3E2900),
    info: Color(0xFF90CAF9),
    infoContainer: Color(0xFF13344F),
    hintStroke: Color(0xFFFFB74D),
    onyomi: Color(0xFF90CAF9),
    kunyomi: Color(0xFFEF9A9A),
  );

  @override
  AppTokens copyWith({
    Color? surface,
    Color? surfaceVariant,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? cardBackground,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? outline,
    Color? outlineVariant,
    Color? primary,
    Color? primaryLight,
    Color? primaryContainer,
    Color? onPrimary,
    Color? onPrimaryContainer,
    Color? error,
    Color? errorContainer,
    Color? success,
    Color? successContainer,
    Color? warning,
    Color? warningContainer,
    Color? info,
    Color? infoContainer,
    Color? hintStroke,
    Color? onyomi,
    Color? kunyomi,
  }) => AppTokens(
    surface: surface ?? this.surface,
    surfaceVariant: surfaceVariant ?? this.surfaceVariant,
    surfaceContainer: surfaceContainer ?? this.surfaceContainer,
    surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
    cardBackground: cardBackground ?? this.cardBackground,
    onSurface: onSurface ?? this.onSurface,
    onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
    outline: outline ?? this.outline,
    outlineVariant: outlineVariant ?? this.outlineVariant,
    primary: primary ?? this.primary,
    primaryLight: primaryLight ?? this.primaryLight,
    primaryContainer: primaryContainer ?? this.primaryContainer,
    onPrimary: onPrimary ?? this.onPrimary,
    onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
    error: error ?? this.error,
    errorContainer: errorContainer ?? this.errorContainer,
    success: success ?? this.success,
    successContainer: successContainer ?? this.successContainer,
    warning: warning ?? this.warning,
    warningContainer: warningContainer ?? this.warningContainer,
    info: info ?? this.info,
    infoContainer: infoContainer ?? this.infoContainer,
    hintStroke: hintStroke ?? this.hintStroke,
    onyomi: onyomi ?? this.onyomi,
    kunyomi: kunyomi ?? this.kunyomi,
  );

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    return AppTokens(
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      surfaceContainer: Color.lerp(
        surfaceContainer,
        other.surfaceContainer,
        t,
      )!,
      surfaceContainerHigh: Color.lerp(
        surfaceContainerHigh,
        other.surfaceContainerHigh,
        t,
      )!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceVariant: Color.lerp(
        onSurfaceVariant,
        other.onSurfaceVariant,
        t,
      )!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryContainer: Color.lerp(
        primaryContainer,
        other.primaryContainer,
        t,
      )!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      onPrimaryContainer: Color.lerp(
        onPrimaryContainer,
        other.onPrimaryContainer,
        t,
      )!,
      error: Color.lerp(error, other.error, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      hintStroke: Color.lerp(hintStroke, other.hintStroke, t)!,
      onyomi: Color.lerp(onyomi, other.onyomi, t)!,
      kunyomi: Color.lerp(kunyomi, other.kunyomi, t)!,
    );
  }

  /// Rebuilds the primary ramp around [accent], keeping the same relationships
  /// the purple ramp has (light shade, container tint, readable on-colours).
  ///
  /// Used by [AccentTheme] to scope a subtree to a level's colour so widgets
  /// that paint themselves `t.primary` follow the level without being edited.
  AppTokens accented(Color accent, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final onAccent = onAccentFor(accent);

    return copyWith(
      primary: accent,
      primaryLight: Color.lerp(accent, const Color(0xFFFFFFFF), 0.35),
      primaryContainer: isDark
          ? Color.lerp(accent, const Color(0xFF000000), 0.55)
          : Color.lerp(accent, const Color(0xFFFFFFFF), 0.88),
      onPrimary: onAccent,
      onPrimaryContainer: isDark
          ? Color.lerp(accent, const Color(0xFFFFFFFF), 0.60)
          : Color.lerp(accent, const Color(0xFF000000), 0.55),
    );
  }
}

/// The readable foreground for [accent].
///
/// Picks whichever on-colour actually contrasts more. `ThemeData`'s
/// `estimateBrightnessForColor` uses a fixed luminance threshold, which lands
/// on the wrong side for mid-tone accents (kana teal, N1 red) and drops those
/// below AA.
///
/// Use this — not a hardcoded `Colors.white` — whenever text or an icon sits on
/// a colour the widget was handed rather than one from the theme.
Color onAccentFor(Color accent) {
  const white = Color(0xFFFFFFFF);
  const nearBlack = Color(0xFF1C1B1F);
  return _contrastRatio(accent, white) >= _contrastRatio(accent, nearBlack)
      ? white
      : nearBlack;
}

/// WCAG relative-luminance contrast ratio between two colours.
double _contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

extension AppTheme on BuildContext {
  AppTokens get tokens => Theme.of(this).extension<AppTokens>()!;
}
