import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';

class KanjiLevelHeader extends StatelessWidget {
  final String level;
  final String? label;
  final Color color;
  final VoidCallback onBack;
  const KanjiLevelHeader({
    super.key,
    required this.level,
    required this.color,
    required this.onBack,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceXs, AppDimens.spaceSm, AppDimens.spaceMd, 0,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: onBack,
            color: t.onSurface,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppDimens.radiusSm),
            ),
            child: Text(
              level,
              style: AppTextStyles.labelLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (label != null) ...[
            const SizedBox(width: AppDimens.spaceSm),
            Text(
              '· $label',
              style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}
