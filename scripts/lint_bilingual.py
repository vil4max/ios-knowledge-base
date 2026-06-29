#!/usr/bin/env python3
"""Lint English-only compliance for topic READMEs and notes."""

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
    KB / "quality/testing/exercises/README.md",
}

CYRILLIC_HEADING = re.compile(r"^#{1,6}\s+.*[а-яА-ЯёЁ]", re.M)
CYRILLIC = re.compile(r"[а-яА-ЯёЁ]")
LANG_RU = re.compile(r'<details\s+class="lang-ru"', re.I)
RU_LABEL = re.compile(
    r"^\s*[-*]\s+\*\*(Question|Answer|Follow-up answer|Follow-up|"
    r"Устная заготовка|Итог одной фразой)\s*\(RU\):",
    re.I,
)
SEC_30_RU = re.compile(r"^## За 30 секунд\s*$", re.M)
RU_FILENAME = re.compile(r"-RU\.md$", re.I)


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
    in_fence = False
    total = 0
    for line in text.splitlines():
        stripped = line.strip()
        if stripped.startswith("```"):
            in_fence = not in_fence
            continue
        if not in_fence:
            total += len(CYRILLIC.findall(line))
    return total


def lint_file(path: Path) -> Violations:
    text = path.read_text(encoding="utf-8")
    v = Violations(path=path)

    if RU_FILENAME.search(path.name):
        v.issues.append("filename uses *-RU.md suffix")

    if SEC_30_RU.search(text):
        v.issues.append("uses deprecated '## За 30 секунд' heading — use '## In 30 seconds'")

    if LANG_RU.search(text):
        v.issues.append("contains <details class=\"lang-ru\"> — remove RU helpers")

    if RU_LABEL.search(text):
        v.issues.append("contains RU Q-card fields — English only")

    for match in CYRILLIC_HEADING.finditer(text):
        title = match.group().strip()
        v.issues.append(f"Cyrillic heading: {title[:60]}{'…' if len(title) > 60 else ''}")
        break

    n = visible_cyrillic_count(text)
    if n > 0:
        v.issues.append(f"{n} visible Cyrillic char(s) outside code fences")

    return v


def main() -> int:
    write_baseline = "--baseline" in sys.argv
    all_v = [lint_file(p) for p in iter_targets()]
    violations = [v for v in all_v if v.issues]

    lines = [
        f"# English-only audit — {len(all_v)} files scanned, {len(violations)} with issues\n"
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
