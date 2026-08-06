import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../common/japanese_text.dart';
import 'mcq_card.dart';

class ClozeOption extends StatelessWidget {
  final McqOption option;
  final bool showFurigana;
  final VoidCallback? onTap;

  const ClozeOption({
    super.key,
    required this.option,
    required this.showFurigana,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    final Color borderColor;
    final Color bgColor;
    final Color contentColor;

    switch (option.state) {
      case McqOptionState.selected:
        borderColor = t.primary;
        bgColor = t.primaryContainer;
        contentColor = t.onPrimaryContainer;
      case McqOptionState.correct:
        borderColor = t.success;
        bgColor = t.successContainer;
        contentColor = t.success;
      case McqOptionState.wrong:
        borderColor = t.error;
        bgColor = t.errorContainer;
        contentColor = t.error;
      case McqOptionState.idle:
        borderColor = t.outlineVariant;
        bgColor = Colors.transparent;
        contentColor = t.onSurface;
    }

    final wordStyle = AppTextStyles.jpBody.copyWith(color: contentColor);
    final rubyStyle = AppTextStyles.jpFurigana.copyWith(
      color: contentColor.withValues(alpha: 0.7),
    );

    return Semantics(
      label: '${option.letter}: ${option.text}',
      selected: option.state != McqOptionState.idle,
      button: option.state == McqOptionState.idle,
      excludeSemantics: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: option.state == McqOptionState.idle ? onTap : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
                vertical: AppDimens.optionTilePaddingV,
              ),
              child: Row(
                children: [
                  LetterCircle(letter: option.letter, color: contentColor),
                  const SizedBox(width: AppDimens.spaceSm + 4),
                  Expanded(
                    child: JapaneseText(
                      word: option.text,
                      reading: option.reading ?? option.text,
                      style: wordStyle,
                      rubyStyle: rubyStyle,
                      showFurigana: showFurigana,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LetterCircle extends StatelessWidget {
  final String letter;
  final Color color;
  const LetterCircle({super.key, required this.letter, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.5),
      ),
      child: Center(
        child: Text(
          letter,
          style: AppTextStyles.label.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }
}
