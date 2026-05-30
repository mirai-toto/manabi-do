import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../widgets/widgets.dart';

class HomeDomainCards extends StatelessWidget {
  final int totalChars;
  final int totalVocab;
  final int charsDue;
  final int charsNew;
  final int vocabDue;
  final int vocabNew;
  final VoidCallback onCharactersTap;
  final VoidCallback onVocabTap;
  final VoidCallback onGrammarTap;
  final VoidCallback onCharsPractice;
  final VoidCallback onVocabPractice;

  const HomeDomainCards({
    super.key,
    required this.totalChars,
    required this.totalVocab,
    required this.charsDue,
    this.charsNew = 0,
    required this.vocabDue,
    this.vocabNew = 0,
    required this.onCharactersTap,
    required this.onVocabTap,
    required this.onGrammarTap,
    required this.onCharsPractice,
    required this.onVocabPractice,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    final cards = [
      DomainCard(
        title: l.sectionGrammar,
        icon: '文',
        gradientColors: [t.primary, t.primaryLight],
        progressColor: t.primary,
        subtitle: 'N5 · N4',
        statLabel: l.comingSoon,
        progress: 0.0,
        onTap: onGrammarTap,
      ),
      DomainCard(
        title: l.sectionCharacters,
        icon: '字',
        gradientColors: [t.charactersDark, t.characters],
        progressColor: t.characters,
        subtitle: 'Kana · Kanji',
        statLabel: totalChars > 0 ? l.nKanji(totalChars) : '—',
        progress: 0.0,
        dueCount: charsDue,
        newCount: charsNew,
        onTap: onCharactersTap,
        onPractice: onCharsPractice,
      ),
      DomainCard(
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
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) => constraints.maxWidth >= 480
          ? Row(
              children: [
                Expanded(child: cards[0]),
                const SizedBox(width: AppDimens.spaceSm),
                Expanded(child: cards[1]),
                const SizedBox(width: AppDimens.spaceSm),
                Expanded(child: cards[2]),
              ],
            )
          : Column(
              children: [
                cards[0],
                const SizedBox(height: AppDimens.spaceSm),
                cards[1],
                const SizedBox(height: AppDimens.spaceSm),
                cards[2],
              ],
            ),
    );
  }
}
