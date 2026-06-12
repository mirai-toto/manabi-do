import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceMd, AppDimens.spaceMd, AppDimens.spaceMd, AppDimens.spaceSm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.headline.copyWith(color: t.onSurface)),
                Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant)),
              ],
            ),
          ),
          Text(glyph, style: AppTextStyles.jpDisplay.copyWith(color: color)),
        ],
      ),
    );
  }
}
