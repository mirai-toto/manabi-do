import 'short_meaning.dart';

/// Rank of an entry the query does not match at all.
const int noSearchMatch = 1 << 30;

// How the query sat inside the gloss, best first. Spaced by two so that a hit
// which opens the sense can take the lower of each pair.
const int _exactJapanese = 0;
const int _partialJapanese = 1;
const int _wholeWord = 2;
const int _wordPrefix = 4;
const int _insideWord = 6;

/// Quality dominates; sense position only orders entries of equal quality.
const int _glossesPerTier = 1000;

/// Ranks how well an entry answers a search query. Lower sorts first.
///
/// Plain substring matching treats every hit alike, so searching "hello" put 石
/// ("… disc (in Othello) …") above 今日は, whose very first sense is "hello".
/// Three things separate them, in this order:
///
/// 1. whether the query matched a whole word, only the start of one ("hel"
///    while typing "hello"), or sat inside one ("hello" in "Othello");
/// 2. whether it opened the sense — "water (esp. cool or cold)" answers "water"
///    in a way "work (e.g. book, film, painting)" does not answer "book";
/// 3. which sense matched, since a ninth gloss says much less about a word than
///    its first.
///
/// Quality is compared before sense position, so a whole-word hit deep in the
/// list still beats one buried inside another word. What it deliberately does
/// not rank is a gloss that *is* the query: "water" and "water supply" both
/// open a first sense, and leaving them tied lets the caller's level tiebreak
/// put 水 above 水分.
///
/// [readings] covers every reading an entry has — kana for vocabulary, on and
/// kun for kanji.
int searchRank({
  required String query,
  required String japanese,
  required List<String> readings,
  required String meaning,
}) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return noSearchMatch;

  final japaneseFields = [
    japanese,
    ...readings,
  ].map((field) => field.toLowerCase()).toList();
  if (japaneseFields.any((field) => field == q)) {
    return _rank(_exactJapanese, 0);
  }
  if (japaneseFields.any((field) => field.contains(q))) {
    return _rank(_partialJapanese, 0);
  }

  var best = noSearchMatch;
  final glosses = splitGlosses(meaning);
  for (var i = 0; i < glosses.length; i++) {
    final gloss = glosses[i].toLowerCase();
    final at = gloss.indexOf(q);
    if (at < 0) continue;

    final int shape;
    if (_startsWord(gloss, at) && _endsWord(gloss, at + q.length)) {
      shape = _wholeWord;
    } else if (_startsWord(gloss, at)) {
      shape = _wordPrefix;
    } else {
      shape = _insideWord;
    }

    final rank = _rank(at == 0 ? shape : shape + 1, i);
    if (rank < best) best = rank;
  }
  return best;
}

int _rank(int quality, int glossIndex) =>
    quality * _glossesPerTier +
    (glossIndex < _glossesPerTier ? glossIndex : _glossesPerTier - 1);

bool _startsWord(String text, int at) =>
    at == 0 || !_isWordChar(text.codeUnitAt(at - 1));

bool _endsWord(String text, int end) =>
    end == text.length || !_isWordChar(text.codeUnitAt(end));

/// Letters and digits, plus everything above ASCII so that accented glosses
/// ("Größe") and kana are not read as word boundaries.
bool _isWordChar(int unit) =>
    (unit >= 0x30 && unit <= 0x39) ||
    (unit >= 0x41 && unit <= 0x5A) ||
    (unit >= 0x61 && unit <= 0x7A) ||
    unit > 0x7F;
