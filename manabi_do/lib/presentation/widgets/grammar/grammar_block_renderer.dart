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
import 'blocks/vocab_table_block.dart';

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

  Widget _buildBlock(GrammarBlock block) {
    final d = block.data;
    return switch (block.type) {
      'text' => TextBlock(
        content: d['content'] as String,
        accentColor: levelColor,
      ),
      'section_title' => SectionTitleBlock(
        content: d['content'] as String,
        color: levelColor,
      ),
      'pattern' => PatternBlock(
        lines: (d['lines'] as List<dynamic>).cast<String>(),
        color: levelColor,
      ),
      'note' => NoteBlock(content: d['content'] as String),
      'example_table' => ExampleTableBlock(
        columns: (d['columns'] as List<dynamic>).cast<String>(),
        rows: _toRows(d['rows']),
        accentColor: levelColor,
      ),
      'vocab_table' => VocabTableBlock(
        columns: (d['columns'] as List<dynamic>).cast<String>(),
        rows: _toRows(d['rows']),
        accentColor: levelColor,
      ),
      'conjugation_table' => ConjugationTableBlock(
        label: d['label'] as String,
        rows: _toRows(d['rows']),
      ),
      'comparison' => ComparisonBlock(
        left: _parseSide(d['left'] as Map<String, dynamic>),
        right: _parseSide(d['right'] as Map<String, dynamic>),
        accentColor: levelColor,
      ),
      'list' => ListBlock(
        style: d['style'] == 'bullet' ? ListStyle.bullet : ListStyle.numbered,
        items: (d['items'] as List<dynamic>).cast<String>(),
        accentColor: levelColor,
      ),
      'transform_cards' => TransformCardsBlock(
        groups: (d['groups'] as List<dynamic>)
            .map((g) => TransformGroup.fromJson(Map<String, dynamic>.from(g)))
            .toList(),
        accentColor: levelColor,
      ),
      'divider' => const Divider(),
      _ => const SizedBox.shrink(),
    };
  }

  List<Map<String, String>> _toRows(dynamic raw) {
    return (raw as List<dynamic>)
        .map((r) => Map<String, String>.from(r as Map))
        .toList();
  }

  ComparisonSide _parseSide(Map<String, dynamic> d) {
    return ComparisonSide(
      label: d['label'] as String,
      description: d['description'] as String,
      exampleJp: d['example_jp'] as String,
      exampleEn: d['example_en'] as String,
    );
  }
}
