import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/theme/jlpt_level.dart';
import '../presentation/widgets/grammar/blocks/pattern_block.dart';

// ── PatternBlock ──────────────────────────────────────────────────────────────

@widgetbook.UseCase(
  name: 'Single line',
  type: PatternBlock,
  path: 'Grammar/Blocks',
)
Widget buildPatternBlockSingle(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: PatternBlock(
      color: levelColor('N5'),
      lines: const ['[Verb stem] + ます'],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Multiple lines',
  type: PatternBlock,
  path: 'Grammar/Blocks',
)
Widget buildPatternBlockMulti(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: PatternBlock(
      color: levelColor('N5'),
      lines: const [
        '[Verb stem] + ます       (affirmative)',
        '[Verb stem] + ません     (negative)',
        '[Verb stem] + ました     (past)',
        '[Verb stem] + ませんでした (past negative)',
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'N4 accent colour',
  type: PatternBlock,
  path: 'Grammar/Blocks',
)
Widget buildPatternBlockN4(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: PatternBlock(
      color: levelColor('N4'),
      lines: const [
        '[い-adj stem] + くて + [adjective / verb]',
        '[な-adj] + で + [adjective / verb]',
      ],
    ),
  );
}
