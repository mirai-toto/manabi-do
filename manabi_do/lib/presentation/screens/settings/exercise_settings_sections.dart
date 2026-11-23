/// The settings belonging to one kind of exercise, as composable blocks.
///
/// There are four, because there are four stores: flashcards, multiple choice,
/// sentences and writing. Nothing is kept per section — a grammar quiz and a
/// vocabulary drill read the same `mcq` values — so a section never gets a
/// block of its own.
///
/// These lived inside `PracticeSettingsSheet`, in one build method, reachable
/// only from a running session. Pulling them out is what lets the settings
/// screen show all four while the sheet still shows only the ones the session
/// in front of you actually uses. One store, one widget, two places to reach it.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/drawing_settings.dart';
import '../../../core/models/flashcard_settings.dart';
import '../../../core/models/mcq_settings.dart';
import '../../../core/models/sentence_settings.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../l10n/l10n.dart';
import '../../providers/drawing_settings_provider.dart';
import '../../providers/flashcard_settings_provider.dart';
import '../../providers/mcq_settings_provider.dart';
import '../../providers/sentence_settings_provider.dart';
import '../../widgets/widgets.dart';

/// Flashcards have no auto-advance switch of their own: `FlashcardSettings`
/// holds no such field, and a flashcard is graded by the learner, so there is
/// nothing to advance past automatically.
class FlashcardSettingsSection extends ConsumerWidget {
  /// Flashcards only offer an example where the content has one to show.
  final bool hasExamples;

  /// Free practice length. Hidden in a graded session, which takes everything
  /// due plus new items up to the daily limits instead.
  final bool showLength;

  const FlashcardSettingsSection({
    super.key,
    this.hasExamples = false,
    this.showLength = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final flashcard = ref.watch(flashcardSettingsProvider);
    void update(FlashcardSettings next) =>
        ref.read(flashcardSettingsProvider.notifier).update(next);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showLength) ...[
          SessionLengthField(
            value: flashcard.sessionLength,
            onSelect: (v) => update(
              v == null
                  ? flashcard.copyWith(clearSessionLength: true)
                  : flashcard.copyWith(sessionLength: v),
            ),
          ),
        ],
        if (hasExamples) ...[
          const SizedBox(height: AppDimens.spaceMd),
          SettingsSwitchRow(
            label: l.showExampleLabel,
            subtitle: l.showExampleSubtitle,
            value: flashcard.showExample,
            onChanged: (v) => update(flashcard.copyWith(showExample: v)),
          ),
        ],
      ],
    );
  }
}

class McqSettingsSection extends ConsumerWidget {
  /// Free practice length. Hidden in a graded session, which takes everything
  /// due plus new items up to the daily limits instead.
  final bool showLength;

  const McqSettingsSection({super.key, this.showLength = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final mcq = ref.watch(mcqSettingsProvider);
    void update(McqSettings next) =>
        ref.read(mcqSettingsProvider.notifier).update(next);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showLength) ...[
          SessionLengthField(
            value: mcq.sessionLength,
            onSelect: (v) => update(
              v == null
                  ? mcq.copyWith(clearSessionLength: true)
                  : mcq.copyWith(sessionLength: v),
            ),
          ),
          const SizedBox(height: AppDimens.spaceMd),
        ],
        ChoiceCountField(
          value: mcq.mcqChoiceCount,
          onSelect: (v) => update(mcq.copyWith(mcqChoiceCount: v)),
        ),
        const SizedBox(height: AppDimens.spaceMd),
        SettingsSwitchRow(
          label: l.autoAdvanceLabel,
          subtitle: l.autoAdvanceSubtitle,
          value: mcq.autoAdvance,
          onChanged: (v) => update(mcq.copyWith(autoAdvance: v)),
        ),
        SettingsSwitchRow(
          label: l.showMcqFuriganaLabel,
          subtitle: l.showMcqFuriganaSubtitle,
          value: mcq.showPromptFurigana,
          onChanged: (v) => update(mcq.copyWith(showPromptFurigana: v)),
        ),
      ],
    );
  }
}

class SentenceSettingsSection extends ConsumerWidget {
  /// Free practice length. Hidden in a graded session, which takes everything
  /// due plus new items up to the daily limits instead.
  final bool showLength;

