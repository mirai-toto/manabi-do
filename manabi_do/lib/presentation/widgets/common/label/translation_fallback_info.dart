import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/l10n.dart';

/// Marks text that is in English because the content has nothing in the
/// reader's language.
///
/// The gap is the corpus's, not the app's, and it is wide: of the 12,000 words
/// 72% have French meanings, KANJIDIC2 publishes no German kanji meanings at
/// all, and fewer than half the example sentences carry French. A written
/// warning on each one would be most of the screen and would teach the reader
/// to ignore it, so this is a quiet mark that explains itself when asked.
///
/// [language] is the reader's own language, named in their language — what is
/// missing, not what is shown.
class TranslationFallbackInfo extends StatelessWidget {
  final String language;

  /// Overrides the icon colour where the mark sits on a tinted surface rather
  /// than the page, such as the kanji hero.
  final Color? color;

  const TranslationFallbackInfo({
    super.key,
    required this.language,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final AppTokens t = context.tokens;
    final String message = context.l10n.translationFallbackNotice(language);
    return Tooltip(
      message: message,
      // Tap, not long-press: a reader who has noticed the mark is asking a
      // question, and a long-press is a gesture nobody guesses.
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 6),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Semantics(
        label: message,
        button: true,
        child: Icon(
          Icons.info_outline_rounded,
          size: 14,
          color: color ?? t.onSurfaceVariant,
        ),
      ),
    );
  }
}
