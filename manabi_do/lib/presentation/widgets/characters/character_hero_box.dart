import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';

class CharacterHeroBox extends StatelessWidget {
  final String character;
  final double size;
  final Color? accentColor;

  const CharacterHeroBox({
    super.key,
    required this.character,
    required this.size,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
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
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          );

    return Container(
      width: size,
      height: size,
      decoration: decoration,
      child: Center(
        child: Text(
          character,
          style: AppTextStyles.jpKanji.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
