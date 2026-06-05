import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/srs_settings_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../providers/database_provider.dart';
import '../../widgets/common/confirm_dialog.dart';
import '../../widgets/common/section_label.dart';
import '../../widgets/settings/settings_card.dart';
import '../../widgets/settings/settings_tile.dart';
import 'language_picker_sheet.dart';

final _packageInfoProvider = FutureProvider<PackageInfo>((_) => PackageInfo.fromPlatform());

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmResetAll(BuildContext context, AppDatabase db, AppLocalizations l) async {
    final confirmed = await showConfirmDialog(
      context,
      title: l.resetProgressTitle,
      body: l.resetProgressBody,
    );
    if (!confirmed) return;
    await db.resetAllProgress();
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref, String current, String title) {
    final t = context.tokens;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: t.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.radiusLg)),
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
    final l         = context.l10n;
    final t         = context.tokens;
    final themeMode = ref.watch(themeModeProvider);
    final locale    = ref.watch(localeProvider);
    final isDark    = themeMode == ThemeMode.dark;
    final pkgAsync  = ref.watch(_packageInfoProvider);
    final srs       = ref.watch(srsSettingsProvider);
    final db        = ref.read(databaseProvider);

    final currentLang = languages.firstWhere(
      (e) => e.code == locale.languageCode,
      orElse: () => languages.first,
    );
    final version  = pkgAsync.when(data: (p) => p.version, loading: () => '—', error: (_, _) => '—');
    final newCards = srs.asData?.value.newCardsPerSession ?? 10;

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
            SettingsCard(children: [
              SettingsStepper(
                icon: Icons.layers_rounded,
                label: l.settingsPracticeNewCards,
                value: newCards,
                onDecrement: newCards > 5
                    ? () => ref.read(srsSettingsProvider.notifier).setNewCardsPerSession(newCards - 5)
                    : null,
                onIncrement: newCards < 50
                    ? () => ref.read(srsSettingsProvider.notifier).setNewCardsPerSession(newCards + 5)
                    : null,
              ),
            ]),

            const SizedBox(height: AppDimens.spaceLg),
            SectionLabel(l.settingsAppearance),
            const SizedBox(height: AppDimens.spaceSm),
            SettingsCard(children: [
              SettingsToggle(
                icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                label: isDark ? l.settingsThemeDark : l.settingsThemeLight,
                value: isDark,
                onChanged: (_) => ref.read(themeModeProvider.notifier).toggle(),
              ),
            ]),

            const SizedBox(height: AppDimens.spaceLg),
            SectionLabel(l.settingsLanguage),
            const SizedBox(height: AppDimens.spaceSm),
            SettingsCard(children: [
              SettingsTile(
                leading: Text(
                  currentLang.flag,
                  style: const TextStyle(fontSize: 22, fontFamily: 'NotoColorEmoji'),
                ),
                label: currentLang.name,
                onTap: () => _showLanguagePicker(context, ref, locale.languageCode, l.settingsLanguage),
              ),
            ]),

            const SizedBox(height: AppDimens.spaceLg),
            SectionLabel(l.settingsData),
            const SizedBox(height: AppDimens.spaceSm),
            SettingsCard(children: [
              SettingsTile(
                leading: Icon(Icons.delete_outline_rounded, size: 20, color: t.error),
                label: l.settingsResetProgress,
                labelColor: t.error,
                onTap: () => _confirmResetAll(context, db, l),
              ),
            ]),

            const SizedBox(height: AppDimens.spaceLg),
            SectionLabel(l.aboutTitle),
            const SizedBox(height: AppDimens.spaceSm),
            SettingsCard(children: [
              SettingsInfo(icon: Icons.info_outline_rounded, label: l.aboutVersion(version)),
              SettingsTile(
                leading: Icon(Icons.article_outlined, size: 20, color: t.onSurfaceVariant),
                label: l.aboutOpenSourceLicenses,
                onTap: () => showLicensePage(context: context, applicationName: l.appTitle),
              ),
            ]),

            const SizedBox(height: AppDimens.spaceLg),
            SectionLabel(l.aboutDataSources),
            const SizedBox(height: AppDimens.spaceSm),
            _AttributionCard(notice: l.aboutEdrdgNotice, link: l.aboutEdrdgLink),
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
          Expanded(child: Text(l.navSettings, style: AppTextStyles.headline.copyWith(color: t.onSurface))),
          Icon(Icons.settings_rounded, color: t.onSurfaceVariant, size: 26),
        ],
      ),
    );
  }
}

class _AttributionCard extends StatelessWidget {
  final String notice;
  final String link;
  const _AttributionCard({required this.notice, required this.link});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(color: t.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notice, style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant)),
          const SizedBox(height: AppDimens.spaceSm),
          Text(link, style: AppTextStyles.bodySmall.copyWith(color: t.primary)),
        ],
      ),
    );
  }
}
