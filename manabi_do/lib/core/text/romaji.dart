/// Romaji typed into a search box, read as kana.
///
/// Covers Hepburn and Kunrei spellings (shi/si, tsu/tu, ja/zya…), doubled
/// consonants (kitte → きって), and the ways people write ん (n before a
/// consonant or at the end, nn, n'). A hyphen becomes the long-vowel mark, so
/// katakana words such as "ko-hi-" still find コーヒー.
library;

/// The hiragana reading of [input], or null when it is not plain romaji: any
/// character outside a–z, apostrophe and hyphen, or letters that do not spell
/// kana, means the query was meant as something else (an English word, say)
/// and is left alone.
String? romajiToHiragana(String input) {
  final String text = input.trim().toLowerCase();
  if (text.isEmpty || !RegExp(r"^[a-z'\-]+$").hasMatch(text)) return null;

  final StringBuffer out = StringBuffer();
  int i = 0;
  while (i < text.length) {
    final String c = text[i];

    if (c == '-') {
      out.write('ー');
      i++;
      continue;
    }
    if (c == "'") {
      i++;
      continue;
    }

    // ん: "nn", "n'", or n not followed by a vowel or y.
    if (c == 'n') {
      final String? next = i + 1 < text.length ? text[i + 1] : null;
      if (next == 'n') {
        // "nn" before a vowel is ん plus an n- syllable: konnichiwa.
        final String? after = i + 2 < text.length ? text[i + 2] : null;
        out.write('ん');
        i += after != null && 'aiueoy'.contains(after) ? 1 : 2;
        continue;
      }
      if (next == null || !'aiueoy'.contains(next)) {
        out.write('ん');
        i++;
        continue;
      }
    }

    // A doubled consonant is a small っ before the syllable.
    if (i + 1 < text.length && c == text[i + 1] && !'aiueon'.contains(c)) {
      out.write('っ');
      i++;
      continue;
    }
    // Hepburn writes っち as "tch".
    if (text.startsWith('tch', i)) {
      out.write('っ');
      i++;
      continue;
    }

    String? kana;
    for (int length = 3; length >= 1 && kana == null; length--) {
      if (i + length > text.length) continue;
      final String syllable = text.substring(i, i + length);
      kana = _syllables[syllable];
      if (kana != null) i += length;
    }
    if (kana == null) return null;
    out.write(kana);
  }
  return out.toString();
}

/// [hiragana] in katakana. The long-vowel mark and anything outside the
/// hiragana block pass through unchanged.
String hiraganaToKatakana(String hiragana) => String.fromCharCodes(
  hiragana.runes.map(
    (int rune) => rune >= 0x3041 && rune <= 0x3096 ? rune + 0x60 : rune,
  ),
);

const Map<String, String> _syllables = {
  'a': 'あ',
  'i': 'い',
  'u': 'う',
  'e': 'え',
  'o': 'お',
  'ka': 'か',
  'ki': 'き',
  'ku': 'く',
  'ke': 'け',
  'ko': 'こ',
  'sa': 'さ',
  'shi': 'し',
  'si': 'し',
  'su': 'す',
  'se': 'せ',
  'so': 'そ',
  'ta': 'た',
  'chi': 'ち',
  'ti': 'ち',
  'tsu': 'つ',
  'tu': 'つ',
  'te': 'て',
  'to': 'と',
  'na': 'な',
  'ni': 'に',
  'nu': 'ぬ',
  'ne': 'ね',
  'no': 'の',
  'ha': 'は',
  'hi': 'ひ',
  'fu': 'ふ',
  'hu': 'ふ',
  'he': 'へ',
  'ho': 'ほ',
  'ma': 'ま',
  'mi': 'み',
  'mu': 'む',
  'me': 'め',
  'mo': 'も',
  'ya': 'や',
  'yu': 'ゆ',
  'yo': 'よ',
  'ra': 'ら',
  'ri': 'り',
  'ru': 'る',
  're': 'れ',
  'ro': 'ろ',
  'wa': 'わ',
  'wo': 'を',
  'ga': 'が',
  'gi': 'ぎ',
  'gu': 'ぐ',
  'ge': 'げ',
  'go': 'ご',
  'za': 'ざ',
  'ji': 'じ',
  'zi': 'じ',
  'zu': 'ず',
  'ze': 'ぜ',
  'zo': 'ぞ',
  'da': 'だ',
  'di': 'ぢ',
  'du': 'づ',
  'dzu': 'づ',
  'de': 'で',
  'do': 'ど',
  'ba': 'ば',
  'bi': 'び',
  'bu': 'ぶ',
  'be': 'べ',
  'bo': 'ぼ',
  'pa': 'ぱ',
  'pi': 'ぴ',
  'pu': 'ぷ',
  'pe': 'ぺ',
  'po': 'ぽ',
  'kya': 'きゃ',
  'kyu': 'きゅ',
  'kyo': 'きょ',
  'sha': 'しゃ',
  'shu': 'しゅ',
  'sho': 'しょ',
  'she': 'しぇ',
  'sya': 'しゃ',
  'syu': 'しゅ',
  'syo': 'しょ',
  'cha': 'ちゃ',
  'chu': 'ちゅ',
  'cho': 'ちょ',
  'che': 'ちぇ',
  'tya': 'ちゃ',
  'tyu': 'ちゅ',
  'tyo': 'ちょ',
  'nya': 'にゃ',
  'nyu': 'にゅ',
  'nyo': 'にょ',
  'hya': 'ひゃ',
  'hyu': 'ひゅ',
  'hyo': 'ひょ',
  'mya': 'みゃ',
  'myu': 'みゅ',
  'myo': 'みょ',
  'rya': 'りゃ',
  'ryu': 'りゅ',
  'ryo': 'りょ',
  'gya': 'ぎゃ',
  'gyu': 'ぎゅ',
  'gyo': 'ぎょ',
  'ja': 'じゃ',
  'ju': 'じゅ',
  'jo': 'じょ',
  'je': 'じぇ',
  'zya': 'じゃ',
  'zyu': 'じゅ',
  'zyo': 'じょ',
  'jya': 'じゃ',
  'jyu': 'じゅ',
  'jyo': 'じょ',
  'bya': 'びゃ',
  'byu': 'びゅ',
  'byo': 'びょ',
  'pya': 'ぴゃ',
  'pyu': 'ぴゅ',
  'pyo': 'ぴょ',
  'fa': 'ふぁ',
  'fi': 'ふぃ',
  'fe': 'ふぇ',
  'fo': 'ふぉ',
  'va': 'ゔぁ',
  'vi': 'ゔぃ',
  'vu': 'ゔ',
  've': 'ゔぇ',
  'vo': 'ゔぉ',
  'thi': 'てぃ',
  'dhi': 'でぃ',
  'twu': 'とぅ',
};
