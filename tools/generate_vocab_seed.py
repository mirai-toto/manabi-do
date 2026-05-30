#!/usr/bin/env python3
"""
Generate Dart vocabulary seed files (n5_vocab_seed.dart … n1_vocab_seed.dart).

Data sources:
  1. Bluskyo/JLPT_Vocabulary  — JLPT level + reading per word (no meanings)
  2. jmdict-simplified         — meanings + part-of-speech for each word

Run once; commit the generated .dart files.

Usage:
  python3 tools/generate_vocab_seed.py

Requires Python 3.9+ (stdlib only, no pip packages).
"""

import io
import json
import os
import re
import sys
import urllib.request
import zipfile

TOOLS_DIR = os.path.dirname(os.path.abspath(__file__))
OUT_DIR   = os.path.join(TOOLS_DIR, '../manabi_do/lib/data/database')

BLUSKYO_URL    = 'https://raw.githubusercontent.com/Bluskyo/JLPT_Vocabulary/main/data/vocab/results/JLPT_vocab_ALL.json'
JMDICT_API_URL = 'https://api.github.com/repos/scriptin/jmdict-simplified/releases/latest'

# ── Download helper ───────────────────────────────────────────────────────────

def _get(url: str, desc: str) -> bytes:
    print(f'  ↓ {desc}')
    req = urllib.request.Request(url, headers={'User-Agent': 'manabi-do/vocab-seed'})
    with urllib.request.urlopen(req, timeout=120) as r:
        total = int(r.headers.get('Content-Length', 0))
        buf   = io.BytesIO()
        done  = 0
        while chunk := r.read(1 << 16):
            buf.write(chunk)
            done += len(chunk)
            if total:
                print(f'\r    {done * 100 // total:3d}%  {done // 1024} KB ', end='', flush=True)
        print()
    return buf.getvalue()


def _jmdict_zip_url() -> str:
    data = json.loads(_get(JMDICT_API_URL, 'jmdict-simplified release info'))
    for asset in data.get('assets', []):
        name: str = asset.get('name', '')
        if name.startswith('jmdict-all') and name.endswith('.json.zip'):
            return asset['browser_download_url']
    raise RuntimeError('Could not find jmdict-all .json.zip in latest release assets')


# ── Part-of-speech normalisation ──────────────────────────────────────────────

_POS_MAP: dict[str, str] = {
    'n':       'noun',
    'adj-i':   'i-adjective',
    'adj-na':  'na-adjective',
    'adj-no':  'no-adjective',
    'adv':     'adverb',
    'adv-to':  'adverb',
    'conj':    'conjunction',
    'int':     'interjection',
    'prt':     'particle',
    'pn':      'pronoun',
    'exp':     'expression',
    'num':     'numeral',
    'aux':     'auxiliary',
    'aux-v':   'auxiliary verb',
    'aux-adj': 'auxiliary adjective',
    'suf':     'suffix',
    'pref':    'prefix',
    'ctr':     'counter',
}
_VERB_RE = re.compile(r'^v\d|^vi$|^vt$|^vs$|^vk$|^vz$|^vr$|^vn$')


def _normalise_pos(codes: list[str]) -> str:
    for code in codes:
        if code in _POS_MAP:
            return _POS_MAP[code]
        if _VERB_RE.match(code):
            return 'verb'
    return codes[0] if codes else ''


# ── jmdict index ──────────────────────────────────────────────────────────────

def build_jmdict_index(jmdict: dict) -> dict[str, tuple[str, str, str]]:
    """Returns { surface_form: (primary_reading, meaning_en, pos) }."""
    idx: dict[str, tuple[str, str, str]] = {}

    for word in jmdict.get('words', []):
        kanji_forms: list[str] = [k['text'] for k in word.get('kanji', []) if k.get('text')]
        kana_forms:  list[str] = [k['text'] for k in word.get('kana',  []) if k.get('text')]
        primary_kana = kana_forms[0] if kana_forms else ''

        meaning = ''
        pos_str = ''
        for sense in word.get('sense', []):
            glosses = [g['text'] for g in sense.get('gloss', []) if g.get('lang', 'eng') == 'eng']
            if not glosses:
                continue
            meaning = '; '.join(glosses[:3])
            pos_str = _normalise_pos(sense.get('partOfSpeech', []))
            break

        if not meaning:
            continue

        for form in kanji_forms or kana_forms:
            if form not in idx:
                idx[form] = (primary_kana, meaning, pos_str)

    return idx


