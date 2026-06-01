class KanaEntry {
  final String kana;
  final String romaji;
  const KanaEntry(this.kana, this.romaji);
}

class KanaRow {
  final String label;
  // null entries render as blank spacer cells to preserve grid alignment
  final List<KanaEntry?> entries;
  const KanaRow({required this.label, required this.entries});
  List<KanaEntry> get kana => entries.whereType<KanaEntry>().toList();
}

abstract final class KanaData {
  static const hiragana = <KanaRow>[
    // ── Gojuuon ──────────────────────────────────────────
    KanaRow(label: 'Vowels', entries: [
      KanaEntry('あ', 'a'), KanaEntry('い', 'i'), KanaEntry('う', 'u'),
      KanaEntry('え', 'e'), KanaEntry('お', 'o'),
    ]),
    KanaRow(label: 'K', entries: [
      KanaEntry('か', 'ka'), KanaEntry('き', 'ki'), KanaEntry('く', 'ku'),
      KanaEntry('け', 'ke'), KanaEntry('こ', 'ko'),
    ]),
    KanaRow(label: 'S', entries: [
      KanaEntry('さ', 'sa'), KanaEntry('し', 'shi'), KanaEntry('す', 'su'),
      KanaEntry('せ', 'se'), KanaEntry('そ', 'so'),
    ]),
    KanaRow(label: 'T', entries: [
      KanaEntry('た', 'ta'), KanaEntry('ち', 'chi'), KanaEntry('つ', 'tsu'),
      KanaEntry('て', 'te'), KanaEntry('と', 'to'),
    ]),
    KanaRow(label: 'N', entries: [
      KanaEntry('な', 'na'), KanaEntry('に', 'ni'), KanaEntry('ぬ', 'nu'),
      KanaEntry('ね', 'ne'), KanaEntry('の', 'no'),
    ]),
    KanaRow(label: 'H', entries: [
      KanaEntry('は', 'ha'), KanaEntry('ひ', 'hi'), KanaEntry('ふ', 'fu'),
      KanaEntry('へ', 'he'), KanaEntry('ほ', 'ho'),
    ]),
    KanaRow(label: 'M', entries: [
      KanaEntry('ま', 'ma'), KanaEntry('み', 'mi'), KanaEntry('む', 'mu'),
      KanaEntry('め', 'me'), KanaEntry('も', 'mo'),
    ]),
    KanaRow(label: 'Y', entries: [
      KanaEntry('や', 'ya'), null, KanaEntry('ゆ', 'yu'), null, KanaEntry('よ', 'yo'),
    ]),
    KanaRow(label: 'R', entries: [
      KanaEntry('ら', 'ra'), KanaEntry('り', 'ri'), KanaEntry('る', 'ru'),
      KanaEntry('れ', 're'), KanaEntry('ろ', 'ro'),
    ]),
    KanaRow(label: 'W / N', entries: [
      KanaEntry('わ', 'wa'), null, KanaEntry('を', 'wo'), null, KanaEntry('ん', 'n'),
    ]),
    // ── Dakuten (voiced) ──────────────────────────────────
    KanaRow(label: 'G', entries: [
      KanaEntry('が', 'ga'), KanaEntry('ぎ', 'gi'), KanaEntry('ぐ', 'gu'),
      KanaEntry('げ', 'ge'), KanaEntry('ご', 'go'),
    ]),
    KanaRow(label: 'Z', entries: [
      KanaEntry('ざ', 'za'), KanaEntry('じ', 'ji'), KanaEntry('ず', 'zu'),
      KanaEntry('ぜ', 'ze'), KanaEntry('ぞ', 'zo'),
    ]),
    KanaRow(label: 'D', entries: [
      KanaEntry('だ', 'da'), KanaEntry('ぢ', 'di'), KanaEntry('づ', 'du'),
      KanaEntry('で', 'de'), KanaEntry('ど', 'do'),
    ]),
    KanaRow(label: 'B', entries: [
      KanaEntry('ば', 'ba'), KanaEntry('び', 'bi'), KanaEntry('ぶ', 'bu'),
      KanaEntry('べ', 'be'), KanaEntry('ぼ', 'bo'),
    ]),
    KanaRow(label: 'P', entries: [
      KanaEntry('ぱ', 'pa'), KanaEntry('ぴ', 'pi'), KanaEntry('ぷ', 'pu'),
      KanaEntry('ぺ', 'pe'), KanaEntry('ぽ', 'po'),
    ]),
  ];

