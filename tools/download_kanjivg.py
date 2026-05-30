#!/usr/bin/env python3
"""Download KanjiVG SVG files for all N1-N5 kanji in the seed data."""

import re
import os
import time
import urllib.request

SEED_DIR = os.path.join(os.path.dirname(__file__), '../manabi_do/lib/data/database')
OUT_DIR  = os.path.join(os.path.dirname(__file__), '../manabi_do/assets/kanji_svg')
BASE_URL = 'https://raw.githubusercontent.com/KanjiVG/kanjivg/master/kanji/{}.svg'

os.makedirs(OUT_DIR, exist_ok=True)

ids: set[int] = set()
for fname in os.listdir(SEED_DIR):
    if fname.endswith('_kanji_seed.dart'):
        with open(os.path.join(SEED_DIR, fname)) as f:
            for line in f:
                m = re.match(r'\s*\((\d+),', line)
                if m:
                    ids.add(int(m.group(1)))

print(f'Found {len(ids)} unique kanji codepoints')

skipped = 0
downloaded = 0
failed: list[str] = []

for cp in sorted(ids):
    hex_name = f'{cp:05x}'
    out_path = os.path.join(OUT_DIR, f'{hex_name}.svg')
    if os.path.exists(out_path):
        skipped += 1
        continue
    url = BASE_URL.format(hex_name)
    try:
        urllib.request.urlretrieve(url, out_path)
        downloaded += 1
        if downloaded % 50 == 0:
            print(f'  {downloaded} downloaded...')
        time.sleep(0.05)
    except Exception as e:
        failed.append(hex_name)
        print(f'  FAIL {hex_name}: {e}')

print(f'\nDone — {downloaded} downloaded, {skipped} already present, {len(failed)} failed')
if failed:
    print('Failed:', ', '.join(failed))
