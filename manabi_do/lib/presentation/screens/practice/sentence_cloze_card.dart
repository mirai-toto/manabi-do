import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../widgets/common/japanese_text.dart';
import '../../widgets/common/pill_badge.dart';
import '../../widgets/exercise/mcq_card.dart';
import 'cloze_option.dart';

class SentenceClozeCard extends StatelessWidget {
  final Sentence sentence;
  final String? translation;
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
    this.onToggleTranslation,
    this.targetReading,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    final sentenceStyle = AppTextStyles.jpBody.copyWith(
      color: t.onSurface,
      fontSize: 26,
      height: 2.2,
    );
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
              if (onToggleTranslation != null)
                GestureDetector(
                  onTap: onToggleTranslation,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.translate_rounded,
                        size: 14,
                        color: showTranslation ? color : t.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppDimens.spaceXs),
                      Text(
                        showTranslation ? 'Hide' : 'Translation',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: showTranslation ? color : t.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: AppDimens.spaceXs),
              InkWell(
                onTap: () => _showCopyDialog(context, t),
                borderRadius: BorderRadius.circular(AppDimens.radiusXs),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: t.outlineVariant),
                    borderRadius: BorderRadius.circular(AppDimens.radiusXs),
                  ),
                  child: Icon(
                    Icons.copy_rounded,
                    size: 14,
                    color: t.onSurfaceVariant,
                  ),
                ),
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
            Text(
              translation!,
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

  void _showCopyDialog(BuildContext context, AppTokens t) {
    final japaneseText = answered
        ? sentence.japanese
        : sentence.japanese.replaceFirst(sentence.targetWord, '___');

    showDialog<void>(
      context: context,
      builder: (ctx) {
        Future<void> copy(String text) async {
          Navigator.of(ctx).pop();
          await Clipboard.setData(ClipboardData(text: text));
        }

        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.copy_rounded, size: 18, color: t.onSurfaceVariant),
              const SizedBox(width: AppDimens.spaceXs),
              Text(
                'Copy',
                style: AppTextStyles.title.copyWith(color: t.onSurface),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(0, AppDimens.spaceSm, 0, 0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CopyOption(
                label: 'Japanese',
                preview: japaneseText,
                onTap: () => copy(japaneseText),
                t: t,
              ),
              if (translation != null)
                _CopyOption(
                  label: 'Translation',
                  preview: translation!,
                  onTap: () => copy(translation!),
                  t: t,
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class _CopyOption extends StatelessWidget {
  final String label;
  final String preview;
  final VoidCallback onTap;
  final AppTokens t;

  const _CopyOption({
    required this.label,
    required this.preview,
    required this.onTap,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceLg,
          vertical: AppDimens.spaceMd,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: t.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceXxs),
                  Text(
                    preview,
                    style: AppTextStyles.body.copyWith(color: t.onSurface),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.copy_rounded, size: 16, color: t.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

WidgetSpan _blankSpan(Color color) => WidgetSpan(
  alignment: PlaceholderAlignment.bottom,
  child: Container(
    margin: const EdgeInsets.symmetric(horizontal: 4),
    width: 72,
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: color, width: 2.5)),
    ),
  ),
);
