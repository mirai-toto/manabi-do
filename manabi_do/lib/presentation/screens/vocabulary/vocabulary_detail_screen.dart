import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/coverage_band.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/band_label.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/pos_label.dart';
import '../../providers/vocabulary_provider.dart';
import '../../widgets/widgets.dart';

/// Everything the app knows about one word.
///
/// The counterpart of `KanjiDetailScreen`. Until now a word had no screen of
/// its own: a learner could reach 食事 from 食 and had nowhere to go from 食事.
class VocabularyDetailScreen extends ConsumerWidget {
  final VocabularyEntry entry;
  const VocabularyDetailScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l = context.l10n;
    final color = bandColor(entry.coverageBand, Theme.of(context).brightness);
    final localized = ref
        .watch(localizedVocabularyMeaningProvider(entry.id))
        .asData
        ?.value;
    final meaning = (localized == null || localized.isEmpty)
        ? entry.meaning
        : localized;

    return Scaffold(
      backgroundColor: t.surface,
      appBar: AppBar(
        backgroundColor: t.surface,
        foregroundColor: t.onSurface,
        elevation: 0,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppDimens.screenMaxWidth),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.spaceMd,
              0,
              AppDimens.spaceMd,
              AppDimens.spaceLg,
            ),
            children: [
              _Hero(entry: entry, color: color),
              const SizedBox(height: AppDimens.spaceMd),
              SectionLabel(l.meaning),
              const SizedBox(height: AppDimens.spaceSm),
              CardContainer(
                padding: const EdgeInsets.all(AppDimens.spaceMd),
                child: Text(
                  meaning,
                  style: AppTextStyles.body.copyWith(color: t.onSurface),
                ),
              ),
              const SizedBox(height: AppDimens.spaceMd),
              VocabularyKanjiList(vocabularyId: entry.id),
              const SizedBox(height: AppDimens.spaceMd),
              _Sentences(entry: entry, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

/// The word itself, read aloud, with what it is and how far into Japanese it
/// sits.
class _Hero extends StatelessWidget {
  final VocabularyEntry entry;
  final Color color;
  const _Hero({required this.entry, required this.color});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: JapaneseText(
                word: entry.word,
                reading: entry.reading,
                style: AppTextStyles.jpLarge.copyWith(color: t.onSurface),
                rubyStyle: AppTextStyles.jpFurigana.copyWith(
                  color: t.onSurfaceVariant,
                ),
              ),
            ),
            SpeakButton(text: entry.word, color: t.onSurfaceVariant),
          ],
        ),
        const SizedBox(height: AppDimens.spaceSm),
        Wrap(
          spacing: AppDimens.spaceSm,
          runSpacing: AppDimens.spaceXs,
          children: [
            PillBadge(
              label: posLabel(entry.partOfSpeech, context),
              color: t.onSurfaceVariant,
              background: t.onSurfaceVariant.withValues(alpha: 0.1),
              textStyle: AppTextStyles.labelSmall,
            ),
            PillBadge(
              label: bandLabel(entry.coverageBand, context),
              color: onBandColor(
                entry.coverageBand,
                Theme.of(context).brightness,
              ),
              background: color,
              textStyle: AppTextStyles.labelSmall,
            ),
          ],
        ),
      ],
    );
  }
}

class _Sentences extends ConsumerWidget {
  final VocabularyEntry entry;
  final Color color;
  const _Sentences({required this.entry, required this.color});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rows =
        ref.watch(vocabularySentencesProvider(entry.id)).asData?.value ??
        const <(Sentence, String?)>[];
    if (rows.isEmpty) return const SizedBox.shrink();
    final t = context.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(context.l10n.exampleSentences),
        const SizedBox(height: AppDimens.spaceSm),
        CardContainer(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMd,
            vertical: AppDimens.spaceXs,
          ),
          child: Column(
            children: [
              for (final (index, row) in rows.indexed) ...[
                if (index > 0)
                  Divider(height: 1, thickness: 1, color: t.outlineVariant),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimens.spaceSm,
                  ),
                  child: JapaneseSentence(
                    sentence: row.$1.japanese,
                    highlight: entry.word,
                    highlightColor: color,
                    translation: row.$2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
