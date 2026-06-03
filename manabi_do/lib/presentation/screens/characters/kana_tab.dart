import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../domain/data/kana_data.dart';
import '../../widgets/widgets.dart';

class KanaTabView extends StatelessWidget {
  final List<KanaRow> rows;
  final Set<String> known;
  final void Function(String) onToggle;

  const KanaTabView({
    super.key,
    required this.rows,
    required this.known,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final allKana = rows.expand((r) => r.kana).toList();
    final knownCount = allKana.where((e) => known.contains(e.kana)).length;

    final color = levelColor('kana');
    return ListView(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
      children: [
        ProgressRow(known: knownCount, total: allKana.length, color: color),
        PracticeButton(color: color),
        for (final row in rows) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
            child: SectionLabel(row.label),
          ),
          const SizedBox(height: AppDimens.spaceXs),
          _KanaGrid(row: row, known: known, onToggle: onToggle),
          const SizedBox(height: AppDimens.spaceSm),
        ],
      ],
    );
  }
}

class _KanaGrid extends StatelessWidget {
  final KanaRow row;
  final Set<String> known;
  final void Function(String) onToggle;

  const _KanaGrid({required this.row, required this.known, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    const gap = AppDimens.spaceSm;
    const cols = 5;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellSize = (constraints.maxWidth - gap * (cols - 1)) / cols;
          final kanaSize = (cellSize * 0.24).clamp(18.0, 48.0);
          final romajiSize = (cellSize * 0.095).clamp(9.0, 18.0);
          return Row(
            children: [
              for (int i = 0; i < row.entries.length; i++) ...[
                if (i > 0) const SizedBox(width: gap),
                if (row.entries[i] == null)
                  SizedBox(width: cellSize, height: cellSize)
                else
                  KanaCell(
                    kana: row.entries[i]!.kana,
                    romaji: row.entries[i]!.romaji,
                    isKnown: known.contains(row.entries[i]!.kana),
                    onTap: () => onToggle(row.entries[i]!.kana),
                    width: cellSize,
                    height: cellSize,
                    kanaSize: kanaSize,
                    romajiSize: romajiSize,
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}