  static const katakana = <KanaRow>[
    // ── Gojuuon ──────────────────────────────────────────
    KanaRow(label: 'Vowels', entries: [
      KanaEntry('ア', 'a'), KanaEntry('イ', 'i'), KanaEntry('ウ', 'u'),
      KanaEntry('エ', 'e'), KanaEntry('オ', 'o'),
    ]),
    KanaRow(label: 'K', entries: [
      KanaEntry('カ', 'ka'), KanaEntry('キ', 'ki'), KanaEntry('ク', 'ku'),
      KanaEntry('ケ', 'ke'), KanaEntry('コ', 'ko'),
    ]),
    KanaRow(label: 'S', entries: [
      KanaEntry('サ', 'sa'), KanaEntry('シ', 'shi'), KanaEntry('ス', 'su'),
      KanaEntry('セ', 'se'), KanaEntry('ソ', 'so'),
    ]),
    KanaRow(label: 'T', entries: [
      KanaEntry('タ', 'ta'), KanaEntry('チ', 'chi'), KanaEntry('ツ', 'tsu'),
      KanaEntry('テ', 'te'), KanaEntry('ト', 'to'),
    ]),
    KanaRow(label: 'N', entries: [
      KanaEntry('ナ', 'na'), KanaEntry('ニ', 'ni'), KanaEntry('ヌ', 'nu'),
      KanaEntry('ネ', 'ne'), KanaEntry('ノ', 'no'),
    ]),
    KanaRow(label: 'H', entries: [
      KanaEntry('ハ', 'ha'), KanaEntry('ヒ', 'hi'), KanaEntry('フ', 'fu'),
      KanaEntry('ヘ', 'he'), KanaEntry('ホ', 'ho'),
    ]),
    KanaRow(label: 'M', entries: [
      KanaEntry('マ', 'ma'), KanaEntry('ミ', 'mi'), KanaEntry('ム', 'mu'),
      KanaEntry('メ', 'me'), KanaEntry('モ', 'mo'),
    ]),
    KanaRow(label: 'Y', entries: [
      KanaEntry('ヤ', 'ya'), null, KanaEntry('ユ', 'yu'), null, KanaEntry('ヨ', 'yo'),
    ]),
    KanaRow(label: 'R', entries: [
      KanaEntry('ラ', 'ra'), KanaEntry('リ', 'ri'), KanaEntry('ル', 'ru'),
      KanaEntry('レ', 're'), KanaEntry('ロ', 'ro'),
    ]),
    KanaRow(label: 'W / N', entries: [
      KanaEntry('ワ', 'wa'), null, KanaEntry('ヲ', 'wo'), null, KanaEntry('ン', 'n'),
    ]),
    // ── Dakuten (voiced) ──────────────────────────────────
    KanaRow(label: 'G', entries: [
      KanaEntry('ガ', 'ga'), KanaEntry('ギ', 'gi'), KanaEntry('グ', 'gu'),
      KanaEntry('ゲ', 'ge'), KanaEntry('ゴ', 'go'),
    ]),
    KanaRow(label: 'Z', entries: [
      KanaEntry('ザ', 'za'), KanaEntry('ジ', 'ji'), KanaEntry('ズ', 'zu'),
      KanaEntry('ゼ', 'ze'), KanaEntry('ゾ', 'zo'),
    ]),
    KanaRow(label: 'D', entries: [
      KanaEntry('ダ', 'da'), KanaEntry('ヂ', 'di'), KanaEntry('ヅ', 'du'),
      KanaEntry('デ', 'de'), KanaEntry('ド', 'do'),
    ]),
    KanaRow(label: 'B', entries: [
      KanaEntry('バ', 'ba'), KanaEntry('ビ', 'bi'), KanaEntry('ブ', 'bu'),
      KanaEntry('ベ', 'be'), KanaEntry('ボ', 'bo'),
    ]),
    KanaRow(label: 'P', entries: [
      KanaEntry('パ', 'pa'), KanaEntry('ピ', 'pi'), KanaEntry('プ', 'pu'),
      KanaEntry('ペ', 'pe'), KanaEntry('ポ', 'po'),
    ]),
  ];
}
