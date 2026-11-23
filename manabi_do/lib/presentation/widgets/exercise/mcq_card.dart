import 'package:flutter/material.dart';
import '../../../core/models/mcq_option.dart';
import 'answer_reaction.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../common/label/japanese_text.dart';
import '../common/indicator/pill_badge.dart';
import '../common/action/speak_button.dart';
import 'letter_circle.dart';

export '../../../core/models/mcq_option.dart';

/// Marks an answered option that opens its detail.
const IconData _kOpenIcon = Icons.info_outline_rounded;
const double _kOpenIconSize = 18;

({Color borderColor, Color bgColor, Color contentColor}) _resolveOptionColors(
  McqOptionState state,
  AppTokens t,
) => switch (state) {
  McqOptionState.selected => (
    borderColor: t.primary,
    bgColor: t.primaryContainer,
    contentColor: t.onPrimaryContainer,
  ),
  McqOptionState.correct => (
    borderColor: t.success,
    bgColor: t.successContainer,
    contentColor: t.success,
  ),
  McqOptionState.wrong => (
    borderColor: t.error,
    bgColor: t.errorContainer,
    contentColor: t.error,
  ),
  McqOptionState.idle => (
    borderColor: t.outlineVariant,
    bgColor: Colors.transparent,
    contentColor: t.onSurface,
  ),
};

/// Multiple-choice question card. Renders a question prompt and a list of
/// `McqOption` tiles with idle/correct/wrong states. The caller reads
/// `mcqSettingsProvider` and passes `showFurigana`.
class McqCard extends StatelessWidget {
  /// Exercise type shown in the badge above the prompt.
  final String badgeLabel;
  final String question;
  final String? japanesePrompt;
  final String? japaneseReading;
  final List<McqOption> options;
  final ValueChanged<int>? onOptionTap;

  /// One per option once the question is answered: tapping an option then
  /// opens what it stands for instead of answering. Null before that.
  final List<VoidCallback>? onOptionOpen;
  final bool compactGrid;
  final bool showFurigana;

