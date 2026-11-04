import '../../../core/providers/locale_provider.dart';
import '../../../core/text/sentence_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/vocabulary_level.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/vocabulary_level_label.dart';
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
    final color = vocabularyLevelColor(
      entry.vocabularyLevel,
      Theme.of(context).brightness,
    );
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
              _Meanings(entry: entry, fallback: meaning),
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
              label: vocabularyLevelLabel(entry.vocabularyLevel, context),
              color: onVocabularyLevelColor(
                entry.vocabularyLevel,
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
        const <(Sentence, ({String locale, String text})?)>[];
    if (rows.isEmpty) return const SizedBox.shrink();
    final t = context.tokens;
    final l = context.l10n;
    final readerLocale = ref.watch(localeProvider).languageCode;

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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        // The annotated form, not the plain one. Every
                        // sentence in the database carries furigana in
                        // `{漢字|かんじ}` form, and passing `japanese` meant
                        // the readings were there and simply never drawn.
                        child: JapaneseSentence(
                          sentence: row.$1.furigana ?? row.$1.japanese,
                          highlight: entry.word,
                          highlightColor: color,
                          translation: row.$2?.text,
                          missingLanguage: missingLanguageForSentence(
                            row.$2?.locale,
                            readerLocale,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimens.spaceSm),
                      // The plain text, never the annotated form: nobody
                      // wants to paste `{何|なに}するの？` anywhere.
                      CopyButton(
                        choices: [
                          CopyChoice(label: l.japanese, text: row.$1.japanese),
                          if (row.$2 != null)
                            CopyChoice(
                              label: l.translationModeLabel,
                              text: row.$2!.text,
                            ),
                        ],
                      ),
                    ],
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

/// A word's meanings, one numbered row per sense.
///
/// JMdict groups glosses into senses and the pipeline used to join every one of
/// them with "; ": 824 characters for する, 37 glosses from 17 unrelated senses
/// with nothing to mark the seams. These rows are JMdict's own grouping, its
/// own usage notes and its own per-sense transitivity, none of it inferred.
///
/// A word with one sense shows no number — there is nothing to enumerate — and
/// a word whose senses never reached the database falls back to the joined
/// string, so the screen degrades instead of emptying.
class _Meanings extends ConsumerWidget {
  final VocabularyEntry entry;
  final String fallback;

  const _Meanings({required this.entry, required this.fallback});

  /// How many senses to show before the rest go behind a tap. Six covers all
  /// but 1% of words outright; する has seventeen and はい twenty.
  static const int _shown = 6;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l = context.l10n;
    final meanings =
        ref.watch(vocabularySensesProvider(entry.id)).asData?.value ??
        (own: const <VocabularySense>[], english: const <VocabularySense>[]);
    final List<VocabularySense> senses = meanings.own.isEmpty
        ? meanings.english
        : meanings.own;
    // English shown under the reader's own meanings, not instead of them:
    // their language collapsed a sense list into one line.
    final List<VocabularySense> alsoEnglish = meanings.own.isEmpty
        ? const <VocabularySense>[]
        : meanings.english;

    final readerLocale = ref.watch(localeProvider).languageCode;
    final String? language = readerLanguageName(readerLocale);
    // JMdict has French for 72% of these words and German for 95%, so the
    // rest arrive in English. The senses say which language they are in.
    final String? missingLanguage = senses.isEmpty
        ? null
        : senses.first.locale == readerLocale
        ? null
        : language;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SectionLabel(l.meaning),
            if (missingLanguage != null) ...[
              const SizedBox(width: AppDimens.spaceXs),
              TranslationFallbackInfo(language: missingLanguage),
            ],
            const Spacer(),
            if (senses.length > 1)
              Text(
                l.nMeanings(senses.length),
                style: AppTextStyles.labelSmall.copyWith(
                  color: t.onSurfaceVariant,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceSm),
        if (senses.isEmpty)
          CardContainer(
            padding: const EdgeInsets.all(AppDimens.spaceMd),
            child: Text(
              fallback,
              style: AppTextStyles.body.copyWith(color: t.onSurface),
            ),
          )
        else
          _SenseList(senses: senses, limit: _shown),
        if (alsoEnglish.isNotEmpty && language != null) ...[
          const SizedBox(height: AppDimens.spaceMd),
          Row(
            children: [
              SectionLabel(l.meaningsInEnglish),
              const SizedBox(width: AppDimens.spaceXs),
              TranslationFallbackInfo(
                language: language,
                message: l.translationCoarseNotice(language),
              ),
              const Spacer(),
              Text(
                l.nMeanings(alsoEnglish.length),
                style: AppTextStyles.labelSmall.copyWith(
                  color: t.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceSm),
          _SenseList(senses: alsoEnglish, limit: _shown),
        ],
      ],
    );
  }
}

class _SenseList extends StatefulWidget {
  final List<VocabularySense> senses;
  final int limit;

  const _SenseList({required this.senses, required this.limit});

  @override
  State<_SenseList> createState() => _SenseListState();
}

class _SenseListState extends State<_SenseList> {
  bool _all = false;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final senses = widget.senses;
    final hidden = senses.length - widget.limit;
    final visible = _all || hidden <= 0
        ? senses
        : senses.take(widget.limit).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CardContainer(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (int i = 0; i < visible.length; i++) ...[
                if (i > 0)
                  Divider(height: 1, thickness: 1, color: t.outlineVariant),
                _SenseRow(sense: visible[i], numbered: senses.length > 1),
              ],
            ],
          ),
        ),
        if (hidden > 0 && !_all) ...[
          const SizedBox(height: AppDimens.spaceSm),
          AppButton(
            label: l.showNMoreMeanings(hidden),
            onPressed: () => setState(() => _all = true),
            fullWidth: true,
            backgroundColor: t.cardBackground,
            foregroundColor: t.primary,
            side: BorderSide(color: t.outlineVariant),
            radius: AppDimens.radiusMd,
          ),
        ],
      ],
    );
  }
}

class _SenseRow extends StatelessWidget {
  final VocabularySense sense;
  final bool numbered;

  const _SenseRow({required this.sense, required this.numbered});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    // JMdict writes several patterns in one note, comma separated, prefixed
    // "as ". Splitting them is all that happens here; the text is the editors'.
    final patterns = sense.note
        .replaceFirst(RegExp(r'^as '), '')
        .split(',')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceCozy,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (numbered) ...[
            SizedBox(
              width: 18,
              child: Text(
                '${sense.position}',
                textAlign: TextAlign.right,
                style: AppTextStyles.labelSmall.copyWith(
                  color: t.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppDimens.spaceSnug),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sense.glosses,
                  style: AppTextStyles.bodySmall.copyWith(color: t.onSurface),
                ),
                if (patterns.isNotEmpty) ...[
                  const SizedBox(height: AppDimens.spaceTight),
                  Wrap(
                    spacing: AppDimens.spaceXs,
                    runSpacing: AppDimens.spaceXs,
                    children: [
                      for (final pattern in patterns)
                        PillBadge(
                          label: pattern,
                          color: t.onSurfaceVariant,
                          background: t.surfaceVariant,
                          textStyle: AppTextStyles.labelSmall,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (sense.kind.isNotEmpty) ...[
            const SizedBox(width: AppDimens.spaceSm),
            PillBadge(
              label: sense.kind == 'vt' ? l.transitive : l.intransitive,
              color: t.onPrimaryContainer,
              background: t.primaryContainer,
              textStyle: AppTextStyles.labelSmall,
            ),
          ],
        ],
      ),
    );
  }
}
