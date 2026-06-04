import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/database/app_database.dart';
import '../../../providers/vocab_provider.dart';

class KanjiHero extends ConsumerWidget {
  final Kanji kanji;
  final Color color;
  final VoidCallback onBack;
  const KanjiHero({super.key, required this.kanji, required this.color, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final darkColor  = Color.lerp(color, Colors.black, isDark ? 0.65 : 0.35)!;
    final lightColor = isDark ? Color.lerp(color, Colors.black, 0.30)! : color;
    final topPadding = MediaQuery.of(context).padding.top;

    final localizedAsync = ref.watch(localizedKanjiMeaningProvider(kanji.id));
    final localizedMeaning = localizedAsync.asData?.value ?? '';
    final meaning = localizedMeaning.isNotEmpty ? localizedMeaning : kanji.meaning;

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
          _BackButton(onTap: onBack),
          const SizedBox(height: AppDimens.spaceMd),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CharacterBox(character: kanji.character),
              const SizedBox(width: AppDimens.spaceMd),
              Expanded(child: _KanjiInfo(meaning: meaning, level: kanji.jlptLevel)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) => Container(
    width: 36,
    height: 36,
    clipBehavior: Clip.antiAlias,
    decoration: const BoxDecoration(
      color: Color(0x33ffffff),
      shape: BoxShape.circle,
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 18),
      ),
    ),
  );
}

class _CharacterBox extends StatelessWidget {
  final String character;
  const _CharacterBox({required this.character});

  @override
  Widget build(BuildContext context) => Container(
    width: 96,
    height: 96,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
    ),
    child: Center(
      child: Text(character, style: AppTextStyles.jpKanji.copyWith(color: Colors.white)),
    ),
  );
}

class _KanjiInfo extends StatelessWidget {
  final String meaning;
  final String level;
  const _KanjiInfo({required this.meaning, required this.level});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(meaning, style: AppTextStyles.title.copyWith(color: Colors.white)),
      const SizedBox(height: AppDimens.spaceXs),
      _LevelPill(level: level),
    ],
  );
}

class _LevelPill extends StatelessWidget {
  final String level;
  const _LevelPill({required this.level});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(100),
    ),
    child: Text(
      level,
      style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
    ),
  );
}
