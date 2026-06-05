import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/l10n.dart';
import '../providers/home_provider.dart';
import '../widgets/widgets.dart';
import 'characters/characters_screen.dart';
import 'grammar/grammar_screen.dart';
import 'home_screen.dart';
import 'more/more_screen.dart';
import 'vocabulary/vocabulary_screen.dart';

class ShellScreen extends ConsumerStatefulWidget {
  const ShellScreen({super.key});

  @override
  ConsumerState<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends ConsumerState<ShellScreen> {
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
      NavDestination(label: l.navHome,           icon: '家'),
      NavDestination(label: l.sectionCharacters, icon: '字'),
      NavDestination(label: l.navVocab,          icon: '語'),
      NavDestination(label: l.sectionGrammar,    icon: '文'),
      NavDestination(label: l.navSettings,       icon: '⚙'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final destinations = _destinations(context);
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    final index = ref.watch(selectedTabProvider);
    void setIndex(int i) => ref.read(selectedTabProvider.notifier).select(i);

    final body = IndexedStack(index: index, children: _screens);

    if (isWide) {
      return Scaffold(
        backgroundColor: t.surfaceContainer,
        body: SafeArea(
          child: Row(
            children: [
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
      bottomNavigationBar: AppNavBar(
        destinations: destinations,
        selectedIndex: index,
        onDestinationSelected: setIndex,
      ),
    );
  }
}
