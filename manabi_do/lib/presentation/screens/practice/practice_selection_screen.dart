import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../widgets/widgets.dart';

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
  late List<Future<(int, int)>?> _countFutures;

  @override
  void initState() {
    super.initState();
    _countFutures = widget.modes.map((m) => m.counts?.call()).toList();
  }

  void _refresh() {
    setState(() {
      _countFutures = widget.modes.map((m) => m.counts?.call()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

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
              FutureBuilder<(int, int)>(
                future: _countFutures[i],
                builder: (context, snap) {
                  String? countLabel;
                  if (snap.hasData) {
                    final (due, newCards) = snap.data!;
                    if (due > 0 || newCards > 0) {
                      countLabel = [
                        if (due > 0) l.reviewsDue(due),
                        if (newCards > 0) l.nNew(newCards),
                      ].join(' · ');
                    }
                  }
                  return PracticeModeCard(
                    title: widget.modes[i].title,
                    icon: widget.modes[i].icon,
                    subtitle: widget.modes[i].subtitle,
                    color: widget.color,
                    countLabel: countLabel,
                    isCountLoading:
                        _countFutures[i] != null &&
                        snap.connectionState == ConnectionState.waiting,
                    onTap: () async {
                      await widget.modes[i].onTap();
                      if (mounted) _refresh();
                    },
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
