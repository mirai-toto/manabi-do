import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

class SegmentedTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> labels;

  const SegmentedTabBar({super.key, required this.controller, required this.labels});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceMd, 0, AppDimens.spaceMd, AppDimens.spaceSm,
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: t.surfaceContainer,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        ),
        child: TabBar(
          controller: controller,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: t.cardBackground,
            borderRadius: BorderRadius.circular(AppDimens.radiusSm),
            boxShadow: [
              BoxShadow(
                color: t.onSurface.withValues(alpha: 0.08),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          labelColor: t.primary,
          unselectedLabelColor: t.onSurfaceVariant,
          labelStyle: AppTextStyles.labelLarge,
          unselectedLabelStyle: AppTextStyles.labelLarge,
          tabs: labels.map((l) => Tab(text: l)).toList(),
        ),
      ),
    );
  }
}
