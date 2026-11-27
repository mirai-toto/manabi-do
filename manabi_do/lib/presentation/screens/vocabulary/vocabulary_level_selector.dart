import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../data/database/app_database.dart';
import '../../../core/theme/vocabulary_level.dart';
import '../../../l10n/vocabulary_level_label.dart';
import '../../../l10n/l10n.dart';
import '../../services/search_service.dart';
import '../../providers/vocabulary_list_provider.dart';
import '../../providers/vocabulary_provider.dart';
import '../../widgets/widgets.dart';
import '../detail_navigation.dart';

/// Pinned `SearchField` over a full-screen-width list of coverage levels.
/// Tapping a level calls `onSelect`. Typing replaces the tiles with matching
/// words from `vocabularySearchProvider` (word, reading or meaning; ranked by
/// `searchRank`, capped at 50), built lazily as they scroll into view.
class VocabularyLevelSelector extends ConsumerWidget {
  final void Function(int) onSelect;
  const VocabularyLevelSelector({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return LevelSearchShell<int>(
      searchLabel: l.searchVocabulary,
      searchHint: l.searchVocabularyHint,
      filterOptions: kAllVocabularyLevels,
      filterLabelOf: (level) => vocabularyLevelLabel(level, context),
      levels: _levelList(context, ref),
      results: (query, filter) => Consumer(
        builder: (context, ref, _) => ref
            .watch(vocabularySearchProvider(SearchQuery(query, filter)))
            .when(
              loading: () => const Center(child: AppSpinner.page()),
              error: (e, s) => const SizedBox.shrink(),
              data: (results) => results.isEmpty
                  ? SearchNoResults(message: l.noResults)
                  : _ResultList(results),
            ),
      ),
    );
  }

  Widget _levelList(BuildContext context, WidgetRef ref) {
    final mine = ref.watch(coverageReachedProvider);
    final total = ref.watch(vocabularyTotalCountProvider);
    final l = context.l10n;
    return ScrollFade(
      builder: (controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
        children: [
          // "At least", because 3,448 of the 12,000 words carry no measurable
          // share: UniDic counts お願いします in pieces, so the corpus has
          // nothing to attribute to it. The figure is a floor, not an estimate.
          if (mine != null)
            CoverageMeterCard(
              label: l.youCanRead,
              share: mine,
              caption: l.ofWrittenJapanese,
              progressLabel: l.coverageAtLeast((mine * 100).round()),
              // How much there is to read against how far through it you are.
              // The percentage alone says nothing about the size of the job.
              nextLabel: total != null ? l.nWords(total) : null,
            ),
          const SizedBox(height: AppDimens.spaceMd),
          SectionLabel(l.vocabularyLevels),
          const SizedBox(height: AppDimens.spaceSm),
          for (final level in kAllVocabularyLevels)
            VocabularyLevelCard(
              level: level,
              wordCount: _wordCount(context, ref, level),
              onTap: () => onSelect(level),
            ),
          const SizedBox(height: AppDimens.spaceLg),
        ],
      ),
    );
  }

  String? _wordCount(BuildContext context, WidgetRef ref, int level) {
    final count = ref
        .watch(vocabularyByLevelProvider(level))
        .asData
        ?.value
        .length;
    return count != null ? context.l10n.nWords(count) : null;
  }
}

/// Result cards, built as they scroll into view: fifty at once, each resolving
/// its meaning, is more than a frame's worth of work.
class _ResultList extends StatelessWidget {
  final List<VocabularyEntry> results;
  const _ResultList(this.results);

  @override
  Widget build(BuildContext context) {
    return ScrollFade(
      builder: (controller) => ListView.separated(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(
          AppDimens.spaceMd,
          0,
          AppDimens.spaceMd,
          AppDimens.spaceLg,
        ),
        itemCount: results.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppDimens.spaceSm),
        itemBuilder: (context, index) => Consumer(
          builder: (context, ref, _) {
            final shown = ref.watch(vocabularyMeaningProvider(results[index]));
            return VocabularyWordTile(
              entry: results[index],
              meaning: shown.meaning,
              missingLanguage: shown.missingLanguage,
              showLevel: true,
              onOpen: () => openWordDetail(context, results[index]),
            );
          },
        ),
      ),
    );
  }
}
