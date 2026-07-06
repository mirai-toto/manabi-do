import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';

/// Renders a plain prose block from a grammar lesson.
///
/// Defaults to [AppTextStyles.body] in [AppTokens.onSurface].
/// Pass [style] to swap the entire base style, or [color] to override only
/// the colour while keeping the default body style.
///
/// Inline markers supported:
///   **text** → bold   *text* → italic
class TextBlock extends StatelessWidget {
  final String content;
  final TextStyle? style;
  final Color? color;
  final Color? accentColor;

  const TextBlock({
    super.key,
    required this.content,
    this.style,
    this.color,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final base = (style ?? AppTextStyles.body).copyWith(
      color: color ?? style?.color ?? t.onSurface,
    );
    return RichText(
      text: TextSpan(
        children: buildSpans(content, base, accentColor: accentColor),
      ),
    );
  }

  static List<TextSpan> buildSpans(
    String text,
    TextStyle base, {
    Color? accentColor,
  }) {
    final spans = <TextSpan>[];
    final pattern = RegExp(r'\*\*(.+?)\*\*|\*(.+?)\*');
    int last = 0;
    for (final match in pattern.allMatches(text)) {
      if (match.start > last) {
        spans.add(
          TextSpan(text: text.substring(last, match.start), style: base),
        );
      }
      if (match.group(1) != null) {
        spans.add(
          TextSpan(
            text: match.group(1),
            style: base.copyWith(
              fontWeight: FontWeight.w700,
              color: accentColor,
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: match.group(2),
            style: base.copyWith(fontStyle: FontStyle.italic),
          ),
        );
      }
      last = match.end;
    }
    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last), style: base));
    }
    return spans;
  }
}
