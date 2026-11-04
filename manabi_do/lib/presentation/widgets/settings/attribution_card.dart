import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../common/surface/card_container.dart';

/// A data source's licence notice and the link it asks to be credited with.
class AttributionCard extends StatelessWidget {
  final String notice;
  final String link;
  const AttributionCard({super.key, required this.notice, required this.link});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return CardContainer(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notice,
            style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
          ),
          const SizedBox(height: AppDimens.spaceSm),
          Text(link, style: AppTextStyles.bodySmall.copyWith(color: t.primary)),
        ],
      ),
    );
  }
}
