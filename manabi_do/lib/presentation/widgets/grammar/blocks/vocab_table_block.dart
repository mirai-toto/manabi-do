import 'package:flutter/material.dart';

import 'grammar_table.dart';

/// Block for vocabulary / kanji tables. Column keys are flexible — any string
/// is valid and the header renders the key capitalised via [SectionLabel].
/// A column named `'japanese'` gets the Japanese font style automatically.
class VocabTableBlock extends StatelessWidget {
  final List<String> columns;
  final List<Map<String, String>> rows;
  final Color? accentColor;

  const VocabTableBlock({
    super.key,
    required this.columns,
    required this.rows,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GrammarTable(columns: columns, rows: rows, accentColor: accentColor);
  }
}
