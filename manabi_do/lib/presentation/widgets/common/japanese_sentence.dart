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
  final bool hideHighlight;

  const JapaneseSentence({
    super.key,
    required this.sentence,
    this.highlight,
    this.highlightColor,
    this.translation,
    this.style,
    this.hideHighlight = false,
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
      if (hideHighlight) {
        spans = [
          ...furiganaSpans(before, baseStyle, rubyStyle),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: accentColor),
              ),
              child: Text(
                stripAnnotation(target),
                style: baseStyle.copyWith(
                  color: Colors.transparent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          ...furiganaSpans(after, baseStyle, rubyStyle),
        ];
      } else {
        spans = [
          ...furiganaSpans(before, baseStyle, rubyStyle),
          ...furiganaSpans(
            target,
            baseStyle.copyWith(color: accentColor, fontWeight: FontWeight.w700),
            rubyStyle.copyWith(color: accentColor),
          ),
          ...furiganaSpans(after, baseStyle, rubyStyle),
        ];
      }
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
