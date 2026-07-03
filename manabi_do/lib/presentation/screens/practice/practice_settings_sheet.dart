import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/drawing_settings.dart';
import '../../../core/models/flashcard_settings.dart';
import '../../../core/models/mcq_settings.dart';
import '../../../core/models/sentence_settings.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../providers/drawing_settings_provider.dart';
import '../../providers/flashcard_settings_provider.dart';
import '../../providers/mcq_settings_provider.dart';
import '../../providers/sentence_settings_provider.dart';

export '../../../core/models/sentence_settings.dart' show TranslationMode;

enum SettingsContext { sentence, mcq, flashcard, writing }

class PracticeSettingsSheet extends ConsumerWidget {
  final Set<SettingsContext> contexts;
  final bool showAutoAdvance;

  const PracticeSettingsSheet({
    super.key,
    this.contexts = const {SettingsContext.mcq},
    this.showAutoAdvance = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l = context.l10n;

    final sentence = ref.watch(sentenceSettingsProvider);
    final mcq = ref.watch(mcqSettingsProvider);
    final flashcard = ref.watch(flashcardSettingsProvider);
    final drawing = ref.watch(drawingSettingsProvider);

    void updateSentence(SentenceSettings next) =>
        ref.read(sentenceSettingsProvider.notifier).update(next);
    void updateMcq(McqSettings next) =>
        ref.read(mcqSettingsProvider.notifier).update(next);
    void updateFlashcard(FlashcardSettings next) =>
        ref.read(flashcardSettingsProvider.notifier).update(next);
    void updateDrawing(DrawingSettings next) =>
        ref.read(drawingSettingsProvider.notifier).update(next);

    final showLabels = contexts.length > 1;

    Widget sessionLengthRow(int? value, void Function(int?) onSelect) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(l.practiceSettingsSessionLength),
        const SizedBox(height: AppDimens.spaceXs),
        _SegmentRow(
          options: const ['10', '20', '50', '∞'],
          selected: switch (value) {
            10 => 0,
            20 => 1,
            50 => 2,
            _ => value == null ? 3 : 1,
          },
          onSelect: (i) {
            const lengths = [10, 20, 50, null];
            onSelect(lengths[i]);
          },
        ),
        const SizedBox(height: AppDimens.spaceXs),
        Text(
          l.sessionLengthHint,
          style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
        ),
      ],
    );

