#!/usr/bin/env python3
"""Migrate Q-cards and sections to EN-first + collapsible RU format."""

from __future__ import annotations

import re
import sys
from pathlib import Path

KB = Path(__file__).resolve().parents[1]

SKIP = {
    KB / "reference/curated/README.md",
    KB / "reference/curated/notes/interview-answer-depth.md",
    KB / "_sidebar.md",
    KB / "README.md",
}

Q_START = re.compile(r"^### Q(\d+)\s*$", re.M)
RU_ITEM = re.compile(
    r"^(\s*[-*]\s+\*\*(Question|Answer|Follow-up answer|Follow-up|"
    r"Устная заготовка|Итог одной фразой)\s*\(RU\):.*)$",
    re.I,
)
EN_ITEM = re.compile(
    r"^(\s*[-*]\s+\*\*(Question|Answer|Follow-up answer|Follow-up|"
    r"Устная заготовка|Итог одной фразой)\s*\(EN\):.*)$",
    re.I,
)
META_ITEM = re.compile(r"^\s*[-*]\s+\*\*(Доп\. информация|Notes):\*\*")
HAS_DETAILS = re.compile(r'<details\s+class="lang-ru"', re.I)
SEC_30_RU = re.compile(r"^## За 30 секунд\s*$", re.M)
SEC_30 = re.compile(r"^## In 30 seconds\s*$", re.M)


def is_list_item_start(line: str) -> bool:
    return bool(re.match(r"^\s*[-*]\s+", line))


def is_ru_line(line: str) -> bool:
    return bool(RU_ITEM.match(line)) or bool(re.match(r"^\s*[-*]\s+\*\*RU:\*\*", line))


def is_en_line(line: str) -> bool:
    return bool(EN_ITEM.match(line)) or bool(re.match(r"^\s*[-*]\s+\*\*EN:\*\*", line))


def collect_item(lines: list[str], start: int) -> tuple[list[str], int]:
    chunk = [lines[start]]
    i = start + 1
    while i < len(lines):
        line = lines[i]
        if line.strip() == "":
            chunk.append(line)
            i += 1
            continue
        if is_list_item_start(line) or line.startswith("### ") or line.startswith("<details"):
            break
        chunk.append(line)
        i += 1
    while chunk and chunk[-1].strip() == "":
        chunk.pop()
    return chunk, i


def wrap_ru_block(ru_lines: list[str]) -> list[str]:
    if not ru_lines:
        return []
    body = "\n".join(ru_lines).strip()
    if not body:
        return []
    return [
        "",
        '<details class="lang-ru">',
        "<summary>По-русски</summary>",
        "",
        body,
        "",
        "</details>",
        "",
    ]


def migrate_q_block(block: str) -> str:
    if HAS_DETAILS.search(block):
        return block
    lines = block.splitlines()
    if not lines:
        return block
    header = lines[0]
    rest = lines[1:]
    en_parts: list[str] = []
    ru_parts: list[str] = []
    meta_parts: list[str] = []
    i = 0
    while i < len(rest):
        line = rest[i]
        if line.strip() == "":
            i += 1
            continue
        if META_ITEM.match(line):
            chunk, i = collect_item(rest, i)
            meta_parts.extend(chunk)
            continue
        if is_en_line(line):
            chunk, i = collect_item(rest, i)
            en_parts.extend(chunk)
            en_parts.append("")
            continue
        if is_ru_line(line):
            chunk, i = collect_item(rest, i)
            ru_parts.extend(chunk)
            ru_parts.append("")
            continue
        if line.startswith("<details"):
            break
        chunk, i = collect_item(rest, i)
        if any(is_ru_line(c) for c in chunk):
            ru_parts.extend(chunk)
        else:
            en_parts.extend(chunk)
        en_parts.append("") if en_parts else ru_parts.append("")

    if not ru_parts:
        return block
    if not en_parts and ru_parts:
        return block

    out = [header]
    if en_parts:
        out.extend(en_parts)
    out.extend(wrap_ru_block(ru_parts))
    if meta_parts:
        out.extend(meta_parts)
    return "\n".join(out).rstrip() + "\n"


