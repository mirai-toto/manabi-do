import 'dart:math' as math;

import 'package:flutter/material.dart' hide Card;
import 'package:fsrs/fsrs.dart';
import '../../../core/srs/srs_level.dart';
import '../../../core/theme/srs_level_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../data/database/app_database.dart';
import '../widgets.dart';

/// 4-column grid of `CharacterCell` tiles for a set of kanji. Tapping a cell
/// navigates to `KanjiDetailScreen`.
class KanjiGrid extends StatelessWidget {
  final List<Kanji> kanjis;
  final Map<int, Card> srsCards;
  final void Function(int kanjiId) onKanjiTap;

  const KanjiGrid({
    super.key,
    required this.kanjis,
    required this.srsCards,
    required this.onKanjiTap,
  });

  @override
  Widget build(BuildContext context) {
    const gap = AppDimens.spaceSm;
    // Four across on a phone; a wider screen adds columns rather than
    // blowing each cell up.
    const minCols = 4;
    const targetCellSize = 110.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final int cols = math.max(
            minCols,
            (constraints.maxWidth / targetCellSize).floor(),
          );
          final cellSize = (constraints.maxWidth - gap * (cols - 1)) / cols;
          final kanjiSize = (cellSize * 0.30).clamp(18.0, 48.0);
          final meaningSize = (cellSize * 0.10).clamp(9.0, 13.0);

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              crossAxisSpacing: gap,
              mainAxisSpacing: gap,
            ),
            itemCount: kanjis.length,
            itemBuilder: (context, i) {
              final entry = kanjis[i];
              final card = srsCards[entry.id];
              final level = srsLevel(card);
              final Color? accent = level == SrsLevel.newCard
                  ? null
                  : level.accent;
              return CharacterCell(
                character: entry.character,
                accentColor: accent,
                onTap: () => onKanjiTap(entry.id),
                width: cellSize,
                height: cellSize,
                characterSize: kanjiSize,
                subLabelSize: meaningSize,
              );
            },
          );
        },
      ),
    );
  }
}
