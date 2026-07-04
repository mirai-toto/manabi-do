import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';

class SectionTitleBlock extends StatelessWidget {
  final String content;
  final Color color;

  const SectionTitleBlock({
    super.key,
    required this.content,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 4,
          height: 22,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppDimens.radiusXxs),
          ),
        ),
        const SizedBox(width: AppDimens.spaceSm),
        Expanded(
          child: Text(
            content,
            style: AppTextStyles.title.copyWith(color: t.onSurface),
          ),
        ),
      ],
    );
  }
}
