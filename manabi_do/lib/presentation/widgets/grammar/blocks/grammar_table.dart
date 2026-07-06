import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../common/card_container.dart';

/// Shared table renderer used by [ExampleTableBlock], [VocabTableBlock], and
/// [ConjugationTableBlock]. Not a block itself — use the typed wrappers.
///
/// Columns named `'japanese'` are rendered in [AppTextStyles.jpBody].
/// When [boldFirstColumn] is true the first column gets a semi-bold label
/// style — used for the conjugation `form` column.
class GrammarTable extends StatelessWidget {
  final List<String> columns;
  final List<Map<String, String>> rows;
  final bool boldFirstColumn;
  final Color? accentColor;

  const GrammarTable({
    super.key,
    required this.columns,
    required this.rows,
    this.boldFirstColumn = false,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return CardContainer(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HeaderRow(columns: columns, accentColor: accentColor),
            Divider(height: 1, thickness: 1, color: t.outlineVariant),
            ...rows.asMap().entries.map(
              (e) => _DataRow(
                columns: columns,
                row: e.value,
                index: e.key,
                boldFirstColumn: boldFirstColumn,
                tokens: t,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final List<String> columns;
  final Color? accentColor;
  const _HeaderRow({required this.columns, this.accentColor});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final color = accentColor ?? t.onSurfaceVariant;
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusMd),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceSm,
      ),
      child: Row(
        children: columns
            .map(
              (col) => Expanded(
                child: Text(
                  col.toUpperCase(),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final List<String> columns;
  final Map<String, String> row;
  final int index;
  final bool boldFirstColumn;
  final AppTokens tokens;

  const _DataRow({
    required this.columns,
    required this.row,
    required this.index,
    required this.boldFirstColumn,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: index.isOdd ? tokens.surfaceContainer : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMd,
          vertical: AppDimens.spaceMd,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columns.asMap().entries.map((entry) {
            final i = entry.key;
            final col = entry.value;
            final value = row[col] ?? '';

            final TextStyle style;
            if (col == 'japanese') {
              style = AppTextStyles.jpBody.copyWith(color: tokens.onSurface);
            } else if (boldFirstColumn && i == 0) {
              style = AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: tokens.onSurface,
              );
            } else {
              style = AppTextStyles.bodySmall.copyWith(color: tokens.onSurface);
            }

            return Expanded(child: Text(value, style: style));
          }).toList(),
        ),
      ),
    );
  }
}
