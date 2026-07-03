import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/srs_settings_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../services/srs_service.dart';
import '../../widgets/widgets.dart';
import 'language_picker_sheet.dart';

final _packageInfoProvider = FutureProvider<PackageInfo>(
  (_) => PackageInfo.fromPlatform(),
);

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
    final pkgAsync = ref.watch(_packageInfoProvider);
    final srs = ref.watch(srsSettingsProvider);

    final currentLang = languages.firstWhere(
      (e) => e.code == locale.languageCode,
      orElse: () => languages.first,
    );
    final version = pkgAsync.when(
      data: (p) => p.version,
      loading: () => '—',
      error: (_, _) => '—',
    );
    final newChars = srs.asData?.value.newCharactersPerDay ?? 10;
    final newVocab = srs.asData?.value.newVocabPerDay ?? 10;

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
            SettingsCard(
              children: [
                SettingsStepper(
                  icon: Icons.auto_stories_rounded,
                  label: l.settingsPracticeNewCharacters,
                  value: newChars,
                  onDecrement: newChars > 0
                      ? () => ref
                            .read(srsSettingsProvider.notifier)
                            .setNewCharactersPerDay((newChars - 5).clamp(0, 50))
                      : null,
                  onIncrement: newChars < 50
                      ? () => ref
                            .read(srsSettingsProvider.notifier)
                            .setNewCharactersPerDay(newChars + 5)
                      : null,
                ),
                SettingsStepper(
                  icon: Icons.translate_rounded,
                  label: l.settingsPracticeNewVocab,
                  value: newVocab,
                  onDecrement: newVocab > 0
                      ? () => ref
                            .read(srsSettingsProvider.notifier)
                            .setNewVocabPerDay((newVocab - 5).clamp(0, 50))
                      : null,
                  onIncrement: newVocab < 50
                      ? () => ref
                            .read(srsSettingsProvider.notifier)
                            .setNewVocabPerDay(newVocab + 5)
                      : null,
                ),
              ],
            ),

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
                if (kDebugMode)
                  SettingsTile(
                    leading: Icon(
                      Icons.science_outlined,
                      size: 20,
                      color: t.onSurfaceVariant,
                    ),
                    label: 'Seed fake reviews (debug)',
                    onTap: () => srsService.seedFakeReviews(ref),
                  ),
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
            SectionLabel(l.aboutTitle),
            const SizedBox(height: AppDimens.spaceSm),
            SettingsCard(
              children: [
                SettingsInfo(
                  icon: Icons.info_outline_rounded,
                  label: l.aboutVersion(version),
                ),
                SettingsTile(
                  leading: Icon(
                    Icons.article_outlined,
                    size: 20,
                    color: t.onSurfaceVariant,
                  ),
                  label: l.aboutOpenSourceLicenses,
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: l.appTitle,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimens.spaceLg),
            SectionLabel(l.aboutDataSources),
            const SizedBox(height: AppDimens.spaceSm),
            _AttributionCard(
              notice: l.aboutEdrdgNotice,
              link: l.aboutEdrdgLink,
            ),
            const SizedBox(height: AppDimens.spaceSm),
            _AttributionCard(
              notice: l.aboutKanjiVgNotice,
              link: l.aboutKanjiVgLink,
            ),
            const SizedBox(height: AppDimens.spaceSm),
            _AttributionCard(
              notice: l.aboutTatoebaNotice,
              link: l.aboutTatoebaLink,
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
          Text(
            notice,
            style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
          ),
          const SizedBox(height: AppDimens.spaceSm),
          Text(link, style: AppTextStyles.bodySmall.copyWith(color: t.primary)),
        ],
      ),
    );
  }
}
