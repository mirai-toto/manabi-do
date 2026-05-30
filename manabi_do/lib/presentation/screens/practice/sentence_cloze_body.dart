import 'package:flutter/material.dart' hide Card;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card, Rating;

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../../core/models/sentence_settings.dart';
import '../../providers/sentence_settings_provider.dart';
import '../../widgets/common/furigana_text.dart';
import '../../widgets/common/pill_badge.dart';
import '../../widgets/exercise/flash_card.dart';
import '../../widgets/exercise/mcq_card.dart';

class SentenceClozeBody extends ConsumerStatefulWidget {
  final Sentence sentence;
  final String? translation;
  final String? targetReading;
  final List<McqOption> options;
  final int correctIndex;
  final Card? card;
  final bool isFreeMode;
  final int index;
  final int total;
  final Color color;
  final void Function(Rating) onAnswer;

  const SentenceClozeBody({
    super.key,
    required this.sentence,
    required this.options,
    required this.correctIndex,
    required this.card,
    required this.index,
    required this.total,
    required this.color,
    required this.onAnswer,
    this.isFreeMode = false,
    this.translation,
    this.targetReading,
  });

  @override
  ConsumerState<SentenceClozeBody> createState() => _SentenceClozeBodyState();
}

class _SentenceClozeBodyState extends ConsumerState<SentenceClozeBody> {
  late List<McqOptionState> _states;
  bool _answered = false;
  bool _autoAdvancing = false;
  bool _showTranslation = false;

  @override
  void initState() {
    super.initState();
    _states = List.filled(widget.options.length, McqOptionState.idle);
  }

  void _onTap(int i) {
    if (_answered) return;
    final isCorrect = i == widget.correctIndex;
    setState(() {
      _answered = true;
      _states = List.generate(widget.options.length, (j) {
        if (j == i)
          return isCorrect ? McqOptionState.correct : McqOptionState.wrong;
        if (!isCorrect && j == widget.correctIndex)
          return McqOptionState.correct;
        return McqOptionState.idle;
      });
    });
    if (widget.isFreeMode && ref.read(sentenceSettingsProvider).autoAdvance) {
      setState(() => _autoAdvancing = true);
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) widget.onAnswer(isCorrect ? Rating.good : Rating.again);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final settings = ref.watch(sentenceSettingsProvider);
    final options = List.generate(
      widget.options.length,
      (i) => widget.options[i].copyWith(state: _states[i]),
    );

    final bool effectiveShowTranslation = switch (settings.translationMode) {
      TranslationMode.always => true,
      TranslationMode.onDemand => _showTranslation,
      TranslationMode.never => false,
    };
    final VoidCallback? toggleCallback =
        (settings.translationMode == TranslationMode.onDemand &&
            widget.translation != null)
        ? () => setState(() => _showTranslation = !_showTranslation)
        : null;
    final String? effectiveTranslation =
        settings.translationMode == TranslationMode.never
        ? null
        : widget.translation;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: widget.index / widget.total,
                  backgroundColor: t.outlineVariant,
                  color: widget.color,
                  borderRadius: BorderRadius.circular(AppDimens.radiusXs),
                ),
              ),
              const SizedBox(width: AppDimens.spaceXs),
              Text(
                '${widget.index + 1} / ${widget.total}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: t.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceLg),
          _SentenceClozeCard(
            sentence: widget.sentence,
            translation: effectiveTranslation,
            showTranslation: effectiveShowTranslation,
            onToggleTranslation: toggleCallback,
            showSentenceFurigana: settings.showSentenceFurigana,
            showChoiceFurigana: settings.showChoiceFurigana,
            targetReading: widget.targetReading,
            options: options,
            answered: _answered,
            color: widget.color,
            onOptionTap: _answered ? null : _onTap,
          ),
          if (_answered && !_autoAdvancing) ...[
            const SizedBox(height: AppDimens.spaceMd),
            FlashCardActions(
              card: widget.card,
              isFreeMode: widget.isFreeMode,
              question: l.selfAssessQuestion,
              onRate: widget.onAnswer,
            ),
          ],
        ],
      ),
    );
  }
}