    Widget mcqChoicesRow(int value, void Function(int) onSelect) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(l.practiceSettingsMcqChoices),
        const SizedBox(height: AppDimens.spaceXs),
        _SegmentRow(
          options: const ['4', '6', '8'],
          selected: switch (value) {
            6 => 1,
            8 => 2,
            _ => 0,
          },
          onSelect: (i) => onSelect(const [4, 6, 8][i]),
        ),
        const SizedBox(height: AppDimens.spaceXs),
        Text(
          l.sessionLengthHint,
          style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
        ),
      ],
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.spaceMd,
          AppDimens.spaceSm,
          AppDimens.spaceMd,
          AppDimens.spaceLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: t.outlineVariant,
                  borderRadius: BorderRadius.circular(AppDimens.radiusXxs),
                ),
              ),
            ),
            const SizedBox(height: AppDimens.spaceMd),
            Text(
              l.practiceSettingsTitle,
              style: AppTextStyles.title.copyWith(color: t.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceMd),

            // ── Flashcard ──────────────────────────────────────────────────
            if (contexts.contains(SettingsContext.flashcard)) ...[
              if (showLabels) ...[
                _CategoryLabel(l.flashcardPractice),
                const SizedBox(height: AppDimens.spaceXs),
              ],
              sessionLengthRow(
                flashcard.sessionLength,
                (v) => updateFlashcard(
                  v == null
                      ? flashcard.copyWith(clearSessionLength: true)
                      : flashcard.copyWith(sessionLength: v),
                ),
              ),
              if (showLabels) const SizedBox(height: AppDimens.spaceMd),
            ],

            // ── MCQ ────────────────────────────────────────────────────────
            if (contexts.contains(SettingsContext.mcq)) ...[
              if (showLabels) ...[
                _CategoryLabel(l.mcqPractice),
                const SizedBox(height: AppDimens.spaceXs),
              ] else
                const SizedBox(height: AppDimens.spaceSm),
              sessionLengthRow(
                mcq.sessionLength,
                (v) => updateMcq(
                  v == null
                      ? mcq.copyWith(clearSessionLength: true)
                      : mcq.copyWith(sessionLength: v),
                ),
              ),
              const SizedBox(height: AppDimens.spaceMd),
              mcqChoicesRow(
                mcq.mcqChoiceCount,
                (v) => updateMcq(mcq.copyWith(mcqChoiceCount: v)),
              ),
              if (showAutoAdvance) ...[
                const SizedBox(height: AppDimens.spaceMd),
                _SwitchRow(
                  label: l.autoAdvanceLabel,
                  subtitle: l.autoAdvanceSubtitle,
                  value: mcq.autoAdvance,
                  onChanged: (v) => updateMcq(mcq.copyWith(autoAdvance: v)),
                ),
              ],
              _SwitchRow(
                label: l.showMcqFuriganaLabel,
                subtitle: l.showMcqFuriganaSubtitle,
                value: mcq.showPromptFurigana,
                onChanged: (v) =>
                    updateMcq(mcq.copyWith(showPromptFurigana: v)),
              ),
              if (showLabels) const SizedBox(height: AppDimens.spaceMd),
            ],

            // ── Sentence ──────────────────────────────────────────────────
            if (contexts.contains(SettingsContext.sentence)) ...[
              if (showLabels) ...[
                _CategoryLabel(l.sentencePractice),
                const SizedBox(height: AppDimens.spaceXs),
              ],
              sessionLengthRow(
                sentence.sessionLength,
                (v) => updateSentence(
                  v == null
                      ? sentence.copyWith(clearSessionLength: true)
                      : sentence.copyWith(sessionLength: v),
                ),
              ),
              const SizedBox(height: AppDimens.spaceMd),
              mcqChoicesRow(
                sentence.mcqChoiceCount,
                (v) => updateSentence(sentence.copyWith(mcqChoiceCount: v)),
              ),
              if (showAutoAdvance) ...[
                const SizedBox(height: AppDimens.spaceMd),
                _SwitchRow(
                  label: l.autoAdvanceLabel,
                  subtitle: l.autoAdvanceSubtitle,
                  value: sentence.autoAdvance,
                  onChanged: (v) =>
                      updateSentence(sentence.copyWith(autoAdvance: v)),
                ),
              ],
              _SwitchRow(
                label: l.showSentenceFuriganaLabel,
                subtitle: l.showSentenceFuriganaSubtitle,
                value: sentence.showSentenceFurigana,
                onChanged: (v) =>
                    updateSentence(sentence.copyWith(showSentenceFurigana: v)),
              ),
              _SwitchRow(
                label: l.showChoiceFuriganaLabel,
                subtitle: l.showChoiceFuriganaSubtitle,
                value: sentence.showChoiceFurigana,
                onChanged: (v) =>
                    updateSentence(sentence.copyWith(showChoiceFurigana: v)),
              ),
              const SizedBox(height: AppDimens.spaceXs),
              _SectionLabel(l.translationModeLabel),
              const SizedBox(height: AppDimens.spaceXs),
              _SegmentRow(
                options: [
                  l.translationModeAlways,
                  l.translationModeOnDemand,
                  l.translationModeNever,
                ],
                selected: sentence.translationMode.index,
                onSelect: (i) => updateSentence(
                  sentence.copyWith(translationMode: TranslationMode.values[i]),
                ),
              ),
              if (showLabels) const SizedBox(height: AppDimens.spaceMd),
            ],

            // ── Writing ───────────────────────────────────────────────────
            if (contexts.contains(SettingsContext.writing)) ...[
              if (showLabels) ...[
                _CategoryLabel(l.writingPractice),
                const SizedBox(height: AppDimens.spaceXs),
              ],
              sessionLengthRow(
                drawing.sessionLength,
                (v) => updateDrawing(
                  v == null
                      ? drawing.copyWith(clearSessionLength: true)
                      : drawing.copyWith(sessionLength: v),
                ),
              ),
              if (showAutoAdvance) ...[
                const SizedBox(height: AppDimens.spaceMd),
                _SwitchRow(
                  label: l.autoAdvanceLabel,
                  subtitle: l.autoAdvanceSubtitle,
                  value: drawing.autoAdvance,
                  onChanged: (v) =>
                      updateDrawing(drawing.copyWith(autoAdvance: v)),
                ),
              ],
              const SizedBox(height: AppDimens.spaceXs),
              _SectionLabel(l.practiceSettingsRecognition),
              const SizedBox(height: AppDimens.spaceXs),
              _SegmentRow(
                options: [
                  l.recognitionStrict,
                  l.recognitionNormal,
                  l.recognitionLenient,
                ],
                selected: drawing.tolerance.index,
                onSelect: (i) => updateDrawing(
                  drawing.copyWith(tolerance: RecognitionTolerance.values[i]),
                ),
              ),
              const SizedBox(height: AppDimens.spaceMd),
              _SectionLabel(l.practiceSettingsHint),
              const SizedBox(height: AppDimens.spaceXs),
              _SegmentRow(
                options: [l.hintMeaning, l.hintReadings, l.hintBoth],
                selected: drawing.hintMode.index,
                onSelect: (i) => updateDrawing(
                  drawing.copyWith(hintMode: KanjiHintMode.values[i]),
                ),
              ),
              const SizedBox(height: AppDimens.spaceMd),
              _SwitchRow(
                label: l.ghostKanjiLabel,
                subtitle: l.ghostKanjiSubtitle,
                value: drawing.ghostKanji,
                onChanged: (v) =>
                    updateDrawing(drawing.copyWith(ghostKanji: v)),
              ),
              _SwitchRow(
                label: l.snapToReferenceLabel,
                subtitle: l.snapToReferenceSubtitle,
                value: drawing.snapToReference,
                onChanged: (v) =>
                    updateDrawing(drawing.copyWith(snapToReference: v)),
              ),
              _SwitchRow(
                label: l.showStrokeCountLabel,
                subtitle: l.showStrokeCountSubtitle,
                value: drawing.showStrokeCount,
                onChanged: (v) =>
                    updateDrawing(drawing.copyWith(showStrokeCount: v)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CategoryLabel extends StatelessWidget {
  final String text;
  const _CategoryLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Text(
      text,
      style: AppTextStyles.body.copyWith(
        color: t.onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Text(
      text,
      style: AppTextStyles.labelSmall.copyWith(color: t.onSurfaceVariant),
    );
  }
}

class _SegmentRow extends StatelessWidget {
  final List<String> options;
  final int selected;
  final void Function(int) onSelect;

  const _SegmentRow({
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Row(
      children: [
        for (int i = 0; i < options.length; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: i == selected ? t.primary : t.cardBackground,
                  borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                  border: Border.all(
                    color: i == selected ? t.primary : t.outlineVariant,
                  ),
                ),
                child: Text(
                  options[i],
                  style: AppTextStyles.labelSmall.copyWith(
                    color: i == selected ? Colors.white : t.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final void Function(bool) onChanged;

  const _SwitchRow({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.body.copyWith(color: t.onSurface),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: t.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: t.primary,
          ),
        ],
      ),
    );
  }
}
