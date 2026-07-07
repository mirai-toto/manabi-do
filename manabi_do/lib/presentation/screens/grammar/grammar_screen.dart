import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../l10n/l10n.dart';
import '../../providers/home_provider.dart';
import '../../widgets/widgets.dart';
import 'grammar_chapter_list.dart';

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
        Positioned.fill(child: Center(child: _GrammarLockedOverlay())),
      ],
    );
  }
}

// ── Lock overlay ───────────────────────────────────────────────────────────────

class _GrammarLockedOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceLg,
          vertical: AppDimens.spaceLg,
        ),
        decoration: BoxDecoration(
          color: t.cardBackground,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline_rounded, size: 40, color: t.primary),
            const SizedBox(height: AppDimens.spaceMd),
            Text(
              l.grammarLockedTitle,
              style: AppTextStyles.titleLarge.copyWith(color: t.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceSm),
            Text(
              l.grammarLockedSubtitle,
              style: AppTextStyles.body.copyWith(color: t.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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

  static final _color = levelColor('basics');

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    return TappableSurface(
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
                child: Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white,
                  size: 24,
                ),
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
                  const SizedBox(height: AppDimens.spaceXs),
                  Text(
                    l.japaneseBasicsSubtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: t.onSurfaceVariant,
                    ),
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
