#!/usr/bin/env python3
"""Wrap RU-primary notes: EN stub + collapsible RU body per ## section."""

from __future__ import annotations

import re
import sys
from pathlib import Path

KB = Path(__file__).resolve().parents[1]
SKIP_PARTS = ("reference/curated", "bilingual-format.md", "interview-answer-depth")
CYRILLIC = re.compile(r"[а-яА-ЯёЁ]")


def cyrillic_ratio(text: str) -> float:
    letters = [c for c in text if c.isalpha()]
    if not letters:
        return 0.0
    cy = sum(1 for c in letters if CYRILLIC.match(c))
    return cy / len(letters)


def wrap_section(title: str, body: str, level: str) -> str:
    body = body.strip()
    if not body or "<details class=\"lang-ru\"" in body:
        return f"{level} {title}\n\n{body}\n\n" if body else f"{level} {title}\n\n"
    if cyrillic_ratio(body) <= 0.08:
        return f"{level} {title}\n\n{body}\n\n"
    en_stub = f"_English summary — expand «По-русски» for full text ({title.strip()})._"
    return (
        f"{level} {title}\n\n"
        f"{en_stub}\n\n"
        '<details class="lang-ru">\n'
        "<summary>По-русски</summary>\n\n"
        f"{body}\n\n"
        "</details>\n\n"
    )


def migrate_note(path: Path) -> bool:
    if any(s in path.as_posix() for s in SKIP_PARTS):
        return False
    text = path.read_text(encoding="utf-8")
    if cyrillic_ratio(text) < 0.08:
        return False

    chunks = re.split(r"^(## .+)$", text, flags=re.M)
    if len(chunks) < 2:
        return False

    out = [chunks[0]]
    i = 1
    while i < len(chunks):
        heading = chunks[i]
        body = chunks[i + 1] if i + 1 < len(chunks) else ""
        title = heading[3:].strip()
        wrapped = wrap_section(title, body, "##")
        if wrapped != f"## {title}\n\n{body.strip()}\n\n" if body.strip() else f"## {title}\n\n":
            out.append(wrapped)
        else:
            out.append(heading + "\n\n" + body)
        i += 2

    new_text = "".join(out)
    if new_text == text:
        return False
    path.write_text(new_text, encoding="utf-8")
    return True


def main() -> int:
    targets = sys.argv[1:] if len(sys.argv) > 1 else None
    changed = 0
    notes = (
        [Path(p) for p in targets]
        if targets
        else sorted(KB.rglob("notes/*.md"))
    )
    for note in notes:
        if not note.is_absolute():
            note = KB / note
        if migrate_note(note):
            print(note.relative_to(KB))
            changed += 1
    print(f"\nWrapped {changed} note(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
