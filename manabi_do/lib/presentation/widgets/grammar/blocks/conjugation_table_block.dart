import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../common/section_label.dart';
import 'grammar_table.dart';

/// Block for verb / adjective conjugation paradigms.
///
/// [label] is displayed above the table as a sub-caption.
/// The first column (`form`) is always rendered bold.
/// Remaining columns match the [ExampleTableBlock] style.
class ConjugationTableBlock extends StatelessWidget {
  final String label;
  final List<Map<String, String>> rows;

  static const _columns = ['form', 'japanese', 'romaji', 'english'];

  const ConjugationTableBlock({
    super.key,
    required this.label,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(label),
        const SizedBox(height: AppDimens.spaceXs),
        GrammarTable(columns: _columns, rows: rows, boldFirstColumn: true),
      ],
    );
  }
}
