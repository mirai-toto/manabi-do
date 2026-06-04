import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';

class CharacterCell extends StatelessWidget {
  final String character;
  final String subLabel;
  final bool isKnown;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final double? characterSize;
  final double? subLabelSize;

  const CharacterCell({
    super.key,
    required this.character,
    this.subLabel = '',
    this.isKnown = false,
    this.onTap,
    this.width = 80,
    this.height = 80,
    this.characterSize,
    this.subLabelSize,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final semanticsLabel = [
      character,
      if (subLabel.isNotEmpty) subLabel,
      if (isKnown) context.l10n.known.toLowerCase(),
    ].join(', ');

    return Semantics(
      label: semanticsLabel,
      button: onTap != null,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: isKnown ? t.successContainer : t.cardBackground,
            border: Border.all(
              color: isKnown ? t.success : t.outlineVariant,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                character,
                style: AppTextStyles.jpMedium.copyWith(
                  fontSize: characterSize,
                  height: 1,
                  color: t.onSurface,
                ),
              ),
              if (subLabel.isNotEmpty) ...[
                const SizedBox(height: AppDimens.spaceXs),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceXs),
                  child: Text(
                    subLabel,
                    style: AppTextStyles.labelSmall.copyWith(
                      fontSize: subLabelSize,
                      letterSpacing: 0.5,
                      color: isKnown ? t.success : t.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
