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

          final rows = <Widget>[];
          for (int i = 0; i < kanjis.length; i += cols) {
            final rowItems = kanjis.sublist(i, (i + cols).clamp(0, kanjis.length));
            rows.add(Row(
              children: [
                for (int j = 0; j < rowItems.length; j++) ...[
                  if (j > 0) const SizedBox(width: gap),
                  KanjiCell(
                    character: rowItems[j].character,
                    isKnown: knownIds.contains(rowItems[j].id),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => KanjiDetailScreen(kanjiId: rowItems[j].id),
                      ),
                    ),
                    size: cellSize,
                    kanjiSize: kanjiSize,
                    meaningSize: meaningSize,
                  ),
                ],
                if (rowItems.length < cols) ...[
                  const SizedBox(width: gap),
                  for (int k = rowItems.length; k < cols - 1; k++) ...[
                    SizedBox(width: cellSize),
                    const SizedBox(width: gap),
                  ],
                  SizedBox(width: cellSize),
                ],
              ],
            ));
            rows.add(const SizedBox(height: gap));
          }
          return Column(children: rows);
        },
      ),
    );
  }
}
