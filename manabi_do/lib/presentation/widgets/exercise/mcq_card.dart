import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../common/japanese_text.dart';
import '../common/pill_badge.dart';
import '../common/speak_button.dart';

enum McqOptionState { idle, selected, correct, wrong }

class McqOption {
  final String letter;
  final String text;
  final String? reading;
  final McqOptionState state;
  final bool useJpFont;

  const McqOption({
    required this.letter,
    required this.text,
    this.reading,
    this.state = McqOptionState.idle,
    this.useJpFont = false,
  });

  McqOption copyWith({McqOptionState? state}) => McqOption(
    letter: letter,
    text: text,
    reading: reading,
    state: state ?? this.state,
    useJpFont: useJpFont,
  );
}

class McqCard extends StatelessWidget {
  final String question;
  final String? japanesePrompt;
  final String? japaneseReading;
  final List<McqOption> options;
  final ValueChanged<int>? onOptionTap;
  final bool compactGrid;
  final bool showFurigana;

  const McqCard({
    super.key,
    required this.question,
    this.japanesePrompt,
    this.japaneseReading,
    required this.options,
    this.onOptionTap,
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
          _ExTypeBadge(),
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
                ),
              ),
            )
          else
            ...List.generate(
              options.length,
              (i) => Padding(
                padding: EdgeInsets.only(top: i == 0 ? 0 : AppDimens.spaceSm),
                child: _McqOptionTile(
                  option: options[i],
                  onTap: () => onOptionTap?.call(i),
                ),
              ),
            ),
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
                  reading: japaneseReading ?? japanesePrompt!,
                  style: AppTextStyles.jpLarge.copyWith(color: t.onSurface),
                  rubyStyle: AppTextStyles.jpFurigana.copyWith(
                    color: t.onSurfaceVariant,
                  ),
                  showFurigana: showFurigana,
                ),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          (option.useJpFont
                                  ? AppTextStyles.jpBody
                                  : AppTextStyles.body)
                              .copyWith(color: contentColor),
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

class _McqGridCell extends StatelessWidget {
  final McqOption option;
  final VoidCallback? onTap;

  const _McqGridCell({required this.option, this.onTap});

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
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppDimens.spaceXs),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: contentColor, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        option.letter,
                        style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: contentColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    option.text,
                    style: AppTextStyles.jpDisplay.copyWith(
                      color: contentColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
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
