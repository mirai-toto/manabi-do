import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card;

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../core/srs/srs_level.dart';
import '../../../data/database/app_database.dart';
import '../../../core/providers/srs_settings_provider.dart';
import '../../../l10n/l10n.dart';
import '../../providers/database_provider.dart';
import '../../providers/vocab_list_provider.dart';
import '../../widgets/common/progress_row.dart';
import '../../widgets/common/practice_button.dart';
import '../practice/practice_selection_screen.dart';
import 'vocab_practice_screen.dart';
import 'vocab_word_tile.dart';

const _kVocabGroupSize = 30;

class VocabLevelView extends ConsumerWidget {
  final String level;
  final int groupIndex;
  final VoidCallback onBack;

  const VocabLevelView({
    super.key,
    required this.level,
    required this.groupIndex,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vocabAsync = ref.watch(vocabByLevelProvider(level));
    final srsCards = ref.watch(vocabSrsCardsProvider).asData?.value ?? {};
    final color = levelColor(level);

    return switch (vocabAsync) {
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
      AsyncError(:final error) => Center(child: Text('Error: $error')),
      AsyncData(:final value) => _LevelContent(
        level: level,
        groupIndex: groupIndex,
        color: color,
        entries: value
            .skip(groupIndex * _kVocabGroupSize)
            .take(_kVocabGroupSize)
            .toList(),
        srsCards: srsCards,
        onBack: onBack,
        ref: ref,
      ),
    };
  }
}

class _LevelContent extends StatelessWidget {
  final String level;
  final int groupIndex;
  final Color color;
  final List<VocabularyEntry> entries;
  final Map<int, Card> srsCards;
  final VoidCallback onBack;
  final WidgetRef ref;

  const _LevelContent({
    required this.level,
    required this.groupIndex,
    required this.color,
    required this.entries,
    required this.srsCards,
    required this.onBack,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final learnedCount = entries.where((e) {
      final level = srsLevel(srsCards[e.id]);
      return level != SrsLevel.newCard && level != SrsLevel.learning;
    }).length;

    final groupIds = entries.map((e) => e.id).toSet();
    final start = groupIndex * _kVocabGroupSize;

    return ListView(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.spaceSm,
            AppDimens.spaceSm,
            AppDimens.spaceMd,
            0,
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: onBack,
                color: t.onSurface,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$level · ${context.l10n.groupN(groupIndex + 1)}',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      '${start + 1}–${start + entries.length}',
                      style: AppTextStyles.title.copyWith(color: t.onSurface),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ProgressRow(known: learnedCount, total: entries.length, color: color),
        PracticeButton(
          color: color,
          onTap: () {
            final db = ref.read(databaseProvider);
            final l = context.l10n;
            final groupTitle = l.groupN(groupIndex + 1);
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (ctx) => PracticeSelectionScreen(
                  title: groupTitle,
                  color: color,
                  modes: [
                    PracticeMode(
                      icon: Icons.calendar_today_rounded,
                      title: l.dailyTraining,
                      counts: () async {
                        final settings = await ref.read(
                          srsSettingsProvider.future,
                        );
                        final full = await db.getVocabSrsSession(
                          level,
                          newCardLimit: settings.newVocabPerDay,
                        );
                        final session = full
                            .where((p) => groupIds.contains(p.$1.id))
                            .toList();
                        return (
                          session.where((p) => p.$2 != null).length,
                          session.where((p) => p.$2 == null).length,
                        );
                      },
                      onTap: () async => Navigator.of(ctx).push(
                        MaterialPageRoute<void>(
                          builder: (_) => VocabPracticeScreen(
                            level: level,
                            allowedIds: groupIds,
                          ),
                        ),
                      ),
                    ),
                    PracticeMode(
                      icon: Icons.style_rounded,
                      title: l.flashcardPractice,
                      onTap: () async => Navigator.of(ctx).push(
                        MaterialPageRoute<void>(
                          builder: (_) => VocabPracticeScreen(
                            level: level,
                            allowedIds: groupIds,
                            flashcardOnly: true,
                          ),
                        ),
                      ),
                    ),
                    PracticeMode(
                      icon: Icons.quiz_rounded,
                      title: l.mcqPractice,
                      onTap: () async => Navigator.of(ctx).push(
                        MaterialPageRoute<void>(
                          builder: (_) => VocabPracticeScreen(
                            level: level,
                            allowedIds: groupIds,
                            mcqOnly: true,
                          ),
                        ),
                      ),
                    ),
                    PracticeMode(
                      icon: Icons.chat_bubble_outline_rounded,
                      title: l.sentencePractice,
                      onTap: () async => Navigator.of(ctx).push(
                        MaterialPageRoute<void>(
                          builder: (_) => VocabPracticeScreen(
                            level: level,
                            allowedIds: groupIds,
                            sentenceOnly: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        // Word list
        for (int i = 0; i < entries.length; i++) ...[
          if (i > 0)
            Divider(
              height: 1,
              thickness: 1,
              color: t.outlineVariant,
              indent: AppDimens.spaceMd,
              endIndent: AppDimens.spaceMd,
            ),
          VocabWordTile(entry: entries[i]),
        ],
      ],
    );
  }
}