def migrate_q_cards(text: str) -> str:
    matches = list(Q_START.finditer(text))
    if not matches:
        return text
    out = []
    pos = 0
    for i, m in enumerate(matches):
        out.append(text[pos : m.start()])
        end = matches[i + 1].start() if i + 1 < len(matches) else len(text)
        block = text[m.start() : end]
        out.append(migrate_q_block(block))
        pos = end
    out.append(text[pos:])
    return "".join(out)


def migrate_30_sec(text: str) -> str:
    text = SEC_30_RU.sub("## In 30 seconds", text)
    m = SEC_30.search(text)
    if not m or HAS_DETAILS.search(text[m.start() : m.start() + 800]):
        return text

    start = m.end()
    next_h = re.search(r"\n## ", text[start:])
    end = start + next_h.start() if next_h else len(text)
    section = text[start:end].strip()
    if not section or HAS_DETAILS.search(section):
        return text

    lines = section.splitlines()
    en_lines: list[str] = []
    ru_lines: list[str] = []
    for line in lines:
        if not line.strip():
            continue
        if re.search(r"[а-яА-ЯёЁ]{4,}", line) and not re.search(r"[a-zA-Z]{4,}", line):
            ru_lines.append(line)
        elif re.search(r"[а-яА-ЯёЁ]", line) and re.search(r"[a-zA-Z]{4,}", line):
            en_lines.append(line)
        else:
            en_lines.append(line)

    if not en_lines and ru_lines:
        en_lines = [
            "_English summary to be added — see Russian below._",
        ]
        new_section = "\n\n".join(en_lines) + "\n\n" + "\n".join(
            wrap_ru_block(ru_lines)
        )
    elif en_lines and not ru_lines:
        new_section = "\n\n".join(en_lines) + "\n\n" + "\n".join(
            wrap_ru_block(
                ["_(Русский перевод — добавить.)_"]
            )
        )
    elif en_lines and ru_lines:
        new_section = "\n\n".join(en_lines) + "\n\n" + "\n".join(wrap_ru_block(ru_lines))
    else:
        return text

    return text[:start] + "\n\n" + new_section + "\n\n" + text[end:]


def migrate_en_ru_headings(text: str) -> str:
    if "### EN" not in text and "### RU" not in text:
        return text
    pattern = re.compile(
        r"(### EN\s*\n)(.*?)(\n### RU\s*\n)(.*?)(?=\n---|\n## |\Z)",
        re.S,
    )

    def repl(m: re.Match[str]) -> str:
        en_body = m.group(2).strip()
        ru_body = m.group(4).strip()
        return (
            en_body
            + "\n\n"
            + "\n".join(wrap_ru_block(ru_body.splitlines()))
            + "\n"
        )

    return pattern.sub(repl, text)


def migrate_file(path: Path, dry_run: bool = False) -> bool:
    original = path.read_text(encoding="utf-8")
    text = original
    text = migrate_q_cards(text)
    text = migrate_30_sec(text)
    text = migrate_en_ru_headings(text)
    if text == original:
        return False
    if not dry_run:
        path.write_text(text, encoding="utf-8")
    return True


def iter_targets() -> list[Path]:
    paths: list[Path] = []
    for readme in KB.rglob("README.md"):
        if readme in SKIP:
            continue
        if "reference/curated" in readme.as_posix():
            continue
        paths.append(readme)
    for note in KB.rglob("notes/*.md"):
        if "reference/curated" in note.as_posix():
            continue
        paths.append(note)
    return sorted(set(paths))


def main() -> int:
    dry = "--dry-run" in sys.argv
    changed = 0
    for path in iter_targets():
        if migrate_file(path, dry_run=dry):
            changed += 1
            print(path.relative_to(KB))
    print(f"\n{'Would migrate' if dry else 'Migrated'} {changed} file(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
