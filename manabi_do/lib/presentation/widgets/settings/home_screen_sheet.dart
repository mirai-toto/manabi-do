import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import 'home_settings_card.dart';

/// Which sections the home screen offers, as a sheet.
///
/// Three switches that were open on the settings screen. They are changed once
/// and then left alone, so they cost a tap now and the screen is shorter for
/// it.
Future<void> showHomeScreenSheet(
  BuildContext context, {
  required bool showKana,
  required bool showKanji,
  required bool showVocabulary,
  required ValueChanged<bool> onShowKanaChanged,
  required ValueChanged<bool> onShowKanjiChanged,
  required ValueChanged<bool> onShowVocabularyChanged,
}) {
  final AppTokens t = context.tokens;
  // The sheet keeps its own copy: the values passed in are a snapshot taken
  // when it opened, and nothing rebuilds a sheet when the caller's state
  // changes, so the switches never moved although each tap was saved.
  bool kana = showKana;
  bool kanji = showKanji;
  bool vocabulary = showVocabulary;
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: t.surface,
    showDragHandle: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.spaceMd,
            0,
            AppDimens.spaceMd,
            AppDimens.spaceMd,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.settingsHomeScreen,
                style: AppTextStyles.title.copyWith(color: t.onSurface),
              ),
              const SizedBox(height: AppDimens.spaceXs),
              Text(
                context.l10n.settingsHomeScreenHint,
                style: AppTextStyles.bodySmall.copyWith(
                  color: t.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppDimens.spaceMd),
              HomeSettingsCard(
                showKana: kana,
                showKanji: kanji,
                showVocabulary: vocabulary,
                onShowKanaChanged: (v) {
                  setState(() => kana = v);
                  onShowKanaChanged(v);
                },
                onShowKanjiChanged: (v) {
                  setState(() => kanji = v);
                  onShowKanjiChanged(v);
                },
                onShowVocabularyChanged: (v) {
                  setState(() => vocabulary = v);
                  onShowVocabularyChanged(v);
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