# ── Kanji codepoints ──────────────────────────────────────────────────────────

def load_kanji_ids() -> set[int]:
    ids: set[int] = set()
    for fname in os.listdir(OUT_DIR):
        if fname.endswith('_kanji_seed.dart'):
            with open(os.path.join(OUT_DIR, fname)) as f:
                for line in f:
                    m = re.match(r'\s*\((\d+),', line)
                    if m:
                        ids.add(int(m.group(1)))
    print(f'  Loaded {len(ids)} kanji codepoints')
    return ids


def primary_kanji_id(word: str, kanji_ids: set[int]) -> int | None:
    for ch in word:
        cp = ord(ch)
        if cp in kanji_ids:
            return cp
    return None


# ── Dart string escaping ──────────────────────────────────────────────────────

def _esc(s: str) -> str:
    return s.replace('\\', '\\\\').replace("'", "\\'")


# ── Main ──────────────────────────────────────────────────────────────────────

def main() -> None:
    print('=== Step 1: Bluskyo JLPT vocabulary ===')
    bluskyo: dict[str, list[dict]] = json.loads(_get(BLUSKYO_URL, 'JLPT_vocabulary.json'))
    print(f'  {len(bluskyo)} total entries')

    # Bluskyo level: 1=N1 … 5=N5
    by_level: dict[int, list[tuple[str, str]]] = {i: [] for i in range(1, 6)}
    for word, entries in bluskyo.items():
        for entry in entries:
            lvl = entry.get('level')
            if lvl in by_level:
                by_level[lvl].append((word, entry.get('reading', '')))

    for i in range(1, 6):
        print(f'  N{i}: {len(by_level[i])} words')

    print('\n=== Step 2: jmdict-simplified ===')
    jmdict_url = _jmdict_zip_url()
    zip_bytes  = _get(jmdict_url, 'jmdict-all.json.zip')
    print('  Extracting…')
    with zipfile.ZipFile(io.BytesIO(zip_bytes)) as zf:
        json_name = next(n for n in zf.namelist() if n.endswith('.json'))
        print(f'  Parsing {json_name}…')
        jmdict = json.loads(zf.read(json_name))
    print('  Building lookup index…')
    jmdict_idx = build_jmdict_index(jmdict)
    del jmdict  # free memory
    print(f'  {len(jmdict_idx)} indexed surface forms')

    print('\n=== Step 3: Kanji codepoints ===')
    kanji_ids = load_kanji_ids()

    print('\n=== Step 4: Write Dart seed files ===')
    # level_int 5 → N5 → file n5_vocab_seed.dart, var n5VocabData
    total_ok = total_miss = 0
    for lvl_int in range(1, 6):
        level_str = f'N{lvl_int}'
        dart_name = f'n{lvl_int}VocabData'
        fname     = f'n{lvl_int}_vocab_seed.dart'
        out_path  = os.path.join(OUT_DIR, fname)

        lines:   list[str] = []
        missing: list[str] = []

        for word, bluskyo_reading in by_level[lvl_int]:
            hit = jmdict_idx.get(word) or jmdict_idx.get(bluskyo_reading)
            if hit is None:
                missing.append(word)
                continue
            jm_reading, meaning, pos = hit
            reading   = bluskyo_reading if bluskyo_reading else jm_reading
            kanji_id  = primary_kanji_id(word, kanji_ids)
            kid_str   = str(kanji_id) if kanji_id is not None else 'null'
            lines.append(
                f"  ('{_esc(word)}', '{_esc(reading)}', '{_esc(meaning)}', '{_esc(pos)}', {kid_str}),"
            )

        ok   = len(lines)
        miss = len(missing)
        total_ok   += ok
        total_miss += miss
        print(f'  {level_str}: {ok} written, {miss} not found')
        if missing[:5]:
            print(f'    e.g. not found: {missing[:5]}')

        header = (
            f'// {level_str} vocabulary — auto-generated by tools/generate_vocab_seed.py\n'
            f'// (word, reading, meaning, partOfSpeech, kanjiId)\n'
            f'// DO NOT EDIT manually.\n'
            f'const {dart_name} = <(String, String, String, String, int?)>[\n'
        )
        with open(out_path, 'w', encoding='utf-8') as f:
            f.write(header)
            f.write('\n'.join(lines))
            f.write('\n];\n')
        print(f'  → {fname}')

    print(f'\nDone — {total_ok} entries written, {total_miss} skipped (not in jmdict)')


if __name__ == '__main__':
    main()
