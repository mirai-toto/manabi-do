import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/database/app_database.dart';
import '../../../core/theme/vocabulary_level.dart';
import '../../../l10n/vocabulary_level_label.dart';
import '../../../l10n/l10n.dart';
import '../../services/search_service.dart';
import '../../providers/vocabulary_list_provider.dart';
import '../../screens/vocabulary/vocabulary_detail_screen.dart';
import '../widgets.dart';

/// Pinned `SearchField` over a full-screen-width list of coverage levels.
/// Tapping a level calls `onSelect`. Typing replaces the tiles with matching
/// words from `vocabularySearchProvider` (word, reading or meaning; ranked by
/// `searchRank`, capped at 50), built lazily as they scroll into view.
class VocabularyLevelSelector extends ConsumerStatefulWidget {
  final void Function(int) onSelect;
  const VocabularyLevelSelector({super.key, required this.onSelect});

  @override
  ConsumerState<VocabularyLevelSelector> createState() =>
      _VocabularyLevelSelectorState();
}

class _VocabularyLevelSelectorState
    extends ConsumerState<VocabularyLevelSelector> {
  String _query = '';
  final Set<int> _filter = <int>{};

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Sits outside the scrollables below, so switching between the level
        // list and results never rebuilds the field or drops the keyboard.
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.spaceMd,
            AppDimens.spaceMd,
            AppDimens.spaceMd,
            AppDimens.spaceSm,
          ),
          child: SearchField(
            label: l.searchVocabulary,
            hint: l.searchVocabularyHint,
            onChanged: (query) => setState(() => _query = query),
          ),
        ),
        // Only while searching: without a query the level list below already
        // is the level picker, and two ways to do one thing reads as a bug.
        if (isSearchableQuery(_query))
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.spaceMd,
              0,
              AppDimens.spaceMd,
              AppDimens.spaceSm,
            ),
            child: FilterChipBar<int>(
              options: kAllVocabularyLevels,
              selected: _filter,
              labelOf: (level) => vocabularyLevelLabel(level, context),
              onToggle: (level) => setState(
                () => _filter.contains(level)
                    ? _filter.remove(level)
                    : _filter.add(level),
              ),
            ),
          ),
        Expanded(
          child: isSearchableQuery(_query) ? _results() : _levelList(context),
        ),
      ],
    );
  }

  Widget _levelList(BuildContext context) {
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
              wordCount: _wordCount(level),
              onTap: () => widget.onSelect(level),
            ),
          const SizedBox(height: AppDimens.spaceLg),
        ],
      ),
    );
  }

  Widget _results() => ref
      .watch(vocabularySearchProvider(SearchQuery(_query, _filter)))
      .when(
        loading: () => const Center(child: AppSpinner.page()),
        error: (e, s) => const SizedBox.shrink(),
        data: (results) =>
            results.isEmpty ? const _NoResults() : _ResultList(results),
      );

  String? _wordCount(int level) {
    final count = ref
        .watch(vocabularyByLevelProvider(level))
        .asData
        ?.value
        .length;
    return count != null ? NumberFormat.decimalPattern().format(count) : null;
  }
}

/// Result rows, built as they scroll into view.
///
/// Laying out fifty at once — each measuring its meaning to decide whether it
/// needs an expand arrow — is more than a frame's worth of work.
class _ResultList extends StatelessWidget {
  final List<VocabularyEntry> results;
  const _ResultList(this.results);

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return ScrollFade(
      builder: (controller) => ListView.builder(
        controller: controller,
        padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
        itemCount: results.length,
        itemBuilder: (context, index) => Column(
          children: [
            if (index > 0)
              Divider(
                height: 1,
                thickness: 1,
                color: t.outlineVariant,
                indent: AppDimens.spaceMd,
                endIndent: AppDimens.spaceMd,
              ),
            VocabularyWordTile(
              entry: results[index],
              showLevel: true,
              onOpen: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => VocabularyDetailScreen(entry: results[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      child: Text(
        context.l10n.noResults,
        textAlign: TextAlign.center,
        style: AppTextStyles.body.copyWith(color: t.onSurfaceVariant),
      ),
    );
  }
}
