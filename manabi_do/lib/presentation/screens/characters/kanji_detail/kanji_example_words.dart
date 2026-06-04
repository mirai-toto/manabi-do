import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/jlpt_level.dart';
import '../../../../data/database/app_database.dart';
import '../../../../l10n/l10n.dart';
import '../../../../l10n/pos_label.dart';
import '../../../widgets/widgets.dart';
import '../../../providers/vocab_provider.dart';

class KanjiExampleWords extends ConsumerWidget {
  final Kanji kanji;
  const KanjiExampleWords({super.key, required this.kanji});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(localizedKanjiVocabProvider((kanjiId: kanji.id, character: kanji.character)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(context.l10n.exampleWords),
        const SizedBox(height: AppDimens.spaceSm),
        async.when(
          loading: () => const _Loading(),
          error: (_, _) => const SizedBox.shrink(),
          data: (words) => words.isEmpty ? const _EmptyState() : _WordList(words: words),
        ),
      ],
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
      child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
    ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
      child: Text(
        context.l10n.noExampleWordsFound,
        style: AppTextStyles.bodySmall.copyWith(color: context.tokens.onSurfaceVariant),
      ),
    ),
  );
}

class _WordList extends StatelessWidget {
  final List<(VocabularyEntry, String)> words;
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
            _WordRow(entry: words[i].$1, meaning: words[i].$2),
          ],
        ],
      ),
    );
  }
}

class _WordRow extends StatelessWidget {
  final VocabularyEntry entry;
  final String meaning;
  const _WordRow({required this.entry, required this.meaning});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd, vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 2, child: _WordLabel(word: entry.word, reading: entry.reading)),
        const SizedBox(width: AppDimens.spaceSm),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meaning,
                style: AppTextStyles.bodySmall.copyWith(color: context.tokens.onSurfaceVariant),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                posLabel(entry.partOfSpeech, context),
                style: AppTextStyles.labelSmall.copyWith(
                  color: context.tokens.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppDimens.spaceSm),
        _JlptBadge(level: entry.jlptLevel),
      ],
    ),
  );
}

class _WordLabel extends StatelessWidget {
  final String word;
  final String reading;
  const _WordLabel({required this.word, required this.reading});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(word, style: AppTextStyles.jpBody.copyWith(color: t.onSurface, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(reading, style: AppTextStyles.labelSmall.copyWith(color: t.onSurfaceVariant)),
      ],
    );
  }
}

class _JlptBadge extends StatelessWidget {
  final String level;
  const _JlptBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    final color = levelColor(level);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
      ),
      child: Text(
        level,
        style: AppTextStyles.labelSmall.copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}
