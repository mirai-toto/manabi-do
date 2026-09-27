import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/text/search_rank.dart';
import '../../data/database/app_database.dart';
import '../providers/database_provider.dart';

/// A search request: the text, and which JLPT levels to keep.
///
/// A class rather than a record because Riverpod families key on equality and
/// a `Set` inside a record compares by identity — every rebuild would look
/// like a new request and refetch.
@immutable
class SearchQuery {
  final String text;
  final Set<String> levels;

  const SearchQuery(this.text, [this.levels = const {}]);

  @override
  bool operator ==(Object other) =>
      other is SearchQuery &&
      other.text == text &&
      other.levels.length == levels.length &&
      other.levels.containsAll(levels);

  @override
  int get hashCode => Object.hash(text, Object.hashAllUnordered(levels));
}

/// How many results a search returns. A one-letter query matches thousands of
/// entries and nobody scrolls that far.
const int kSearchResultLimit = 50;

/// The text a search ranks an entry against.
typedef SearchFields = ({
  String japanese,
  List<String> readings,
  String meaning,
  String level,
});

/// Orders search matches. The database decides which rows contain the query;
/// this decides which of them answer it.
///
/// Both searches share one policy — best match first, ties to the easier level,
/// capped — so neither can drift away from the other.
class SearchService {
  final AppDatabase _db;

  const SearchService(this._db);

  /// [levels] narrows the result to those JLPT levels. Empty means all.
  Future<List<VocabularyEntry>> vocabulary(
    String query, {
    Set<String> levels = const {},
  }) async {
    final candidates = await _db.searchVocabularyCandidates(query);
    return _ranked(
      query: query,
      levels: levels,
      candidates: candidates,
      fieldsOf: (entry) => (
        japanese: entry.word,
        readings: [entry.reading],
        meaning: entry.meaning,
        level: entry.jlptLevel,
      ),
      // Alphabetical, so equally good matches keep a stable order.
      tiebreak: (a, b) => a.word.compareTo(b.word),
    );
  }

  /// [levels] narrows the result to those JLPT levels. Empty means all.
  Future<List<Kanji>> kanji(
    String query, {
    Set<String> levels = const {},
  }) async {
    final candidates = await _db.searchKanjiCandidates(query);
    return _ranked(
      query: query,
      levels: levels,
      candidates: candidates,
      fieldsOf: (kanji) => (
        japanese: kanji.character,
        readings: [kanji.onReading, kanji.kunReading],
        meaning: kanji.meaning,
        level: kanji.jlptLevel,
      ),
      tiebreak: (a, b) => a.id.compareTo(b.id),
    );
  }
}

List<T> _ranked<T>({
  required String query,
  required Set<String> levels,
  required List<T> candidates,
  required SearchFields Function(T) fieldsOf,
  required Comparator<T> tiebreak,
}) {
  // Filtered before the cap, not after: a level filter applied to an already
  // truncated list would return the two N1 entries that happened to survive
  // rather than the fifty that exist.
  final pool = levels.isEmpty
      ? candidates
      : candidates.where((c) => levels.contains(fieldsOf(c).level)).toList();

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
          level: _levelRank(fields.level),
        );
      }).toList()..sort((a, b) {
        final byRank = a.rank.compareTo(b.rank);
        if (byRank != 0) return byRank;
        final byLevel = a.level.compareTo(b.level);
        return byLevel != 0 ? byLevel : tiebreak(a.item, b.item);
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
