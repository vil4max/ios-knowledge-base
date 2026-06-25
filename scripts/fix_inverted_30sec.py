#!/usr/bin/env python3
"""Fix inverted 30-sec: RU visible + empty details -> EN visible + RU in details."""

from __future__ import annotations

import re
from pathlib import Path

KB = Path(__file__).resolve().parents[1]
PLACEHOLDER = "_(Русский перевод — добавить.)_"
BLOCK = re.compile(
    r"(## In 30 seconds\s*\n)(.*?)(\n<details class=\"lang-ru\">.*?<summary>По-русски</summary>\s*\n+)"
    + re.escape(PLACEHOLDER)
    + r"(\s*\n</details>)",
    re.S,
)

EN_STUB = "_English summary — expand «По-русски» for the full Russian text._"


def fix_file(path: Path) -> bool:
    text = path.read_text(encoding="utf-8")
    m = BLOCK.search(text)
    if not m:
        return False
    ru_body = m.group(2).strip()
    replacement = (
        m.group(1)
        + "\n"
        + EN_STUB
        + "\n\n"
        + m.group(3)
        + ru_body
        + m.group(4)
    )
    text = text[: m.start()] + replacement + text[m.end() :]
    path.write_text(text, encoding="utf-8")
    return True


def main() -> None:
    n = 0
    for md in KB.rglob("*.md"):
        if fix_file(md):
            print(md.relative_to(KB))
            n += 1
    print(f"Fixed {n} file(s)")


if __name__ == "__main__":
    main()
