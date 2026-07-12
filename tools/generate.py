#!/usr/bin/env python3
"""Orchestrate the full content generation pipeline.

Steps (run from the repo root):
  1. Download missing KanjiVG SVGs into data/kanji_svg/
  2. (--translations) Regenerate multilingual translations from JMdict/KANJIDIC2
  3. Build manabi_do/assets/manabi_do_content.db

Usage:
    python3 tools/generate.py [--no-sentences] [--translations]

Flags:
    --no-sentences   Skip Tatoeba sentence import (much faster, good for grammar/kanji edits)
    --translations   Also run gen_translations.py before building the DB
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
        "--translations",
        action="store_true",
        help="Regenerate translations from JMdict/KANJIDIC2 before building",
    )
    args = parser.parse_args()

    run([sys.executable, "tools/download_kanjivg.py"])

    if args.translations:
        run([sys.executable, "tools/gen_translations.py"])

    build_cmd = [sys.executable, "tools/build_content_db.py"]
    if args.no_sentences:
        build_cmd.append("--no-sentences")
    run(build_cmd)


if __name__ == "__main__":
    main()
