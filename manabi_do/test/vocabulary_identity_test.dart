import 'package:flutter_test/flutter_test.dart';
import 'package:manabi_do/data/database/user_data_preservation.dart';

/// Review history is matched across a content update by identity, not by row
/// id. Until schema 29 the only identity was (word, reading), so rewriting a
/// word's spelling orphaned its cards — which is what happened to 17 words
/// when 要る stopped being written いる.
void main() {
  List<List<Object?>> cards(List<int> ids) => [
    for (final id in ids) ['vocabulary', id, 1234],
  ];

  const saved = {'srs_cards': <List<Object?>>[]};

  test('a word that changes spelling keeps its history', () {
    // Before: id 2 is "to need", written いる. After: same JMdict entry, now
    // written 要る, and it has moved to row 97.
    final old = {2: vocabularyIdentities('1546640', 'いる', 'いる')};
    final fresh = {97: vocabularyIdentities('1546640', '要る', 'いる')};

    final result = remapVocabularyIds(
      {
        'srs_cards': cards([2]),
      },
      old,
      fresh,
    );

    expect(result.translated, 1);
    expect(result.dropped, 0);
    expect(result.rows['srs_cards']!.single[1], 97);
  });

  test('without the id, the same rename loses the card', () {
    // The behaviour this replaced, kept so the regression is visible.
    final old = {2: vocabularyIdentities(null, 'いる', 'いる')};
    final fresh = {97: vocabularyIdentities(null, '要る', 'いる')};

    expect(
      () => remapVocabularyIds(
        {
          'srs_cards': cards([2]),
        },
        old,
        fresh,
      ),
      throwsA(isA<VocabularyRemapException>()),
    );
  });

  test('upgrading from before schema 29 still matches on the spelling', () {
    // The old database has no JMdict id to offer; the new one has both keys.
    final old = {2: vocabularyIdentities(null, '食べる', 'たべる')};
    final fresh = {11: vocabularyIdentities('1358280', '食べる', 'たべる')};

    final result = remapVocabularyIds(
      {
        'srs_cards': cards([2]),
      },
      old,
      fresh,
    );

    expect(result.translated, 1);
    expect(result.rows['srs_cards']!.single[1], 11);
  });

  test('a word that really left is still dropped', () {
    final old = {
      2: vocabularyIdentities('1546640', '要る', 'いる'),
      3: vocabularyIdentities('9999999', '廃語', 'はいご'),
    };
    final fresh = {97: vocabularyIdentities('1546640', '要る', 'いる')};

    final result = remapVocabularyIds(
      {
        'srs_cards': cards([2, 3]),
      },
      old,
      fresh,
    );

    expect(result.translated, 1);
    expect(result.dropped, 1);
  });

  test('saved tables with nothing in them survive', () {
    final result = remapVocabularyIds(saved, const {}, const {});
    expect(result.translated, 0);
    expect(result.dropped, 0);
  });
}
