import 'dart:math';

import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/srs_settings_provider.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/level_label.dart';
import '../../widgets/exercise/mcq_card.dart';
import '../practice_session_screen.dart';

class VocabPracticeScreen extends StatelessWidget {
  final String level;
  const VocabPracticeScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return PracticeSessionScreen(
      title: levelLabel(level, context),
      color: levelColor(level),
      loadQueue: _buildQueue,
    );
  }

  Future<List<PracticeItem>> _buildQueue(AppDatabase db, WidgetRef ref) async {
    final settings = await ref.read(srsSettingsProvider.future);
    final locale = ref.read(localeProvider).languageCode;
    final color = levelColor(level);
    final rng = Random();

    final pairs = await db.getVocabSrsSession(level, newCardLimit: settings.newCardsPerSession);
    final pool = await db.getVocabByLevel(level);
    final poolIds = pool.map((v) => v.id).toList();
    final translations = locale != 'en'
        ? await db.getVocabTranslations(poolIds, locale)
        : <int, String>{};

    String meaningOf(VocabularyEntry v) =>
        translations[v.id]?.isNotEmpty == true ? translations[v.id]! : v.meaning;

    return pairs.map((pair) {
      final (entry, card) = pair;
      final quizType = rng.nextInt(3); // 0: JP→EN flashcard, 1: EN→JP flashcard, 2: MCQ

      if (quizType == 0 || quizType == 1) {
        return PracticeItem(
          id: entry.id, srsType: 'vocabulary', card: card,
          buildBody: (index, total, onAnswer) => PracticeFlashcardBody(
            japanese: entry.word,
            label: entry.reading,
            answer: meaningOf(entry),
            isReversed: quizType == 1,
            card: card, index: index, total: total, color: color, onAnswer: onAnswer,
          ),
        );
      }

      // MCQ: select correct meaning
      final distractors = pool.where((v) => v.id != entry.id).toList()..shuffle(rng);
      final optionEntries = [entry, ...distractors.take(3)]..shuffle(rng);
      final correctIndex = optionEntries.indexWhere((v) => v.id == entry.id);
      final mcqOptions = List.generate(4, (i) => McqOption(
        letter: String.fromCharCode(65 + i),
        text: meaningOf(optionEntries[i]),
      ));

      return PracticeItem(
        id: entry.id, srsType: 'vocabulary', card: card,
        buildBody: (index, total, onAnswer) {
          return Builder(
            builder: (context) => PracticeMcqBody(
              question: context.l10n.mcqSelectWordMeaning,
              japanesePrompt: entry.word,
              options: mcqOptions,
              correctIndex: correctIndex,
              card: card, index: index, total: total, color: color, onAnswer: onAnswer,
            ),
          );
        },
      );
    }).toList();
  }
}
