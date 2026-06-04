import 'package:flutter/material.dart' hide Card;
import 'package:fsrs/fsrs.dart';
import '../../../../core/srs/srs_level.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../data/database/app_database.dart';
import '../../../widgets/widgets.dart';
import '../kanji_detail_screen.dart';

class KanjiGrid extends StatelessWidget {
  final List<Kanji> kanjis;
  final Set<int> skippedIds;
  final Map<int, Card> srsCards;

  const KanjiGrid({
    super.key,
    required this.kanjis,
    required this.skippedIds,
    required this.srsCards,
  });

  @override
  Widget build(BuildContext context) {
    const gap = AppDimens.spaceSm;
    const cols = 4;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellSize = (constraints.maxWidth - gap * (cols - 1)) / cols;
          final kanjiSize = (cellSize * 0.30).clamp(18.0, 48.0);
          final meaningSize = (cellSize * 0.10).clamp(9.0, 13.0);

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              crossAxisSpacing: gap,
              mainAxisSpacing: gap,
            ),
            itemCount: kanjis.length,
            itemBuilder: (context, i) {
              final entry = kanjis[i];
              final card = srsCards[entry.id];
              final level = srsLevel(card);
              final Color? accent;
              if (skippedIds.contains(entry.id)) {
                accent = Colors.grey.shade400;
              } else if (level == SrsLevel.newCard) {
                accent = null;
              } else {
                accent = level.accent(context.tokens);
              }
              return CharacterCell(
                character: entry.character,
                accentColor: accent,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => KanjiDetailScreen(kanjiId: entry.id),
                  ),
                ),
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
