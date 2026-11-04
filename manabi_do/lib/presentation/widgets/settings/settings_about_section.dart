import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/providers/onboarding_provider.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../screens/settings/sources_screen.dart';
import '../widgets.dart';

final packageInfoProvider = FutureProvider<PackageInfo>(
  (_) => PackageInfo.fromPlatform(),
);

/// One card: what this build is, what it is made of, and how to reach the
/// person who made it.
///
/// The source notices moved to [SourcesScreen]. Seven paragraphs of licence
/// text sat open at the foot of the settings screen and were most of its
/// length; a licence asks to be reachable, not unavoidable. Feedback and
/// support joined them here because they were loose unlabelled cards in the
/// middle of the screen, and they belong with the rest of the information
/// about the app rather than between two settings.
class SettingsAboutSection extends ConsumerWidget {
  final VoidCallback onSendFeedback;
  final VoidCallback onSupport;

  const SettingsAboutSection({
    super.key,
    required this.onSendFeedback,
    required this.onSupport,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final t = context.tokens;
    final pkgAsync = ref.watch(packageInfoProvider);
    final version = pkgAsync.when(
      data: (p) => p.version,
      loading: () => '',
      error: (_, _) => '',
    );

    Icon icon(IconData data) => Icon(data, size: 20, color: t.onSurfaceVariant);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(l.aboutTitle),
        const SizedBox(height: AppDimens.spaceSm),
        SettingsCard(
          children: [
            // Long-press the version to see onboarding again. Debug only,
            // and deliberately undiscoverable: it is for testing the first-run
            // flow without clearing the app's stored settings by hand.
            if (kDebugMode)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onLongPress: () async {
                  await ref.read(onboardingSeenProvider.notifier).reset();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Onboarding reset — restart the app'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
                child: SettingsInfo(
                  icon: Icons.info_outline_rounded,
                  label: l.aboutVersion(version),
                ),
              )
            else
              SettingsInfo(
                icon: Icons.info_outline_rounded,
                label: l.aboutVersion(version),
              ),
            SettingsTile(
              leading: icon(Icons.article_outlined),
              label: l.aboutOpenSourceLicenses,
              onTap: () => showLicensePage(
                context: context,
                applicationName: l.appTitle,
              ),
            ),
            SettingsTile(
              leading: icon(Icons.inventory_2_outlined),
              label: l.aboutDataSources,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SourcesScreen()),
              ),
            ),
            SettingsTile(
              leading: icon(Icons.mail_outline_rounded),
              label: l.settingsSendFeedback,
              onTap: onSendFeedback,
            ),
            SettingsTile(
              leading: icon(Icons.coffee_outlined),
              label: l.settingsSupportDeveloper,
              onTap: onSupport,
            ),
          ],
        ),
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
    return CardContainer(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
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
