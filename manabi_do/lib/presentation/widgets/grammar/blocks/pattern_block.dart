import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../widgets/common/card_container.dart';

/// Renders a grammar pattern formula block.
///
/// Each line is displayed in a monospaced font inside a tinted card.
/// [color] is the JLPT level accent colour — used for the left border
/// and the background tint.
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
              .map(
                (line) => Text(
                  line,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    height: 1.8,
                  ).copyWith(color: t.onSurface),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
