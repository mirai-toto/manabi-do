import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/text/sentence_language.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../providers/kanji_provider.dart';
import '../../providers/vocabulary_provider.dart';
import '../../widgets/widgets.dart';
import '../detail_navigation.dart';
import 'vocabulary_kanji_list.dart';

/// One example sentence, on a screen of its own: read aloud, copied without a
/// dialog, and with every taught word and kanji in it reachable.
///
/// A word's sentence list only links the word's own kanji, so a learner could
/// spot an unknown kanji elsewhere in the sentence and have no way to look it
/// up.
class SentenceDetailScreen extends ConsumerWidget {
  final Sentence sentence;
  final String? translation;

  /// The reader's language, named, when [translation] fell back to English.
  final String? translationMissingLanguage;

  /// The word the sentence was opened from, highlighted in it.
  final String highlight;
  final Color highlightColor;

  const SentenceDetailScreen({
    super.key,
    required this.sentence,
    required this.translation,
    required this.translationMissingLanguage,
    required this.highlight,
    required this.highlightColor,
  });

  Future<void> _copy(BuildContext context, String text) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final String copied = context.l10n.copiedToClipboard;
    await Clipboard.setData(ClipboardData(text: text));
    messenger.showSnackBar(SnackBar(content: Text(copied)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l = context.l10n;
    final List<Kanji> kanji =
        ref.watch(kanjiInTextProvider(sentence.japanese)).asData?.value ??
        const <Kanji>[];
    final String? translation = this.translation;
    final int? tatoebaId = sentence.tatoebaId;
    final List<SentenceWordItem> words = tatoebaId == null
        ? const <SentenceWordItem>[]
        : ref.watch(localizedSentenceWordsProvider(tatoebaId)).asData?.value ??
              const <SentenceWordItem>[];

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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    // The annotated form, for its furigana; copying below uses
                    // the plain one.
                    child: JapaneseSentence(
                      sentence: sentence.furigana ?? sentence.japanese,
                      highlight: highlight,
                      highlightColor: highlightColor,
                      translation: translation,
                      missingLanguage: translationMissingLanguage,
                      style: AppTextStyles.jpSentence,
                    ),
                  ),
                  const SizedBox(width: AppDimens.spaceSm),
                  SpeakButton(
                    text: sentence.japanese,
                    color: t.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.spaceMd),
              Wrap(
                spacing: AppDimens.spaceSm,
                runSpacing: AppDimens.spaceSm,
                children: [
                  AppButton(
                    label: l.copyJapanese,
                    variant: AppButtonVariant.outlined,
                    size: AppButtonSize.small,
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    onPressed: () => _copy(context, sentence.japanese),
                  ),
                  if (translation != null)
                    AppButton(
                      label: l.copyTranslation,
                      variant: AppButtonVariant.outlined,
                      size: AppButtonSize.small,
                      icon: const Icon(Icons.copy_rounded, size: 16),
                      onPressed: () => _copy(context, translation),
                    ),
                ],
              ),
              const SizedBox(height: AppDimens.spaceLg),
              // Absent when nothing was found, like the kanji below: a heading
              // over nothing reads as a bug.
              if (words.isNotEmpty) ...[
                SectionLabel(l.wordsInSentence),
                const SizedBox(height: AppDimens.spaceSm),
                WordListCard(
                  words: [
                    for (final w in words)
                      (
                        entry: w.word.entry,
                        meaning: w.word.meaning,
                        translated: w.word.translated,
                        surface: w.surface,
                      ),
                  ],
                  missingLanguage: readerLanguageName(
                    ref.watch(localeProvider).languageCode,
                  ),
                  onOpen: (entry) => openWordDetail(context, entry),
                ),
                const SizedBox(height: AppDimens.spaceLg),
              ],
              KanjiListSection(title: l.kanjiInSentence, kanji: kanji),
            ],
          ),
        ),
      ),
    );
  }
}
