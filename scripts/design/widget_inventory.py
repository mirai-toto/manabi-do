#!/usr/bin/env python3
"""Group every widget by purpose and report overlaps, dead code and bypasses.

Directory layout groups widgets by feature area, which is the wrong axis for
spotting duplication: `PracticeButton` sat in `common/` and `AppButton` in
`common/` too, while both were buttons and neither review noticed. So roles are
declared here by hand, and an unclassified widget is reported rather than
ignored. Classifying a new widget is the moment the duplication becomes obvious,
which is the point.

Run from the repo root:

    python3 scripts/design/widget_inventory.py            # markdown to stdout
    python3 scripts/design/widget_inventory.py --write    # docs/08_widget_inventory.md
    python3 scripts/design/widget_inventory.py --check    # exit 1 on a finding
"""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
from collections import defaultdict
from dataclasses import dataclass, field
from pathlib import Path

APP = Path("manabi_do")
LIB = APP / "lib"
WIDGETS = LIB / "presentation" / "widgets"
DOC = Path("docs/08_widget_inventory.md")

# Roles describe what a widget is FOR, not where it lives. Two public widgets in
# one role is not automatically wrong, but it always needs a reason.
ROLES: dict[str, str] = {
    "action": "Things you press. One button engine; anything else here needs a reason.",
    "input": "Things you type into, draw on, or pick from.",
    "navigation": "Moving between tabs and destinations.",
    "surface": "Generic containers other widgets sit inside.",
    "indicator": "Read-only status: progress, counts, streaks, badges.",
    "label": "Text presentation, including Japanese-specific typography.",
    "list-item": "One row or tile inside a list or grid.",
    "exercise-body": "Owns one question type end to end inside a session.",
    "exercise-part": "A piece an exercise body composes.",
    "grammar-block": "One authored lesson block type, driven by content JSON.",
    "composite": "A whole section or view assembled from smaller widgets.",
    "decoration": "Purely visual furniture with no state of its own.",
}

CLASSIFIED: dict[str, str] = {
    # action
    "AppButton": "action",
    "AuthButton": "action",
    "SpeakButton": "action",
    "RatingButton": "action",
    "FlashcardActions": "action",
    "LessonReadToggle": "action",
    "AppFilterChip": "action",
    "SettingsToggle": "action",
    # input
    "AppTextField": "input",
    "SearchField": "input",
    "SegmentedControl": "input",
    "SegmentedTabBar": "input",
    "SettingsStepper": "input",
    "KanjiDrawingCanvas": "input",
    "LanguagePickerSheet": "input",
    # navigation
    "AppNavBar": "navigation",
    "AppNavRail": "navigation",
    "NavItem": "navigation",
    "NavDestination": "navigation",
    # surface
    "CardContainer": "surface",
    "TappableSurface": "surface",
    "SettingsCard": "surface",
    "CollapsibleSection": "surface",
    # indicator
    "AppProgressBar": "indicator",
    "ProgressRow": "indicator",
    "AppSpinner": "indicator",
    "DifficultyDots": "indicator",
    "PillBadge": "indicator",
    "StreakPill": "indicator",
    "ReviewProgressInfo": "indicator",
    "SrsProgressCard": "indicator",
    "PracticeProgressRow": "indicator",
    "WeekStrip": "indicator",
    "LevelBadge": "indicator",
    # label
    "SectionLabel": "label",
    "SectionHeader": "label",
    "JapaneseText": "label",
    "JapaneseSentence": "label",
    "FuriganaSegment": "label",
    "SettingsInfo": "label",
    # list-item
    "DeckRow": "list-item",
    "LessonRow": "list-item",
    "SettingsTile": "list-item",
    "VocabularyWordTile": "list-item",
    "ChapterCard": "list-item",
    "ContinueLessonCard": "list-item",
    "JlptLevelCard": "list-item",
    "PracticeModeCard": "list-item",
    "CharacterCell": "list-item",
    "SessionReviewRow": "list-item",
    "StudyGroupCard": "list-item",
    "TodaysSessionCard": "list-item",
    "KanjiReadingChip": "list-item",
    # exercise-body
    "PracticeFlashcardBody": "exercise-body",
    "PracticeMcqBody": "exercise-body",
    "KanjiDrawingBody": "exercise-body",
    "SentenceClozeBody": "exercise-body",
    "GrammarClozeBody": "exercise-body",
    "GrammarBuilderBody": "exercise-body",
    "GrammarErrorDetectionBody": "exercise-body",
    "DrawingExercise": "exercise-body",
    # exercise-part
    "Flashcard": "exercise-part",
    "McqCard": "exercise-part",
    "SentenceClozeCard": "exercise-part",
    "SummaryCard": "exercise-part",
    "FeedbackPanel": "exercise-part",
    "ExampleCard": "exercise-part",
    "ClozeOption": "exercise-part",
    "LetterCircle": "exercise-part",
    "LessonReaderCard": "exercise-part",
    "ReaderBodyText": "exercise-part",
    "ReaderSectionTitle": "exercise-part",
    "ReaderJpExample": "exercise-part",
    # grammar-block
    "GrammarBlockRenderer": "grammar-block",
    "TextBlock": "grammar-block",
    "ListBlock": "grammar-block",
    "NoteBlock": "grammar-block",
    "PatternBlock": "grammar-block",
    "SectionTitleBlock": "grammar-block",
    "ComparisonBlock": "grammar-block",
    "ComparisonSide": "grammar-block",
    "ConjugationTableBlock": "grammar-block",
    "ExampleTableBlock": "grammar-block",
    "VocabularyTableBlock": "grammar-block",
    "TransformCardsBlock": "grammar-block",
    "TransformGroup": "grammar-block",
    "TransformRow": "grammar-block",
    "GrammarTable": "grammar-block",
    # composite
    "KanjiGroupView": "composite",
    "KanjiGroupSelector": "composite",
    "KanjiLevelSelector": "composite",
    "VocabularyLevelView": "composite",
    "VocabularyGroupSelector": "composite",
    "VocabularyLevelSelector": "composite",
    "KanjiGrid": "composite",
    "KanjiExampleWords": "composite",
    "KanjiReadingsCard": "composite",
    "StrokeOrderSection": "composite",
    "StrokeStepRow": "composite",
    "SettingsAboutSection": "composite",
    "AttributionCard": "composite",
    "HomeSettingsCard": "composite",
    "PracticeSettingsCard": "composite",
    "HomeHeader": "composite",
    "KanjiLevelHeader": "composite",
    # decoration
    "SheetDragHandle": "decoration",
    "ScrollFade": "decoration",
    "KanjiHero": "decoration",
    "CharacterHeroBox": "decoration",
    "LandingHeroPanel": "decoration",
    "AppEmoji": "decoration",
    "StrokeOrderAnimator": "decoration",
}

