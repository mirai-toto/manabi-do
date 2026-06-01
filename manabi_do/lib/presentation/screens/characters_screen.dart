import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/l10n.dart';

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('字', style: AppTextStyles.jpDisplay.copyWith(color: t.characters)),
          const SizedBox(height: 8),
          Text(l.sectionCharacters, style: AppTextStyles.headline.copyWith(color: t.onSurface)),
          const SizedBox(height: 4),
          Text(l.comingSoon, style: AppTextStyles.body.copyWith(color: t.onSurfaceVariant)),
        ],
      ),
    );
  }
}
