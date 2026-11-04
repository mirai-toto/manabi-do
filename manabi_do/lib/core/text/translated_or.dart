/// The translation stored for [id], or [english] when there is none.
///
/// Translation maps leave out, or hold an empty string for, rows the content
/// has no translation for; both fall back to the English source text.
String translatedOr(Map<int, String> translations, int id, String english) {
  final String? text = translations[id];
  return text != null && text.isNotEmpty ? text : english;
}
