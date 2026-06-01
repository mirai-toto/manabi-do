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

  // Secondary
  final Color secondary;
  final Color secondaryContainer;
  final Color onSecondary;
  final Color onSecondaryContainer;

  // Semantic
  final Color error;
  final Color errorContainer;
  final Color success;
  final Color successContainer;
  final Color warning;
  final Color warningContainer;

  // Section brand
  final Color charactersDark;
  final Color characters;
  final Color vocabularyDark;
  final Color vocabulary;

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
    required this.secondary,
    required this.secondaryContainer,
    required this.onSecondary,
    required this.onSecondaryContainer,
    required this.error,
    required this.errorContainer,
    required this.success,
    required this.successContainer,
    required this.warning,
    required this.warningContainer,
    required this.charactersDark,
    required this.characters,
    required this.vocabularyDark,
    required this.vocabulary,
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
    secondary: Color(0xFF5E5791),
    secondaryContainer: Color(0xFFE4DFFF),
    onSecondary: Color(0xFFFFFFFF),
    onSecondaryContainer: Color(0xFF1A1250),
    error: Color(0xFFB3261E),
    errorContainer: Color(0xFFFCE8E6),
    success: Color(0xFF146B3A),
    successContainer: Color(0xFFC8F5DA),
    warning: Color(0xFF7A5200),
    warningContainer: Color(0xFFFFDDB3),
    charactersDark: Color(0xFF0D47A1),
    characters: Color(0xFF1976D2),
    vocabularyDark: Color(0xFF1B5E20),
    vocabulary: Color(0xFF388E3C),
  );

  static const dark = AppTokens(
    surface: Color(0xFF141218),
    surfaceVariant: Color(0xFF49454F),
    surfaceContainer: Color(0xFF211F26),
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
    secondary: Color(0xFFCCC2DC),
    secondaryContainer: Color(0xFF4A4458),
    onSecondary: Color(0xFF332D41),
    onSecondaryContainer: Color(0xFFE8DEF8),
    error: Color(0xFFF2B8B5),
    errorContainer: Color(0xFF8C1D18),
    success: Color(0xFF6CDFAB),
    successContainer: Color(0xFF0A3D22),
    warning: Color(0xFFFFBA60),
    warningContainer: Color(0xFF3E2900),
    charactersDark: Color(0xFF1565C0),
    characters: Color(0xFF90CAF9),
    vocabularyDark: Color(0xFF2E7D32),
    vocabulary: Color(0xFFA5D6A7),
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
    Color? secondary,
    Color? secondaryContainer,
    Color? onSecondary,
    Color? onSecondaryContainer,
    Color? error,
    Color? errorContainer,
    Color? success,
    Color? successContainer,
    Color? warning,
    Color? warningContainer,
    Color? charactersDark,
    Color? characters,
    Color? vocabularyDark,
    Color? vocabulary,
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
    secondary: secondary ?? this.secondary,
    secondaryContainer: secondaryContainer ?? this.secondaryContainer,
    onSecondary: onSecondary ?? this.onSecondary,
    onSecondaryContainer: onSecondaryContainer ?? this.onSecondaryContainer,
    error: error ?? this.error,
    errorContainer: errorContainer ?? this.errorContainer,
    success: success ?? this.success,
    successContainer: successContainer ?? this.successContainer,
    warning: warning ?? this.warning,
    warningContainer: warningContainer ?? this.warningContainer,
    charactersDark: charactersDark ?? this.charactersDark,
    characters: characters ?? this.characters,
    vocabularyDark: vocabularyDark ?? this.vocabularyDark,
    vocabulary: vocabulary ?? this.vocabulary,
  );

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    return AppTokens(
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      surfaceContainer: Color.lerp(surfaceContainer, other.surfaceContainer, t)!,
      surfaceContainerHigh: Color.lerp(surfaceContainerHigh, other.surfaceContainerHigh, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceVariant: Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryContainer: Color.lerp(primaryContainer, other.primaryContainer, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      onPrimaryContainer: Color.lerp(onPrimaryContainer, other.onPrimaryContainer, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryContainer: Color.lerp(secondaryContainer, other.secondaryContainer, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      onSecondaryContainer: Color.lerp(onSecondaryContainer, other.onSecondaryContainer, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      charactersDark: Color.lerp(charactersDark, other.charactersDark, t)!,
      characters: Color.lerp(characters, other.characters, t)!,
      vocabularyDark: Color.lerp(vocabularyDark, other.vocabularyDark, t)!,
      vocabulary: Color.lerp(vocabulary, other.vocabulary, t)!,
    );
  }
}

extension AppTheme on BuildContext {
  AppTokens get tokens => Theme.of(this).extension<AppTokens>()!;
}
