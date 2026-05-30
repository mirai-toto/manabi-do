import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';

class AppProgressBar extends StatelessWidget {
  final double progress; // 0.0 – 1.0
  final Color? color;
  final double height;
  final double? width;

  const AppProgressBar({
    super.key,
    required this.progress,
    this.color,
    this.height = 6,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Semantics(
      value: '${(progress.clamp(0.0, 1.0) * 100).round()}%',
      excludeSemantics: true,
      child: SizedBox(
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.radiusPill),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: t.surfaceVariant,
            valueColor: AlwaysStoppedAnimation(color ?? t.primary),
          ),
        ),
      ),
    );
  }
}
