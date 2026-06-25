#!/usr/bin/env python3
"""Lint bilingual RU+EN compliance for topic READMEs and notes."""

from __future__ import annotations

import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

KB = Path(__file__).resolve().parents[1]

SKIP_DIRS = {"reference/curated", ".git"}
SKIP_FILES = {
    KB / "reference/curated/README.md",
    KB / "reference/curated/notes/interview-answer-depth.md",
    KB / "_sidebar.md",
    KB / "README.md",
    KB / "ai-engineering/README.md",
    KB / "ai-engineering/roadmap/README.md",
    KB / "quality/testing/exercises/README.md",
}

RU_LABEL = re.compile(
    r"^\s*[-*]\s+\*\*(Question|Answer|Follow-up answer|Follow-up|"
    r"Устная заготовка|Итог одной фразой)\s*\(RU\):",
    re.I,
)
EN_LABEL = re.compile(
    r"^\s*[-*]\s+\*\*(Question|Answer|Follow-up answer|Follow-up|"
    r"Устная заготовка|Итог одной фразой)\s*\(EN\):",
    re.I,
)
Q_CARD = re.compile(r"^### Q\d+", re.M)
HAS_DETAILS = re.compile(r'<details\s+class="lang-ru"', re.I)
RU_FILENAME = re.compile(r"-RU\.md$", re.I)
SEC_30 = re.compile(r"^## In 30 seconds\s*$", re.M)
SEC_30_RU = re.compile(r"^## За 30 секунд\s*$", re.M)
CYRILLIC_HEADING = re.compile(r"^#{1,6}\s+.*[а-яА-ЯёЁ]", re.M)
CYRILLIC = re.compile(r"[а-яА-ЯёЁ]")
DETAILS_OPEN = re.compile(r'<details\s+class="lang-ru"', re.I)
DETAILS_CLOSE = re.compile(r"</details>", re.I)

README_SKIP_CYRILLIC = {
    KB / "glossary/README.md",
    KB / "ai-engineering/roadmap/README.md",
}


@dataclass
class Violations:
    path: Path
    issues: list[str] = field(default_factory=list)


def iter_targets() -> list[Path]:
    paths: list[Path] = []
    for readme in KB.rglob("README.md"):
        rel = readme.relative_to(KB).as_posix()
        if any(rel.startswith(s) for s in SKIP_DIRS):
            continue
        if readme in SKIP_FILES:
            continue
        if readme.parent.name == "curated" and "reference" in rel:
            continue
        paths.append(readme)
    for note in KB.rglob("notes/*.md"):
        rel = note.relative_to(KB).as_posix()
        if any(rel.startswith(s) for s in SKIP_DIRS):
            continue
        if "reference/curated" in rel:
            continue
        paths.append(note)
    return sorted(set(paths))


def visible_cyrillic_count(text: str) -> int:
    in_details = False
    in_fence = False
    total = 0
    for line in text.splitlines():
        stripped = line.strip()
        if stripped.startswith("```"):
            in_fence = not in_fence
        if DETAILS_OPEN.search(line):
            in_details = True
        if not in_details and not in_fence:
            total += len(CYRILLIC.findall(line))
        if DETAILS_CLOSE.search(line):
            in_details = False
    return total


def lint_file(path: Path) -> Violations:
    text = path.read_text(encoding="utf-8")
    v = Violations(path=path)

    if RU_FILENAME.search(path.name):
        v.issues.append("filename uses *-RU.md suffix")

    if SEC_30_RU.search(text):
        v.issues.append("uses deprecated '## За 30 секунд' heading — use '## In 30 seconds'")

    for match in CYRILLIC_HEADING.finditer(text):
        title = match.group().strip()
        v.issues.append(f"Cyrillic heading: {title[:60]}{'…' if len(title) > 60 else ''}")
        break

    if Q_CARD.search(text):
        cards = list(Q_CARD.finditer(text))
        for i, match in enumerate(cards):
            start = match.start()
            end = cards[i + 1].start() if i + 1 < len(cards) else len(text)
            block = text[start:end]
            if "<!-- knowledge-cards" in text[max(0, start - 80):start]:
                pass
            has_en = bool(EN_LABEL.search(block))
            has_ru = bool(RU_LABEL.search(block))
            qnum = match.group().strip()
            if has_ru and not has_en:
                v.issues.append(f"{qnum}: RU without EN")
            if has_en and not has_ru:
                v.issues.append(f"{qnum}: EN without RU")
            if has_ru and has_en and not HAS_DETAILS.search(block):
                v.issues.append(f"{qnum}: RU not in <details class=\"lang-ru\">")

    if SEC_30.search(text) and not HAS_DETAILS.search(text):
        v.issues.append("30-sec section missing <details class=\"lang-ru\">")

    if path.name == "README.md" and path not in README_SKIP_CYRILLIC:
        n = visible_cyrillic_count(text)
        if n > 0:
            v.issues.append(f"README has {n} visible Cyrillic char(s) outside <details class=\"lang-ru\">")

    return v


def main() -> int:
    write_baseline = "--baseline" in sys.argv
    all_v = [lint_file(p) for p in iter_targets()]
    violations = [v for v in all_v if v.issues]

    lines = [
        f"# Bilingual audit — {len(all_v)} files scanned, {len(violations)} with issues\n"
    ]
    for v in violations:
        rel = v.path.relative_to(KB)
        lines.append(f"\n## {rel}\n")
        for issue in v.issues:
            lines.append(f"- {issue}")

    report = "\n".join(lines) + "\n"
    baseline = KB / "scripts" / "bilingual-audit-baseline.txt"
    if write_baseline or not baseline.exists():
        baseline.write_text(report, encoding="utf-8")
        print(f"Wrote {baseline.relative_to(KB)}")

    for v in violations:
        rel = v.path.relative_to(KB)
        for issue in v.issues:
            print(f"{rel}: {issue}")

    print(f"\n{len(violations)} file(s) with issues")
    return 1 if violations else 0


if __name__ == "__main__":
    raise SystemExit(main())
