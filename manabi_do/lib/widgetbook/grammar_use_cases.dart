import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/theme/app_text_styles.dart';
import '../core/theme/app_tokens.dart';
import '../core/theme/jlpt_level.dart';
import '../presentation/widgets/grammar/blocks/comparison_block.dart';
import '../presentation/widgets/grammar/blocks/conjugation_table_block.dart';
import '../presentation/widgets/grammar/blocks/example_table_block.dart';
import '../presentation/widgets/grammar/blocks/list_block.dart';
import '../presentation/widgets/grammar/blocks/note_block.dart';
import '../presentation/widgets/grammar/blocks/pattern_block.dart';
import '../presentation/widgets/grammar/blocks/section_title_block.dart';
import '../presentation/widgets/grammar/blocks/text_block.dart';
import '../presentation/widgets/grammar/blocks/vocab_table_block.dart';

// ── TextBlock ─────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: TextBlock, path: 'Grammar/Blocks')
Widget buildTextBlockDefault(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: TextBlock(
      content:
          'Japanese verbs conjugate based on their group. '
          'Identifying a verb\'s group determines how **every other form** is built.',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Custom colour',
  type: TextBlock,
  path: 'Grammar/Blocks',
)
Widget buildTextBlockColor(BuildContext context) {
  final t = context.tokens;
  return Padding(
    padding: const EdgeInsets.all(16),
    child: TextBlock(
      content: 'This text uses *onSurfaceVariant*: useful for secondary prose.',
      color: t.onSurfaceVariant,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Custom style',
  type: TextBlock,
  path: 'Grammar/Blocks',
)
Widget buildTextBlockStyle(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: TextBlock(
      content:
          'Smaller label style with *italic* and **bold** still working correctly.',
      style: AppTextStyles.bodySmall,
    ),
  );
}

// ── SectionTitleBlock ─────────────────────────────────────────────────────────

@widgetbook.UseCase(
  name: 'N5 accent',
  type: SectionTitleBlock,
  path: 'Grammar/Blocks',
)
Widget buildSectionTitleN5(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SectionTitleBlock(content: 'Verb Groups', color: levelColor('N5')),
  );
}

@widgetbook.UseCase(
  name: 'N1 accent',
  type: SectionTitleBlock,
  path: 'Grammar/Blocks',
)
Widget buildSectionTitleN1(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SectionTitleBlock(
      content: 'Advanced Conditional Forms',
      color: levelColor('N1'),
    ),
  );
}

// ── NoteBlock ─────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: NoteBlock, path: 'Grammar/Blocks')
Widget buildNoteBlock(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: NoteBlock(
      content:
          '～ます covers both present habits and future actions: '
          'Japanese does not separate these two meanings.',
    ),
  );
}

// ── ExampleTableBlock ─────────────────────────────────────────────────────────

