import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';

class NoteBlock extends StatelessWidget {
  final String content;

  const NoteBlock({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      decoration: BoxDecoration(
        color: t.warningContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border(left: BorderSide(color: t.warning, width: 3)),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceMd,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: t.warning, size: 18),
          const SizedBox(width: AppDimens.spaceSm),
          Expanded(
            child: Text(
              content,
              style: AppTextStyles.body.copyWith(
                color: t.onSurface,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
