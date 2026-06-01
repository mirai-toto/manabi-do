import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/l10n.dart';
import '../widgets/widgets.dart';
import 'characters_screen.dart';
import 'grammar_screen.dart';
import 'home_screen.dart';
import 'vocabulary_screen.dart';

class ShellScreen extends ConsumerStatefulWidget {
  const ShellScreen({super.key});

  @override
  ConsumerState<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends ConsumerState<ShellScreen> {
  int _currentIndex = 0;

  static const _screens = [
    HomeScreen(),
    CharactersScreen(),
    VocabularyScreen(),
    GrammarScreen(),
  ];

  List<NavDestination> _destinations(BuildContext context) {
    final l = context.l10n;
    return [
      NavDestination(label: l.navHome,          icon: '🏠'),
      NavDestination(label: l.sectionCharacters, icon: '字'),
      NavDestination(label: l.navVocab,          icon: '語'),
      NavDestination(label: l.sectionGrammar,    icon: '文'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final destinations = _destinations(context);
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    final body = IndexedStack(index: _currentIndex, children: _screens);

    if (isWide) {
      return Scaffold(
        backgroundColor: t.surfaceContainer,
        body: SafeArea(
          child: Row(
            children: [
              AppNavRail(
                destinations: destinations,
                selectedIndex: _currentIndex,
                onDestinationSelected: (i) => setState(() => _currentIndex = i),
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
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
