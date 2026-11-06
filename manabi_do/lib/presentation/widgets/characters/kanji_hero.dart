import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../widgets.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/database/app_database.dart';

/// Full-width gradient hero banner for a kanji detail screen. Shows the
/// character, JLPT level badge, meanings, and a back button. The caller
/// resolves the meaning.
class KanjiHero extends StatelessWidget {
  final Kanji kanji;

  /// The meaning to show, already in the reader's language where possible.
  final String meaning;

  /// The reader's language, named, when [meaning] fell back to English.
  final String? missingLanguage;
  final Color color;
  final VoidCallback onBack;
  const KanjiHero({
    super.key,
    required this.kanji,
    required this.meaning,
    this.missingLanguage,
    required this.color,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final darkColor = Color.lerp(color, Colors.black, isDark ? 0.65 : 0.35)!;
    final lightColor = isDark ? Color.lerp(color, Colors.black, 0.30)! : color;
    final topPadding = MediaQuery.of(context).padding.top;
    // White is not always readable here: the hero is tinted with the kanji's
    // JLPT colour, and mid-tone levels drop it below AA. Measure against the
    // lighter end of the gradient, which is the worst case.
    final Color onAccent = onAccentFor(lightColor);

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
              CharacterHeroBox(
                character: kanji.character,
                size: 96,
                onAccentOverride: onAccent,
              ),
              const SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child: _KanjiInfo(
                  meaning: meaning,
                  level: kanji.jlptLevel,
                  onAccent: onAccent,
                  missingLanguage: missingLanguage,
                ),
              ),
              const SizedBox(width: AppDimens.spaceSm),
              // Beside the character rather than on it: over the glyph it was
              // small and hard to find.
              SpeakButton(
                text: kanji.character,
                color: onAccent,
                background: onAccent.withValues(alpha: 0.2),
                size: 22,
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
      child: Semantics(
        label: MaterialLocalizations.of(context).backButtonTooltip,
        button: true,
        excludeSemantics: true,
        child: InkWell(
          onTap: onTap,
          child: Icon(Icons.arrow_back_rounded, color: onAccent, size: 18),
        ),
      ),
    ),
  );
}

class _KanjiInfo extends StatelessWidget {
  final String meaning;
  final String level;
  final Color onAccent;
  final String? missingLanguage;
  const _KanjiInfo({
    required this.meaning,
    required this.level,
    required this.onAccent,
    this.missingLanguage,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              meaning,
              style: AppTextStyles.title.copyWith(color: onAccent),
            ),
          ),
          if (missingLanguage != null) ...[
            const SizedBox(width: AppDimens.spaceXs),
            TranslationFallbackInfo(
              language: missingLanguage!,
              color: onAccent,
            ),
          ],
        ],
      ),
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
