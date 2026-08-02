import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/grammar/grammar_models.dart';
import '../../../l10n/l10n.dart';
import '../common/japanese_sentence.dart';

class ExampleCard extends StatelessWidget {
  final GrammarExample example;
  final String locale;
  final bool showTranslation;

  const ExampleCard({
    super.key,
    required this.example,
    required this.locale,
    this.showTranslation = true,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: t.surfaceContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceSm,
              vertical: AppDimens.spaceXxs,
            ),
            decoration: BoxDecoration(
              color: t.primaryContainer,
              borderRadius: BorderRadius.circular(AppDimens.radiusPill),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/icons/example_icon.svg',
                  width: 12,
                  height: 12,
                  colorFilter: ColorFilter.mode(t.primary, BlendMode.srcIn),
                ),
                const SizedBox(width: AppDimens.spaceXxs),
                Text(
                  context.l10n.example,
                  style: AppTextStyles.labelSmall.copyWith(color: t.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spaceSm),
          Center(
            child: JapaneseSentence(
              sentence: example.sentence,
              highlight: example.highlight,
              hideHighlight: !showTranslation,
              highlightColor: t.primary,
              translation: showTranslation
                  ? (example.translation?[locale] ?? example.translation?['en'])
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