@widgetbook.UseCase(
  name: '3 columns',
  type: ExampleTableBlock,
  path: 'Grammar/Blocks',
)
Widget buildExampleTable3Col(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ExampleTableBlock(
      columns: const ['japanese', 'romaji', 'english'],
      rows: const [
        {
          'japanese': '毎日勉強します。',
          'romaji': 'Mainichi benkyō shimasu.',
          'english': 'I study every day.',
        },
        {
          'japanese': '肉を食べません。',
          'romaji': 'Niku wo tabemasen.',
          'english': 'I don\'t eat meat.',
        },
        {
          'japanese': '明日学校に行きます。',
          'romaji': 'Ashita gakkō ni ikimasu.',
          'english': 'I will go to school tomorrow.',
        },
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: '2 columns (no romaji)',
  type: ExampleTableBlock,
  path: 'Grammar/Blocks',
)
Widget buildExampleTable2Col(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ExampleTableBlock(
      columns: const ['japanese', 'english'],
      rows: const [
        {'japanese': '水を飲みます。', 'english': 'I drink water.'},
        {'japanese': '本を読みません。', 'english': 'I don\'t read books.'},
      ],
    ),
  );
}

// ── VocabTableBlock ───────────────────────────────────────────────────────────

@widgetbook.UseCase(
  name: 'With verb group',
  type: VocabTableBlock,
  path: 'Grammar/Blocks',
)
Widget buildVocabTableGroup(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: VocabTableBlock(
      columns: const ['japanese', 'romaji', 'english', 'group'],
      rows: const [
        {
          'japanese': '書く',
          'romaji': 'kaku',
          'english': 'to write',
          'group': '1',
        },
        {
          'japanese': '食べる',
          'romaji': 'taberu',
          'english': 'to eat',
          'group': '2',
        },
        {'japanese': 'する', 'romaji': 'suru', 'english': 'to do', 'group': '3'},
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'With counter',
  type: VocabTableBlock,
  path: 'Grammar/Blocks',
)
Widget buildVocabTableCounter(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: VocabTableBlock(
      columns: const ['japanese', 'romaji', 'english', 'counter'],
      rows: const [
        {
          'japanese': '一冊',
          'romaji': 'issatsu',
          'english': 'one (book)',
          'counter': '冊',
        },
        {
          'japanese': '二枚',
          'romaji': 'nimai',
          'english': 'two (flat things)',
          'counter': '枚',
        },
        {
          'japanese': '三本',
          'romaji': 'sanbon',
          'english': 'three (long things)',
          'counter': '本',
        },
      ],
    ),
  );
}

// ── ConjugationTableBlock ─────────────────────────────────────────────────────

@widgetbook.UseCase(
  name: 'い-adjective',
  type: ConjugationTableBlock,
  path: 'Grammar/Blocks',
)
Widget buildConjugationTableAdj(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ConjugationTableBlock(
      label: 'い-Adjectives · 高い',
      rows: const [
        {
          'form': 'Present',
          'japanese': '高い',
          'romaji': 'takai',
          'english': 'is expensive / tall',
        },
        {
          'form': 'Negative',
          'japanese': '高くない',
          'romaji': 'takakunai',
          'english': 'is not expensive',
        },
        {
          'form': 'Past',
          'japanese': '高かった',
          'romaji': 'takakatta',
          'english': 'was expensive',
        },
        {
          'form': 'Past negative',
          'japanese': '高くなかった',
          'romaji': 'takakunakatta',
          'english': 'was not expensive',
        },
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Verb (ます-form)',
  type: ConjugationTableBlock,
  path: 'Grammar/Blocks',
)
Widget buildConjugationTableVerb(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ConjugationTableBlock(
      label: 'Group 1 Verb · 書く',
      rows: const [
        {
          'form': 'Present',
          'japanese': '書きます',
          'romaji': 'kakimasu',
          'english': 'write / will write',
        },
        {
          'form': 'Negative',
          'japanese': '書きません',
          'romaji': 'kakimasen',
          'english': 'don\'t write',
        },
        {
          'form': 'Past',
          'japanese': '書きました',
          'romaji': 'kakimashita',
          'english': 'wrote',
        },
        {
          'form': 'Past negative',
          'japanese': '書きませんでした',
          'romaji': 'kakimasen deshita',
          'english': 'didn\'t write',
        },
      ],
    ),
  );
}

// ── ComparisonBlock ───────────────────────────────────────────────────────────

@widgetbook.UseCase(
  name: 'から vs ので',
  type: ComparisonBlock,
  path: 'Grammar/Blocks',
)
Widget buildComparisonBlock(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ComparisonBlock(
      left: const ComparisonSide(
        label: 'から',
        description: 'Subjective, direct, casual',
        exampleJp: '疲れたから、休みます。',
        exampleEn: 'I\'m resting because I\'m tired.',
      ),
      right: const ComparisonSide(
        label: 'ので',
        description: 'Objective, softer, more polite',
        exampleJp: '雨が降っているので、家にいます。',
        exampleEn: 'I\'m staying home because it\'s raining.',
      ),
    ),
  );
}

// ── ListBlock ─────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Bullet', type: ListBlock, path: 'Grammar/Blocks')
Widget buildListBlockBullet(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ListBlock(
      style: ListStyle.bullet,
      items: const [
        'Ends in a **u-sound** (く、ぐ、す、つ、ぬ、ぶ、む、る)',
        'The dictionary form ends in *any* hiragana from the う column.',
        'Exception: Group 2 verbs that also end in る must be memorised.',
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Numbered', type: ListBlock, path: 'Grammar/Blocks')
Widget buildListBlockNumbered(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ListBlock(
      style: ListStyle.numbered,
      items: const [
        'Drop the **dictionary form** ending (u-sound).',
        'Add the **い-stem** (e.g. 書く → 書き).',
        'Attach **ます** for the polite present / future.',
      ],
    ),
  );
}

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
