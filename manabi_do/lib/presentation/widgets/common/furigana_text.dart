import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

// ── Data ──────────────────────────────────────────────────────────────────────

class FuriganaSegment {
  final String text;
  final String? ruby; // null for kana segments (no annotation needed)
  const FuriganaSegment({required this.text, this.ruby});
}

// ── Parsing ───────────────────────────────────────────────────────────────────

bool _isKanji(String ch) {
  final cp = ch.codeUnitAt(0);
  return (cp >= 0x4E00 && cp <= 0x9FFF) || // CJK Unified
      (cp >= 0x3400 && cp <= 0x4DBF) || // CJK Extension A
      (cp >= 0xF900 && cp <= 0xFAFF); // CJK Compatibility
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

/// Aligns [reading] to [word] and returns annotated segments.
/// Kana characters in the word act as anchors; remaining reading chars
/// are distributed to the kanji segments before them.
List<FuriganaSegment> parseFurigana(String word, String reading) {
  final wordSegs = _segmentWord(word);

  if (!wordSegs.any((s) => s.isKanji)) {
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

    // Find the next kana segment to use as a right anchor.
    var j = i + 1;
    while (j < wordSegs.length && wordSegs[j].isKanji) { j++; }

    if (j >= wordSegs.length) {
      // Last kanji block: all remaining reading is its ruby.
      final ruby = reading.substring(readPos);
      result.add(FuriganaSegment(text: seg.text, ruby: ruby.isEmpty ? null : ruby));
      readPos = reading.length;
    } else {
      final nextKana = wordSegs[j].text;
      final kanaPos = reading.indexOf(nextKana, readPos);
      if (kanaPos == -1) {
        // Fallback: assign everything left to this kanji.
        result.add(FuriganaSegment(text: seg.text, ruby: reading.substring(readPos)));
        readPos = reading.length;
      } else {
        final ruby = reading.substring(readPos, kanaPos);
        result.add(FuriganaSegment(text: seg.text, ruby: ruby.isEmpty ? null : ruby));
        readPos = kanaPos;
      }
    }
  }

  return result;
}

// ── Widget ────────────────────────────────────────────────────────────────────

class FuriganaText extends StatelessWidget {
  final String word;
  final String reading;
  final TextStyle wordStyle;
  final TextStyle? rubyStyle;

  const FuriganaText({
    super.key,
    required this.word,
    required this.reading,
    required this.wordStyle,
    this.rubyStyle,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final segments = parseFurigana(word, reading);
    final hasRuby = segments.any((s) => s.ruby != null);

    if (!hasRuby) {
      return Text(word, style: wordStyle);
    }

    final effectiveRubyStyle = rubyStyle ??
        AppTextStyles.jpBody.copyWith(
          fontSize: 11,
          color: t.onSurfaceVariant,
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: segments
          .map((seg) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(seg.ruby ?? '', style: effectiveRubyStyle),
                  Text(seg.text, style: wordStyle),
                ],
              ))
          .toList(),
    );
  }
}
