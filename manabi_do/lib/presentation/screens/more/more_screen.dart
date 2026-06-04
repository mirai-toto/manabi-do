import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../widgets/widgets.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l = context.l10n;
    final themeMode = ref.watch(themeModeProvider);
    final locale    = ref.watch(localeProvider);
    final isDark    = themeMode == ThemeMode.dark;

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
              _LanguageRow(
                label: 'English',
                selected: locale.languageCode == 'en',
                onTap: () {
                  if (locale.languageCode != 'en') {
                    ref.read(localeProvider.notifier).toggle();
                  }
                },
              ),
              Divider(height: 1, thickness: 1, color: t.outlineVariant),
              _LanguageRow(
                label: 'Français',
                selected: locale.languageCode == 'fr',
                onTap: () {
                  if (locale.languageCode != 'fr') {
                    ref.read(localeProvider.notifier).toggle();
                  }
                },
              ),
            ]),
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
            child: Text(l.navMore, style: AppTextStyles.headline.copyWith(color: t.onSurface)),
          ),
          Text('⚙', style: AppTextStyles.jpDisplay.copyWith(color: t.onSurfaceVariant)),
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
          Expanded(
            child: Text(label, style: AppTextStyles.body.copyWith(color: t.onSurface)),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: t.primary,
          ),
        ],
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _LanguageRow({required this.label, required this.selected, required this.onTap});

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
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(
                  color: selected ? t.primary : t.onSurface,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_rounded, size: 20, color: t.primary),
          ],
        ),
      ),
    );
  }
}
