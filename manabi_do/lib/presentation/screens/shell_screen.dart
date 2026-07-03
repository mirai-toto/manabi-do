import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/l10n.dart';
import '../providers/home_provider.dart';
import '../widgets/widgets.dart';
import 'characters/characters_screen.dart';
import 'grammar/grammar_screen.dart';
import 'home/home_screen.dart';
import 'settings/settings_screen.dart';
import 'vocabulary/vocabulary_screen.dart';

class ShellScreen extends ConsumerStatefulWidget {
  const ShellScreen({super.key});

  @override
  ConsumerState<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends ConsumerState<ShellScreen> {
  static const _screenCount = 5;

  final _navKeys = List.generate(
    _screenCount,
    (_) => GlobalKey<NavigatorState>(),
  );

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  bool _onKey(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      _onBack();
      return true;
    }
    return false;
  }

  static const _screens = [
    HomeScreen(),
    CharactersScreen(),
    VocabularyScreen(),
    GrammarScreen(),
    SettingsScreen(),
  ];

  List<NavDestination> _destinations(BuildContext context) {
    final l = context.l10n;
    return [
      NavDestination(label: l.navHome, icon: '家'),
      NavDestination(label: l.sectionCharacters, icon: '字'),
      NavDestination(label: l.sectionVocabulary, icon: '語'),
      NavDestination(label: l.sectionGrammar, icon: '文'),
      NavDestination(label: l.navSettings, icon: '⚙'),
    ];
  }

  void _onBack() {
    final index = ref.read(selectedTabProvider);
    if (_navKeys[index].currentState?.canPop() ?? false) {
      if (ref.read(practiceActiveProvider)) return;
      _navKeys[index].currentState!.pop();
      return;
    }
    if (index == 1 && ref.read(kanjiSelectedLevelProvider) != null) {
      ref.read(kanjiSelectedLevelProvider.notifier).clear();
      return;
    }
    if (index == 2 && ref.read(vocabSelectedLevelProvider) != null) {
      ref.read(vocabSelectedLevelProvider.notifier).clear();
      return;
    }
    if (index == 3 && ref.read(grammarSelectedLevelProvider) != null) {
      ref.read(grammarSelectedLevelProvider.notifier).clear();
      return;
    }
    if (index != 0) {
      ref.read(selectedTabProvider.notifier).select(0);
    } else {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    void invalidateSrsCounts() {
      ref.invalidate(kanaDueCountProvider);
      ref.invalidate(kanjiDueCountProvider);
      ref.invalidate(vocabDueCountProvider);
    }

    ref.listen<int>(selectedTabProvider, (previous, next) {
      if (previous != null && previous != next) {
        _navKeys[next].currentState?.popUntil((route) => route.isFirst);
        invalidateSrsCounts();
      }
    });

    ref.listen<bool>(practiceActiveProvider, (previous, next) {
      if (previous == true && next == false) invalidateSrsCounts();
    });

    ref.listen(kanjiSelectedLevelProvider, (_, _) => invalidateSrsCounts());
    ref.listen(kanjiSelectedGroupProvider, (_, _) => invalidateSrsCounts());
    ref.listen(vocabSelectedLevelProvider, (_, _) => invalidateSrsCounts());
    ref.listen(vocabSelectedGroupProvider, (_, _) => invalidateSrsCounts());
    ref.listen(grammarSelectedLevelProvider, (_, _) => invalidateSrsCounts());

    final t = context.tokens;
    final destinations = _destinations(context);
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    final index = ref.watch(selectedTabProvider);
    final practiceActive = ref.watch(practiceActiveProvider);
    void setIndex(int i) {
      if (i == index) {
        _navKeys[i].currentState?.popUntil((route) => route.isFirst);
        switch (i) {
          case 1:
            ref.read(kanjiSelectedGroupProvider.notifier).clear();
            ref.read(kanjiSelectedLevelProvider.notifier).clear();
          case 2:
            ref.read(vocabSelectedGroupProvider.notifier).clear();
            ref.read(vocabSelectedLevelProvider.notifier).clear();
          case 3:
            ref.read(grammarSelectedLevelProvider.notifier).clear();
        }
        invalidateSrsCounts();
        return;
      }
      ref.read(selectedTabProvider.notifier).select(i);
    }

    final body = PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => _onBack(),
      child: IndexedStack(
        index: index,
        children: List.generate(
          _screenCount,
          (i) => Navigator(
            key: _navKeys[i],
            onGenerateRoute: (_) =>
                MaterialPageRoute(builder: (_) => _screens[i]),
          ),
        ),
      ),
    );

    if (isWide) {
      return Scaffold(
        backgroundColor: t.surfaceContainer,
        body: SafeArea(
          child: Row(
            children: [
              if (!practiceActive)
                AppNavRail(
                  destinations: destinations,
                  selectedIndex: index,
                  onDestinationSelected: setIndex,
                ),
              Expanded(child: body),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: t.surfaceContainer,
      body: SafeArea(child: body),
      bottomNavigationBar: practiceActive
          ? null
          : AppNavBar(
              destinations: destinations,
              selectedIndex: index,
              onDestinationSelected: setIndex,
            ),
    );
  }
}
