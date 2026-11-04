import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:manabi_do/core/theme/app_text_styles.dart';
import 'package:manabi_do/presentation/widgets/common/label/japanese_text.dart';

/// A cloze sentence is built from several calls to [furiganaSpans]. A slice
/// with ruby becomes [WidgetSpan] columns; one without becomes a plain
/// [TextSpan], which sits on the text baseline rather than the column's
/// bottom. Mixing the two in one line is what dropped あった。half a line
/// below 卵が全部で１０ on screen.
void main() {
  const style = TextStyle(fontSize: 22);
  final ruby = AppTextStyles.jpFurigana;

  bool mixed(List<InlineSpan> spans) =>
      spans.any((s) => s is WidgetSpan) && spans.any((s) => s is TextSpan);

  test('a sentence split across calls renders as one kind of span', () {
    final before = furiganaSpans(
      '{卵|たまご}が{全部|ぜんぶ}で',
      style,
      ruby,
      reserveRuby: true,
    );
    final after = furiganaSpans('あった。', style, ruby, reserveRuby: true);
    expect(mixed([...before, ...after]), isFalse);
  });

  test('asking each slice on its own is what mixes them', () {
    // The behaviour the fix replaced, kept as the thing not to go back to.
    final before = furiganaSpans('{卵|たまご}が{全部|ぜんぶ}で', style, ruby);
    final after = furiganaSpans('あった。', style, ruby);
    expect(mixed([...before, ...after]), isTrue);
  });

  test('a sentence with no ruby anywhere stays plain', () {
    // reserveRuby is off, so a kana-only line keeps its tight spacing.
    final spans = furiganaSpans('あった。', style, ruby);
    expect(spans.every((s) => s is TextSpan), isTrue);
  });
}
