import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/srs_settings_provider.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../widgets/widgets.dart';
import '../settings/exercise_settings_sections.dart';

export '../../../core/models/sentence_settings.dart' show TranslationMode;

enum SettingsContext { sentence, mcq, flashcard, writing, grammar }

class PracticeSettingsSheet extends ConsumerWidget {
  final Set<SettingsContext> contexts;

  /// True in a graded session: it offers the grading scale, and hides the free
  /// practice length, which it does not use.
  final bool gradesRecorded;
  final bool hasExamples;

  const PracticeSettingsSheet({
    super.key,
    this.contexts = const {SettingsContext.mcq},
    this.gradesRecorded = false,
    this.hasExamples = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l = context.l10n;

    final SrsSettings srs = ref.watch(srsSettingsProvider);

    final showLabels = contexts.length > 1;

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
            const SheetDragHandle(),
            Text(
              l.practiceSettingsTitle,
              style: AppTextStyles.title.copyWith(color: t.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceMd),

            // Only offered where the grade is kept: free practice discards it,
            // so there is no precision to choose.
            if (gradesRecorded) ...[
              SettingsSwitchRow(
                label: l.settingsDetailedGrading,
                subtitle: l.settingsDetailedGradingSubtitle,
                value: srs.detailedGrading,
                onChanged: (v) => ref
                    .read(srsSettingsProvider.notifier)
                    .setDetailedGrading(v),
              ),
              const SizedBox(height: AppDimens.spaceMd),
            ],

            // Each block is a store, not a section: grammar keeps nothing of
            // its own and reads the same flashcard and multiple-choice values
            // that vocabulary and kanji do.
            if (contexts.contains(SettingsContext.flashcard)) ...[
              if (showLabels) ...[
                _CategoryLabel(l.flashcardPractice),
                const SizedBox(height: AppDimens.spaceXs),
              ],
              FlashcardSettingsSection(
                hasExamples: hasExamples,
                showLength: !gradesRecorded,
              ),
              if (showLabels) const SizedBox(height: AppDimens.spaceMd),
            ],

            if (contexts.contains(SettingsContext.mcq)) ...[
              if (showLabels) ...[
                _CategoryLabel(l.mcqPractice),
                const SizedBox(height: AppDimens.spaceXs),
              ] else
                const SizedBox(height: AppDimens.spaceSm),
              McqSettingsSection(showLength: !gradesRecorded),
              if (showLabels) const SizedBox(height: AppDimens.spaceMd),
            ],

            // Grammar runs flashcards and multiple choice, so it shows those
            // two stores under one heading of its own.
            if (contexts.contains(SettingsContext.grammar)) ...[
              if (showLabels) ...[
                _CategoryLabel(l.grammarPractice),
                const SizedBox(height: AppDimens.spaceXs),
              ],
              McqSettingsSection(showLength: !gradesRecorded),
              if (hasExamples)
                FlashcardSettingsSection(
                  hasExamples: hasExamples,
                  showLength: !gradesRecorded,
                ),
              if (showLabels) const SizedBox(height: AppDimens.spaceMd),
            ],

            if (contexts.contains(SettingsContext.sentence)) ...[
              if (showLabels) ...[
                _CategoryLabel(l.sentencePractice),
                const SizedBox(height: AppDimens.spaceXs),
              ],
              SentenceSettingsSection(showLength: !gradesRecorded),
              if (showLabels) const SizedBox(height: AppDimens.spaceMd),
            ],

            if (contexts.contains(SettingsContext.writing)) ...[
              if (showLabels) ...[
                _CategoryLabel(l.writingPractice),
                const SizedBox(height: AppDimens.spaceXs),
              ],
              WritingSettingsSection(showLength: !gradesRecorded),
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
