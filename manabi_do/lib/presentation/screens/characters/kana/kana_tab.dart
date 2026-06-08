import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart';
import '../../../../core/srs/srs_level.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/jlpt_level.dart';
import '../../../../domain/data/kana_data.dart';
import '../../../../l10n/l10n.dart';
import '../../../providers/kana_progress_provider.dart';
import '../../../widgets/widgets.dart';
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
        isSkipped: knownIds.contains(entry.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allKana = rows.expand((r) => r.kana).toList();
    final color = levelColor('kana');
    final srsCards = ref.watch(kanaSrsCardsProvider(type)).asData?.value ?? {};
    final knownCount = allKana.where((e) {
      final level = srsLevel(srsCards[e.id]);
      return level != SrsLevel.newCard && level != SrsLevel.learning;
    }).length;

    return ListView(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
      children: [
        ProgressRow(known: knownCount, total: allKana.length, color: color),
        PracticeButton(color: color, onTap: onPractice),
        for (final row in rows)
          _KanaRowSection(
            row: row,
            label: _localizeRowLabel(context, row.label),
            srsCards: srsCards,
            skippedIds: knownIds,
            onTap: (entry) => _showDetail(context, entry, _localizeRowLabel(context, row.label)),
          ),
      ],
    );
  }

  static String _localizeRowLabel(BuildContext context, String label) => switch (label) {
    'Vowels' => context.l10n.kanaRowVowels,
    _ => label,
  };
}

class _KanaRowSection extends StatelessWidget {
  final KanaRow row;
  final String label;
  final Map<int, Card> srsCards;
  final Set<int> skippedIds;
  final void Function(KanaEntry) onTap;
  const _KanaRowSection({required this.row, required this.label, required this.srsCards, required this.skippedIds, required this.onTap});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
        child: SectionLabel(label),
      ),
      const SizedBox(height: AppDimens.spaceXs),
      _KanaGrid(row: row, srsCards: srsCards, skippedIds: skippedIds, onTap: onTap),
      const SizedBox(height: AppDimens.spaceSm),
    ],
  );
}

class _KanaGrid extends StatelessWidget {
  final KanaRow row;
  final Map<int, Card> srsCards;
  final Set<int> skippedIds;
  final void Function(KanaEntry) onTap;

  const _KanaGrid({required this.row, required this.srsCards, required this.skippedIds, required this.onTap});

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
                  _KanaCell(
                    entry: row.entries[i]!,
                    card: srsCards[row.entries[i]!.id],
                    isSkipped: skippedIds.contains(row.entries[i]!.id),
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

class _KanaCell extends StatelessWidget {
  final KanaEntry entry;
  final Card? card;
  final bool isSkipped;
  final VoidCallback onTap;
  final double width;
  final double height;
  final double? characterSize;
  final double? subLabelSize;

  const _KanaCell({
    required this.entry,
    required this.card,
    required this.isSkipped,
    required this.onTap,
    required this.width,
    required this.height,
    this.characterSize,
    this.subLabelSize,
  });

  @override
  Widget build(BuildContext context) {
    final level = srsLevel(card);
    final Color? accent;
    if (isSkipped) {
      accent = context.tokens.outlineVariant;
    } else if (level == SrsLevel.newCard) {
      accent = null;
    } else {
      accent = level.accent(context.tokens);
    }
    return CharacterCell(
      character: entry.kana,
      subLabel: entry.romaji,
      accentColor: accent,
      onTap: onTap,
      width: width,
      height: height,
      characterSize: characterSize,
      subLabelSize: subLabelSize,
    );
  }
}
