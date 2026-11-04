import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/providers/home_settings_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/srs_settings_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../services/feedback_service.dart';
import '../../services/srs_service.dart';
import '../../services/support_service.dart';
import '../../widgets/widgets.dart';
import 'exercise_settings_screen.dart';

/// Order the appearance segments are shown in. Listed explicitly so it cannot
/// drift from `ThemeMode`'s declaration order.
const List<ThemeMode> _themeModes = [
  ThemeMode.system,
  ThemeMode.light,
  ThemeMode.dark,
];

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmResetAll(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: l.resetProgressTitle,
      body: l.resetProgressBody,
    );
    if (!confirmed) return;
    await ref.read(srsServiceProvider).resetAll();
  }

  Future<void> _sendFeedback(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
  ) async {
    final PackageInfo? info = ref.read(packageInfoProvider).asData?.value;
    final bool opened = await openFeedbackEmail(
      subject: l.feedbackEmailSubject,
      bodyHint: l.feedbackEmailBodyHint,
      version: info?.version ?? '',
      buildNumber: info?.buildNumber ?? '',
      languageCode: ref.read(localeProvider).languageCode,
    );
    if (opened || !context.mounted) return;

    // No mail app could take the link, so show the address rather than let the
    // tap do nothing.
    _showCopyableSnackBar(
      context,
      message: l.feedbackNoMailApp(feedbackEmailAddress),
      value: feedbackEmailAddress,
      copiedMessage: l.feedbackAddressCopied,
      copyLabel: l.copy,
    );
  }

  Future<void> _openSupport(BuildContext context, AppLocalizations l) async {
    final bool opened = await openSupportPage();
    if (opened || !context.mounted) return;

    _showCopyableSnackBar(
      context,
      message: l.supportNoBrowser(supportPageUrl),
      value: supportPageUrl,
      copiedMessage: l.supportLinkCopied,
      copyLabel: l.copy,
    );
  }

  /// Reports a link we could not open, with the raw value on offer so the user
  /// can still reach it by hand.
  void _showCopyableSnackBar(
    BuildContext context, {
    required String message,
    required String value,
    required String copiedMessage,
    required String copyLabel,
  }) {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: copyLabel,
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: value));
            messenger.showSnackBar(SnackBar(content: Text(copiedMessage)));
          },
        ),
      ),
    );
  }

  void _showLanguagePicker(
    BuildContext context,
    WidgetRef ref,
    String current,
    String title,
  ) {
    final t = context.tokens;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: t.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusLg),
        ),
      ),
      builder: (_) => LanguagePickerSheet(
        currentCode: current,
        title: title,
        onSelect: (code) {
          ref.read(localeProvider.notifier).setLocale(Locale(code));
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final t = context.tokens;
    final themeMode =
        ref.watch(themeModeProvider).asData?.value ?? ThemeMode.system;
    final locale = ref.watch(localeProvider);

    final SrsSettings srs =
        ref.watch(srsSettingsProvider).asData?.value ?? const SrsSettings();
    final SrsSettingsNotifier srsNotifier = ref.read(
      srsSettingsProvider.notifier,
    );

    final HomeSettings home =
        ref.watch(homeSettingsProvider).asData?.value ?? const HomeSettings();
    final HomeSettingsNotifier homeNotifier = ref.read(
      homeSettingsProvider.notifier,
    );

    final currentLang = languages.firstWhere(
      (e) => e.code == locale.languageCode,
      orElse: () => languages.first,
    );

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimens.screenMaxWidth),
        child: ListView(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          children: [
            _ScreenHeader(),
            const SizedBox(height: AppDimens.spaceLg),

            SectionLabel(l.settingsPractice),
            const SizedBox(height: AppDimens.spaceSm),
            PracticeSettingsCard(
              newCharactersPerDay: srs.newCharactersPerDay,
              newVocabularyPerDay: srs.newVocabularyPerDay,
              onNewCharactersChanged: srsNotifier.setNewCharactersPerDay,
              onNewVocabularyChanged: srsNotifier.setNewVocabularyPerDay,
              detailedGrading: srs.detailedGrading,
              onDetailedGradingChanged: srsNotifier.setDetailedGrading,
            ),

            const SizedBox(height: AppDimens.spaceSm),
            Text(
              l.settingsStudyScopeNote,
              style: AppTextStyles.bodySmall.copyWith(
                color: t.onSurfaceVariant,
              ),
            ),

            // The twenty-two exercise settings that used to be reachable only
            // from inside a running session. One row per store, because
            // nothing is kept per section: grammar reads the same flashcard
            // and multiple-choice values that vocabulary and kanji do.
            const SizedBox(height: AppDimens.spaceLg),
            SectionLabel(l.settingsExercises),
            const SizedBox(height: AppDimens.spaceSm),
            SettingsCard(
              children: [
                for (final kind in ExerciseKind.values)
                  SettingsTile(
                    leading: Icon(
                      _exerciseIcon(kind),
                      size: 20,
                      color: t.onSurfaceVariant,
                    ),
                    label: _exerciseLabel(kind, l),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ExerciseSettingsScreen(kind: kind),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceSm),
            Text(
              l.settingsExercisesNote,
              style: AppTextStyles.bodySmall.copyWith(
                color: t.onSurfaceVariant,
              ),
            ),

            // App chrome: how it looks, what language it speaks, what it
            // opens on. Theme stays a segmented control, because a three-way
            // choice shows every option in the height one row would cost.
            const SizedBox(height: AppDimens.spaceLg),
            SectionLabel(l.settingsApp),
            const SizedBox(height: AppDimens.spaceSm),
            SegmentedControl(
              options: [
                l.settingsThemeSystem,
                l.settingsThemeLight,
                l.settingsThemeDark,
              ],
              icons: const [
                Icons.brightness_auto_rounded,
                Icons.light_mode_rounded,
                Icons.dark_mode_rounded,
              ],
              selected: _themeModes.indexOf(themeMode),
              onSelect: (i) =>
                  ref.read(themeModeProvider.notifier).setMode(_themeModes[i]),
            ),
            const SizedBox(height: AppDimens.spaceSm),
            SettingsCard(
              children: [
                SettingsTile(
                  leading: Text(
                    currentLang.flag,
                    style: const TextStyle(
                      fontSize: 22,
                      fontFamily: 'NotoColorEmoji',
                    ),
                  ),
                  label: l.settingsLanguage,
                  value: currentLang.name,
                  onTap: () => _showLanguagePicker(
                    context,
                    ref,
                    locale.languageCode,
                    l.settingsLanguage,
                  ),
                ),
                SettingsTile(
                  leading: Icon(
                    Icons.home_outlined,
                    size: 20,
                    color: t.onSurfaceVariant,
                  ),
                  label: l.settingsHomeScreen,
                  value: _homeSummary(home, l),
                  onTap: () => showHomeScreenSheet(
                    context,
                    showKana: home.showKana,
                    showKanji: home.showKanji,
                    showVocabulary: home.showVocabulary,
                    onShowKanaChanged: homeNotifier.setShowKana,
                    onShowKanjiChanged: homeNotifier.setShowKanji,
                    onShowVocabularyChanged: homeNotifier.setShowVocabulary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimens.spaceLg),
            SettingsAboutSection(
              onSendFeedback: () => _sendFeedback(context, ref, l),
              onSupport: () => _openSupport(context, l),
            ),

            // Last, and on its own. Everything above changes a preference;
            // this deletes what you have learned.
            const SizedBox(height: AppDimens.spaceLg),
            SettingsCard(
              children: [
                SettingsTile(
                  leading: Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: t.error,
                  ),
                  label: l.settingsResetProgress,
                  labelColor: t.error,
                  onTap: () => _confirmResetAll(context, ref, l),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceLg),
          ],
        ),
      ),
    );
  }
}

class _ScreenHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(top: AppDimens.spaceSm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l.navSettings,
              style: AppTextStyles.headline.copyWith(color: t.onSurface),
            ),
          ),
          Icon(Icons.settings_rounded, color: t.onSurfaceVariant, size: 26),
        ],
      ),
    );
  }
}

IconData _exerciseIcon(ExerciseKind kind) => switch (kind) {
  ExerciseKind.flashcard => Icons.style_rounded,
  ExerciseKind.mcq => Icons.list_alt_rounded,
  ExerciseKind.sentence => Icons.format_quote_rounded,
  ExerciseKind.writing => Icons.edit_rounded,
};

String _exerciseLabel(ExerciseKind kind, AppLocalizations l) => switch (kind) {
  ExerciseKind.flashcard => l.flashcardPractice,
  ExerciseKind.mcq => l.mcqPractice,
  ExerciseKind.sentence => l.sentencePractice,
  ExerciseKind.writing => l.writingPractice,
};

/// The home screen's sections, named, or "all" when none is hidden.
String _homeSummary(HomeSettings home, AppLocalizations l) {
  final List<String> on = [
    if (home.showKana) l.kana,
    if (home.showKanji) l.tabKanji,
    if (home.showVocabulary) l.sectionVocabulary,
  ];
  if (on.length == 3) return l.settingsHomeAll;
  if (on.isEmpty) return l.settingsHomeNone;
  return on.join(' · ');
}
