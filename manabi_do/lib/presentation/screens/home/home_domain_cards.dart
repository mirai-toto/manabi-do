import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../widgets/widgets.dart';

class HomeDomainCards extends StatelessWidget {
  final int totalKana;
  final int totalKanji;
  final int totalVocab;
  final int kanaDue;
  final int kanaNew;
  final int kanjiDue;
  final int kanjiNew;
  final int vocabDue;
  final int vocabNew;
  final VoidCallback onKanaTap;
  final VoidCallback onKanjiTap;
  final VoidCallback onVocabTap;
  final VoidCallback onGrammarTap;
  final VoidCallback onKanaPractice;
  final VoidCallback onKanjiPractice;
  final VoidCallback onVocabPractice;

  const HomeDomainCards({
    super.key,
    required this.totalKana,
    required this.totalKanji,
    required this.totalVocab,
    this.kanaDue = 0,
    this.kanaNew = 0,
    this.kanjiDue = 0,
    this.kanjiNew = 0,
    this.vocabDue = 0,
    this.vocabNew = 0,
    required this.onKanaTap,
    required this.onKanjiTap,
    required this.onVocabTap,
    required this.onGrammarTap,
    required this.onKanaPractice,
    required this.onKanjiPractice,
    required this.onVocabPractice,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    final kanaCard = DomainCard(
      title: l.kana,
      icon: 'か',
      gradientColors: [t.charactersDark, t.characters],
      progressColor: t.characters,
      subtitle: 'Hiragana · Katakana',
      statLabel: totalKana > 0 ? l.nKanji(totalKana) : '—',
      progress: 0.0,
      dueCount: kanaDue,
      newCount: kanaNew,
      onTap: onKanaTap,
      onPractice: onKanaPractice,
    );

    final kanjiCard = DomainCard(
      title: l.tabKanji,
      icon: '字',
      gradientColors: [t.charactersDark, t.characters],
      progressColor: t.characters,
      subtitle: 'N5 → N1',
      statLabel: totalKanji > 0 ? l.nKanji(totalKanji) : '—',
      progress: 0.0,
      dueCount: kanjiDue,
      newCount: kanjiNew,
      onTap: onKanjiTap,
      onPractice: onKanjiPractice,
    );

    final vocabCard = DomainCard(
      title: l.navVocab,
      icon: '語',
      gradientColors: [t.vocabularyDark, t.vocabulary],
      progressColor: t.vocabulary,
      subtitle: 'N5 → N1',
      statLabel: totalVocab > 0 ? l.nWords(totalVocab) : '—',
      progress: 0.0,
      dueCount: vocabDue,
      newCount: vocabNew,
      onTap: onVocabTap,
      onPractice: onVocabPractice,
    );

    final grammarCard = DomainCard(
      title: l.sectionGrammar,
      icon: '文',
      gradientColors: [t.primary, t.primaryLight],
      progressColor: t.primary,
      subtitle: 'N5 · N4',
      statLabel: l.comingSoon,
      progress: 0.0,
      onTap: onGrammarTap,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 480) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: kanaCard),
                  const SizedBox(width: AppDimens.spaceSm),
                  Expanded(child: kanjiCard),
                ],
              ),
              const SizedBox(height: AppDimens.spaceSm),
              Row(
                children: [
                  Expanded(child: vocabCard),
                  const SizedBox(width: AppDimens.spaceSm),
                  Expanded(child: grammarCard),
                ],
              ),
            ],
          );
        }
        return Column(
          children: [
            kanaCard,
            const SizedBox(height: AppDimens.spaceSm),
            kanjiCard,
            const SizedBox(height: AppDimens.spaceSm),
            vocabCard,
            const SizedBox(height: AppDimens.spaceSm),
            grammarCard,
          ],
        );
      },
    );
  }
}
