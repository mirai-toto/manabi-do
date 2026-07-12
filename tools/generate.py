#!/usr/bin/env python3
"""Orchestrate the full content generation pipeline.

Steps (run from the repo root):
  1. (--sync)         Re-seed content/characters/ and content/vocabulary/ from online sources
  2. (--translations) Refresh multilingual meanings on existing entries
  3. Download missing KanjiVG SVGs into data/kanji_svg/
  4. Build manabi_do/assets/manabi_do_content.db

Usage:
    python3 tools/generate.py [--no-sentences] [--sync [--force]] [--translations]

Flags:
    --no-sentences   Skip Tatoeba sentence import (much faster, good for grammar/kanji edits)
    --sync           Re-seed kanji/vocab JSON from Bluskyo, JMdict, KANJIDIC2 before building
    --force          With --sync: re-download source files even if already cached in data/
    --translations   Refresh multilingual meanings from JMdict/KANJIDIC2 before building
                     Requires data/jmdict.json and data/kanjidic2.xml (see content/README.md)
"""

import argparse
import subprocess
import sys


def run(cmd: list[str]) -> None:
    print(f"\n{'─' * 60}")
    print(f"▶ {' '.join(cmd)}")
    print(f"{'─' * 60}")
    result = subprocess.run(cmd)
    if result.returncode != 0:
        sys.exit(result.returncode)


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Rebuild all generated content for Manabi Do.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "--no-sentences",
        action="store_true",
        help="Skip Tatoeba sentence import",
    )
    parser.add_argument(
        "--sync",
        action="store_true",
        help="Re-seed kanji/vocab JSON from online sources before building",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="With --sync: re-download source files even if already cached",
    )
    parser.add_argument(
        "--translations",
        action="store_true",
        help="Refresh multilingual meanings from JMdict/KANJIDIC2 before building",
    )
    args = parser.parse_args()

    if args.sync:
        sync_cmd = [sys.executable, "tools/sync_content.py"]
        if args.force:
            sync_cmd.append("--force")
        run(sync_cmd)

    if args.translations:
        run([sys.executable, "tools/gen_translations.py"])

    run([sys.executable, "tools/download_kanjivg.py"])

    build_cmd = [sys.executable, "tools/build_content_db.py"]
    if args.no_sentences:
        build_cmd.append("--no-sentences")
    run(build_cmd)


if __name__ == "__main__":
    main()
