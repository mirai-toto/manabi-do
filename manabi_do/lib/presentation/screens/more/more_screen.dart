import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../widgets/widgets.dart';

// Supported languages: code → (flag emoji, native name)
const _languages = [
  (code: 'en', flag: '🇬🇧', name: 'English'),
  (code: 'fr', flag: '🇫🇷', name: 'Français'),
  (code: 'de', flag: '🇩🇪', name: 'Deutsch'),
];

final _packageInfoProvider = FutureProvider<PackageInfo>((_) => PackageInfo.fromPlatform());

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l        = context.l10n;
    final themeMode = ref.watch(themeModeProvider);
    final locale    = ref.watch(localeProvider);
    final isDark    = themeMode == ThemeMode.dark;
    final pkgAsync  = ref.watch(_packageInfoProvider);

    final currentLang = _languages.firstWhere(
      (e) => e.code == locale.languageCode,
      orElse: () => _languages.first,
    );

    final version = pkgAsync.when(data: (p) => p.version, loading: () => '—', error: (e, s) => '—');

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimens.screenMaxWidth),
        child: ListView(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          children: [
            _ScreenHeader(),
            const SizedBox(height: AppDimens.spaceLg),
            SectionLabel(l.settingsAppearance),
            const SizedBox(height: AppDimens.spaceSm),
            _SettingsCard(children: [
              _ToggleRow(
                icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                label: isDark ? l.settingsThemeDark : l.settingsThemeLight,
                value: isDark,
                onChanged: (_) => ref.read(themeModeProvider.notifier).toggle(),
              ),
            ]),
            const SizedBox(height: AppDimens.spaceLg),
            SectionLabel(l.settingsLanguage),
            const SizedBox(height: AppDimens.spaceSm),
            _SettingsCard(children: [
              _TappableRow(
                leading: Text(
                  currentLang.flag,
                  style: const TextStyle(fontSize: 22, fontFamily: 'NotoColorEmoji'),
                ),
                label: currentLang.name,
                onTap: () => _showLanguagePicker(context, ref, locale.languageCode),
              ),
            ]),
            const SizedBox(height: AppDimens.spaceLg),
            SectionLabel(l.aboutTitle),
            const SizedBox(height: AppDimens.spaceSm),
            _SettingsCard(children: [
              _InfoRow(
                icon: Icons.info_outline_rounded,
                label: l.aboutVersion(version),
              ),
              _TappableRow(
                leading: Icon(Icons.article_outlined, size: 20, color: context.tokens.onSurfaceVariant),
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

  void _showLanguagePicker(BuildContext context, WidgetRef ref, String current) {
    final t = context.tokens;
    final l = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: t.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.radiusLg)),
      ),
      builder: (_) => _LanguagePickerSheet(
        currentCode: current,
        onSelect: (code) {
          ref.read(localeProvider.notifier).setLocale(Locale(code));
          Navigator.of(context).pop();
        },
        title: l.settingsLanguage,
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
            child: Text(l.navSettings, style: AppTextStyles.headline.copyWith(color: t.onSurface)),
          ),
          Icon(Icons.settings_rounded, color: t.onSurfaceVariant, size: 26),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(color: t.outlineVariant),
      ),
      child: Column(children: children),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({required this.icon, required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd, vertical: AppDimens.spaceSm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: t.onSurfaceVariant),
          const SizedBox(width: AppDimens.spaceMd),
          Expanded(child: Text(label, style: AppTextStyles.body.copyWith(color: t.onSurface))),
          Switch(value: value, onChanged: onChanged, activeThumbColor: t.primary),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd, vertical: AppDimens.spaceSm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: t.onSurfaceVariant),
          const SizedBox(width: AppDimens.spaceMd),
          Expanded(child: Text(label, style: AppTextStyles.body.copyWith(color: t.onSurface))),
        ],
      ),
    );
  }
}

class _TappableRow extends StatelessWidget {
  final Widget leading;
  final String label;
  final VoidCallback onTap;
  const _TappableRow({required this.leading, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd, vertical: AppDimens.spaceMd),
        child: Row(
          children: [
            leading,
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(child: Text(label, style: AppTextStyles.body.copyWith(color: t.onSurface))),
            Icon(Icons.chevron_right_rounded, size: 20, color: t.onSurfaceVariant),
          ],
        ),
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

class _LanguagePickerSheet extends StatelessWidget {
  final String currentCode;
  final void Function(String code) onSelect;
  final String title;
  const _LanguagePickerSheet({required this.currentCode, required this.onSelect, required this.title});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppDimens.spaceMd),
              decoration: BoxDecoration(
                color: t.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(title, style: AppTextStyles.title.copyWith(color: t.onSurface)),
              ),
            ),
            const SizedBox(height: AppDimens.spaceMd),
            for (final lang in _languages) ...[
              InkWell(
                onTap: () => onSelect(lang.code),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd, vertical: AppDimens.spaceMd),
                  child: Row(
                    children: [
                      Text(
                        lang.flag,
                        style: const TextStyle(fontSize: 28, fontFamily: 'NotoColorEmoji'),
                      ),
                      const SizedBox(width: AppDimens.spaceMd),
                      Expanded(
                        child: Text(
                          lang.name,
                          style: AppTextStyles.body.copyWith(
                            color: lang.code == currentCode ? t.primary : t.onSurface,
                            fontWeight: lang.code == currentCode ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                      if (lang.code == currentCode)
                        Icon(Icons.check_rounded, size: 20, color: t.primary),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
