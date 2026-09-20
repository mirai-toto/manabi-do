import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../widgets.dart';

/// Toggles for which decks appear on the home screen.
class HomeSettingsCard extends StatelessWidget {
  final bool showKana;
  final bool showKanji;
  final bool showVocab;
  final ValueChanged<bool> onShowKanaChanged;
  final ValueChanged<bool> onShowKanjiChanged;
  final ValueChanged<bool> onShowVocabChanged;

  const HomeSettingsCard({
    super.key,
    required this.showKana,
    required this.showKanji,
    required this.showVocab,
    required this.onShowKanaChanged,
    required this.onShowKanjiChanged,
    required this.onShowVocabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = context.l10n;
    final AppTokens t = context.tokens;

    Widget glyph(String char) => SizedBox(
      width: 20,
      child: Text(
        char,
        textAlign: TextAlign.center,
        style: AppTextStyles.jpBody.copyWith(color: t.onSurfaceVariant),
      ),
    );

    return SettingsCard(
      children: [
        SettingsToggle(
          leading: glyph('か'),
          label: l.kana,
          value: showKana,
          onChanged: onShowKanaChanged,
        ),
        SettingsToggle(
          leading: glyph('字'),
          label: l.tabKanji,
          value: showKanji,
          onChanged: onShowKanjiChanged,
        ),
        SettingsToggle(
          leading: glyph('語'),
          label: l.sectionVocabulary,
          value: showVocab,
          onChanged: onShowVocabChanged,
        ),
      ],
    );
  }
}
