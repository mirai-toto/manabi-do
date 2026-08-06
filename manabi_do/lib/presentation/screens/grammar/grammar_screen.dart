import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../l10n/l10n.dart';
import '../../providers/home_provider.dart';
import '../../widgets/widgets.dart';

const _grammarEnabled = false;

const _levels = ['N5', 'N4', 'N3', 'N2', 'N1'];

class GrammarScreen extends ConsumerWidget {
  const GrammarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final t = context.tokens;
    final selectedLevel = ref.watch(grammarSelectedLevelProvider);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: l.sectionGrammar,
          subtitle: l.grammarSubtitle,
          glyph: '文',
          color: t.primary,
        ),
        Expanded(
          child: selectedLevel == null
              ? _LevelSelector(
                  onSelect: (level) => ref
                      .read(grammarSelectedLevelProvider.notifier)
                      .select(level),
                )
              : GrammarChapterList(
                  level: selectedLevel,
                  onBack: () =>
                      ref.read(grammarSelectedLevelProvider.notifier).clear(),
                ),
        ),
      ],
    );

    if (_grammarEnabled || kDebugMode) return content;

    return Stack(
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: IgnorePointer(child: content),
        ),
        Positioned.fill(
          child: Center(
            child: LockedFeatureCard(
              title: l.grammarLockedTitle,
              subtitle: l.grammarLockedSubtitle,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Level selector ─────────────────────────────────────────────────────────────

class _LevelSelector extends StatelessWidget {
  final void Function(String) onSelect;
  const _LevelSelector({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      children: [
        PracticeModeCard(
          title: l.japaneseBasics,
          subtitle: l.japaneseBasicsSubtitle,
          icon: Icons.menu_book_rounded,
          color: levelColor('basics'),
          onTap: () => onSelect('basics'),
        ),
        const SizedBox(height: AppDimens.spaceSm),
        SectionLabel(l.selectLevel),
        const SizedBox(height: AppDimens.spaceSm),
        for (final level in _levels)
          JlptLevelCard(
            code: level,
            subtitle: level == 'N5' ? null : l.comingSoon,
            onTap: () {
              if (level == 'N5') {
                onSelect(level);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l.comingSoon),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
      ],
    );
  }
}
