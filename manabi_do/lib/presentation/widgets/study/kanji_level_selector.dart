import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../providers/kanji_provider.dart';
import '../widgets.dart';

const _kanjiLevels = ['N5', 'N4', 'N3', 'N2', 'N1'];

class KanjiLevelSelector extends ConsumerStatefulWidget {
  final void Function(String) onSelect;
  final void Function(int kanjiId) onOpenKanji;
  const KanjiLevelSelector({
    super.key,
    required this.onSelect,
    required this.onOpenKanji,
  });

  @override
  ConsumerState<KanjiLevelSelector> createState() => _KanjiLevelSelectorState();
}

class _KanjiLevelSelectorState extends ConsumerState<KanjiLevelSelector> {
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
            label: l.searchKanji,
            hint: l.searchKanjiHint,
            onChanged: (query) => setState(() => _query = query),
          ),
        ),
        Expanded(
          child: isSearchableQuery(_query) ? _results() : _levelList(context),
        ),
      ],
    );
  }

  Widget _levelList(BuildContext context) => ListView(
    padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
    children: [
      SectionLabel(context.l10n.selectLevel),
      const SizedBox(height: AppDimens.spaceSm),
      for (final code in _kanjiLevels)
        JlptLevelCard(
          code: code,
          subtitle: _subtitle(context, code),
          onTap: () => widget.onSelect(code),
        ),
    ],
  );

  Widget _results() => ref
      .watch(kanjiSearchProvider(_query))
      .when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => const SizedBox.shrink(),
        data: (results) => results.isEmpty
            ? const _NoResults()
            : _ResultList(results: results, onOpenKanji: widget.onOpenKanji),
      );

  String? _subtitle(BuildContext context, String code) {
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

class _KanjiResultTile extends StatelessWidget {
  final Kanji kanji;
  final VoidCallback onTap;
  const _KanjiResultTile({required this.kanji, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final color = levelColor(kanji.jlptLevel);
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
                      Text(
                        kanji.meaning,
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
