import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/locale_provider.dart';
import '../../../../core/text/sentence_language.dart';
import '../../../providers/vocabulary_provider.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/jlpt_level.dart';
import '../../../../data/database/app_database.dart';
import '../../../../l10n/l10n.dart';
import '../../../services/search_service.dart';
import '../../../providers/kanji_provider.dart';
import '../../../widgets/widgets.dart';

const _kanjiLevels = ['N5', 'N4', 'N3', 'N2', 'N1'];

/// Pinned `SearchField` over a full-screen list of JLPT level tiles for the
/// kanji section. Tapping a level calls `onSelect`. Typing replaces the tiles
/// with ranked matches from `kanjiSearchProvider`; tapping a result calls
/// `onOpenKanji`.
class KanjiLevelSelector extends ConsumerWidget {
  final void Function(String) onSelect;
  final void Function(int kanjiId) onOpenKanji;
  const KanjiLevelSelector({
    super.key,
    required this.onSelect,
    required this.onOpenKanji,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return LevelSearchShell<String>(
      searchLabel: l.searchKanji,
      searchHint: l.searchKanjiHint,
      filterOptions: _kanjiLevels,
      filterLabelOf: (level) => level,
      levels: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
        children: [
          SectionLabel(l.selectLevel),
          const SizedBox(height: AppDimens.spaceSm),
          for (final code in _kanjiLevels)
            JlptLevelCard(
              code: code,
              subtitle: _subtitle(context, ref, code),
              onTap: () => onSelect(code),
            ),
        ],
      ),
      results: (query, filter) => Consumer(
        builder: (context, ref, _) => ref
            .watch(kanjiSearchProvider(SearchQuery(query, filter)))
            .when(
              loading: () => const Center(child: AppSpinner.page()),
              error: (e, s) => const SizedBox.shrink(),
              data: (results) => results.isEmpty
                  ? SearchNoResults(message: l.noResults)
                  : _ResultList(results: results, onOpenKanji: onOpenKanji),
            ),
      ),
    );
  }

  String? _subtitle(BuildContext context, WidgetRef ref, String code) {
    final data = ref.watch(kanjiListProvider(code)).asData?.value;
    return data != null ? context.l10n.nKanji(data.total) : null;
  }
}

/// Result rows, built as they scroll into view rather than all at once.
class _ResultList extends StatelessWidget {
  final List<Kanji> results;
  final void Function(int kanjiId) onOpenKanji;
  const _ResultList({required this.results, required this.onOpenKanji});

  @override
  Widget build(BuildContext context) => ListView.builder(
    padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
    itemCount: results.length,
    itemBuilder: (context, index) => _KanjiResultTile(
      kanji: results[index],
      onTap: () => onOpenKanji(results[index].id),
    ),
  );
}

class _KanjiResultTile extends ConsumerWidget {
  final Kanji kanji;
  final VoidCallback onTap;
  const _KanjiResultTile({required this.kanji, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final color = levelColor(kanji.jlptLevel);
    // The detail screen has shown the reader's own meaning for a while; the
    // row that leads to it still showed English. KANJIDIC2 has no German at
    // all, so the mark explains the rows that stay English.
    final localized = ref.watch(localizedKanjiMeaningProvider(kanji.id));
    final String meaning = localized.asData?.value.isNotEmpty == true
        ? localized.asData!.value
        : kanji.meaning;
    final String? missingLanguage = missingMeaningLanguage(
      localized,
      readerLocale: ref.watch(localeProvider).languageCode,
    );
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceSm,
              vertical: AppDimens.spaceSm,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 48,
                  child: Text(
                    kanji.character,
                    style: AppTextStyles.jpMedium.copyWith(color: t.onSurface),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TranslatedText(
                        meaning,
                        missingLanguage: missingLanguage,
                        style: AppTextStyles.body.copyWith(color: t.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppDimens.spaceXxs),
                      Text(
                        [
                          kanji.onReading,
                          kanji.kunReading,
                        ].where((r) => r.isNotEmpty).join('  ·  '),
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
                ),
              ],
            ),
          ),
        ),
        Divider(height: 1, color: t.outlineVariant),
      ],
    );
  }
}
