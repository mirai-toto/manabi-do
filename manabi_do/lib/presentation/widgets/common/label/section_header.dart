import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';

/// Bold section title with optional subtitle, glyph accent, and color.
///
/// On short screens (a phone in landscape) it shrinks to a single line so
/// the content below keeps most of the height.
class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String glyph;
  final Color color;

  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.glyph,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final bool compact = MediaQuery.sizeOf(context).height < 500;
    final Text titleText = Text(
      title,
      style: (compact ? AppTextStyles.title : AppTextStyles.headline).copyWith(
        color: t.onSurface,
      ),
    );
    final Text subtitleText = Text(
      subtitle,
      maxLines: compact ? 1 : null,
      overflow: compact ? TextOverflow.ellipsis : null,
      style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimens.spaceMd,
        compact ? AppDimens.spaceSm : AppDimens.spaceMd,
        AppDimens.spaceMd,
        compact ? AppDimens.spaceXs : AppDimens.spaceSm,
      ),
      child: Row(
        crossAxisAlignment: compact
            ? CrossAxisAlignment.baseline
            : CrossAxisAlignment.center,
        textBaseline: TextBaseline.alphabetic,
        children: [
          if (compact) ...[
            titleText,
            const SizedBox(width: AppDimens.spaceSm),
            Expanded(child: subtitleText),
          ] else
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [titleText, subtitleText],
              ),
            ),
          Text(
            glyph,
            style: (compact ? AppTextStyles.jpMedium : AppTextStyles.jpDisplay)
                .copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
