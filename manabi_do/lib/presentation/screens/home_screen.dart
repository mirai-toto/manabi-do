import 'package:flutter/material.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/l10n.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _greeting(BuildContext context) {
    final hour = DateTime.now().hour;
    final l = context.l10n;
    if (hour < 12) return l.greetingMorning;
    if (hour < 18) return l.greetingAfternoon;
    return l.greetingEvening;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    final grammarCard = SectionCard(
      title: l.sectionGrammar,
      icon: '文',
      gradientColors: [t.primary, t.primaryLight],
      progressColor: t.primary,
      subtitle: '17 chapters · N5/N4',
      statLabel: '3 / 17 chapters',
      progress: 0.18,
      onTap: () {},
    );
    final charactersCard = SectionCard(
      title: l.sectionCharacters,
      icon: '字',
      gradientColors: [t.charactersDark, t.characters],
      progressColor: t.characters,
      subtitle: 'Kana · Kanji N5/N4',
      statLabel: '46 / 184 known',
      progress: 0.25,
      onTap: () {},
    );
    final vocabularyCard = SectionCard(
      title: l.sectionVocabulary,
      icon: '語',
      gradientColors: [t.vocabularyDark, t.vocabulary],
      progressColor: t.vocabulary,
      subtitle: '800+ words · N5/N4',
      statLabel: '120 / 800 known',
      progress: 0.15,
      onTap: () {},
    );
    final streakCard = StreakCard(
      days: 7,
      label: l.streakLabel,
      subtitle: l.streakSubtitle,
    );

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
          children: [
            _HomeHeader(greeting: _greeting(context), subtitle: l.greetingSubtitle),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.maxWidth;
                  final sectionCards = w >= 480
                      ? Row(children: [
                          Expanded(child: grammarCard),
                          const SizedBox(width: AppDimens.spaceSm),
                          Expanded(child: charactersCard),
                          const SizedBox(width: AppDimens.spaceSm),
                          Expanded(child: vocabularyCard),
                        ])
                      : Column(children: [
                          grammarCard,
                          const SizedBox(height: AppDimens.spaceSm),
                          charactersCard,
                          const SizedBox(height: AppDimens.spaceSm),
                          vocabularyCard,
                        ]);

                  return Column(
                    children: [
                      sectionCards,
                      const SizedBox(height: AppDimens.spaceLg),
                      streakCard,
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final String greeting;
  final String subtitle;

  const _HomeHeader({required this.greeting, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceMd, AppDimens.spaceMd, AppDimens.spaceMd, AppDimens.spaceLg,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      greeting,
                      style: AppTextStyles.titleLarge.copyWith(color: t.onSurface),
                    ),
                    const SizedBox(width: 6),
                    const AppEmoji('👋', size: 22),
                  ],
                ),
                const SizedBox(height: AppDimens.spaceXxs),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: t.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '?',
                style: AppTextStyles.title.copyWith(color: t.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
