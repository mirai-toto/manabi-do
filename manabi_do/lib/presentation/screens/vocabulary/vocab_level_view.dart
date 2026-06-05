import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/level_label.dart';
import '../../providers/database_provider.dart';
import '../../providers/vocab_list_provider.dart';
import '../../widgets/common/progress_row.dart';
import '../../widgets/common/practice_button.dart';
import 'vocab_practice_screen.dart';
import 'vocab_word_tile.dart';

class VocabLevelView extends ConsumerWidget {
  final String level;
  final VoidCallback onBack;

  const VocabLevelView({super.key, required this.level, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vocabAsync = ref.watch(vocabByLevelProvider(level));
    final knownIds = ref.watch(knownVocabIdsProvider).asData?.value ?? {};
    final color = levelColor(level);

    return switch (vocabAsync) {
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
      AsyncError(:final error) => Center(child: Text('Error: $error')),
      AsyncData(:final value) => _LevelContent(
          level: level,
          color: color,
          entries: value,
          knownIds: knownIds,
          onBack: onBack,
          ref: ref,
        ),
    };
  }
}

class _LevelContent extends StatelessWidget {
  final String level;
  final Color color;
  final List<VocabularyEntry> entries;
  final Set<int> knownIds;
  final VoidCallback onBack;
  final WidgetRef ref;

  const _LevelContent({
    required this.level,
    required this.color,
    required this.entries,
    required this.knownIds,
    required this.onBack,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final knownCount = knownIds.intersection(entries.map((e) => e.id).toSet()).length;

    return ListView(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.spaceSm, AppDimens.spaceSm, AppDimens.spaceMd, 0,
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
                      level,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      levelLabel(level, context),
                      style: AppTextStyles.title.copyWith(color: t.onSurface),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ProgressRow(known: knownCount, total: entries.length, color: color),
        PracticeButton(
          color: color,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => VocabPracticeScreen(level: level),
            ),
          ),
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
          VocabWordTile(
            entry: entries[i],
            isKnown: knownIds.contains(entries[i].id),
            onToggleKnown: () => ref.read(databaseProvider).setVocabKnown(
              entries[i].id,
              isKnown: !knownIds.contains(entries[i].id),
            ),
          ),
        ],
      ],
    );
  }
}