# Material widgets that AppButton is meant to stand in front of. Counted outside
# widgets/common to measure how often the design system is bypassed.
BYPASS = ["ElevatedButton", "OutlinedButton", "FilledButton", "TextButton"]


@dataclass
class Widget:
    name: str
    path: Path
    role: str | None
    external: int = 0
    internal: int = 0
    callers: list[str] = field(default_factory=list)

    @property
    def dead(self) -> bool:
        return self.external == 0 and self.internal == 0

    @property
    def internal_only(self) -> bool:
        return self.external == 0 and self.internal > 0


def dart_files(root: Path) -> list[Path]:
    return [
        p
        for p in sorted(root.rglob("*.dart"))
        if not p.name.endswith(".g.dart") and p.name != "widgets.dart"
    ]


def declared_widgets() -> list[Widget]:
    found: list[Widget] = []
    decl = re.compile(r"^class ([A-Z][A-Za-z0-9_]*)", re.MULTILINE)
    for path in dart_files(WIDGETS):
        for name in decl.findall(path.read_text()):
            if name.endswith("State"):
                continue  # State classes are an implementation detail
            found.append(Widget(name=name, path=path, role=CLASSIFIED.get(name)))
    return found


def count_references(widgets: list[Widget]) -> None:
    """One ripgrep pass per widget is slow; read every file once instead."""
    sources: dict[Path, str] = {}
    for path in dart_files(LIB):
        if "widgetbook" in path.parts:
            continue  # previews are not usage
        sources[path] = path.read_text()

    for w in widgets:
        name = re.escape(w.name)
        # `Foo(`, `Foo<`, and named constructors like `Foo.compact(`.
        use = re.compile(rf"\b{name}(?:\.\w+)?\s*[(<]")
        # A widget's own constructors and State plumbing mention its name without
        # using it. Left in, every widget would look self-referencing and none
        # would ever read as dead. A declaration's first argument is always `{`,
        # `)`, `this.` or `super.`; an instantiation passes `name:` or a value,
        # which is what separates the two without parsing Dart.
        decl = re.compile(
            rf"\b{name}(?:\.\w+)?\s*\(\s*(?:\{{|\)|this\.|super\.)|"
            rf"\b(?:State|ConsumerState)\s*<\s*{name}\s*>|"
            rf"createState\(\)\s*=>\s*_?{name}",
            re.MULTILINE,
        )
        for path, text in sources.items():
            hits = len(use.findall(text))
            if not hits:
                continue
            if path == w.path:
                w.internal += max(0, hits - len(decl.findall(text)))
            else:
                w.external += hits
                w.callers.append(str(path.relative_to(LIB)))


def count_bypasses() -> dict[str, list[tuple[str, int]]]:
    out: dict[str, list[tuple[str, int]]] = defaultdict(list)
    common = WIDGETS / "common"
    for path in dart_files(LIB):
        if "widgetbook" in path.parts or common in path.parents:
            continue
        text = path.read_text()
        for name in BYPASS:
            hits = len(re.findall(rf"\b{name}[(.]", text))
            if hits:
                out[name].append((str(path.relative_to(LIB)), hits))
    return out


