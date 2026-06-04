// Enriches content/kanji_n[1-5].json and content/vocab_n[1-5].json
// with multilingual meanings from JMdict-simplified and KANJIDIC2.
//
// Prerequisites — download these files and place them in tool/data/:
//   JMdict-simplified (all languages JSON):
//     https://github.com/scriptin/jmdict-simplified/releases
//     → jmdict-all-<version>.json  (rename to tool/data/jmdict.json)
//   KANJIDIC2 XML:
//     https://www.edrdg.org/kanjidic/kanjidic2.xml.gz
//     → uncompress to tool/data/kanjidic2.xml
//
// Run from the project root:
//   dart run tool/gen_translations.dart
//
// After running, commit the updated JSON files. The DB will pick up
// the new translations on the next app reinstall / schema migration.

import 'dart:convert';
import 'dart:io';
import 'package:xml/xml.dart';

// BCP-47 normalization for JMdict lang codes
const _langMap = {
  'eng': 'en',
  'fre': 'fr',
  'ger': 'de',
  'spa': 'es',
  'rus': 'ru',
  'nld': 'nl',
  'hun': 'hu',
  'slv': 'sl',
  'swe': 'sv',
};

void main() async {
  final jmdictFile   = File('tool/data/jmdict.json');
  final kanjidic2File = File('tool/data/kanjidic2.xml');

  if (!jmdictFile.existsSync() || !kanjidic2File.existsSync()) {
    stderr.writeln('Missing input files. See the instructions at the top of this script.');
    exit(1);
  }

  stdout.writeln('Loading JMdict…');
  final jmdict = jsonDecode(await jmdictFile.readAsString()) as Map<String, dynamic>;
  final jmdictWords = jmdict['words'] as List<dynamic>;

  // Build lookup: (kanji_form, reading_form) → Map<locale, meaning>
  final vocabLookup = <(String, String), Map<String, String>>{};
  for (final word in jmdictWords) {
    final kanjiForms   = (word['kanji']   as List<dynamic>).map((k) => k['text'] as String).toList();
    final readingForms = (word['kana']    as List<dynamic>).map((r) => r['text'] as String).toList();
    final senses       = word['sense']    as List<dynamic>;

    final translations = <String, List<String>>{};
    for (final sense in senses) {
      final glosses = sense['gloss'] as List<dynamic>;
      for (final gloss in glosses) {
        final lang = _langMap[gloss['lang'] as String? ?? 'eng'];
        if (lang == null) continue;
        final text = gloss['text'] as String;
        translations.putIfAbsent(lang, () => []).add(text);
      }
    }

    final merged = translations.map((k, v) => MapEntry(k, v.join('; ')));
    if (merged.isEmpty) continue;

    for (final k in kanjiForms.isEmpty ? [''] : kanjiForms) {
      for (final r in readingForms) {
        vocabLookup[(k, r)] ??= {};
        vocabLookup[(k, r)]!.addAll(merged);
      }
    }
  }

  stdout.writeln('Loading KANJIDIC2…');
  final kanjiXml = XmlDocument.parse(await kanjidic2File.readAsString());

  // Build lookup: kanjiId (unicode codepoint) → Map<locale, meaning>
  final kanjiLookup = <int, Map<String, String>>{};
  for (final entry in kanjiXml.findAllElements('character')) {
    final literal = entry.findElements('literal').first.innerText;
    final id = literal.runes.first;

    final meanings = <String, List<String>>{};
    for (final rm in entry.findAllElements('rmgroup')) {
      for (final m in rm.findAllElements('meaning')) {
        final langAttr = m.getAttribute('m_lang') ?? 'en';
        final lang = langAttr.isEmpty ? 'en' : _langMap[langAttr] ?? langAttr;
        meanings.putIfAbsent(lang, () => []).add(m.innerText);
      }
    }
    kanjiLookup[id] = meanings.map((k, v) => MapEntry(k, v.join(', ')));
  }

  const encoder = JsonEncoder.withIndent('  ');
  final outDir = Directory('content');

  for (final slug in ['n5', 'n4', 'n3', 'n2', 'n1']) {
    // ── Kanji ────────────────────────────────────────────────────────────
    final kanjiFile = File('${outDir.path}/kanji_$slug.json');
    final kanjiList = (jsonDecode(await kanjiFile.readAsString()) as List<dynamic>)
        .cast<Map<String, dynamic>>();

    int kanjiHits = 0;
    for (final entry in kanjiList) {
      final id = entry['id'] as int;
      final tr = kanjiLookup[id];
      if (tr != null && tr.isNotEmpty) {
        final existing = entry['meanings'] as Map<String, dynamic>;
        existing.addAll(tr);
        kanjiHits++;
      }
    }
    await kanjiFile.writeAsString(encoder.convert(kanjiList));
    stdout.writeln('kanji_$slug.json: enriched $kanjiHits / ${kanjiList.length} entries');

    // ── Vocab ─────────────────────────────────────────────────────────────
    final vocabFile = File('${outDir.path}/vocab_$slug.json');
    final vocabList = (jsonDecode(await vocabFile.readAsString()) as List<dynamic>)
        .cast<Map<String, dynamic>>();

    int vocabHits = 0;
    for (final entry in vocabList) {
      final word    = entry['word']    as String;
      final reading = entry['reading'] as String;
      final tr = vocabLookup[(word, reading)] ?? vocabLookup[('', reading)];
      if (tr != null && tr.isNotEmpty) {
        final existing = entry['meanings'] as Map<String, dynamic>;
        existing.addAll(tr);
        vocabHits++;
      }
    }
    await vocabFile.writeAsString(encoder.convert(vocabList));
    stdout.writeln('vocab_$slug.json: enriched $vocabHits / ${vocabList.length} entries');
  }

  stdout.writeln('\nDone. Reinstall the app to trigger a DB reseed with the new translations.');
}
