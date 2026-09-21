import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import 'nav_destination.dart';

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
                    : Text(
                        destination.icon!,
                        // The glyph acts as an icon here, so it needs to sit on
                        // the optical centre. `Center` centres the line box, and
                        // NotoSansJP's default leading is split proportionally
                        // to ascent/descent — which drops CJK ink below the
                        // middle. Tighten the box and split the leading evenly.
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
