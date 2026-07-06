import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

// ── Data ──────────────────────────────────────────────────────────────────────

class FuriganaSegment {
  final String text;
  final String? ruby;
  const FuriganaSegment({required this.text, this.ruby});
}

// ── Parsing ───────────────────────────────────────────────────────────────────

bool _isKanji(String ch) {
  final cp = ch.codeUnitAt(0);
  return (cp >= 0x4E00 && cp <= 0x9FFF) ||
      (cp >= 0x3400 && cp <= 0x4DBF) ||
      (cp >= 0xF900 && cp <= 0xFAFF);
}

List<({String text, bool isKanji})> _segmentWord(String word) {
  final segs = <({String text, bool isKanji})>[];
  if (word.isEmpty) return segs;

  var buf = word[0];
  var curKanji = _isKanji(word[0]);

  for (var i = 1; i < word.length; i++) {
    final k = _isKanji(word[i]);
    if (k == curKanji) {
      buf += word[i];
    } else {
      segs.add((text: buf, isKanji: curKanji));
      buf = word[i];
      curKanji = k;
    }
  }
  segs.add((text: buf, isKanji: curKanji));
  return segs;
}

/// Parses a pre-annotated string in `{kanji|reading}` format into segments.
List<FuriganaSegment> parseFuriganaAnnotation(String annotated) {
  if (annotated.isEmpty) return [];
  final result = <FuriganaSegment>[];
  final regex = RegExp(r'\{([^|]+)\|([^}]*)\}');
  int pos = 0;
  for (final match in regex.allMatches(annotated)) {
    if (match.start > pos) {
      result.add(FuriganaSegment(text: annotated.substring(pos, match.start)));
    }
    final ruby = match.group(2)!;
    result.add(
      FuriganaSegment(text: match.group(1)!, ruby: ruby.isEmpty ? null : ruby),
    );
    pos = match.end;
  }
  if (pos < annotated.length) {
    result.add(FuriganaSegment(text: annotated.substring(pos)));
  }
  return result;
}

/// Aligns [reading] to [word] and returns annotated segments.
List<FuriganaSegment> parseFurigana(String word, String reading) {
  final wordSegs = _segmentWord(word);

  if (!wordSegs.any((s) => s.isKanji) || reading.isEmpty) {
    return [FuriganaSegment(text: word)];
  }

  final result = <FuriganaSegment>[];
  var readPos = 0;

  for (var i = 0; i < wordSegs.length; i++) {
    final seg = wordSegs[i];

    if (!seg.isKanji) {
      result.add(FuriganaSegment(text: seg.text));
      readPos += seg.text.length;
      continue;
    }

    var j = i + 1;
    while (j < wordSegs.length && wordSegs[j].isKanji) {
      j++;
    }

    if (j >= wordSegs.length) {
      final ruby = reading.substring(readPos);
      result.add(
        FuriganaSegment(text: seg.text, ruby: ruby.isEmpty ? null : ruby),
      );
      readPos = reading.length;
    } else {
      final nextKana = wordSegs[j].text;
      final kanaPos = reading.indexOf(nextKana, readPos);
      if (kanaPos == -1) {
        result.add(
          FuriganaSegment(text: seg.text, ruby: reading.substring(readPos)),
        );
        readPos = reading.length;
      } else {
        final ruby = reading.substring(readPos, kanaPos);
        result.add(
          FuriganaSegment(text: seg.text, ruby: ruby.isEmpty ? null : ruby),
        );
        readPos = kanaPos;
      }
    }
  }

  return result;
}

// ── Span helpers (used by sentence-level rendering) ───────────────────────────

/// Strips `{kanji|reading}` annotation markers, leaving only the base text.
String stripAnnotation(String annotated) => annotated.replaceAllMapped(
  RegExp(r'\{([^|]+)\|[^}]*\}'),
  (m) => m.group(1)!,
);

/// Splits a full-sentence `{kanji|reading}` annotation into (before, target,
/// after) by tracking each segment's position in [japanese] and cutting at
/// [targetWord]'s character range.
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

/// Builds a single character + ruby annotation as a [WidgetSpan].
/// Every character — annotated or plain — uses this same Column structure so
/// all characters in a RichText share identical height and sit on the same
/// visual baseline. Pass an empty string for [ruby] on unannotated characters.
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

/// Builds a list of [InlineSpan]s from [text], which may be a
/// `{kanji|reading}`-annotated string or plain text.
///
/// When [showFurigana] is true, ruby annotations are rendered above each
/// kanji. When false, annotations are stripped and every character is wrapped
/// in the same Column structure (empty ruby row) to keep line height uniform.
List<InlineSpan> furiganaSpans(
  String text,
  TextStyle textStyle,
  TextStyle rubyStyle, {
  bool showFurigana = true,
}) {
  if (showFurigana) {
    final segments = parseFuriganaAnnotation(text);
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
  } else {
    final plain = stripAnnotation(text);
    return List.generate(
      plain.length,
      (i) => rubySpan(plain[i], '', textStyle, rubyStyle),
    );
  }
}

// ── Widget ────────────────────────────────────────────────────────────────────

/// Renders a Japanese word with optional furigana above each kanji.
///
/// When [showFurigana] is false, or when [word] contains no kanji, renders as
/// a plain [Text]. Use [furiganaSpans] + [RichText] for sentence-level display
/// where multiple segments with different styles must flow together.
class JapaneseText extends StatelessWidget {
  final String word;
  final String reading;
  final TextStyle style;
  final TextStyle? rubyStyle;
  final bool showFurigana;

  const JapaneseText({
    super.key,
    required this.word,
    required this.reading,
    required this.style,
    this.rubyStyle,
    this.showFurigana = true,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    if (!showFurigana) return Text(word, style: style);

    final segments = parseFurigana(word, reading);
    if (!segments.any((s) => s.ruby != null)) return Text(word, style: style);

    final effectiveRubyStyle =
        rubyStyle ??
        AppTextStyles.jpFurigana.copyWith(color: t.onSurfaceVariant);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: segments
          .map(
            (seg) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(seg.ruby ?? '', style: effectiveRubyStyle),
                Text(seg.text, style: style),
              ],
            ),
          )
          .toList(),
    );
  }
}
