import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../providers/kanji_provider.dart';
import '../../screens/characters/kanji/kanji_detail_screen.dart';
import '../widgets.dart';

/// `SectionLabel` + the kanji a word is written with, each opening its own
/// detail screen.
///
/// The mirror of [KanjiExampleWords], which lists words for a kanji. The join
/// table it reads has existed since the single `kanji_id` column was replaced,
/// but nothing showed it: a learner could get from 食 to 食事 and not back.
///
/// Absent entirely when the word has no kanji the app teaches, which is the
/// common case for a kana word — a heading over nothing reads as a bug.
class VocabularyKanjiList extends ConsumerWidget {
  final int vocabularyId;
  const VocabularyKanjiList({super.key, required this.vocabularyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanji = ref.watch(kanjiForVocabularyProvider(vocabularyId));
    final rows = kanji.asData?.value ?? const <Kanji>[];
    if (rows.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(context.l10n.writtenWith),
        const SizedBox(height: AppDimens.spaceSm),
        CardContainer(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMd,
            vertical: AppDimens.spaceXs,
          ),
          child: Column(
            children: [
              for (final (index, entry) in rows.indexed) ...[
                if (index > 0)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: context.tokens.outlineVariant,
                  ),
                _KanjiRow(kanji: entry),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _KanjiRow extends StatelessWidget {
  final Kanji kanji;
  const _KanjiRow({required this.kanji});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final color = levelColor(kanji.jlptLevel);
    final readings = [
      kanji.onReading,
      kanji.kunReading,
    ].where((r) => r.isNotEmpty).join(' / ');

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => KanjiDetailScreen(kanjiId: kanji.id),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
        child: Row(
          children: [
            CharacterCell(
              character: kanji.character,
              accentColor: color,
              width: 48,
              height: 48,
              characterSize: 28,
            ),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kanji.meaning,
                    style: AppTextStyles.body.copyWith(
                      color: t.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (readings.isNotEmpty)
                    Text(
                      readings,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: t.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppDimens.spaceSm),
            PillBadge(
              label: kanji.jlptLevel,
              color: color,
              background: color.withValues(alpha: 0.12),
              textStyle: AppTextStyles.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
