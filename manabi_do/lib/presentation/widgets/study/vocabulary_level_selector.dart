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
    return ScrollFade(
      builder: (controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        children: [
          AppTextField(
            label: l.searchVocabulary,
            hint: l.searchVocabularyHint,
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
            for (final code in _levels)
              JlptLevelCard(
                code: code,
                subtitle: _subtitle(context, code),
                onTap: () => widget.onSelect(code),
              ),
          ] else
            ref
                .watch(vocabularySearchProvider(_query))
                .when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
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
                      : _Results(entries: results),
                ),
        ],
      ),
    );
  }

  String? _subtitle(BuildContext context, String code) {
    final count = ref
        .watch(vocabularyByLevelProvider(code))
        .asData
        ?.value
        .length;
    return count != null ? context.l10n.nWords(count) : null;
  }
}

class _Results extends StatelessWidget {
  final List<VocabularyEntry> entries;
  const _Results({required this.entries});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Column(
      children: [
        for (int i = 0; i < entries.length; i++) ...[
          if (i > 0) Divider(height: 1, thickness: 1, color: t.outlineVariant),
          VocabularyWordTile(entry: entries[i], showLevel: true),
        ],
      ],
    );
  }
}
