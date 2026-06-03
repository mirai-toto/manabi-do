import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/jlpt_level.dart';
import '../../../../data/database/app_database.dart';
import '../../../../l10n/l10n.dart';
import '../../../widgets/widgets.dart';
import '../../../providers/vocab_provider.dart';

class KanjiExampleWords extends ConsumerWidget {
  final Kanji kanji;
  const KanjiExampleWords({super.key, required this.kanji});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(kanjiVocabProvider((kanjiId: kanji.id, character: kanji.character)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(context.l10n.exampleWords),
        const SizedBox(height: AppDimens.spaceSm),
        async.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
              child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (words) => words.isEmpty
              ? _emptyState(context)
              : _WordList(words: words),
        ),
      ],
    );
  }

  Widget _emptyState(BuildContext context) {
    final t = context.tokens;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
        child: Text(
          context.l10n.noExampleWordsFound,
          style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
        ),
      ),
    );
  }
}

class _WordList extends StatelessWidget {
  final List<VocabularyEntry> words;
  const _WordList({required this.words});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(color: t.outlineVariant),
      ),
      child: Column(
        children: [
          for (int i = 0; i < words.length; i++) ...[
            if (i > 0) Divider(height: 1, thickness: 1, color: t.outlineVariant),
            _WordRow(word: words[i]),
          ],
        ],
      ),
    );
  }
}

class _WordRow extends StatelessWidget {
  final VocabularyEntry word;
  const _WordRow({required this.word});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final color = levelColor(word.jlptLevel);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word.word,
                  style: AppTextStyles.jpBody.copyWith(color: t.onSurface, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  word.reading,
                  style: AppTextStyles.labelSmall.copyWith(color: t.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimens.spaceSm),
          Expanded(
            flex: 3,
            child: Text(
              word.meaning,
              style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppDimens.spaceSm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppDimens.radiusSm),
            ),
            child: Text(
              word.jlptLevel,
              style: AppTextStyles.labelSmall.copyWith(color: color, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
