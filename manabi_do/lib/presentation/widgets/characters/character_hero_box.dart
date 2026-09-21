import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

class CharacterHeroBox extends StatelessWidget {
  final String character;
  final double size;
  final Color? accentColor;

  /// Foreground to use when [accentColor] is null — the box is then a
  /// translucent scrim over whatever the parent painted, so only the parent
  /// knows what is readable on it.
  final Color onAccentOverride;

  const CharacterHeroBox({
    super.key,
    required this.character,
    required this.size,
    this.accentColor,
    this.onAccentOverride = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    // Mid-tone accents (N3 yellow, N2 orange) make white unreadable here.
    final Color onAccent = accentColor != null
        ? onAccentFor(accentColor!)
        : onAccentOverride;
    final decoration = accentColor != null
        ? BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.lerp(accentColor!, Colors.black, 0.25)!,
                accentColor!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          )
        : BoxDecoration(
            color: onAccent.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          );

    return Container(
      width: size,
      height: size,
      decoration: decoration,
      child: Center(
        child: Text(
          character,
          style: AppTextStyles.jpKanji.copyWith(color: onAccent),
        ),
      ),
    );
  }
}
