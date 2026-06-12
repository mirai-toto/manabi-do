import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../widgets/widgets.dart';
import 'grammar_chapter_list.dart';

const _levels = ['N5', 'N4', 'N3', 'N2', 'N1'];

class GrammarScreen extends ConsumerStatefulWidget {
  const GrammarScreen({super.key});

  @override
  ConsumerState<GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends ConsumerState<GrammarScreen> {
  String? _selectedLevel;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: l.sectionGrammar,
          subtitle: l.grammarSubtitle,
          glyph: '文',
          color: t.primary,
        ),
        Expanded(
          child: _selectedLevel == null
              ? _LevelSelector(onSelect: (level) => setState(() => _selectedLevel = level))
              : GrammarChapterList(
                  level: _selectedLevel!,
                  onBack: () => setState(() => _selectedLevel = null),
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
        _BasicsCard(onTap: () => onSelect('basics')),
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

// ── Basics card ────────────────────────────────────────────────────────────────

class _BasicsCard extends StatelessWidget {
  final VoidCallback onTap;
  const _BasicsCard({required this.onTap});

  static const _color = Color(0xFF795548);

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    return TappableCard(
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(color: _color.withValues(alpha: 0.35)),
      ),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _color,
                borderRadius: BorderRadius.circular(AppDimens.radiusSm),
              ),
              child: const Center(
                child: Icon(Icons.menu_book_rounded, color: Colors.white, size: 24),
              ),
            ),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.japaneseBasics,
                    style: AppTextStyles.body.copyWith(
                      color: t.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l.japaneseBasicsSubtitle,
                    style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: t.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
