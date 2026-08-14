import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../services/feedback_service.dart';
import '../../services/srs_service.dart';
import '../../widgets/widgets.dart';

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
    await srsService.resetAll(ref);
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
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(l.feedbackNoMailApp(feedbackEmailAddress)),
        action: SnackBarAction(
          label: l.copy,
          onPressed: () async {
            await Clipboard.setData(
              const ClipboardData(text: feedbackEmailAddress),
            );
            messenger.showSnackBar(
              SnackBar(content: Text(l.feedbackAddressCopied)),
            );
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
            const SettingsPracticeCard(),

            const SizedBox(height: AppDimens.spaceLg),
            SectionLabel(l.settingsAppearance),
            const SizedBox(height: AppDimens.spaceSm),
            SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: const Icon(Icons.brightness_auto_rounded),
                  label: Text(l.settingsThemeSystem),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: const Icon(Icons.light_mode_rounded),
                  label: Text(l.settingsThemeLight),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: const Icon(Icons.dark_mode_rounded),
                  label: Text(l.settingsThemeDark),
                ),
              ],
              selected: {themeMode},
              onSelectionChanged: (modes) =>
                  ref.read(themeModeProvider.notifier).setMode(modes.first),
            ),

            const SizedBox(height: AppDimens.spaceLg),
            SectionLabel(l.settingsLanguage),
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
                  label: currentLang.name,
                  onTap: () => _showLanguagePicker(
                    context,
                    ref,
                    locale.languageCode,
                    l.settingsLanguage,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimens.spaceLg),
            SectionLabel(l.settingsData),
            const SizedBox(height: AppDimens.spaceSm),
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
            SectionLabel(l.settingsFeedback),
            const SizedBox(height: AppDimens.spaceSm),
            SettingsCard(
              children: [
                SettingsTile(
                  leading: Icon(
                    Icons.mail_outline_rounded,
                    size: 20,
                    color: t.onSurfaceVariant,
                  ),
                  label: l.settingsSendFeedback,
                  onTap: () => _sendFeedback(context, ref, l),
                ),
              ],
            ),

            const SizedBox(height: AppDimens.spaceLg),
            const SettingsAboutSection(),
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
