import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_dimens.dart';
import '../widgets.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/database/app_database.dart';
import '../../providers/vocabulary_provider.dart';

class KanjiHero extends ConsumerWidget {
  final Kanji kanji;
  final Color color;
  final VoidCallback onBack;
  const KanjiHero({
    super.key,
    required this.kanji,
    required this.color,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final darkColor = Color.lerp(color, Colors.black, isDark ? 0.65 : 0.35)!;
    final lightColor = isDark ? Color.lerp(color, Colors.black, 0.30)! : color;
    final topPadding = MediaQuery.of(context).padding.top;
    // White is not always readable here: the hero is tinted with the kanji's
    // JLPT colour, and mid-tone levels drop it below AA. Measure against the
    // lighter end of the gradient, which is the worst case.
    final Color onAccent = onAccentFor(lightColor);

    final localizedAsync = ref.watch(localizedKanjiMeaningProvider(kanji.id));
    final localizedMeaning = localizedAsync.asData?.value ?? '';
    final meaning = localizedMeaning.isNotEmpty
        ? localizedMeaning
        : kanji.meaning;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [darkColor, lightColor],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppDimens.spaceMd,
        topPadding + AppDimens.spaceSm,
        AppDimens.spaceMd,
        AppDimens.spaceLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BackButton(onTap: onBack, onAccent: onAccent),
          const SizedBox(height: AppDimens.spaceMd),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CharacterHeroBox(
                    character: kanji.character,
                    size: 96,
                    onAccentOverride: onAccent,
                  ),
                  Positioned(
                    top: AppDimens.spaceSm,
                    right: AppDimens.spaceSm,
                    child: SpeakButton(
                      text: kanji.character,
                      color: onAccent.withValues(alpha: 0.8),
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child: _KanjiInfo(
                  meaning: meaning,
                  level: kanji.jlptLevel,
                  onAccent: onAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color onAccent;
  const _BackButton({required this.onTap, required this.onAccent});

  @override
  Widget build(BuildContext context) => Container(
    width: 36,
    height: 36,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: onAccent.withValues(alpha: 0.2),
      shape: BoxShape.circle,
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Icon(Icons.arrow_back_rounded, color: onAccent, size: 18),
      ),
    ),
  );
}

class _KanjiInfo extends StatelessWidget {
  final String meaning;
  final String level;
  final Color onAccent;
  const _KanjiInfo({
    required this.meaning,
    required this.level,
    required this.onAccent,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(meaning, style: AppTextStyles.title.copyWith(color: onAccent)),
      const SizedBox(height: AppDimens.spaceXs),
      _LevelPill(level: level, onAccent: onAccent),
    ],
  );
}

class _LevelPill extends StatelessWidget {
  final String level;
  final Color onAccent;
  const _LevelPill({required this.level, required this.onAccent});

  @override
  Widget build(BuildContext context) => PillBadge(
    label: level,
    color: onAccent,
    background: onAccent.withValues(alpha: 0.2),
  );
}
