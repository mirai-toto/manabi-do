import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../data/grammar/grammar_models.dart';
import 'blocks/comparison_block.dart';
import 'blocks/conjugation_table_block.dart';
import 'blocks/example_table_block.dart';
import 'blocks/list_block.dart';
import 'blocks/note_block.dart';
import 'blocks/pattern_block.dart';
import 'blocks/section_title_block.dart';
import 'blocks/text_block.dart';
import 'blocks/transform_cards_block.dart';
import 'blocks/vocabulary_table_block.dart';

/// Dispatches a `GrammarBlock` to the correct block widget by `type`.
class GrammarBlockRenderer extends StatelessWidget {
  final List<GrammarBlock> blocks;
  final Color levelColor;
  final ScrollController? controller;
  final Widget? trailing;

  const GrammarBlockRenderer({
    super.key,
    required this.blocks,
    required this.levelColor,
    this.controller,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final hasTrailing = trailing != null;
    final itemCount = blocks.length + (hasTrailing ? 1 : 0);
    return ListView.separated(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceMd,
        AppDimens.spaceMd,
        AppDimens.spaceMd,
        AppDimens.spaceLg,
      ),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: AppDimens.spaceLg),
      itemBuilder: (context, i) {
        if (i < blocks.length) return _buildBlock(blocks[i]);
        return trailing!;
      },
    );
  }

  Widget _buildBlock(GrammarBlock block) => switch (block) {
    TextGrammarBlock(:final content) => TextBlock(
      content: content,
      accentColor: levelColor,
    ),
    SectionTitleGrammarBlock(:final content) => SectionTitleBlock(
      content: content,
      color: levelColor,
    ),
    PatternGrammarBlock(:final lines) => PatternBlock(
      lines: lines,
      color: levelColor,
    ),
    NoteGrammarBlock(:final content) => NoteBlock(content: content),
    ExampleTableGrammarBlock(:final columns, :final rows) => ExampleTableBlock(
      columns: columns,
      rows: rows,
      accentColor: levelColor,
    ),
    VocabularyTableGrammarBlock(:final columns, :final rows) =>
      VocabularyTableBlock(
        columns: columns,
        rows: rows,
        accentColor: levelColor,
      ),
    ConjugationTableGrammarBlock(:final label, :final rows) =>
      ConjugationTableBlock(label: label, rows: rows),
    ComparisonGrammarBlock(:final left, :final right) => ComparisonBlock(
      left: left,
      right: right,
      accentColor: levelColor,
    ),
    ListGrammarBlock(:final bullet, :final items) => ListBlock(
      style: bullet ? ListStyle.bullet : ListStyle.numbered,
      items: items,
      accentColor: levelColor,
    ),
    TransformCardsGrammarBlock(:final groups) => TransformCardsBlock(
      groups: groups,
      accentColor: levelColor,
    ),
    DividerGrammarBlock() => const Divider(),
    UnknownGrammarBlock() => const SizedBox.shrink(),
  };
}
