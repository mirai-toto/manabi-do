import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../domain/data/kana_data.dart';
import '../../../l10n/l10n.dart';
import '../../widgets/widgets.dart';
import 'kana_detail_sheet.dart';

class KanaTabView extends ConsumerWidget {
  final List<KanaRow> rows;
  final Set<int> knownIds;
  final String type; // 'hiragana' | 'katakana'
  final VoidCallback onPractice;

  const KanaTabView({
    super.key,
    required this.rows,
    required this.knownIds,
    required this.type,
    required this.onPractice,
  });

  void _showDetail(BuildContext context, KanaEntry entry, String rowLabel) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.tokens.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.radiusLg)),
      ),
      builder: (_) => KanaDetailSheet(
        entry: entry,
        rowLabel: rowLabel,
        type: type,
        isKnown: knownIds.contains(entry.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allKana = rows.expand((r) => r.kana).toList();
    final knownCount = allKana.where((e) => knownIds.contains(e.id)).length;
    final color = levelColor('kana');

    return ListView(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
      children: [
        ProgressRow(known: knownCount, total: allKana.length, color: color),
        PracticeButton(color: color, onTap: onPractice),
        for (final row in rows)
          _KanaRowSection(
            row: row,
            knownIds: knownIds,
            onTap: (entry) => _showDetail(context, entry, _localizedRowLabel(context, row.label)),
          ),
      ],
    );
  }

  String _localizedRowLabel(BuildContext context, String label) {
    return switch (label) {
      'Vowels' => context.l10n.kanaRowVowels,
      _ => label,
    };
  }
}

class _KanaRowSection extends StatelessWidget {
  final KanaRow row;
  final Set<int> knownIds;
  final void Function(KanaEntry) onTap;
  const _KanaRowSection({required this.row, required this.knownIds, required this.onTap});

  String _localizedLabel(BuildContext context) {
    return switch (row.label) {
      'Vowels' => context.l10n.kanaRowVowels,
      _ => row.label,
    };
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
        child: SectionLabel(_localizedLabel(context)),
      ),
      const SizedBox(height: AppDimens.spaceXs),
      _KanaGrid(row: row, knownIds: knownIds, onTap: onTap),
      const SizedBox(height: AppDimens.spaceSm),
    ],
  );
}

class _KanaGrid extends StatelessWidget {
  final KanaRow row;
  final Set<int> knownIds;
  final void Function(KanaEntry) onTap;

  const _KanaGrid({required this.row, required this.knownIds, required this.onTap});

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
                  CharacterCell(
                    character: row.entries[i]!.kana,
                    subLabel: row.entries[i]!.romaji,
                    isKnown: knownIds.contains(row.entries[i]!.id),
                    onTap: () => onTap(row.entries[i]!),
                    width: cellSize,
                    height: cellSize,
                    characterSize: kanaSize,
                    subLabelSize: romajiSize,
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}
