import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/srs_settings_provider.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../providers/database_provider.dart';
import '../../providers/home_provider.dart';
import '../../widgets/widgets.dart';
import '../practice/practice_selection_screen.dart';
import '../practice/practice_session_screen.dart';
import 'home_domain_cards.dart';
import 'home_header.dart';
import 'home_review_queues.dart';

const _kTabCharacters = 1;
const _kTabVocabulary = 2;
const _kTabGrammar = 3;

String _greeting(BuildContext context) {
  final hour = DateTime.now().hour;
  final l = context.l10n;
  if (hour < 12) return l.greetingMorning;
  if (hour < 18) return l.greetingAfternoon;
  return l.greetingEvening;
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _refresh(),
    );
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
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    final totalKanji = ref.watch(totalKanjiProvider).asData?.value ?? 0;
    final totalKana = ref.watch(totalKanaProvider).asData?.value ?? 0;
    final totalVocab = ref.watch(totalVocabProvider).asData?.value ?? 0;
    final totalChars = totalKana + totalKanji;

    final charsDue = ref.watch(charactersDueCountProvider).asData?.value ?? 0;
    final charsNew = ref.watch(charactersNewCountProvider).asData?.value ?? 0;
    final vocabDue = ref.watch(vocabDueCountProvider).asData?.value ?? 0;
    final vocabNew = ref.watch(vocabNewCountProvider).asData?.value ?? 0;

    void goTo(int tab) => ref.read(selectedTabProvider.notifier).select(tab);

    void openCharsPractice() {
      final t = context.tokens;
      final db = ref.read(databaseProvider);
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (ctx) => PracticeSelectionScreen(
            title: l.sectionCharacters,
            color: t.characters,
            modes: [
              PracticeMode(
                icon: Icons.translate_rounded,
                title: l.kana,
                counts: () async {
                  final s = await ref.read(srsSettingsProvider.future);
                  final session = await db.getAllDueKanaSrsSession(
                    newCardLimit: s.newCharactersPerDay,
                  );
                  return (
                    session.where((p) => p.$2 != null).length,
                    session.where((p) => p.$2 == null).length,
                  );
                },
                onTap: () async => Navigator.of(ctx).push(
                  MaterialPageRoute<void>(
                    builder: (_) => PracticeSessionScreen(
                      title: l.kana,
                      color: t.characters,
                      loadQueue: loadKanaQueue,
                    ),
                  ),
                ),
              ),
              PracticeMode(
                icon: Icons.calendar_today_rounded,
                title: l.tabKanji,
                counts: () async {
                  final s = await ref.read(srsSettingsProvider.future);
                  final session = await db.getAllDueKanjiSrsSession(
                    newCardLimit: s.newCharactersPerDay,
                  );
                  return (
                    session.where((p) => p.$2 != null).length,
                    session.where((p) => p.$2 == null).length,
                  );
                },
                onTap: () async => Navigator.of(ctx).push(
                  MaterialPageRoute<void>(
                    builder: (_) => PracticeSessionScreen(
                      title: l.tabKanji,
                      color: t.characters,
                      loadQueue: loadKanjiQueue,
                    ),
                  ),
                ),
              ),
              PracticeMode(
                icon: Icons.explore_rounded,
                title: l.freePractice,
                onTap: () async {
                  Navigator.of(ctx).pop();
                  goTo(_kTabCharacters);
                },
              ),
            ],
          ),
        ),
      );
    }

    void openVocabPractice() {
      final t = context.tokens;
      final db = ref.read(databaseProvider);
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (ctx) => PracticeSelectionScreen(
            title: l.navVocab,
            color: t.vocabulary,
            modes: [
              PracticeMode(
                icon: Icons.calendar_today_rounded,
                title: l.dailyTraining,
                counts: () async {
                  final s = await ref.read(srsSettingsProvider.future);
                  final session = await db.getAllDueVocabSrsSession(
                    newCardLimit: s.newVocabPerDay,
                  );
                  return (
                    session.where((p) => p.$2 != null).length,
                    session.where((p) => p.$2 == null).length,
                  );
                },
                onTap: () async => Navigator.of(ctx).push(
                  MaterialPageRoute<void>(
                    builder: (_) => PracticeSessionScreen(
                      title: l.navVocab,
                      color: t.vocabulary,
                      loadQueue: loadVocabQueue,
                    ),
                  ),
                ),
              ),
              PracticeMode(
                icon: Icons.explore_rounded,
                title: l.freePractice,
                onTap: () async {
                  Navigator.of(ctx).pop();
                  goTo(_kTabVocabulary);
                },
              ),
              PracticeMode(
                icon: Icons.chat_bubble_outline_rounded,
                title: l.sentencePractice,
                onTap: () async => Navigator.of(ctx).push(
                  MaterialPageRoute<void>(
                    builder: (_) => PracticeSessionScreen(
                      title: l.sentencePractice,
                      color: t.vocabulary,
                      loadQueue: loadVocabSentenceQueue,
                      settingsContexts: const {SettingsContext.sentence},
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimens.screenMaxWidth),
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
          children: [
            HomeHeader(
              greeting: _greeting(context),
              subtitle: l.greetingSubtitle,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
              ),
              child: Column(
                children: [
                  HomeDomainCards(
                    totalChars: totalChars,
                    totalVocab: totalVocab,
                    charsDue: charsDue,
                    charsNew: charsNew,
                    vocabDue: vocabDue,
                    vocabNew: vocabNew,
                    onCharactersTap: () => goTo(_kTabCharacters),
                    onVocabTap: () => goTo(_kTabVocabulary),
                    onGrammarTap: () => goTo(_kTabGrammar),
                    onCharsPractice: openCharsPractice,
                    onVocabPractice: openVocabPractice,
                  ),
                  const SizedBox(height: AppDimens.spaceLg),
                  StreakCard(
                    days: ref.watch(streakDaysProvider).asData?.value ?? 0,
                    label: l.streakLabel,
                    subtitle: l.streakSubtitle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
