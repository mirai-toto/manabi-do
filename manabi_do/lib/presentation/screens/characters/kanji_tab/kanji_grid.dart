import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../providers/kanji_provider.dart';
import '../../../widgets/widgets.dart';
import '../kanji_detail_screen.dart';

class KanjiGrid extends StatelessWidget {
  final List<KanjiListEntry> kanjis;
  final Set<int> knownIds;
  const KanjiGrid({super.key, required this.kanjis, required this.knownIds});

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
              return CharacterCell(
                character: entry.character,
                isKnown: knownIds.contains(entry.id),
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
