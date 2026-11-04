import '../common/label/translation_fallback_info.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../common/label/japanese_text.dart';
import '../common/indicator/pill_badge.dart';
import '../common/action/copy_button.dart';
import '../common/action/speak_button.dart';
import 'mcq_card.dart';
import 'cloze_option.dart';

/// Stateless display card for a sentence cloze item. Renders the gapped
/// sentence, optional furigana, translation toggle, and `ClozeOption` chips. No
/// answer-handling logic.
class SentenceClozeCard extends StatelessWidget {
  final Sentence sentence;
  final String? translation;
  final String? translationMissingLanguage;
  final bool showTranslation;
  final VoidCallback? onToggleTranslation;
  final bool showSentenceFurigana;
  final bool showChoiceFurigana;
  final String? targetReading;
  final List<McqOption> options;
  final bool answered;
  final Color color;
  final ValueChanged<int>? onOptionTap;

  const SentenceClozeCard({
    super.key,
    required this.sentence,
    required this.options,
    required this.answered,
    required this.color,
    required this.onOptionTap,
    required this.showTranslation,
    required this.showSentenceFurigana,
    required this.showChoiceFurigana,
    this.translation,
    this.translationMissingLanguage,
    this.onToggleTranslation,
    this.targetReading,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    final sentenceStyle = AppTextStyles.jpSentence.copyWith(color: t.onSurface);
    final rubyStyle = AppTextStyles.jpFurigana.copyWith(
      color: t.onSurfaceVariant,
    );
    final targetStyle = sentenceStyle.copyWith(
      color: color,
      fontWeight: FontWeight.w700,
    );
    final targetRubyStyle = AppTextStyles.jpFurigana.copyWith(
      color: color.withValues(alpha: 0.8),
    );

    final List<InlineSpan> beforeSpans;
    final List<InlineSpan> afterSpans;
    final List<InlineSpan> targetSpans;

    if (sentence.furigana != null) {
      final (beforeAnnot, targetAnnot, afterAnnot) = splitSentenceAnnotation(
        sentence.furigana!,
        sentence.japanese,
        sentence.targetWord,
      );
      beforeSpans = furiganaSpans(
        beforeAnnot,
        sentenceStyle,
        rubyStyle,
        showFurigana: showSentenceFurigana,
      );
      afterSpans = furiganaSpans(
        afterAnnot,
        sentenceStyle,
        rubyStyle,
        showFurigana: showSentenceFurigana,
      );
      targetSpans = answered
          ? furiganaSpans(targetAnnot, targetStyle, targetRubyStyle)
          : [_blankSpan(color)];
    } else {
      final rawBefore = sentence.japanese.split(sentence.targetWord).first;
      final rawAfter = sentence.japanese
          .split(sentence.targetWord)
          .skip(1)
          .join(sentence.targetWord);
      beforeSpans = (showSentenceFurigana && sentence.furiganaBefore != null)
          ? furiganaSpans(sentence.furiganaBefore!, sentenceStyle, rubyStyle)
          : furiganaSpans(
              rawBefore,
              sentenceStyle,
              rubyStyle,
              showFurigana: false,
            );
      afterSpans = (showSentenceFurigana && sentence.furiganaAfter != null)
          ? furiganaSpans(sentence.furiganaAfter!, sentenceStyle, rubyStyle)
          : furiganaSpans(
              rawAfter,
              sentenceStyle,
              rubyStyle,
              showFurigana: false,
            );
      if (answered) {
        final segs = parseFurigana(
          sentence.targetWord,
          targetReading ?? sentence.targetWord,
        );
        targetSpans = segs
            .map<InlineSpan>(
              (seg) => rubySpan(
                seg.text,
                seg.ruby ?? '',
                targetStyle,
                targetRubyStyle,
              ),
            )
            .toList();
      } else {
        targetSpans = [_blankSpan(color)];
      }
    }

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
          Row(
            children: [
              PillBadge(
                label: l.sentenceFillIn.toUpperCase(),
                color: color,
                background: color.withValues(alpha: 0.12),
                textStyle: AppTextStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: color,
                ),
              ),
              const Spacer(),
              if (onToggleTranslation != null) ...[
                _TranslationToggle(
                  showing: showTranslation,
                  color: color,
                  onTap: onToggleTranslation!,
                ),
                const SizedBox(width: AppDimens.spaceSm),
              ],
              SpeakButton(text: sentence.japanese, color: color),
              const SizedBox(width: AppDimens.spaceXs),
              CopyButton(
                choices: [
                  CopyChoice(label: l.japanese, text: _copyableJapanese),
                  if (translation != null)
                    CopyChoice(
                      label: l.translationModeLabel,
                      text: translation!,
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMd),
          Text(
            l.sentenceFillInPrompt,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: t.onSurface,
            ),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [...beforeSpans, ...targetSpans, ...afterSpans],
            ),
          ),
          if (showTranslation && translation != null) ...[
            const SizedBox(height: AppDimens.spaceMd),
            // The mark rides at the end of the text, so it does not take a
            // line of its own in the middle of an exercise.
            TranslatedText(
              translation!,
              missingLanguage: translationMissingLanguage,
              style: AppTextStyles.bodySmall.copyWith(
                color: t.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: AppDimens.spaceLg),
          ...List.generate(
            options.length,
            (i) => Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : AppDimens.spaceSm),
              child: ClozeOption(
                option: options[i],
                showFurigana: showChoiceFurigana,
                onTap: () => onOptionTap?.call(i),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// What the Japanese reads before the answer is revealed. The exercise hides
  /// the target word, so copying the sentence early must not hand it over.
  String get _copyableJapanese => answered
      ? sentence.japanese
      : sentence.japanese.replaceFirst(sentence.targetWord, '___');
}

WidgetSpan _blankSpan(Color color) => WidgetSpan(
  alignment: PlaceholderAlignment.bottom,
  child: Container(
    margin: const EdgeInsets.symmetric(horizontal: AppDimens.spaceXs),
    width: 72,
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: color, width: 2.5)),
    ),
  ),
);

/// Shows or hides the sentence translation.
///
/// Always drawn in the level colour. It used to grey out in one of its two
/// states, which read as "disabled" rather than "off" — the control is
/// available either way, so the state is carried by the fill instead: tinted
/// when the translation is showing, outlined when it is not.
class _TranslationToggle extends StatelessWidget {
  final bool showing;
  final Color color;
  final VoidCallback onTap;

  const _TranslationToggle({
    required this.showing,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final label = showing ? l.hide : l.translationModeLabel;

    return Semantics(
      label: label,
      button: true,
      toggled: showing,
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.radiusPill),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceSnug,
              vertical: AppDimens.spaceTight,
            ),
            decoration: BoxDecoration(
              color: showing
                  ? color.withValues(alpha: 0.14)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimens.radiusPill),
              border: Border.all(
                color: color.withValues(alpha: showing ? 0.0 : 0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  showing ? Icons.translate_rounded : Icons.translate_outlined,
                  size: 14,
                  color: color,
                ),
                const SizedBox(width: AppDimens.spaceXs),
                Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
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
