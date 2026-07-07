import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../widgets/common/card_container.dart';

class PatternBlock extends StatelessWidget {
  final List<String> lines;
  final Color color;

  const PatternBlock({super.key, required this.lines, required this.color});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return CardContainer(
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: color, width: 3)),
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMd,
          vertical: AppDimens.spaceMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: lines
              .map((line) => RichText(text: _buildSpans(line, t, color)))
              .toList(),
        ),
      ),
    );
  }

  // Parses [placeholders] and **accent** markers within a pattern line.
  InlineSpan _buildSpans(String line, AppTokens t, Color accent) {
    final base = TextStyle(fontFamily: 'monospace', fontSize: 14, height: 1.8);
    final normal = base.copyWith(color: t.onSurface);
    final muted = base.copyWith(color: t.onSurfaceVariant);
    final highlighted = base.copyWith(
      color: accent,
      fontWeight: FontWeight.w600,
    );

    final spans = <InlineSpan>[];
    final re = RegExp(r'\[([^\]]+)\]|\*\*([^*]+)\*\*');
    int cursor = 0;

    for (final m in re.allMatches(line)) {
      if (m.start > cursor) {
        spans.add(
          TextSpan(text: line.substring(cursor, m.start), style: normal),
        );
      }
      if (m.group(1) != null) {
        spans.add(TextSpan(text: '[${m.group(1)}]', style: muted));
      } else {
        spans.add(TextSpan(text: m.group(2), style: highlighted));
      }
      cursor = m.end;
    }
    if (cursor < line.length) {
      spans.add(TextSpan(text: line.substring(cursor), style: normal));
    }

    return TextSpan(children: spans);
  }
}
