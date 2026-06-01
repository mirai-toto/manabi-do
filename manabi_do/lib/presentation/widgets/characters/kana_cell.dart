import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';

class KanaCell extends StatelessWidget {
  final String kana;
  final String romaji;
  final bool isKnown;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const KanaCell({
    super.key,
    required this.kana,
    required this.romaji,
    this.isKnown = false,
    this.onTap,
    this.width = 72,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Semantics(
      label: '$kana, $romaji${isKnown ? ", ${context.l10n.known.toLowerCase()}" : ""}',
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
              kana,
              style: AppTextStyles.jpMedium.copyWith(height: 1, color: t.onSurface),
            ),
            const SizedBox(height: AppDimens.spaceXs),
            Text(
              romaji,
              style: AppTextStyles.labelSmall.copyWith(
                letterSpacing: 0.5,
                color: isKnown ? t.success : t.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
