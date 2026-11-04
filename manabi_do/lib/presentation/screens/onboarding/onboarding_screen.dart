import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/home_settings_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/onboarding_provider.dart';
import '../../../core/providers/srs_settings_provider.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/vocabulary_level.dart';
import '../../../l10n/l10n.dart';
import '../../widgets/widgets.dart';

/// The four screens shown once, before the first session.
///
/// Three of them set something the app already stores: the locale, the home
/// sections, and the daily pace. The second asks for nothing — it is the one
/// that explains why the word order is what it is, and a learner who has seen
/// it accepts five a day instead of wondering why 日本 is not lesson one.
///
/// Every setting here has a working default, so [onboardingSkip] from the last
/// screen leaves nothing unset.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pages = PageController();
  int _page = 0;

  static const int _pageCount = 4;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _next() {
    if (_page >= _pageCount - 1) {
      _finish();
      return;
    }
    _pages.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  Future<void> _finish() async {
    await ref.read(onboardingSeenProvider.notifier).markSeen();
  }

  @override
  Widget build(BuildContext context) {
    final AppTokens t = context.tokens;
    final AppLocalizations l = context.l10n;
    final home = ref.watch(homeSettingsProvider);
    final bool canContinue =
        _page != 2 || home.showKana || home.showKanji || home.showVocabulary;

    return Scaffold(
      backgroundColor: t.surface,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimens.screenMaxWidth,
            ),
            child: Column(
              children: [
                _Progress(page: _page, total: _pageCount),
                Expanded(
                  child: PageView(
                    controller: _pages,
                    onPageChanged: (i) => setState(() => _page = i),
                    children: const [
                      _LanguagePage(),
                      _HookPage(),
                      _SectionsPage(),
                      _PacePage(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimens.spaceMd,
                    AppDimens.spaceSm,
                    AppDimens.spaceMd,
                    AppDimens.spaceMd,
                  ),
                  child: Column(
                    children: [
                      if (!canContinue) ...[
                        Text(
                          l.onboardingPickOne,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: t.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceSm),
                      ],
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: canContinue ? _next : null,
                          style: FilledButton.styleFrom(
                            backgroundColor: t.primary,
                            foregroundColor: t.onPrimary,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppDimens.spaceMd,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimens.radiusMd,
                              ),
                            ),
                          ),
                          child: Text(
                            _page == _pageCount - 1
                                ? l.onboardingStart
                                : l.onboardingContinue,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      // Only on the last screen: by then every default has
                      // been seen, so skipping is a choice rather than a way
                      // past something unexplained.
                      if (_page == _pageCount - 1)
                        TextButton(
                          onPressed: _finish,
                          child: Text(
                            l.onboardingSkip,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: t.onSurfaceVariant,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  final int page;
  final int total;

  const _Progress({required this.page, required this.total});

  @override
  Widget build(BuildContext context) {
    final AppTokens t = context.tokens;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceMd,
        AppDimens.spaceMd,
        AppDimens.spaceMd,
        AppDimens.spaceSm,
      ),
      child: Row(
        children: [
          for (int i = 0; i < total; i++) ...[
            if (i > 0) const SizedBox(width: AppDimens.spaceXs),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                height: 4,
                decoration: BoxDecoration(
                  color: i <= page ? t.primary : t.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Shared frame: a title, a line of explanation, then whatever the page asks.
class _Page extends StatelessWidget {
  final String title;
  final String body;
  final Widget child;
  final Widget? hero;

  const _Page({
    required this.title,
    required this.body,
    required this.child,
    this.hero,
  });

  @override
  Widget build(BuildContext context) {
    final AppTokens t = context.tokens;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hero != null) ...[
            const SizedBox(height: AppDimens.spaceMd),
            Center(child: hero!),
            const SizedBox(height: AppDimens.spaceSm),
          ],
          const SizedBox(height: AppDimens.spaceSm),
          Text(
            title,
            style: AppTextStyles.headline.copyWith(color: t.onSurface),
          ),
          const SizedBox(height: AppDimens.spaceSm),
          Text(
            body,
            style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          child,
          const SizedBox(height: AppDimens.spaceLg),
        ],
      ),
    );
  }
}

class _LanguagePage extends ConsumerWidget {
  const _LanguagePage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTokens t = context.tokens;
    final l = context.l10n;
    final String current = ref.watch(localeProvider).languageCode;

    return _Page(
      // jpDisplay, not jpHero: at 96px four kana are wider than a phone and
      // ようこそ broke across two lines. FittedBox shrinks it further on a
      // narrow screen rather than letting it wrap again.
      hero: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'ようこそ',
          maxLines: 1,
          softWrap: false,
          style: AppTextStyles.jpDisplay.copyWith(color: t.primary),
        ),
      ),
      title: l.onboardingWelcome,
      body: l.onboardingLanguageBody,
      child: Column(
        children: [
          for (final lang in languages) ...[
            _Choice(
              label: lang.name,
              leading: AppEmoji(lang.flag, size: 22),
              selected: lang.code == current,
              onTap: () => ref
                  .read(localeProvider.notifier)
                  .setLocale(Locale(lang.code)),
            ),
            const SizedBox(height: AppDimens.spaceSm),
          ],
        ],
      ),
    );
  }
}

class _HookPage extends StatelessWidget {
  const _HookPage();

  /// The first three levels, as the shipped content measures them. Enough to
  /// show the shape; all five would be a chart rather than a point.
  static const List<(int, String, double, double)> _levels = [
    (1, '750', 0.512, 1.0),
    (2, '1,250', 0.112, 0.22),
    (3, '2,000', 0.074, 0.145),
  ];

  @override
  Widget build(BuildContext context) {
    final AppTokens t = context.tokens;
    final l = context.l10n;
    final Brightness brightness = Theme.of(context).brightness;

    return _Page(
      title: l.onboardingHookTitle,
      body: l.onboardingHookBody,
      child: CardContainer(
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        child: Column(
          children: [
            for (final (level, count, share, width) in _levels) ...[
              if (level > 1) const SizedBox(height: AppDimens.spaceMd),
              _LevelBar(
                label: l.onboardingLevelWords(level, count),
                share: share,
                width: width,
                color: vocabularyLevelColor(level, brightness),
                track: t.surfaceContainer,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LevelBar extends StatelessWidget {
  final String label;
  final double share;
  final double width;
  final Color color;
  final Color track;

  const _LevelBar({
    required this.label,
    required this.share,
    required this.width,
    required this.color,
    required this.track,
  });

  @override
  Widget build(BuildContext context) {
    final AppTokens t = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: t.onSurfaceVariant,
                ),
              ),
            ),
            Text(
              '${(share * 100).toStringAsFixed(1)}%',
              style: AppTextStyles.labelSmall.copyWith(
                color: t.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceXs),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: width,
            minHeight: 8,
            backgroundColor: track,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _SectionsPage extends ConsumerWidget {
  const _SectionsPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final home = ref.watch(homeSettingsProvider);
    final notifier = ref.read(homeSettingsProvider.notifier);

    return _Page(
      title: l.onboardingStudyTitle,
      body: l.onboardingStudyBody,
      child: Column(
        children: [
          _Choice(
            label: l.kana,
            selected: home.showKana,
            onTap: () => notifier.setShowKana(!home.showKana),
          ),
          const SizedBox(height: AppDimens.spaceSm),
          _Choice(
            label: l.tabKanji,
            selected: home.showKanji,
            onTap: () => notifier.setShowKanji(!home.showKanji),
          ),
          const SizedBox(height: AppDimens.spaceSm),
          _Choice(
            label: l.sectionVocabulary,
            selected: home.showVocabulary,
            onTap: () => notifier.setShowVocabulary(!home.showVocabulary),
          ),
        ],
      ),
    );
  }
}

class _PacePage extends ConsumerWidget {
  const _PacePage();

  /// Roughly how long a day's work takes, for the estimate under the steppers.
  /// A new item costs more than a review, and reviews pile up to a few times
  /// the daily intake once a deck is going.
  static int _minutes(int characters, int words) {
    final double perDay =
        (characters + words) * 0.5 + (characters + words) * 1.0;
    return perDay.clamp(1, 120).round();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTokens t = context.tokens;
    final l = context.l10n;
    final srs = ref.watch(srsSettingsProvider);
    final notifier = ref.read(srsSettingsProvider.notifier);

    return _Page(
      title: l.onboardingPaceTitle,
      body: l.onboardingPaceBody,
      child: Column(
        children: [
          SettingsCard(
            children: [
              SettingsStepper(
                icon: Icons.translate_rounded,
                label: l.settingsPracticeNewCharacters,
                value: srs.newCharactersPerDay,
                onDecrement: srs.newCharactersPerDay > 0
                    ? () => notifier.setNewCharactersPerDay(
                        srs.newCharactersPerDay - 1,
                      )
                    : null,
                onIncrement: srs.newCharactersPerDay < 50
                    ? () => notifier.setNewCharactersPerDay(
                        srs.newCharactersPerDay + 1,
                      )
                    : null,
              ),
              SettingsStepper(
                icon: Icons.menu_book_rounded,
                label: l.settingsPracticeNewVocabulary,
                value: srs.newVocabularyPerDay,
                onDecrement: srs.newVocabularyPerDay > 0
                    ? () => notifier.setNewVocabularyPerDay(
                        srs.newVocabularyPerDay - 1,
                      )
                    : null,
                onIncrement: srs.newVocabularyPerDay < 50
                    ? () => notifier.setNewVocabularyPerDay(
                        srs.newVocabularyPerDay + 1,
                      )
                    : null,
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMd),
          Text(
            l.onboardingPaceEstimate(
              _minutes(srs.newCharactersPerDay, srs.newVocabularyPerDay),
            ),
            style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// A tappable row that reads as chosen or not. Used for both the language
/// list, where one wins, and the sections, where any number can.
class _Choice extends StatelessWidget {
  final String label;
  final Widget? leading;
  final bool selected;
  final VoidCallback onTap;

  const _Choice({
    required this.label,
    required this.selected,
    required this.onTap,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final AppTokens t = context.tokens;
    return Material(
      color: selected ? t.primaryContainer : t.cardBackground,
      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMd,
            vertical: AppDimens.spaceCozy,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? t.primary : t.outlineVariant,
              width: AppDimens.borderWidthContainer,
            ),
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          ),
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: AppDimens.spaceMd),
              ],
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    color: selected ? t.onPrimaryContainer : t.onSurface,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              Icon(
                selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                size: 20,
                color: selected ? t.primary : t.outlineVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
