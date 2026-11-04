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

const Map<String, String> _iso1To2 = {
  'en': 'eng',
  'fr': 'fra',
  'de': 'deu',
  'es': 'spa',
  'pt': 'por',
  'it': 'ita',
  'ru': 'rus',
};

/// The language [sentenceLocale] names, or null when it is already the
/// reader's — labelling every line would be noise, so only a substitution
/// gets named.
String? languageNameForSentenceLocale(
  String? sentenceLocale,
  String readerLocale,
) {
  if (sentenceLocale == null) return null;
  if (sentenceLocale == (_iso1To2[readerLocale] ?? readerLocale)) return null;
  return _endonyms[sentenceLocale];
}
