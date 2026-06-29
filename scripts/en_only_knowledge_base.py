#!/usr/bin/env python3
"""Remove RU helpers and normalize EN-only markdown across the knowledge base."""

from __future__ import annotations

import re
import sys
from pathlib import Path

KB = Path(__file__).resolve().parents[1]

SKIP_PATH_PARTS = (
    "reference/curated",
    ".git",
)

SKIP_FILES = {
    KB / "_sidebar.md",
    KB / "reference/curated/notes/bilingual-format.md",
}

DETAILS_OPEN = re.compile(r'<details\s+class="lang-ru"\s*>', re.I)
DETAILS_CLOSE = re.compile(r"</details>", re.I)

RU_ITEM_START = re.compile(
    r"^(\s*[-*]\s+\*\*(Question|Answer|Follow-up answer|Follow-up|"
    r"Устная заготовка|Итог одной фразой|Доп\. информация)\s*\(RU\):)",
    re.I,
)

EN_LABEL = re.compile(
    r"\*\*(Question|Answer|Follow-up answer|Follow-up|"
    r"Устная заготовка|Итог одной фразой)\s*\(EN\):",
    re.I,
)

EN_SUMMARY = re.compile(r"^_English summary.*$", re.M)
RU_SECTION = re.compile(r"^<summary>По-русски</summary>\s*$", re.M)

INLINE_CLEANUPS: list[tuple[str, str]] = [
    (r"\*\*Ответ\*\*:", "**Answer:**"),
    (r"\*\*Ответ:\*\*", "**Answer:**"),
    (r"\*\*Вопрос\*\*:", "**Question:**"),
    (r"## За 30 секунд", "## In 30 seconds"),
    (r"## Карточки знаний \(Q&A\)", "## Interview Q&A (Knowledge cards)"),
    (r"## Материалы", "## Materials"),
    (r"## Ключевые понятия", "## Key concepts"),
    (r"## Ссылки", "## Links"),
]


def should_skip(path: Path) -> bool:
    rel = path.relative_to(KB).as_posix()
    if path in SKIP_FILES:
        return True
    return any(part in rel for part in SKIP_PATH_PARTS)


def strip_lang_ru_details(text: str) -> str:
    out: list[str] = []
    i = 0
    while i < len(text):
        match = DETAILS_OPEN.search(text, i)
        if not match:
            out.append(text[i:])
            break
        out.append(text[i : match.start()])
        depth = 1
        j = match.end()
        while j < len(text) and depth:
            nested = DETAILS_OPEN.search(text, j)
            closed = DETAILS_CLOSE.search(text, j)
            if closed and (not nested or closed.start() < nested.start()):
                depth -= 1
                j = closed.end()
            elif nested:
                depth += 1
                j = nested.end()
            else:
                j = len(text)
        i = j
    return "".join(out)


def collect_ru_item(lines: list[str], start: int) -> int:
    i = start + 1
    while i < len(lines):
        line = lines[i]
        if line.strip() == "":
            i += 1
            continue
        if RU_ITEM_START.match(line) or line.startswith("### ") or line.startswith("## "):
            break
        if re.match(r"^\s*[-*]\s+\*\*", line) and not RU_ITEM_START.match(line):
            break
        if line.startswith("<details"):
            break
        i += 1
    return i


def strip_ru_q_items(text: str) -> str:
    lines = text.splitlines()
    out: list[str] = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if RU_ITEM_START.match(line):
            i = collect_ru_item(lines, i)
            continue
        out.append(line)
        i += 1
    return "\n".join(out)


def normalize_en_labels(text: str) -> str:
    return EN_LABEL.sub(lambda m: f"**{m.group(1)}:", text)


def apply_inline_cleanups(text: str) -> str:
    for pattern, repl in INLINE_CLEANUPS:
        text = re.sub(pattern, repl, text)
    return text


def cleanup_whitespace(text: str) -> str:
    text = re.sub(r"\n{4,}", "\n\n\n", text)
    text = re.sub(r"[ \t]+\n", "\n", text)
    text = re.sub(r"\n{3,}", "\n\n", text)
    return text.rstrip() + "\n"


def migrate_text(text: str) -> str:
    text = strip_lang_ru_details(text)
    text = strip_ru_q_items(text)
    text = EN_SUMMARY.sub("", text)
    text = RU_SECTION.sub("", text)
    text = normalize_en_labels(text)
    text = apply_inline_cleanups(text)
    text = cleanup_whitespace(text)
    return text


def iter_md_files() -> list[Path]:
    paths: list[Path] = []
    for path in KB.rglob("*.md"):
        if should_skip(path):
            continue
        paths.append(path)
    return sorted(paths)


def cyrillic_count(text: str) -> int:
    return len(re.findall(r"[а-яА-ЯёЁ]", text))


def migrate_file(path: Path, dry_run: bool = False) -> tuple[bool, int]:
    original = path.read_text(encoding="utf-8")
    updated = migrate_text(original)
    remaining = cyrillic_count(updated)
    if updated == original:
        return False, remaining
    if not dry_run:
        path.write_text(updated, encoding="utf-8")
    return True, remaining


def main() -> int:
    dry_run = "--dry-run" in sys.argv
    changed = 0
    remaining_files: list[tuple[int, Path]] = []

    for path in iter_md_files():
        did_change, remaining = migrate_file(path, dry_run=dry_run)
        if did_change:
            changed += 1
            print(path.relative_to(KB))
        if remaining > 0:
            remaining_files.append((remaining, path))

    print(f"\n{'Would update' if dry_run else 'Updated'} {changed} file(s)")

    if remaining_files:
        remaining_files.sort(reverse=True)
        print(f"\nFiles with Cyrillic remaining ({len(remaining_files)}):")
        for count, path in remaining_files:
            print(f"  {count:5d}  {path.relative_to(KB)}")
        return 1

    print("\nNo Cyrillic remaining.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
