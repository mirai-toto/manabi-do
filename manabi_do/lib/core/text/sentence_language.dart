/// Naming the language an example sentence's translation is actually in.
///
/// Only English is guaranteed by the content pipeline: a Tatoeba sentence is
/// imported when it has an English translation, and the others come along when
/// the corpus happens to have them — French reaches about 43% of imported
/// sentences, German about 52%. The query asks for the reader's language or
/// English, so English is the only language that can turn up unasked, and
/// saying so is the difference between a gap the app knows about and one that
/// looks like a defect.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// `sentence_translations` stores ISO 639-2; the app's locales are 639-1.
const Map<String, String> _endonyms = {
  'eng': 'English',
  'fra': 'Français',
  'deu': 'Deutsch',
  'spa': 'Español',
  'ita': 'Italiano',
  'por': 'Português',
  'rus': 'Русский',
};

// sentence_translations uses ISO 639-2 (3-letter) codes; the app uses 639-1.
const Map<String, String> _iso1To2 = {
  'en': 'eng',
  'fr': 'fra',
  'de': 'deu',
  'es': 'spa',
  'pt': 'por',
  'it': 'ita',
  'ru': 'rus',
};

/// [locale] (ISO 639-1) as the 639-2 code sentence translations are stored
/// under. Unknown codes pass through unchanged.
String sentenceLocaleCode(String locale) => _iso1To2[locale] ?? locale;

/// The reader's own language, named, when [sentenceLocale] is not it — which
/// is the language the content is missing. Null when the translation is
/// already in their language, because then there is nothing to explain.
String? missingLanguageForSentence(
  String? sentenceLocale,
  String readerLocale,
) {
  if (sentenceLocale == null) return null;
  final String reader3 = sentenceLocaleCode(readerLocale);
  if (sentenceLocale == reader3) return null;
  return _endonyms[reader3];
}

/// The reader's language, named in itself. Null for a language the content
/// never carries, which cannot be missing from anything.
String? readerLanguageName(String readerLocale) =>
    _endonyms[_iso1To2[readerLocale] ?? readerLocale];

/// The language a localized-meaning provider failed to supply, or null when
/// nothing is missing.
///
/// The providers return an empty string for two different reasons: the reader
/// is on English, where there is nothing to localize and the base column is
/// already right, or the content has no meaning in their language. Only the
/// second is a gap. Reading emptiness alone marked every row in the English
/// app with "No English translation for this yet", which is why this rule
/// lives in one place instead of at each call site.
String? missingMeaningLanguage(
  AsyncValue<String> localized, {
  required String readerLocale,
}) {
  if (readerLocale == 'en') return null;
  final String? value = localized.asData?.value;
  if (value == null || value.isNotEmpty) return null;
  return readerLanguageName(readerLocale);
}
