import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../common/pill_badge.dart';
import '../common/speak_button.dart';

enum McqOptionState { idle, selected, correct, wrong }

class McqOption {
  final String letter;
  final String text;
  final McqOptionState state;
  final bool useJpFont;

  const McqOption({
    required this.letter,
    required this.text,
    this.state = McqOptionState.idle,
    this.useJpFont = false,
  });

  McqOption copyWith({McqOptionState? state}) =>
      McqOption(letter: letter, text: text, state: state ?? this.state, useJpFont: useJpFont);
}

class McqCard extends StatelessWidget {
  final String question;
  final String? japanesePrompt;
  final List<McqOption> options;
  final ValueChanged<int>? onOptionTap;

  const McqCard({
    super.key,
    required this.question,
    this.japanesePrompt,
    required this.options,
    this.onOptionTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Container(
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusXl),
        boxShadow: [
          BoxShadow(color: t.onSurface.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ExTypeBadge(),
          const SizedBox(height: AppDimens.spaceMd),
          _ExPrompt(question: question, japanesePrompt: japanesePrompt),
          const SizedBox(height: AppDimens.spaceLg),
          ...List.generate(options.length, (i) => Padding(
            padding: EdgeInsets.only(top: i == 0 ? 0 : AppDimens.spaceSm),
            child: _McqOptionTile(
              option: options[i],
              onTap: () => onOptionTap?.call(i),
            ),
          )),
        ],
      ),
    );
  }
}

class _ExTypeBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return PillBadge(
      label: context.l10n.multipleChoice.toUpperCase(),
      color: t.primary,
      background: t.primaryContainer,
      textStyle: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.6),
    );
  }
}

class _ExPrompt extends ConsumerWidget {
  final String question;
  final String? japanesePrompt;

  const _ExPrompt({required this.question, this.japanesePrompt});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: t.onSurface,
          ),
        ),
        if (japanesePrompt != null) ...[
          const SizedBox(height: AppDimens.spaceXs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                japanesePrompt!,
                style: AppTextStyles.jpMedium.copyWith(color: t.onSurface),
              ),
              const SizedBox(width: AppDimens.spaceSm),
              SpeakButton(text: japanesePrompt!, color: t.onSurfaceVariant),
            ],
          ),
        ],
      ],
    );
  }
}

class _McqOptionTile extends StatelessWidget {
  final McqOption option;
  final VoidCallback? onTap;

  const _McqOptionTile({required this.option, this.onTap});

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
                  _LetterCircle(letter: option.letter, color: contentColor),
                  const SizedBox(width: AppDimens.spaceSm + 4),
                  Expanded(
                    child: Text(
                      option.text,
                      style: (option.useJpFont
                          ? AppTextStyles.jpBody
                          : AppTextStyles.body
                      ).copyWith(color: contentColor),
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

class _LetterCircle extends StatelessWidget {
  final String letter;
  final Color color;
  const _LetterCircle({required this.letter, required this.color});

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
