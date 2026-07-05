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
import 'blocks/vocab_table_block.dart';

class GrammarBlockRenderer extends StatelessWidget {
  final List<GrammarBlock> blocks;
  final Color levelColor;

  const GrammarBlockRenderer({
    super.key,
    required this.blocks,
    required this.levelColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceMd,
      ),
      itemCount: blocks.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppDimens.spaceMd),
      itemBuilder: (context, i) => _buildBlock(blocks[i]),
    );
  }

  Widget _buildBlock(GrammarBlock block) {
    final d = block.data;
    return switch (block.type) {
      'text' => TextBlock(content: d['content'] as String),
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
      ),
      'vocab_table' => VocabTableBlock(
        columns: (d['columns'] as List<dynamic>).cast<String>(),
        rows: _toRows(d['rows']),
      ),
      'conjugation_table' => ConjugationTableBlock(
        label: d['label'] as String,
        rows: _toRows(d['rows']),
      ),
      'comparison' => ComparisonBlock(
        left: _parseSide(d['left'] as Map<String, dynamic>),
        right: _parseSide(d['right'] as Map<String, dynamic>),
      ),
      'list' => ListBlock(
        style: d['style'] == 'bullet' ? ListStyle.bullet : ListStyle.numbered,
        items: (d['items'] as List<dynamic>).cast<String>(),
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
