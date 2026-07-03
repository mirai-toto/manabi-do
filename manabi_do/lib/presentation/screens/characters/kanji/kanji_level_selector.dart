import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/jlpt_level.dart';
import '../../../../data/database/app_database.dart';
import '../../../../l10n/l10n.dart';
import '../../../providers/kanji_provider.dart';
import '../../../widgets/widgets.dart';
import 'kanji_detail_screen.dart';

const _kanjiLevels = ['N5', 'N4', 'N3', 'N2', 'N1'];

class KanjiLevelSelector extends ConsumerStatefulWidget {
  final void Function(String) onSelect;
  const KanjiLevelSelector({super.key, required this.onSelect});

  @override
  ConsumerState<KanjiLevelSelector> createState() => _KanjiLevelSelectorState();
}

class _KanjiLevelSelectorState extends ConsumerState<KanjiLevelSelector> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search(String query) => setState(() => _query = query.trim());

  void _clear() {
    _controller.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.tokens;
    return ListView(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      children: [
        AppTextField(
          label: l.searchKanji,
          hint: l.searchKanjiHint,
          controller: _controller,
          onChanged: _search,
          prefixIcon: Icon(Icons.search_rounded, color: t.onSurfaceVariant),
          suffixIcon: _query.isNotEmpty
              ? IconButton(icon: const Icon(Icons.clear), onPressed: _clear)
              : null,
        ),
        const SizedBox(height: AppDimens.spaceMd),
        if (_query.isEmpty) ...[
          SectionLabel(l.selectLevel),
          const SizedBox(height: AppDimens.spaceSm),
          for (final code in _kanjiLevels)
            JlptLevelCard(
              code: code,
              subtitle: _subtitle(context, code),
              onTap: () => widget.onSelect(code),
            ),
        ] else
          ref
              .watch(kanjiSearchProvider(_query))
              .when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => const SizedBox.shrink(),
                data: (results) => results.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppDimens.spaceLg),
                          child: Text(
                            l.noResults,
                            style: AppTextStyles.body.copyWith(
                              color: t.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: results
                            .map((k) => _KanjiResultTile(kanji: k))
                            .toList(),
                      ),
              ),
      ],
    );
  }

  String? _subtitle(BuildContext context, String code) {
    final data = ref.watch(kanjiListProvider(code)).asData?.value;
    return data != null ? context.l10n.nKanji(data.total) : '—';
  }
}

class _KanjiResultTile extends StatelessWidget {
  final Kanji kanji;
  const _KanjiResultTile({required this.kanji});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final color = levelColor(kanji.jlptLevel);
    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => KanjiDetailScreen(kanjiId: kanji.id),
            ),
          ),
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
                      const SizedBox(height: 2),
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
