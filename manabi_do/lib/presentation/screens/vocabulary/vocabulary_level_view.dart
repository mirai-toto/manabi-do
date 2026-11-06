import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

import '../../providers/srs_cards_provider.dart';

import '../../../core/srs/srs_level.dart';
import '../../../core/theme/srs_level_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/vocabulary_level.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/vocabulary_level_label.dart';
import '../../../l10n/l10n.dart';
import '../../providers/vocabulary_list_provider.dart';
import '../../providers/vocabulary_provider.dart';
import 'vocabulary_detail_screen.dart';
import '../../widgets/widgets.dart';

/// Shows the thirty words of one group, split by what to do about each.
///
/// Grouped rather than listed. A flat list of thirty drew every word the same
/// whether it was mastered or never seen, so the screen was an inventory and
/// the learner still had to work out where to start. The app already tracks six
/// SRS states per word; these sections are that state, made visible.
class VocabularyLevelView extends ConsumerWidget {
  final int level;
  final int groupIndex;
  final VoidCallback onBack;
  final void Function(Set<int> vocabularyIds) onPractice;

  const VocabularyLevelView({
    super.key,
    required this.level,
    required this.groupIndex,
    required this.onBack,
    required this.onPractice,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vocabularyAsync = ref.watch(vocabularyByLevelProvider(level));
    final color = vocabularyLevelColor(level, context.tokens);

    return switch (vocabularyAsync) {
      AsyncLoading() => const Center(child: AppSpinner.page()),
      AsyncError() => const SizedBox.shrink(),
      AsyncData(:final value) => _LevelContent(
        level: level,
        groupIndex: groupIndex,
        color: color,
        entries: value
            .skip(groupIndex * kVocabularyGroupSize)
            .take(kVocabularyGroupSize)
            .toList(),
        onBack: onBack,
        onPractice: onPractice,
      ),
    };
  }
}

class _LevelContent extends ConsumerWidget {
  final int level;
  final int groupIndex;
  final Color color;
  final List<VocabularyEntry> entries;
  final VoidCallback onBack;
  final void Function(Set<int> vocabularyIds) onPractice;

  const _LevelContent({
    required this.level,
    required this.groupIndex,
    required this.color,
    required this.entries,
    required this.onBack,
    required this.onPractice,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l = context.l10n;

    final learnedCount = ref.watch(
      vocabularyGroupLearnedCountProvider((
        level: level,
        groupIndex: groupIndex,
      )),
    );

    final groupIds = entries.map((e) => e.id).toSet();
    final start = groupIndex * kVocabularyGroupSize;
    final sections = _sections(context, ref);
    final dueCount = sections
        .where((s) => s.kind == _Bucket.due)
        .fold(0, (sum, s) => sum + s.words.length);

    return ScrollFade(
      builder: (controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
        children: [
          VocabularyGroupHeader(
            eyebrow:
                '${vocabularyLevelLabel(level, context)} · ${l.groupN(groupIndex + 1)}',
            title: '${start + 1}–${start + entries.length}',
            color: color,
            onBack: onBack,
          ),
          ProgressRow(known: learnedCount, total: entries.length, color: color),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMd,
              vertical: AppDimens.spaceSm,
            ),
            child: PracticeButton(
              label: dueCount > 0 ? l.reviewNDue(dueCount) : l.freePractice,
              color: color,
              onPressed: () => onPractice(groupIds),
            ),
          ),
          for (final section in sections) ...[
            _SectionHeader(section: section),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: t.cardBackground,
                  borderRadius: BorderRadius.circular(AppDimens.radiusLg),
                  border: Border.all(color: t.outlineVariant),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    for (int i = 0; i < section.words.length; i++) ...[
                      if (i > 0)
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: t.outlineVariant,
                        ),
                      VocabularyWordRow(
                        entry: section.words[i].entry,
                        meaning: ref
                            .watch(
                              vocabularyMeaningProvider(section.words[i].entry),
                            )
                            .meaning,
                        missingLanguage: ref
                            .watch(
                              vocabularyMeaningProvider(section.words[i].entry),
                            )
                            .missingLanguage,
                        accent: section.words[i].accent,
                        onOpen: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => VocabularyDetailScreen(
                              entry: section.words[i].entry,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// The group's words split by what to do about each one.
  ///
  /// A word with a card that has come due is the only thing the learner is
  /// behind on, so it comes first. "Not started" sits above "Known" because it
  /// is the work left, and a finished pile is a reward to scroll to rather than
  /// something to act on. An empty pile is left out entirely: a heading over
  /// nothing reads as a bug.
  List<_Section> _sections(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l = context.l10n;
    final cards = ref.watch(srsCardsProvider('vocabulary')).asData?.value ?? {};
    final now = DateTime.now();

    final due = <_WordState>[];
    final learning = <_WordState>[];
    final notStarted = <_WordState>[];
    final known = <_WordState>[];

    for (final entry in entries) {
      final fsrs.Card? card = cards[entry.id];
      final srs = srsLevel(card);
      // A word nobody has met has no mastery colour of its own, so the spine
      // falls back to the ordinary divider colour rather than vanishing.
      final state = _WordState(
        entry: entry,
        accent: srs == SrsLevel.newCard ? t.outlineVariant : srs.accent,
      );
      if (card == null) {
        notStarted.add(state);
      } else if (!card.due.isAfter(now)) {
        due.add(state);
      } else if (isSrsKnown(card)) {
        known.add(state);
      } else {
        learning.add(state);
      }
    }

    return [
      _Section(
        kind: _Bucket.due,
        name: l.srsDueToday,
        dot: SrsLevel.learning.accent,
        words: due,
      ),
      _Section(
        kind: _Bucket.learning,
        name: l.srsStateLearning,
        dot: SrsLevel.familiar.accent,
        words: learning,
      ),
      _Section(
        kind: _Bucket.notStarted,
        name: l.statusNotStarted,
        dot: t.outlineVariant,
        words: notStarted,
      ),
      _Section(
        kind: _Bucket.known,
        name: l.lessonStateKnown,
        dot: SrsLevel.expert.accent,
        words: known,
      ),
    ].where((section) => section.words.isNotEmpty).toList();
  }
}

/// Which pile a word falls into. One word is in exactly one.
enum _Bucket { due, learning, notStarted, known }

class _WordState {
  final VocabularyEntry entry;
  final Color accent;
  const _WordState({required this.entry, required this.accent});
}

class _Section {
  final _Bucket kind;
  final String name;
  final Color dot;
  final List<_WordState> words;
  const _Section({
    required this.kind,
    required this.name,
    required this.dot,
    required this.words,
  });
}

/// A pile's name, its colour and how many words are in it.
class _SectionHeader extends StatelessWidget {
  final _Section section;
  const _SectionHeader({required this.section});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceMd,
        AppDimens.spaceMd,
        AppDimens.spaceMd,
        AppDimens.spaceTight,
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: section.dot,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: AppDimens.spaceSm),
          Text(
            section.name.toUpperCase(),
            style: AppTextStyles.labelSmall.copyWith(
              color: t.onSurfaceVariant,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(width: AppDimens.spaceSm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
            decoration: BoxDecoration(
              color: t.surfaceVariant,
              borderRadius: BorderRadius.circular(AppDimens.radiusPill),
            ),
            child: Text(
              '${section.words.length}',
              style: AppTextStyles.labelSmall.copyWith(
                color: t.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
