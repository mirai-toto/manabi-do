import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
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

  /// Replaces the default notice. "There is no French for this" and "the
  /// French is a single line" are both worth explaining and are not the same
  /// thing.
  final String? message;

  const TranslationFallbackInfo({
    super.key,
    required this.language,
    this.color,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final AppTokens t = context.tokens;
    final String notice =
        message ?? context.l10n.translationFallbackNotice(language);
    return Tooltip(
      message: notice,
      // Tap, not long-press: a reader who has noticed the mark is asking a
      // question, and a long-press is a gesture nobody guesses.
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 6),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Semantics(
        label: notice,
        button: true,
        // Tinted and padded, because the first version was a 14px glyph in
        // onSurfaceVariant beside a small uppercase label and nobody saw it.
        // An affordance nobody notices is not an affordance, and the padding
        // is what makes it big enough to hit on a phone.
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceXxs),
          child: Icon(
            Icons.info_outline_rounded,
            size: 17,
            color: color ?? t.primary,
          ),
        ),
      ),
    );
  }
}

/// Text that carries its own explanation when it is not in the reader's
/// language.
///
/// The mark rides at the end of the text as a [WidgetSpan], so it lands after
/// the last line of a wrapped translation instead of taking a row of its own,
/// and a caller adds it by passing one extra argument rather than assembling a
/// `Text.rich` each time. Pass null for [missingLanguage] and this is an
/// ordinary [Text].
class TranslatedText extends StatelessWidget {
  final String text;

  /// The reader's language, named, when [text] is not in it.
  final String? missingLanguage;

  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  /// Colour for the mark where it sits on a tinted surface.
  final Color? markColor;

  const TranslatedText(
    this.text, {
    super.key,
    this.missingLanguage,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.markColor,
  });

  @override
  Widget build(BuildContext context) {
    if (missingLanguage == null) {
      return Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }
    final WidgetSpan mark = WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: TranslationFallbackInfo(
        language: missingLanguage!,
        color: markColor,
      ),
    );
    // A clipped line throws away everything past the ellipsis, the mark
    // included, so text that is allowed to truncate wears it in front where
    // truncation cannot reach. Text that runs to its full length keeps it at
    // the end, where it reads as a footnote rather than a bullet.
    final bool mayTruncate = maxLines != null;
    return Text.rich(
      TextSpan(
        children: mayTruncate
            ? [mark, const TextSpan(text: ' '), TextSpan(text: text)]
            : [TextSpan(text: text), const TextSpan(text: ' '), mark],
      ),
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
