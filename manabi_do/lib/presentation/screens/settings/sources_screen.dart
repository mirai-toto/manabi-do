import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../widgets/widgets.dart';

/// Every outside source the content is built from, and the credit it is owed.
///
/// These seven notices used to sit open on the settings screen, seven
/// paragraphs deep, between the exercise settings and the end of the page.
/// Licences ask to be reachable, not to be unavoidable, so they live one tap
/// away instead.
class SourcesScreen extends StatelessWidget {
  const SourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    return Scaffold(
      backgroundColor: t.surface,
      appBar: AppBar(
        backgroundColor: t.surface,
        foregroundColor: t.onSurface,
        elevation: 0,
        title: Text(l.aboutDataSources),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppDimens.screenMaxWidth),
          child: ListView(
            padding: const EdgeInsets.all(AppDimens.spaceMd),
            children: [
              Text(
                l.aboutDataSourcesIntro,
                style: AppTextStyles.bodySmall.copyWith(
                  color: t.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppDimens.spaceMd),
              AttributionCard(
                notice: l.aboutEdrdgNotice,
                link: l.aboutEdrdgLink,
              ),
              const SizedBox(height: AppDimens.spaceSm),
              AttributionCard(
                notice: l.aboutKanjiVgNotice,
                link: l.aboutKanjiVgLink,
              ),
              const SizedBox(height: AppDimens.spaceSm),
              AttributionCard(
                notice: l.aboutTatoebaNotice,
                link: l.aboutTatoebaLink,
              ),
              const SizedBox(height: AppDimens.spaceSm),
              // Owed since the first release and missing until now. Waller's
              // lists decide which kanji the app teaches and how hard each one
              // is, and his vocabulary lists set every word level before
              // version 24. CC BY asks for credit.
              AttributionCard(
                notice: l.aboutWallerNotice,
                link: l.aboutWallerLink,
              ),
              const SizedBox(height: AppDimens.spaceSm),
              AttributionCard(
                notice: l.aboutBccwjNotice,
                link: l.aboutBccwjLink,
              ),
              const SizedBox(height: AppDimens.spaceSm),
              // Not shipped either, but which sentence illustrates which word
              // was its decision.
              AttributionCard(
                notice: l.aboutJanomeNotice,
                link: l.aboutJanomeLink,
              ),
              const SizedBox(height: AppDimens.spaceSm),
              // The tool is not shipped, but the furigana it produced is.
              AttributionCard(
                notice: l.aboutPykakasiNotice,
                link: l.aboutPykakasiLink,
              ),
              const SizedBox(height: AppDimens.spaceLg),
            ],
          ),
        ),
      ),
    );
  }
}
