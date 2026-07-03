import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../widgets/common/furigana_text.dart';
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
      beforeSpans = showSentenceFurigana
          ? furiganaSpans(beforeAnnot, sentenceStyle, rubyStyle)
          : plainSpans(_stripAnnotation(beforeAnnot), sentenceStyle, rubyStyle);
      afterSpans = showSentenceFurigana
          ? furiganaSpans(afterAnnot, sentenceStyle, rubyStyle)
          : plainSpans(_stripAnnotation(afterAnnot), sentenceStyle, rubyStyle);
      targetSpans = answered
          ? furiganaSpans(targetAnnot, targetStyle, targetRubyStyle)
          : [_blankSpan(color)];
    } else {
      final rawBefore = sentence.japanese.split(sentence.targetWord).first;
      final rawAfter = sentence.japanese
          .split(sentence.targetWord)
          .skip(1)
          .join(sentence.targetWord);
      if (showSentenceFurigana) {
        beforeSpans = sentence.furiganaBefore != null
            ? furiganaSpans(sentence.furiganaBefore!, sentenceStyle, rubyStyle)
            : plainSpans(rawBefore, sentenceStyle, rubyStyle);
        afterSpans = sentence.furiganaAfter != null
            ? furiganaSpans(sentence.furiganaAfter!, sentenceStyle, rubyStyle)
            : plainSpans(rawAfter, sentenceStyle, rubyStyle);
      } else {
        beforeSpans = plainSpans(rawBefore, sentenceStyle, rubyStyle);
        afterSpans = plainSpans(rawAfter, sentenceStyle, rubyStyle);
      }
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
                      const SizedBox(width: 4),
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
                  const SizedBox(height: 2),
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

// ── Furigana span helpers ─────────────────────────────────────────────────────

// Every segment — annotated kanji or plain kana/punctuation — becomes a
// WidgetSpan with the same Column(ruby, text) structure so all characters
// share identical height and sit on the same visual baseline in RichText.
// Kana/punctuation segments are split per character so line-wrapping can
// still occur at character boundaries inside a RichText.
List<InlineSpan> furiganaSpans(
  String annotated,
  TextStyle textStyle,
  TextStyle rubyStyle,
) {
  final segments = parseFuriganaAnnotation(annotated);
  final spans = <InlineSpan>[];
  for (final seg in segments) {
    if (seg.ruby != null) {
      spans.add(rubySpan(seg.text, seg.ruby!, textStyle, rubyStyle));
    } else {
      for (int i = 0; i < seg.text.length; i++) {
        spans.add(rubySpan(seg.text[i], '', textStyle, rubyStyle));
      }
    }
  }
  return spans;
}

List<InlineSpan> plainSpans(
  String text,
  TextStyle textStyle,
  TextStyle rubyStyle,
) {
  return List.generate(
    text.length,
    (i) => rubySpan(text[i], '', textStyle, rubyStyle),
  );
}

/// Splits a full-sentence `{kanji|reading}` annotation into (before, target,
/// after) by tracking each segment's position in [japanese] and cutting at
/// [targetWord]'s character range. Segments that straddle a boundary (a rare
/// pykakasi compound spanning the cut point) are placed in [target].
(String, String, String) splitSentenceAnnotation(
  String furigana,
  String japanese,
  String targetWord,
) {
  final wordStart = japanese.indexOf(targetWord);
  if (wordStart == -1) return (furigana, '', '');
  final wordEnd = wordStart + targetWord.length;

  final before = StringBuffer();
  final target = StringBuffer();
  final after = StringBuffer();

  int pos = 0;
  int i = 0;
  final regex = RegExp(r'\{([^|]+)\|([^}]*)\}');

  while (i < furigana.length) {
    final match = regex.matchAsPrefix(furigana, i);
    if (match != null) {
      final kanji = match.group(1)!;
      final segEnd = pos + kanji.length;
      final form = match.group(0)!;
      if (segEnd <= wordStart) {
        before.write(form);
      } else if (pos >= wordEnd) {
        after.write(form);
      } else if (pos >= wordStart && segEnd <= wordEnd) {
        target.write(form);
      } else {
        // Segment straddles the word boundary. Distribute the reading
        // proportionally across individual kanji so each character keeps
        // its own annotation rather than losing furigana entirely.
        final reading = match.group(2)!;
        int readPos = 0;
        for (int k = 0; k < kanji.length; k++) {
          final charPos = pos + k;
          final ch = kanji[k];
          final String annotatedChar;
          if (reading.isEmpty) {
            annotatedChar = ch;
          } else {
            final remaining = kanji.length - k;
            final charsLeft = reading.length - readPos;
            final share = (charsLeft / remaining).ceil();
            final charReading = reading.substring(
              readPos,
              (readPos + share).clamp(0, reading.length),
            );
            readPos += charReading.length;
            annotatedChar = charReading.isNotEmpty ? '{$ch|$charReading}' : ch;
          }
          if (charPos < wordStart) {
            before.write(annotatedChar);
          } else if (charPos < wordEnd) {
            target.write(annotatedChar);
          } else {
            after.write(annotatedChar);
          }
        }
      }
      pos = segEnd;
      i = match.end;
    } else {
      final char = furigana[i];
      final segEnd = pos + 1;
      if (segEnd <= wordStart) {
        before.write(char);
      } else if (pos >= wordEnd) {
        after.write(char);
      } else {
        target.write(char);
      }
      pos = segEnd;
      i++;
    }
  }

  return (before.toString(), target.toString(), after.toString());
}

String _stripAnnotation(String annotated) => annotated.replaceAllMapped(
  RegExp(r'\{([^|]+)\|[^}]*\}'),
  (m) => m.group(1)!,
);

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

WidgetSpan rubySpan(
  String text,
  String ruby,
  TextStyle textStyle,
  TextStyle rubyStyle,
) => WidgetSpan(
  alignment: PlaceholderAlignment.bottom,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(ruby, style: rubyStyle),
      Text(text, style: textStyle),
    ],
  ),
);
