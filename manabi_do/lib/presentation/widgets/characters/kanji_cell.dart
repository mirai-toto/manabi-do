import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

class KanjiCell extends StatelessWidget {
  final String character;
  final String meaning;
  final bool isKnown;
  final VoidCallback? onTap;
  final double size;
  final double? kanjiSize;
  final double? meaningSize;

  const KanjiCell({
    super.key,
    required this.character,
    required this.meaning,
    this.isKnown = false,
    this.onTap,
    this.size = 80,
    this.kanjiSize,
    this.meaningSize,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Semantics(
      label: '$character, $meaning${isKnown ? ', known' : ''}',
      button: onTap != null,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: size,
          height: size,
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
                  fontSize: kanjiSize,
                  height: 1,
                  color: t.onSurface,
                ),
              ),
              if (meaning.isNotEmpty) ...[
                const SizedBox(height: AppDimens.spaceXs),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceXs),
                  child: Text(
                    meaning,
                    style: AppTextStyles.labelSmall.copyWith(
                      fontSize: meaningSize,
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
