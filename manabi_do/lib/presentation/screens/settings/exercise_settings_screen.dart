import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../widgets/widgets.dart';

/// Which exercise's settings a screen shows. One per store.
enum ExerciseKind { flashcard, mcq, sentence, writing }

/// One exercise's settings, reached from the settings screen.
///
/// The same sections the in-session sheet shows, so there is one place to
/// change a value and two places to reach it. What differs is that a settings
/// screen has no session: the per-exercise auto-advance switches apply here,
/// and they are labelled so nobody confuses them with the session-wide one.
class ExerciseSettingsScreen extends ConsumerWidget {
  final ExerciseKind kind;

  const ExerciseSettingsScreen({super.key, required this.kind});

  String _title(AppLocalizations l) => switch (kind) {
    ExerciseKind.flashcard => l.flashcardPractice,
    ExerciseKind.mcq => l.mcqPractice,
    ExerciseKind.sentence => l.sentencePractice,
    ExerciseKind.writing => l.writingPractice,
  };

  /// Where this exercise's settings take effect. Shown because the values are
  /// shared: change multiple choice and vocabulary, kanji and grammar all
  /// change with it.
  String _usedIn(AppLocalizations l) => switch (kind) {
    ExerciseKind.flashcard || ExerciseKind.mcq => [
      l.sectionVocabulary,
      l.sectionCharacters,
      l.sectionGrammar,
    ].join(' · '),
    ExerciseKind.sentence => l.sectionVocabulary,
    ExerciseKind.writing => l.sectionCharacters,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l = context.l10n;

    return Scaffold(
      backgroundColor: t.surface,
      appBar: AppBar(
        backgroundColor: t.surface,
        foregroundColor: t.onSurface,
        elevation: 0,
        title: Text(_title(l)),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppDimens.screenMaxWidth),
          child: ListView(
            padding: const EdgeInsets.all(AppDimens.spaceMd),
            children: [
              Text(
                _usedIn(l),
                style: AppTextStyles.bodySmall.copyWith(
                  color: t.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppDimens.spaceLg),
              switch (kind) {
                ExerciseKind.flashcard => const FlashcardSettingsSection(
                  hasExamples: true,
                ),
                ExerciseKind.mcq => const McqSettingsSection(
                  showAutoAdvance: true,
                ),
                ExerciseKind.sentence => const SentenceSettingsSection(
                  showAutoAdvance: true,
                ),
                ExerciseKind.writing => const WritingSettingsSection(
                  showAutoAdvance: true,
                ),
              },
              if (kind != ExerciseKind.flashcard) ...[
                const SizedBox(height: AppDimens.spaceMd),
                Container(
                  padding: const EdgeInsets.all(AppDimens.spaceCozy),
                  decoration: BoxDecoration(
                    color: t.primaryContainer,
                    borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                  ),
                  child: Text(
                    l.autoAdvanceFreePracticeNote,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: t.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: AppDimens.spaceLg),
            ],
          ),
        ),
      ),
    );
  }
}