  const SentenceSettingsSection({super.key, this.showLength = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final sentence = ref.watch(sentenceSettingsProvider);
    void update(SentenceSettings next) =>
        ref.read(sentenceSettingsProvider.notifier).update(next);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showLength) ...[
          SessionLengthField(
            value: sentence.sessionLength,
            onSelect: (v) => update(
              v == null
                  ? sentence.copyWith(clearSessionLength: true)
                  : sentence.copyWith(sessionLength: v),
            ),
          ),
          const SizedBox(height: AppDimens.spaceMd),
        ],
        ChoiceCountField(
          value: sentence.mcqChoiceCount,
          onSelect: (v) => update(sentence.copyWith(mcqChoiceCount: v)),
        ),
        const SizedBox(height: AppDimens.spaceMd),
        SettingsSwitchRow(
          label: l.autoAdvanceLabel,
          subtitle: l.autoAdvanceSubtitle,
          value: sentence.autoAdvance,
          onChanged: (v) => update(sentence.copyWith(autoAdvance: v)),
        ),
        SettingsSwitchRow(
          label: l.showSentenceFuriganaLabel,
          subtitle: l.showSentenceFuriganaSubtitle,
          value: sentence.showSentenceFurigana,
          onChanged: (v) => update(sentence.copyWith(showSentenceFurigana: v)),
        ),
        SettingsSwitchRow(
          label: l.showChoiceFuriganaLabel,
          subtitle: l.showChoiceFuriganaSubtitle,
          value: sentence.showChoiceFurigana,
          onChanged: (v) => update(sentence.copyWith(showChoiceFurigana: v)),
        ),
        SettingsSwitchRow(
          label: l.nativeTranslationOnlyLabel,
          subtitle: l.nativeTranslationOnlySubtitle,
          value: sentence.nativeTranslationOnly,
          onChanged: (v) => update(sentence.copyWith(nativeTranslationOnly: v)),
        ),
        const SizedBox(height: AppDimens.spaceXs),
        SettingsFieldLabel(l.translationModeLabel),
        const SizedBox(height: AppDimens.spaceXs),
        SegmentedControl(
          options: [
            l.translationModeAlways,
            l.translationModeOnDemand,
            l.translationModeNever,
          ],
          selected: sentence.translationMode.index,
          onSelect: (i) => update(
            sentence.copyWith(translationMode: TranslationMode.values[i]),
          ),
        ),
      ],
    );
  }
}

class WritingSettingsSection extends ConsumerWidget {
  /// Free practice length. Hidden in a graded session, which takes everything
  /// due plus new items up to the daily limits instead.
  final bool showLength;

  const WritingSettingsSection({super.key, this.showLength = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final drawing = ref.watch(drawingSettingsProvider);
    void update(DrawingSettings next) =>
        ref.read(drawingSettingsProvider.notifier).update(next);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showLength) ...[
          SessionLengthField(
            value: drawing.sessionLength,
            onSelect: (v) => update(
              v == null
                  ? drawing.copyWith(clearSessionLength: true)
                  : drawing.copyWith(sessionLength: v),
            ),
          ),
          const SizedBox(height: AppDimens.spaceMd),
        ],
        SettingsSwitchRow(
          label: l.autoAdvanceLabel,
          subtitle: l.autoAdvanceSubtitle,
          value: drawing.autoAdvance,
          onChanged: (v) => update(drawing.copyWith(autoAdvance: v)),
        ),
        const SizedBox(height: AppDimens.spaceXs),
        SettingsFieldLabel(l.practiceSettingsRecognition),
        const SizedBox(height: AppDimens.spaceXs),
        SegmentedControl(
          options: [
            l.recognitionStrict,
            l.recognitionNormal,
            l.recognitionLenient,
          ],
          selected: drawing.tolerance.index,
          onSelect: (i) => update(
            drawing.copyWith(tolerance: RecognitionTolerance.values[i]),
          ),
        ),
        const SizedBox(height: AppDimens.spaceMd),
        SettingsFieldLabel(l.practiceSettingsHint),
        const SizedBox(height: AppDimens.spaceXs),
        SegmentedControl(
          options: [l.hintMeaning, l.hintReadings, l.hintBoth],
          selected: drawing.hintMode.index,
          onSelect: (i) =>
              update(drawing.copyWith(hintMode: KanjiHintMode.values[i])),
        ),
        const SizedBox(height: AppDimens.spaceMd),
        SettingsSwitchRow(
          label: l.ghostKanjiLabel,
          subtitle: l.ghostKanjiSubtitle,
          value: drawing.ghostKanji,
          onChanged: (v) => update(drawing.copyWith(ghostKanji: v)),
        ),
        SettingsSwitchRow(
          label: l.snapToReferenceLabel,
          subtitle: l.snapToReferenceSubtitle,
          value: drawing.snapToReference,
          onChanged: (v) => update(drawing.copyWith(snapToReference: v)),
        ),
        SettingsSwitchRow(
          label: l.showStrokeCountLabel,
          subtitle: l.showStrokeCountSubtitle,
          value: drawing.showStrokeCount,
          onChanged: (v) => update(drawing.copyWith(showStrokeCount: v)),
        ),
      ],
    );
  }
}
