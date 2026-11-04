import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/text/search_rank.dart';
import '../../data/database/app_database.dart';
import '../providers/database_provider.dart';

/// A search request: the text, and which groups to keep.
///
/// [F] is whatever identifies a group in the thing being searched: a JLPT
/// level string for kanji, a vocabulary level number for vocabulary. One class
/// with a type parameter rather than two, because the equality below is the
/// only reason either exists.
///
/// A class rather than a record because Riverpod families key on equality and
/// a `Set` inside a record compares by identity — every rebuild would look
/// like a new request and refetch.
@immutable
class SearchQuery<F> {
  final String text;
  final Set<F> filters;

  const SearchQuery(this.text, [this.filters = const {}]);

  @override
  bool operator ==(Object other) =>
      other is SearchQuery<F> &&
      other.text == text &&
      other.filters.length == filters.length &&
      other.filters.containsAll(filters);

  @override
  int get hashCode => Object.hash(text, Object.hashAllUnordered(filters));
}

/// How many results a search returns. A one-letter query matches thousands of
/// entries and nobody scrolls that far.
const int kSearchResultLimit = 50;

/// The text a search ranks an entry against.
typedef SearchFields = ({
  String japanese,
  List<String> readings,
  String meaning,
});

/// Orders search matches. The database decides which rows contain the query;
/// this decides which of them answer it.
///
/// Both searches share one policy — best match first, ties to the easier
/// entry, capped — so neither can drift away from the other. What "easier"
/// means is the one thing each search supplies for itself: kanji have a JLPT
/// level, words have a vocabulary level.
class SearchService {
  final AppDatabase _db;

  const SearchService(this._db);

  /// [levels] narrows the result to those coverage levels. Empty means all.
  ///
  /// [locale] decides which meanings are searched and scored. Ranking on the
  /// English text alone would list a word matched on its French gloss below
  /// every word whose English happens to contain the same letters.
  Future<List<VocabularyEntry>> vocabulary(
    String query, {
    Set<int> levels = const {},
    String locale = 'en',
  }) async {
    final candidates = await _db.searchVocabularyCandidates(query, locale);
    final Map<int, String> localized = locale == 'en'
        ? const {}
        : await _db.getVocabularyTranslations(
            candidates.map((e) => e.id).toList(),
            locale,
          );
    return _ranked(
      query: query,
      candidates: candidates,
      fieldsOf: (entry) => (
        japanese: entry.word,
        readings: [entry.reading],
        meaning: localized[entry.id] ?? entry.meaning,
      ),
      keep: (entry) => levels.isEmpty || levels.contains(entry.vocabularyLevel),
      // Level 1 is the commonest, so the number is already the right order.
      easiness: (entry) => entry.vocabularyLevel,
      // Alphabetical, so equally good matches keep a stable order.
      tiebreak: (a, b) => a.word.compareTo(b.word),
    );
  }

  /// [levels] narrows the result to those JLPT levels. Empty means all.
  Future<List<Kanji>> kanji(
    String query, {
    Set<String> levels = const {},
    String locale = 'en',
  }) async {
    final candidates = await _db.searchKanjiCandidates(query, locale);
    final Map<int, String> localized = locale == 'en'
        ? const {}
        : await _db.getKanjiTranslations(
            candidates.map((k) => k.id).toList(),
            locale,
          );
    return _ranked(
      query: query,
      candidates: candidates,
      fieldsOf: (kanji) => (
        japanese: kanji.character,
        readings: [kanji.onReading, kanji.kunReading],
        meaning: localized[kanji.id] ?? kanji.meaning,
      ),
      keep: (kanji) => levels.isEmpty || levels.contains(kanji.jlptLevel),
      easiness: (kanji) => _levelRank(kanji.jlptLevel),
      tiebreak: (a, b) => a.id.compareTo(b.id),
    );
  }
}

List<T> _ranked<T>({
  required String query,
  required List<T> candidates,
  required SearchFields Function(T) fieldsOf,
  required bool Function(T) keep,
  required int Function(T) easiness,
  required Comparator<T> tiebreak,
}) {
  // Filtered before the cap, not after: a filter applied to an already
  // truncated list would return the two N1 entries that happened to survive
  // rather than the fifty that exist.
  final pool = candidates.where(keep).toList();

  final scored =
      pool.map((candidate) {
        final fields = fieldsOf(candidate);
        return (
          item: candidate,
          rank: searchRank(
            query: query,
            japanese: fields.japanese,
            readings: fields.readings,
            meaning: fields.meaning,
          ),
          easiness: easiness(candidate),
        );
      }).toList()..sort((a, b) {
        final byRank = a.rank.compareTo(b.rank);
        if (byRank != 0) return byRank;
        final byEase = a.easiness.compareTo(b.easiness);
        return byEase != 0 ? byEase : tiebreak(a.item, b.item);
      });

  return scored
      .take(kSearchResultLimit)
      .map((candidate) => candidate.item)
      .toList();
}

/// Easiest first. Searching "water" should surface 水 above the rare N1 entries
/// whose meanings happen to mention water.
int _levelRank(String level) => switch (level) {
  'N5' => 0,
  'N4' => 1,
  'N3' => 2,
  'N2' => 3,
  'N1' => 4,
  _ => 5,
};

final searchServiceProvider = Provider(
  (ref) => SearchService(ref.read(databaseProvider)),
);
