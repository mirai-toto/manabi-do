import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import 'nav_destination.dart';

/// How far to lift the glyph, as a fraction of its font size.
///
/// Measured from `assets/fonts/NotoSansJP[wght].ttf`, not guessed. The font is
/// 1000 upem with hhea ascent 1160 / descent 288, so with `height: 1.0` and
/// even leading the line box centre lands 436 above the baseline — but a kanji's
/// ink centre sits around 360-383. The glyphs we use (家 字 語 文) are low by
/// 5.4% to 7.6% of the em; this is their average.
const double _glyphRise = 0.060;

class NavItem extends StatelessWidget {
  final NavDestination destination;
  final bool isActive;
  final VoidCallback onTap;
  final double pillWidth;
  final double iconSize;
  final double? labelFontSize;
  final double labelSpacing;
  final TextAlign labelAlign;

  const NavItem({
    super.key,
    required this.destination,
    required this.isActive,
    required this.onTap,
    required this.pillWidth,
    required this.iconSize,
    this.labelFontSize,
    required this.labelSpacing,
    this.labelAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final activeColor = t.onPrimaryContainer;
    final inactiveColor = t.onSurfaceVariant;
    final iconColor = isActive ? activeColor : inactiveColor;

    return Semantics(
      label: destination.label,
      selected: isActive,
      button: true,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: isActive ? pillWidth : iconSize + 2,
              height: 32,
              decoration: isActive
                  ? BoxDecoration(
                      color: t.primaryContainer,
                      borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                    )
                  : null,
              child: Center(
                child: destination.iconAsset != null
                    ? SvgPicture.asset(
                        destination.iconAsset!,
                        width: iconSize,
                        height: iconSize,
                        colorFilter: ColorFilter.mode(
                          iconColor,
                          BlendMode.srcIn,
                        ),
                      )
                    : Transform.translate(
                        // `Center` aligns the line box, not the ink, and
                        // NotoSansJP leaves headroom above its glyphs — so a
                        // kanji used as an icon reads low. See `_glyphRise`.
                        offset: Offset(0, -(iconSize - 2) * _glyphRise),
                        child: Text(
                          destination.icon!,
                          style: AppTextStyles.jpBody.copyWith(
                            fontSize: iconSize - 2,
                            color: iconColor,
                            height: 1.0,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            ),
            SizedBox(height: labelSpacing),
            Text(
              destination.label,
              style: AppTextStyles.labelSmall.copyWith(
                fontSize: labelFontSize,
                color: isActive ? activeColor : inactiveColor,
              ),
              textAlign: labelAlign,
            ),
          ],
        ),
      ),
    );
  }
}