def render(widgets: list[Widget]) -> tuple[str, list[str]]:
    findings: list[str] = []
    by_role: dict[str, list[Widget]] = defaultdict(list)
    for w in widgets:
        by_role[w.role or "UNCLASSIFIED"].append(w)

    b: list[str] = []
    b.append("# Widget Inventory")
    b.append("")
    b.append(
        "Generated by `scripts/design/widget_inventory.py`. Do not edit by hand — "
        "edit the role map in that script and regenerate."
    )
    b.append("")
    b.append(
        "Widgets are grouped by **purpose**, not by directory. Directory groups by "
        "feature area, which is why two buttons living in `common/` went unnoticed "
        "through several reviews. Two public widgets sharing a role is not "
        "automatically wrong, but it always needs a reason."
    )
    b.append("")
    b.append(f"{len(widgets)} widget classes across {len(by_role)} roles.")
    b.append("")

    b.append("## Roles at a glance")
    b.append("")
    b.append("```mermaid")
    b.append("mindmap")
    b.append("  root((widgets))")
    for role in sorted(by_role):
        b.append(f"    {role}")
        for w in sorted(by_role[role], key=lambda x: x.name):
            mark = " ✗" if w.dead else (" ·" if w.internal_only else "")
            b.append(f"      {w.name}{mark}")
    b.append("```")
    b.append("")
    b.append("`✗` unused anywhere. `·` used only inside its own file.")
    b.append("")

    for role in sorted(by_role):
        group = sorted(by_role[role], key=lambda x: (-x.external, x.name))
        b.append(f"## {role}")
        b.append("")
        if role in ROLES:
            b.append(f"_{ROLES[role]}_")
            b.append("")
        b.append("| Widget | Uses | File |")
        b.append("| --- | --- | --- |")
        for w in group:
            uses = str(w.external) if w.external else (
                f"0 (internal ×{w.internal})" if w.internal else "**0**"
            )
            b.append(f"| `{w.name}` | {uses} | `{w.path.relative_to(WIDGETS)}` |")
        b.append("")

        public = [w for w in group if not w.dead and not w.internal_only]
        if role == "action" and len(public) > 1:
            names = ", ".join(f"`{w.name}`" for w in public)
            findings.append(f"{len(public)} widgets share the `action` role: {names}")

    dead = [w for w in widgets if w.dead]
    if dead:
        findings.extend(f"`{w.name}` is unused ({w.path.relative_to(LIB.parent)})" for w in dead)

    internal = [w for w in widgets if w.internal_only]
    if internal:
        b.append("## Used only inside their own file")
        b.append("")
        b.append("Candidates for a leading underscore, so the barrel stops exporting them.")
        b.append("")
        for w in sorted(internal, key=lambda x: x.name):
            b.append(f"- `{w.name}` — `{w.path.relative_to(WIDGETS)}`")
        b.append("")

    unclassified = by_role.get("UNCLASSIFIED", [])
    if unclassified:
        findings.extend(
            f"`{w.name}` has no role in the map ({w.path.relative_to(LIB.parent)})"
            for w in unclassified
        )

    bypasses = count_bypasses()
    if bypasses:
        total = sum(n for hits in bypasses.values() for _, n in hits)
        files = {f for hits in bypasses.values() for f, _ in hits}
        b.append("## Design-system bypasses")
        b.append("")
        b.append(
            f"{total} raw Material button usages across {len(files)} files outside "
            "`widgets/common/`. Each one is a button `AppButton` is not styling."
        )
        b.append("")
        b.append("| Material widget | Files | Usages |")
        b.append("| --- | --- | --- |")
        for name in BYPASS:
            hits = bypasses.get(name, [])
            if hits:
                b.append(f"| `{name}` | {len(hits)} | {sum(n for _, n in hits)} |")
        b.append("")
        findings.append(f"{total} raw Material button usages bypass AppButton")

    if findings:
        b.append("## Findings")
        b.append("")
        for f in findings:
            b.append(f"- {f}")
        b.append("")

    return "\n".join(b) + "\n", findings


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--write", action="store_true", help=f"write {DOC}")
    ap.add_argument("--check", action="store_true", help="exit 1 if there are findings")
    args = ap.parse_args()

    if not WIDGETS.is_dir():
        print(f"run from the repo root: {WIDGETS} not found", file=sys.stderr)
        return 2

    widgets = declared_widgets()
    count_references(widgets)
    doc, findings = render(widgets)

    if args.write:
        DOC.parent.mkdir(parents=True, exist_ok=True)
        DOC.write_text(doc)
        print(f"wrote {DOC} ({len(widgets)} widgets, {len(findings)} findings)")
    else:
        print(doc)

    for f in findings:
        print(f"finding: {f}", file=sys.stderr)

    return 1 if args.check and findings else 0


if __name__ == "__main__":
    sys.exit(main())
