import 'package:flutter/material.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/l10n.dart';
import '../widgets/widgets.dart';
import 'widget_gallery_screen.dart';

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
    final l = context.l10n;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimens.screenMaxWidth),
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
          children: [
            _HomeHeader(greeting: _greeting(context), subtitle: l.greetingSubtitle),
            const _DevGalleryLink(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
              child: Column(children: [
                const _SectionCards(),
                const SizedBox(height: AppDimens.spaceLg),
                StreakCard(days: 7, label: l.streakLabel, subtitle: l.streakSubtitle),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCards extends StatelessWidget {
  const _SectionCards();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final cards = [
      SectionCard(
        title: l.sectionGrammar, icon: '文',
        gradientColors: [t.primary, t.primaryLight], progressColor: t.primary,
        subtitle: '17 chapters · N5/N4', statLabel: '3 / 17 chapters',
        progress: 0.18, onTap: () {},
      ),
      SectionCard(
        title: l.sectionCharacters, icon: '字',
        gradientColors: [t.charactersDark, t.characters], progressColor: t.characters,
        subtitle: 'Kana · Kanji N5/N4', statLabel: '46 / 184 known',
        progress: 0.25, onTap: () {},
      ),
      SectionCard(
        title: l.sectionVocabulary, icon: '語',
        gradientColors: [t.vocabularyDark, t.vocabulary], progressColor: t.vocabulary,
        subtitle: '800+ words · N5/N4', statLabel: '120 / 800 known',
        progress: 0.15, onTap: () {},
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

class _DevGalleryLink extends StatelessWidget {
  const _DevGalleryLink();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: AppDimens.spaceMd, bottom: AppDimens.spaceXs),
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const WidgetGalleryScreen()),
          ),
          child: Text(
            'Widget Gallery →',
            style: AppTextStyles.labelSmall.copyWith(color: t.onSurfaceVariant),
          ),
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
          const _AvatarPlaceholder(),
        ],
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: t.primaryContainer, shape: BoxShape.circle),
      child: Center(
        child: Text('?', style: AppTextStyles.title.copyWith(color: t.primary)),
      ),
    );
  }
}
