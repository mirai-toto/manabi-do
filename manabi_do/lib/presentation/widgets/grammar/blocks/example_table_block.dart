import 'package:flutter/material.dart';

import 'grammar_table.dart';

/// Block for example sentence tables with `japanese`, `romaji`, `english`
/// columns (any subset, in any order).
class ExampleTableBlock extends StatelessWidget {
  final List<String> columns;
  final List<Map<String, String>> rows;

  const ExampleTableBlock({
    super.key,
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return GrammarTable(columns: columns, rows: rows);
  }
}
