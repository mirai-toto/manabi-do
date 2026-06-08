import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/locale_provider.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/jlpt_level.dart';
import '../../data/database/app_database.dart';
import '../../l10n/l10n.dart';
import '../providers/home_provider.dart';
import '../providers/kana_progress_provider.dart';
import '../providers/kanji_provider.dart';
import '../providers/vocab_list_provider.dart';
import '../widgets/exercise/practice_session_screen.dart';
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

// ── Combined loadQueue closures for home-screen review ────────────────────────
// Due-only (newCardLimit=0). Flashcard format — full MCQ/drawing lives per-tab.

Future<List<PracticeItem>> _loadCharactersQueue(AppDatabase db, WidgetRef ref) async {
  final kana  = await db.getAllDueKanaSrsSession();
  final kanji = await db.getAllDueKanjiSrsSession();

  final kanaItems = kana.map((pair) {
    final (k, card) = pair;
    final color = levelColor('kana');
    return PracticeItem(
      id: k.id, srsType: k.type, card: card,
      buildBody: (index, total, onAnswer) => PracticeFlashcardBody(
        japanese: k.character, answer: k.romaji,
        card: card, index: index, total: total, color: color, onAnswer: onAnswer,
      ),
    );
  });

  final kanjiItems = kanji.map((pair) {
    final (k, card) = pair;
    final color = levelColor(k.jlptLevel);
    return PracticeItem(
      id: k.id, srsType: 'kanji', card: card,
      buildBody: (index, total, onAnswer) => PracticeFlashcardBody(
        japanese: k.character, answer: k.meaning,
        card: card, index: index, total: total, color: color, onAnswer: onAnswer,
      ),
    );
  });

  return [...kanaItems, ...kanjiItems]..shuffle();
}

Future<List<PracticeItem>> _loadVocabQueue(AppDatabase db, WidgetRef ref) async {
  final locale = ref.read(localeProvider).languageCode;
  final pairs  = await db.getAllDueVocabSrsSession();
  final ids    = pairs.map((p) => p.$1.id).toList();
  final translations = locale != 'en'
      ? await db.getVocabTranslations(ids, locale)
      : <int, String>{};
  final rng = Random();

  final items = pairs.map((pair) {
    final (entry, card) = pair;
    final color   = levelColor(entry.jlptLevel);
    final meaning = translations[entry.id]?.isNotEmpty == true
        ? translations[entry.id]!
        : entry.meaning;
    return PracticeItem(
      id: entry.id, srsType: 'vocabulary', card: card,
      buildBody: (index, total, onAnswer) => PracticeFlashcardBody(
        japanese: entry.word,
        label: entry.reading,
        answer: meaning,
        isReversed: rng.nextBool(),
        card: card, index: index, total: total, color: color, onAnswer: onAnswer,
      ),
    );
  }).toList();

  return items..shuffle();
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with WidgetsBindingObserver {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) => _refresh());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _refresh() {
    ref.invalidate(charactersDueCountProvider);
    ref.invalidate(vocabDueCountProvider);
    ref.invalidate(streakDaysProvider);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  @override
  Widget build(BuildContext context) {
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

    final charsDue = ref.watch(charactersDueCountProvider).asData?.value ?? 0;
    final vocabDue = ref.watch(vocabDueCountProvider).asData?.value ?? 0;

    void goTo(int tab) => ref.read(selectedTabProvider.notifier).select(tab);

    void startCharsReview() => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PracticeSessionScreen(
          title: l.sectionCharacters,
          color: context.tokens.characters,
          loadQueue: _loadCharactersQueue,
        ),
      ),
    );

    void startVocabReview() => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PracticeSessionScreen(
          title: l.navVocab,
          color: context.tokens.vocabulary,
          loadQueue: _loadVocabQueue,
        ),
      ),
    );

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
                  _SectionCards(
                    knownChars: knownChars, totalChars: totalChars,
                    knownVocab: knownVocab, totalVocab: totalVocab,
                    charsDue: charsDue, vocabDue: vocabDue,
                    onCharactersTap: () => goTo(_kTabCharacters),
                    onVocabTap:      () => goTo(_kTabVocabulary),
                    onGrammarTap:    () => goTo(_kTabGrammar),
                    onCharsReview:   startCharsReview,
                    onVocabReview:   startVocabReview,
                  ),
                  const SizedBox(height: AppDimens.spaceLg),
                  StreakCard(days: ref.watch(streakDaysProvider).asData?.value ?? 0, label: l.streakLabel, subtitle: l.streakSubtitle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section cards ─────────────────────────────────────────────────────────────

class _SectionCards extends StatelessWidget {
  final int knownChars;
  final int totalChars;
  final int knownVocab;
  final int totalVocab;
  final int charsDue;
  final int vocabDue;
  final VoidCallback onCharactersTap;
  final VoidCallback onVocabTap;
  final VoidCallback onGrammarTap;
  final VoidCallback onCharsReview;
  final VoidCallback onVocabReview;

  const _SectionCards({
    required this.knownChars,
    required this.totalChars,
    required this.knownVocab,
    required this.totalVocab,
    required this.charsDue,
    required this.vocabDue,
    required this.onCharactersTap,
    required this.onVocabTap,
    required this.onGrammarTap,
    required this.onCharsReview,
    required this.onVocabReview,
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
        progress: charProgress,
        dueCount: charsDue,
        onTap: onCharactersTap,
        onReview: onCharsReview,
      ),
      SectionCard(
        title: l.navVocab, icon: '語',
        gradientColors: [t.vocabularyDark, t.vocabulary], progressColor: t.vocabulary,
        subtitle: 'N5 → N1',
        statLabel: totalVocab > 0 ? '$knownVocab / $totalVocab' : '—',
        progress: vocabProgress,
        dueCount: vocabDue,
        onTap: onVocabTap,
        onReview: onVocabReview,
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