// Every segment — annotated kanji or plain kana/punctuation — becomes a
// WidgetSpan with the same Column(ruby, text) structure so all characters
// share identical height and sit on the same visual baseline in RichText.
// Kana/punctuation segments are split per character so line-wrapping can
// still occur at character boundaries inside a RichText.
List<InlineSpan> _furiganaSpans(
  String annotated,
  TextStyle textStyle,
  TextStyle rubyStyle,
) {
  final segments = parseFuriganaAnnotation(annotated);
  final spans = <InlineSpan>[];
  for (final seg in segments) {
    if (seg.ruby != null) {
      spans.add(_rubySpan(seg.text, seg.ruby!, textStyle, rubyStyle));
    } else {
      for (int i = 0; i < seg.text.length; i++) {
        spans.add(_rubySpan(seg.text[i], '', textStyle, rubyStyle));
      }
    }
  }
  return spans;
}

// Same as _furiganaSpans but for plain text with no annotation (fallback).
List<InlineSpan> _plainSpans(
  String text,
  TextStyle textStyle,
  TextStyle rubyStyle,
) {
  return List.generate(
    text.length,
    (i) => _rubySpan(text[i], '', textStyle, rubyStyle),
  );
}

/// Splits a full-sentence `{kanji|reading}` annotation into (before, target,
/// after) by tracking each segment's position in [japanese] and cutting at
/// [targetWord]'s character range. Segments that straddle a boundary (a rare
/// pykakasi compound spanning the cut point) are placed in [target].
(String, String, String) _splitAnnotation(
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

WidgetSpan _rubySpan(
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

class _SentenceClozeCard extends StatelessWidget {
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

  const _SentenceClozeCard({
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
      // Full-sentence annotation: split at target word position so readings
      // reflect the correct morphological context.
      final (beforeAnnot, targetAnnot, afterAnnot) = _splitAnnotation(
        sentence.furigana!,
        sentence.japanese,
        sentence.targetWord,
      );
      beforeSpans = showSentenceFurigana
          ? _furiganaSpans(beforeAnnot, sentenceStyle, rubyStyle)
          : _plainSpans(
              _stripAnnotation(beforeAnnot),
              sentenceStyle,
              rubyStyle,
            );
      afterSpans = showSentenceFurigana
          ? _furiganaSpans(afterAnnot, sentenceStyle, rubyStyle)
          : _plainSpans(_stripAnnotation(afterAnnot), sentenceStyle, rubyStyle);
      targetSpans = answered
          ? _furiganaSpans(targetAnnot, targetStyle, targetRubyStyle)
          : [_blankSpan(color)];
    } else {
      // Fallback for rows without the new furigana column.
      final rawBefore = sentence.japanese.split(sentence.targetWord).first;
      final rawAfter = sentence.japanese
          .split(sentence.targetWord)
          .skip(1)
          .join(sentence.targetWord);
      if (showSentenceFurigana) {
        beforeSpans = sentence.furiganaBefore != null
            ? _furiganaSpans(sentence.furiganaBefore!, sentenceStyle, rubyStyle)
            : _plainSpans(rawBefore, sentenceStyle, rubyStyle);
        afterSpans = sentence.furiganaAfter != null
            ? _furiganaSpans(sentence.furiganaAfter!, sentenceStyle, rubyStyle)
            : _plainSpans(rawAfter, sentenceStyle, rubyStyle);
      } else {
        beforeSpans = _plainSpans(rawBefore, sentenceStyle, rubyStyle);
        afterSpans = _plainSpans(rawAfter, sentenceStyle, rubyStyle);
      }
      if (answered) {
        final segs = parseFurigana(
          sentence.targetWord,
          targetReading ?? sentence.targetWord,
        );
        targetSpans = segs
            .map<InlineSpan>(
              (seg) => _rubySpan(
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
              child: _ClozeOption(
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

class _ClozeOption extends StatelessWidget {
  final McqOption option;
  final bool showFurigana;
  final VoidCallback? onTap;

  const _ClozeOption({
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
                  _LetterCircle(letter: option.letter, color: contentColor),
                  const SizedBox(width: AppDimens.spaceSm + 4),
                  Expanded(
                    child: showFurigana && option.reading != null
                        ? FuriganaText(
                            word: option.text,
                            reading: option.reading!,
                            wordStyle: wordStyle,
                            rubyStyle: rubyStyle,
                          )
                        : Text(option.text, style: wordStyle),
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
