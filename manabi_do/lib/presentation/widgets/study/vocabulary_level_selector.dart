import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../providers/vocabulary_list_provider.dart';
import '../widgets.dart';

const _levels = ['N5', 'N4', 'N3', 'N2', 'N1'];

class VocabularyLevelSelector extends ConsumerStatefulWidget {
  final void Function(String) onSelect;
  const VocabularyLevelSelector({super.key, required this.onSelect});

  @override
  ConsumerState<VocabularyLevelSelector> createState() =>
      _VocabularyLevelSelectorState();
}

class _VocabularyLevelSelectorState
    extends ConsumerState<VocabularyLevelSelector> {
  String _query = '';

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
        Expanded(
          child: isSearchableQuery(_query) ? _results() : _levelList(context),
        ),
      ],
    );
  }

  Widget _levelList(BuildContext context) => ScrollFade(
    builder: (controller) => ListView(
      controller: controller,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
      children: [
        SectionLabel(context.l10n.selectLevel),
        const SizedBox(height: AppDimens.spaceSm),
        for (final code in _levels)
          JlptLevelCard(
            code: code,
            subtitle: _subtitle(context, code),
            onTap: () => widget.onSelect(code),
          ),
      ],
    ),
  );

  Widget _results() => ref
      .watch(vocabularySearchProvider(_query))
      .when(
        loading: () => const Center(child: AppSpinner.page()),
        error: (e, s) => const SizedBox.shrink(),
        data: (results) =>
            results.isEmpty ? const _NoResults() : _ResultList(results),
      );

  String? _subtitle(BuildContext context, String code) {
    final count = ref
        .watch(vocabularyByLevelProvider(code))
        .asData
        ?.value
        .length;
    return count != null ? context.l10n.nWords(count) : null;
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
            VocabularyWordTile(entry: results[index], showLevel: true),
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
