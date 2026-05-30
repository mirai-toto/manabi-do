import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../widgets/common/tappable_surface.dart';

class PracticeMode {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Future<(int, int)>? Function()? counts;
  final Future<void> Function() onTap;

  PracticeMode({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.counts,
  });
}

class PracticeSelectionScreen extends StatefulWidget {
  final String title;
  final Color color;
  final List<PracticeMode> modes;

  const PracticeSelectionScreen({
    super.key,
    required this.title,
    required this.color,
    required this.modes,
  });

  @override
  State<PracticeSelectionScreen> createState() =>
      _PracticeSelectionScreenState();
}

class _PracticeSelectionScreenState extends State<PracticeSelectionScreen> {
  int _generation = 0;

  void _refresh() => setState(() => _generation++);

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Scaffold(
      backgroundColor: t.surface,
      appBar: AppBar(
        backgroundColor: t.surface,
        title: Text(
          widget.title,
          style: AppTextStyles.title.copyWith(color: t.onSurface),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < widget.modes.length; i++) ...[
              if (i > 0) const SizedBox(height: AppDimens.spaceMd),
              _ModeCard(
                key: ValueKey((_generation, i)),
                mode: widget.modes[i],
                color: widget.color,
                onRefresh: _refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ModeCard extends StatefulWidget {
  final PracticeMode mode;
  final Color color;
  final VoidCallback onRefresh;

  const _ModeCard({
    super.key,
    required this.mode,
    required this.color,
    required this.onRefresh,
  });

  @override
  State<_ModeCard> createState() => _ModeCardState();
}

class _ModeCardState extends State<_ModeCard> {
  Future<(int, int)>? _countsFuture;

  @override
  void initState() {
    super.initState();
    _countsFuture = widget.mode.counts?.call();
  }

  Future<void> _handleTap() async {
    await widget.mode.onTap();
    if (mounted) widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final mode = widget.mode;

    return TappableSurface(
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(color: widget.color.withValues(alpha: 0.25)),
      ),
      onTap: () {
        _handleTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceLg),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.spaceMd),
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              ),
              child: Icon(mode.icon, color: widget.color, size: 24),
            ),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mode.title,
                    style: AppTextStyles.body.copyWith(
                      color: t.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (mode.subtitle != null) ...[
                    const SizedBox(height: AppDimens.spaceXxs),
                    Text(
                      mode.subtitle!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: widget.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if (_countsFuture != null)
                    FutureBuilder<(int, int)>(
                      future: _countsFuture,
                      builder: (context, snap) {
                        if (!snap.hasData) return const SizedBox.shrink();
                        final (due, newCards) = snap.data!;
                        if (due == 0 && newCards == 0)
                          return const SizedBox.shrink();
                        final parts = [
                          if (due > 0) l.reviewsDue(due),
                          if (newCards > 0) l.nNew(newCards),
                        ];
                        return Padding(
                          padding: const EdgeInsets.only(
                            top: AppDimens.spaceXxs,
                          ),
                          child: Text(
                            parts.join(' · '),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: widget.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: t.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
