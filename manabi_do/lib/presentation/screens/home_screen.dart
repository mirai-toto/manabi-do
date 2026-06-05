import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/l10n.dart';
import '../providers/home_provider.dart';
import '../providers/kana_progress_provider.dart';
import '../providers/kanji_provider.dart';
import '../providers/vocab_list_provider.dart';
import '../widgets/widgets.dart';

// Tab indices matching ShellScreen._screens order.
const _kTabCharacters = 1;
const _kTabVocabulary = 2;
const _kTabGrammar    = 3;

String _greeting(BuildContext context) {
  final hour = DateTime.now().hour;
  final l = context.l10n;
  if (hour < 12) return l.greetingMorning;
  if (hour < 18) return l.greetingAfternoon;
  return l.greetingEvening;
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;

    // ── Progress data ────────────────────────────────────────────────────────
    final knownKanji    = ref.watch(knownKanjiIdsProvider).asData?.value.length ?? 0;
    final knownHiragana = ref.watch(knownHiraganaProvider).asData?.value.length ?? 0;
    final knownKatakana = ref.watch(knownKatakanaProvider).asData?.value.length ?? 0;
    final knownVocab    = ref.watch(knownVocabIdsProvider).asData?.value.length ?? 0;

    final totalKanji = ref.watch(totalKanjiProvider).asData?.value ?? 0;
    final totalKana  = ref.watch(totalKanaProvider).asData?.value ?? 0;
    final totalVocab = ref.watch(totalVocabProvider).asData?.value ?? 0;

    final knownChars = knownHiragana + knownKatakana + knownKanji;
    final totalChars = totalKana + totalKanji;

    void goTo(int tab) => ref.read(selectedTabProvider.notifier).select(tab);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimens.screenMaxWidth),
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
          children: [
            _HomeHeader(greeting: _greeting(context), subtitle: l.greetingSubtitle),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
              child: Column(
                children: [
                  _DueTodayBanner(onTap: () => goTo(_kTabCharacters)),
                  const SizedBox(height: AppDimens.spaceMd),
                  _SectionCards(
                    knownChars: knownChars, totalChars: totalChars,
                    knownVocab: knownVocab, totalVocab: totalVocab,
                    onCharactersTap: () => goTo(_kTabCharacters),
                    onVocabTap:      () => goTo(_kTabVocabulary),
                    onGrammarTap:    () => goTo(_kTabGrammar),
                  ),
                  const SizedBox(height: AppDimens.spaceLg),
                  StreakCard(days: 0, label: l.streakLabel, subtitle: l.streakSubtitle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Due-today banner ──────────────────────────────────────────────────────────

class _DueTodayBanner extends ConsumerWidget {
  final VoidCallback onTap;
  const _DueTodayBanner({required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l = context.l10n;
    final dueAsync = ref.watch(dueTodayCountProvider);

    return dueAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (due) {
        final hasReviews = due > 0;
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.radiusXl),
          child: Material(
            color: hasReviews ? t.primaryContainer : t.surfaceContainer,
            child: InkWell(
              onTap: hasReviews ? onTap : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceLg,
                  vertical: AppDimens.spaceMd,
                ),
                child: Row(
                  children: [
                    Text(
                      hasReviews ? '📚' : '✅',
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(width: AppDimens.spaceMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hasReviews
                                ? l.reviewsDue(due)
                                : l.allCaughtUp,
                            style: AppTextStyles.body.copyWith(
                              color: hasReviews ? t.onPrimaryContainer : t.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            hasReviews ? l.reviewsDueSubtitle : l.allCaughtUpSubtitle,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: hasReviews
                                  ? t.onPrimaryContainer.withValues(alpha: 0.7)
                                  : t.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (hasReviews)
                      Icon(Icons.arrow_forward_rounded,
                          color: t.onPrimaryContainer, size: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Section cards ─────────────────────────────────────────────────────────────

class _SectionCards extends StatelessWidget {
  final int knownChars;
  final int totalChars;
  final int knownVocab;
  final int totalVocab;
  final VoidCallback onCharactersTap;
  final VoidCallback onVocabTap;
  final VoidCallback onGrammarTap;

  const _SectionCards({
    required this.knownChars,
    required this.totalChars,
    required this.knownVocab,
    required this.totalVocab,
    required this.onCharactersTap,
    required this.onVocabTap,
    required this.onGrammarTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    final charProgress = totalChars > 0 ? knownChars / totalChars : 0.0;
    final vocabProgress = totalVocab > 0 ? knownVocab / totalVocab : 0.0;

    final cards = [
      SectionCard(
        title: l.sectionGrammar, icon: '文',
        gradientColors: [t.primary, t.primaryLight], progressColor: t.primary,
        subtitle: 'N5 · N4', statLabel: l.comingSoon,
        progress: 0.0, onTap: onGrammarTap,
      ),
      SectionCard(
        title: l.sectionCharacters, icon: '字',
        gradientColors: [t.charactersDark, t.characters], progressColor: t.characters,
        subtitle: 'Kana · Kanji',
        statLabel: totalChars > 0 ? '$knownChars / $totalChars' : '—',
        progress: charProgress, onTap: onCharactersTap,
      ),
      SectionCard(
        title: l.navVocab, icon: '語',
        gradientColors: [t.vocabularyDark, t.vocabulary], progressColor: t.vocabulary,
        subtitle: 'N5 → N1',
        statLabel: totalVocab > 0 ? '$knownVocab / $totalVocab' : '—',
        progress: vocabProgress, onTap: onVocabTap,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) => constraints.maxWidth >= 480
          ? Row(children: [
              Expanded(child: cards[0]),
              const SizedBox(width: AppDimens.spaceSm),
              Expanded(child: cards[1]),
              const SizedBox(width: AppDimens.spaceSm),
              Expanded(child: cards[2]),
            ])
          : Column(children: [
              cards[0],
              const SizedBox(height: AppDimens.spaceSm),
              cards[1],
              const SizedBox(height: AppDimens.spaceSm),
              cards[2],
            ]),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

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
                Row(children: [
                  Text(greeting, style: AppTextStyles.titleLarge.copyWith(color: t.onSurface)),
                  const SizedBox(width: 6),
                  const AppEmoji('👋', size: 22),
                ]),
                const SizedBox(height: AppDimens.spaceXxs),
                Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant)),
              ],
            ),
          ),
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: t.primaryContainer, shape: BoxShape.circle),
            child: Center(
              child: Text('?', style: AppTextStyles.title.copyWith(color: t.primary)),
            ),
          ),
        ],
      ),
    );
  }
}
