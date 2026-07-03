import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../widgets/widgets.dart';

final packageInfoProvider = FutureProvider<PackageInfo>(
  (_) => PackageInfo.fromPlatform(),
);

class SettingsAboutSection extends ConsumerWidget {
  const SettingsAboutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final pkgAsync = ref.watch(packageInfoProvider);
    final version = pkgAsync.when(
      data: (p) => p.version,
      loading: () => '—',
      error: (_, _) => '—',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                color: context.tokens.onSurfaceVariant,
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
        AttributionCard(notice: l.aboutEdrdgNotice, link: l.aboutEdrdgLink),
        const SizedBox(height: AppDimens.spaceSm),
        AttributionCard(notice: l.aboutKanjiVgNotice, link: l.aboutKanjiVgLink),
        const SizedBox(height: AppDimens.spaceSm),
        AttributionCard(notice: l.aboutTatoebaNotice, link: l.aboutTatoebaLink),
      ],
    );
  }
}

class AttributionCard extends StatelessWidget {
  final String notice;
  final String link;
  const AttributionCard({super.key, required this.notice, required this.link});

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