  const McqCard({
    super.key,
    required this.badgeLabel,
    required this.question,
    this.japanesePrompt,
    this.japaneseReading,
    required this.options,
    this.onOptionTap,
    this.onOptionOpen,
    this.compactGrid = false,
    this.showFurigana = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Container(
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusXl),
        boxShadow: [
          BoxShadow(
            color: t.onSurface.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ExTypeBadge(label: badgeLabel),
          const SizedBox(height: AppDimens.spaceMd),
          _ExPrompt(
            question: question,
            japanesePrompt: japanesePrompt,
            japaneseReading: japaneseReading,
            showFurigana: showFurigana,
          ),
          const SizedBox(height: AppDimens.spaceLg),
          if (compactGrid)
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppDimens.spaceSm,
              crossAxisSpacing: AppDimens.spaceSm,
              children: List.generate(
                options.length,
                (i) => _McqGridCell(
                  option: options[i],
                  onTap: () => onOptionTap?.call(i),
                  onOpen: onOptionOpen?[i],
                ),
              ),
            )
          else
            ...List.generate(
              options.length,
              (i) => Padding(
                padding: EdgeInsets.only(top: i == 0 ? 0 : AppDimens.spaceSm),
                child: McqOptionTile(
                  option: options[i],
                  onTap: () => onOptionTap?.call(i),
                  onOpen: onOptionOpen?[i],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ExTypeBadge extends StatelessWidget {
  final String label;

  const _ExTypeBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return PillBadge(
      label: label.toUpperCase(),
      color: t.primary,
      background: t.primaryContainer,
      textStyle: AppTextStyles.labelSmall.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
      ),
    );
  }
}

class _ExPrompt extends StatelessWidget {
  final String question;
  final String? japanesePrompt;
  final String? japaneseReading;
  final bool showFurigana;

  const _ExPrompt({
    required this.question,
    required this.showFurigana,
    this.japanesePrompt,
    this.japaneseReading,
  });

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: AppDimens.spaceLg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: JapaneseText(
                  word: japanesePrompt!,
                  reading: japaneseReading,
                  style: AppTextStyles.jpLarge.copyWith(color: t.onSurface),
                  rubyStyle: AppTextStyles.jpFurigana.copyWith(
                    color: t.onSurfaceVariant,
                  ),
                  showFurigana: showFurigana,
                ),
              ),
              const SizedBox(width: AppDimens.spaceSm),
              SpeakButton(
                text: stripAnnotation(japanesePrompt!),
                color: t.onSurfaceVariant,
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _McqOptionShell extends StatelessWidget {
  final McqOption option;
  final VoidCallback? onTap;

  /// Set once the question is answered: the whole option then opens its
  /// detail, whatever its state.
  final VoidCallback? onOpen;
  final Widget Function(Color contentColor) builder;

  const _McqOptionShell({
    required this.option,
    required this.builder,
    this.onTap,
    this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final (:borderColor, :bgColor, :contentColor) = _resolveOptionColors(
      option.state,
      t,
    );

    return Semantics(
      label: '${option.letter}: ${stripAnnotation(option.text)}',
      selected: option.state != McqOptionState.idle,
      button: onOpen != null || option.state == McqOptionState.idle,
      excludeSemantics: true,
      child: AnswerReaction(
        state: option.state,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(
              color: borderColor,
              width: AppDimens.borderWidthInteractive,
            ),
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap:
                  onOpen ??
                  (option.state == McqOptionState.idle ? onTap : null),
              child: builder(contentColor),
            ),
          ),
        ),
      ),
    );
  }
}

/// One answer row: a lettered circle and the option text, drawn in the
/// colours of its [McqOption.state]. Shared by multiple choice and the
/// fill-in-the-blank exercises.
class McqOptionTile extends StatelessWidget {
  final McqOption option;
  final VoidCallback? onTap;

  /// Opens the option's detail; shows an icon saying so. Set after answering.
  final VoidCallback? onOpen;
  final bool showFurigana;

  const McqOptionTile({
    super.key,
    required this.option,
    this.onTap,
    this.onOpen,
    this.showFurigana = true,
  });

  @override
  Widget build(BuildContext context) {
    return _McqOptionShell(
      option: option,
      onTap: onTap,
      onOpen: onOpen,
      builder: (contentColor) => Padding(
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
                reading: option.reading,
                showFurigana: showFurigana,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    (option.useJpFont
                            ? AppTextStyles.jpBody
                            : AppTextStyles.body)
                        .copyWith(color: contentColor),
                rubyStyle: AppTextStyles.jpFurigana.copyWith(
                  color: contentColor.withValues(alpha: 0.7),
                ),
              ),
            ),
            if (onOpen != null) ...[
              const SizedBox(width: AppDimens.spaceSm),
              Icon(_kOpenIcon, size: _kOpenIconSize, color: contentColor),
            ],
          ],
        ),
      ),
    );
  }
}

class _McqGridCell extends StatelessWidget {
  final McqOption option;
  final VoidCallback? onTap;
  final VoidCallback? onOpen;

  const _McqGridCell({required this.option, this.onTap, this.onOpen});

  @override
  Widget build(BuildContext context) {
    return _McqOptionShell(
      option: option,
      onTap: onTap,
      onOpen: onOpen,
      builder: (contentColor) => Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimens.spaceXs),
            child: LetterCircle.compact(
              letter: option.letter,
              color: contentColor,
            ),
          ),
          Center(
            child: JapaneseText(
              word: option.text,
              style: AppTextStyles.jpDisplay.copyWith(color: contentColor),
              rubyStyle: AppTextStyles.jpFurigana.copyWith(color: contentColor),
              textAlign: TextAlign.center,
            ),
          ),
          if (onOpen != null)
            Positioned(
              top: AppDimens.spaceXs,
              right: AppDimens.spaceXs,
              child: Icon(
                _kOpenIcon,
                size: _kOpenIconSize,
                color: contentColor,
              ),
            ),
        ],
      ),
    );
  }
}
