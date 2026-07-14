import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import 'japanese_text.dart';

class JapaneseSentence extends StatelessWidget {
  final String sentence;
  final String? highlight;
  final Color? highlightColor;
  final String? translation;
  final TextStyle? style;

  const JapaneseSentence({
    super.key,
    required this.sentence,
    this.highlight,
    this.highlightColor,
    this.translation,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final baseStyle = (style ?? AppTextStyles.jpBody).copyWith(
      color: t.onSurface,
    );
    final rubyStyle = AppTextStyles.jpFurigana.copyWith(
      color: t.onSurfaceVariant,
    );
    final accentColor = highlightColor ?? t.primary;

    final List<InlineSpan> spans;

    if (highlight != null && highlight!.isNotEmpty) {
      final plain = stripAnnotation(sentence);
      final (before, target, after) = splitSentenceAnnotation(
        sentence,
        plain,
        highlight!,
      );
      spans = [
        ...furiganaSpans(before, baseStyle, rubyStyle),
        ...furiganaSpans(
          target,
          baseStyle.copyWith(color: accentColor, fontWeight: FontWeight.w700),
          rubyStyle.copyWith(color: accentColor),
        ),
        ...furiganaSpans(after, baseStyle, rubyStyle),
      ];
    } else {
      spans = furiganaSpans(sentence, baseStyle, rubyStyle);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: spans),
        ),
        if (translation != null) ...[
          const SizedBox(height: 4),
          Text(
            translation!,
            style: AppTextStyles.bodySmall.copyWith(
              color: t.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
