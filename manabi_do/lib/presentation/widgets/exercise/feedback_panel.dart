import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

class FeedbackPanel extends StatelessWidget {
  final String text;
  final bool isCorrect;

  const FeedbackPanel({super.key, required this.text, required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: isCorrect ? t.successContainer : t.errorContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      ),
      child: Text(
        text,
        style: AppTextStyles.body.copyWith(
          color: isCorrect ? t.success : t.error,
        ),
      ),
    );
  }
}
