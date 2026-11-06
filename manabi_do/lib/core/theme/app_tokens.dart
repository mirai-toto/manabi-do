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

  // Drawing
  final Color hintStroke;

  // Reading types
  final Color onyomi;
  final Color kunyomi;

  /// The five vocabulary level colours, level 1 first. A sequential ramp
  /// around [primary]: see `vocabulary_level.dart`.
  final List<Color> levelRamp;

  // The landing hero's gradient, drawn on its own dark panel in either mode.
  final Color heroDeep;
  final Color heroMid;

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
    required this.hintStroke,
    required this.onyomi,
    required this.kunyomi,
    required this.levelRamp,
    required this.heroDeep,
    required this.heroMid,
  });

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
    Color? hintStroke,
    Color? onyomi,
    Color? kunyomi,
    List<Color>? levelRamp,
    Color? heroDeep,
    Color? heroMid,
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
    hintStroke: hintStroke ?? this.hintStroke,
    onyomi: onyomi ?? this.onyomi,
    kunyomi: kunyomi ?? this.kunyomi,
    levelRamp: levelRamp ?? this.levelRamp,
    heroDeep: heroDeep ?? this.heroDeep,
    heroMid: heroMid ?? this.heroMid,
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
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      hintStroke: Color.lerp(hintStroke, other.hintStroke, t)!,
      onyomi: Color.lerp(onyomi, other.onyomi, t)!,
      kunyomi: Color.lerp(kunyomi, other.kunyomi, t)!,
      levelRamp: [
        for (var i = 0; i < levelRamp.length; i++)
          Color.lerp(levelRamp[i], other.levelRamp[i], t)!,
      ],
      heroDeep: Color.lerp(heroDeep, other.heroDeep, t)!,
      heroMid: Color.lerp(heroMid, other.heroMid, t)!,
    );
  }

  /// Rebuilds the primary ramp around [accent], keeping the same relationships
  /// the purple ramp has (light shade, container tint, readable on-colours).
  ///
  /// Used by [AccentTheme] to scope a subtree to a level's colour so widgets
  /// that paint themselves `t.primary` follow the level without being edited.
  AppTokens accented(Color accent, Brightness brightness) {
    final onAccent = onAccentFor(accent);

    return copyWith(
      primary: accent,
      primaryLight: Color.lerp(accent, const Color(0xFFFFFFFF), 0.35),
      primaryContainer: accentContainer(accent, brightness),
      onPrimary: onAccent,
      onPrimaryContainer: onAccentContainer(accent, brightness),
    );
  }
}

/// The pale surface [accent] sits on, and the readable text colour for that
/// surface. Same relationship the theme's own primary container has, so a
/// widget handed a bare colour can build the pair without inventing one.
Color accentContainer(Color accent, Brightness brightness) =>
    brightness == Brightness.dark
    ? Color.lerp(accent, const Color(0xFF000000), 0.55)!
    : Color.lerp(accent, const Color(0xFFFFFFFF), 0.88)!;

/// The readable foreground for [accentContainer].
Color onAccentContainer(Color accent, Brightness brightness) =>
    brightness == Brightness.dark
    ? Color.lerp(accent, const Color(0xFFFFFFFF), 0.60)!
    : Color.lerp(accent, const Color(0xFF000000), 0.55)!;

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

extension AppTokensContext on BuildContext {
  AppTokens get tokens => Theme.of(this).extension<AppTokens>()!;
}
