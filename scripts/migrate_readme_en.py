#!/usr/bin/env python3
"""Migrate topic READMEs to EN-visible prose; RU in <details class=\"lang-ru\">."""

from __future__ import annotations

import re
import sys
from pathlib import Path

KB = Path(__file__).resolve().parents[1]

SKIP_READMES = {
    KB / "reference/curated/README.md",
    KB / "README.md",
    KB / "glossary/README.md",
    KB / "ai-engineering/roadmap/README.md",
    KB / "quality/testing/exercises/README.md",
}

CYRILLIC = re.compile(r"[а-яА-ЯёЁ]")
FENCE = re.compile(r"^```")
Q_START = re.compile(r"^### Q\d+", re.M)
DETAILS_OPEN = re.compile(r'<details\s+class="lang-ru"', re.I)
DETAILS_CLOSE = re.compile(r"</details>", re.I)

SECTIONS_SKIP_WRAP = frozenset(
    s.lower()
    for s in (
        "In 30 seconds",
        "Apple docs",
        "Interview Q&A (Knowledge cards)",
        "Interview Q&A (roadmap / drill)",
        "🎯 Focus vs Defer",
        "Focus vs Defer",
        "WWDC & resources",
        "Links",
        "Key concepts",
        "🏋️ Exercises",
        "Exercises",
    )
)

INLINE_REPLACEMENTS: list[tuple[str, str]] = [
    (r"\*\*Ответ\*\*:", "**Answer:**"),
    (r"\*\*Ответ:\*\*", "**Answer:**"),
    (r"\*\*Фокус\*\*", "**Focus**"),
    (r"\| \*\*Уровни\*\* \|", "| **Levels** |"),
    (r"\| \*\*Трек\*\* \|", "| **Track** |"),
    (r"`notes/` — Q&A \+ ссылки на Apple docs", "`notes/` — Q&A + links to Apple docs"),
    (r"`exercises/` — упражнения с expected outcome", "`exercises/` — exercises with expected outcome"),
    (r"`playgrounds/` — runnable примеры", "`playgrounds/` — runnable examples"),
    (r"`assets/` — файлы и PDF, привязанные к теме", "`assets/` — files and PDFs for this topic"),
    (r"Вводный конспект \(RU\):", "Intro notes (RU):"),
    (r"Конспект:", "Notes:"),
    (r"Статья \(bookmark\):", "Article (bookmark):"),
    (r"Intro digest \(social, URL позже\):", "Intro digest (social, URL TBD):"),
    (r"Quiz \(draft\):", "Quiz (draft):"),
    (r"— отдельный 6-дневный роадмап", "— separate 6-day roadmap"),
    (r"— теория «Combine vs Concurrency» — в Q&A ниже в этом файле", "— Combine vs Concurrency theory in Q&A below"),
    (r"в этом же файле — перед карточками", "in this file — before cards"),
    (r"Ниже — Q&A по теме\.", "Interview Q&A below."),
    (r"\*\*Инфографика:\*\*", "**Infographic:**"),
    (r"Каталог для \*\*ориентации\*\*", "Catalog for **orientation**"),
    (r"на собесе и в проде", "in interviews and production"),
    (r"\*\*Defer\*\* ниже", "**Defer** below"),
    (r"см\. Q-cards и \*\*Focus vs Defer\*\* ниже", "see Q-cards and **Focus vs Defer** below"),
    (r"\*\*Связь с фундаментом:\*\*", "**Foundation tie-in:**"),
    (r"\*\*Источник:\*\*", "**Source:**"),
    (r"\*\*Контекст для собеседования", "**Interview context"),
    (r"\| Pattern \| Описание \|", "| Pattern | Description |"),
    (r"Use when / Когда применять:", "Use when:"),
    (r"Red flags / Красные флаги:", "Red flags:"),
    (r"Practice: `practice/LeetCode/` \(локальный алгоритмический трек\)", "Practice: `practice/LeetCode/` (local algorithm track)"),
    (r"— пять блоков:", "— five blocks:"),
    (r"Layout, Navigation, Lists, Text/Media, Input", "Layout, Navigation, Lists, Text/Media, Input"),
    (r" — основа\.", " — core."),
    (r"на компиляции\.", "at compile time."),
    (r"— object-gr", "— object-gr"),
]

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


def cyrillic_ratio(text: str) -> float:
    letters = [c for c in text if c.isalpha()]
    if not letters:
        return 0.0
    cy = sum(1 for c in letters if CYRILLIC.match(c))
    return cy / len(letters)


def apply_inline_replacements(text: str) -> str:
    for pattern, repl in INLINE_REPLACEMENTS:
        text = re.sub(pattern, repl, text)
    return text


def is_list_item_start(line: str) -> bool:
    return bool(re.match(r"^\s*[-*]\s+", line))


def is_ru_line(line: str) -> bool:
    return bool(RU_ITEM.match(line))


def is_en_line(line: str) -> bool:
    return bool(EN_ITEM.match(line))


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
    if DETAILS_OPEN.search(block):
        return block
    lines = block.splitlines()
    if not lines:
        return block
    header = lines[0]
    rest = lines[1:]
    en_parts: list[str] = []
    ru_parts: list[str] = []
    i = 0
    while i < len(rest):
        line = rest[i]
        if line.strip() == "":
            i += 1
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
    if not ru_parts or not en_parts:
        return block
    out = [header]
    out.extend(en_parts)
    out.extend(wrap_ru_block(ru_parts))
    return "\n".join(out).rstrip() + "\n"


def migrate_q_cards(text: str) -> str:
    matches = list(Q_START.finditer(text))
    if not matches:
        return text
    out: list[str] = []
    pos = 0
    for i, m in enumerate(matches):
        out.append(text[pos : m.start()])
        end = matches[i + 1].start() if i + 1 < len(matches) else len(text)
        block = text[m.start() : end]
        out.append(migrate_q_block(block))
        pos = end
    out.append(text[pos:])
    return "".join(out)


def split_paragraphs(body: str) -> list[str]:
    parts: list[str] = []
    buf: list[str] = []
    in_fence = False
    for line in body.splitlines():
        if FENCE.match(line.strip()):
            in_fence = not in_fence
        if not in_fence and line.strip() == "" and buf:
            parts.append("\n".join(buf))
            buf = []
            continue
        buf.append(line)
    if buf:
        parts.append("\n".join(buf))
    return [p for p in parts if p.strip()]


def wrap_cyrillic_list_blocks(body: str) -> str:
    if DETAILS_OPEN.search(body):
        return body
    lines = body.splitlines()
    out: list[str] = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if re.match(r"^[-*] ", line):
            block = [line]
            i += 1
            while i < len(lines):
                nxt = lines[i]
                if re.match(r"^[-*] ", nxt) or nxt.startswith("## ") or nxt.startswith("### "):
                    break
                if nxt.strip() == "":
                    block.append(nxt)
                    i += 1
                    break
                if re.match(r"^\s{2,}[-*] ", nxt) or re.match(r"^\s{2,}\S", nxt):
                    block.append(nxt)
                    i += 1
                    continue
                break
            text = "\n".join(block).strip()
            if cyrillic_ratio(text) > 0.12:
                out.append(
                    '<details class="lang-ru">\n'
                    "<summary>По-русски</summary>\n\n"
                    f"{text}\n\n"
                    "</details>"
                )
            else:
                out.extend(block)
            continue
        out.append(line)
        i += 1
    return "\n".join(out)


def wrap_ru_paragraphs(body: str) -> str:
    if DETAILS_OPEN.search(body):
        return body
    body = wrap_cyrillic_list_blocks(body)
    out: list[str] = []
    ru_buf: list[str] = []

    def flush() -> None:
        if not ru_buf:
            return
        block = "\n\n".join(ru_buf).strip()
        ru_buf.clear()
        out.append(
            '<details class="lang-ru">\n'
            "<summary>По-русски</summary>\n\n"
            f"{block}\n\n"
            "</details>"
        )

    for para in split_paragraphs(body):
        if cyrillic_ratio(para) > 0.14:
            ru_buf.append(para)
        else:
            flush()
            out.append(para)
    flush()
    return "\n\n".join(out)


def should_wrap_section(title: str) -> bool:
    clean = re.sub(r"[^\w\s&]", "", title).strip().lower()
    for skip in SECTIONS_SKIP_WRAP:
        if skip.lower() in title.lower():
            return False
    return clean not in {s.lower() for s in SECTIONS_SKIP_WRAP}


def migrate_sections(text: str) -> str:
    chunks = re.split(r"^(## .+)$", text, flags=re.M)
    if len(chunks) < 2:
        return text
    out = [chunks[0]]
    i = 1
    while i < len(chunks):
        heading = chunks[i]
        body = chunks[i + 1] if i + 1 < len(chunks) else ""
        title = heading[3:].strip()
        if should_wrap_section(title) and cyrillic_ratio(body) > 0.14:
            body = wrap_ru_paragraphs(body)
        if body and not body.endswith("\n"):
            body += "\n"
        out.append(heading + "\n\n" + body)
        i += 2
    return "".join(out)


def fix_spacing(text: str) -> str:
    text = re.sub(r"</details>\s*##", "</details>\n\n##", text)
    text = re.sub(r"</details>\s*---", "</details>\n\n---", text)
    text = re.sub(r"\n{4,}", "\n\n\n", text)
    return text


def wrap_focus_answers(text: str) -> str:
    lines = text.splitlines()
    out: list[str] = []
    i = 0
    in_focus = False
    while i < len(lines):
        line = lines[i]
        if re.match(r"^## .*Focus vs Defer", line, re.I):
            in_focus = True
            out.append(line)
            i += 1
            continue
        if in_focus and line.startswith("## "):
            in_focus = False
        if in_focus and re.match(r"^[-*] ", line):
            block = [line]
            i += 1
            while i < len(lines):
                nxt = lines[i]
                if re.match(r"^[-*] ", nxt) or nxt.startswith("### ") or nxt.startswith("## "):
                    break
                block.append(nxt)
                i += 1
            text_block = "\n".join(block)
            if CYRILLIC.search(text_block):
                out.append(
                    '<details class="lang-ru">\n'
                    "<summary>По-русски</summary>\n\n"
                    f"{text_block}\n\n"
                    "</details>"
                )
            else:
                out.extend(block)
            continue
        out.append(line)
        i += 1
    return "\n".join(out)


def wrap_qcard_cyrillic_lines(text: str) -> str:
    lines = text.splitlines()
    out: list[str] = []
    i = 0
    in_q = False
    while i < len(lines):
        line = lines[i]
        if line.startswith("### Q"):
            in_q = True
            out.append(line)
            i += 1
            continue
        if in_q and (line.startswith("### Q") or line.startswith("## ")):
            in_q = False
        if in_q and re.match(
            r"^\s*[-*]\s+\*\*(Follow-up|Follow-up answer|Устная заготовка|Итог одной фразой)",
            line,
        ) and CYRILLIC.search(line):
            block = [line]
            i += 1
            while i < len(lines):
                nxt = lines[i]
                if nxt.strip() == "":
                    block.append(nxt)
                    i += 1
                    break
                if re.match(r"^\s*[-*]\s+\*\*", nxt) or nxt.startswith("### ") or nxt.startswith("## ") or nxt.startswith("<details"):
                    break
                block.append(nxt)
                i += 1
            out.append(
                '<details class="lang-ru">\n'
                "<summary>По-русски</summary>\n\n"
                + "\n".join(block).strip()
                + "\n\n</details>"
            )
            continue
        out.append(line)
        i += 1
    return "\n".join(out)


def final_sweep_visible_ru(text: str) -> str:
    lines = text.splitlines(keepends=True)
    out: list[str] = []
    in_details = False
    in_fence = False
    ru_buf: list[str] = []

    def flush() -> None:
        nonlocal ru_buf
        if not ru_buf:
            return
        body = "".join(ru_buf).strip("\n")
        ru_buf = []
        if not body.strip():
            return
        out.append(
            '<details class="lang-ru">\n'
            "<summary>По-русски</summary>\n\n"
            f"{body}\n\n"
            "</details>\n"
        )

    for line in lines:
        stripped = line.strip()
        if FENCE.match(stripped):
            in_fence = not in_fence
        if DETAILS_OPEN.search(line):
            flush()
            in_details = True
            out.append(line)
            continue
        if DETAILS_CLOSE.search(line):
            in_details = False
            out.append(line)
            continue
        if in_details or in_fence:
            flush()
            out.append(line)
            continue
        if stripped.startswith("## ") or stripped.startswith("### Q"):
            flush()
            out.append(line)
            continue
        if CYRILLIC.search(line):
            ru_buf.append(line)
            continue
        if stripped == "" and ru_buf:
            ru_buf.append(line)
            continue
        flush()
        out.append(line)
    flush()
    return "".join(out)


def migrate_file(path: Path, dry_run: bool = False) -> bool:
    original = path.read_text(encoding="utf-8")
    text = original
    text = apply_inline_replacements(text)
    text = migrate_q_cards(text)
    text = wrap_qcard_cyrillic_lines(text)
    text = wrap_focus_answers(text)
    text = migrate_sections(text)
    text = final_sweep_visible_ru(text)
    text = fix_spacing(text)
    if text == original:
        return False
    if not dry_run:
        path.write_text(text, encoding="utf-8")
    return True


def iter_readmes() -> list[Path]:
    return sorted(
        p
        for p in KB.rglob("README.md")
        if p not in SKIP_READMES and "reference/curated" not in p.as_posix()
    )


def visible_cyrillic_chars(path: Path) -> int:
    return visible_cyrillic_count(path.read_text(encoding="utf-8"))


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


def main() -> int:
    dry = "--dry-run" in sys.argv
    changed = 0
    for path in iter_readmes():
        if migrate_file(path, dry_run=dry):
            print(path.relative_to(KB))
            changed += 1
    print(f"\n{'Would update' if dry else 'Updated'} {changed} README(s)")
    remaining = [(visible_cyrillic_chars(p), p.relative_to(KB)) for p in iter_readmes()]
    remaining = [(n, r) for n, r in remaining if n > 0]
    remaining.sort(reverse=True)
    if remaining:
        print(f"\nVisible Cyrillic chars remaining in {len(remaining)} README(s):")
        for n, rel in remaining[:15]:
            print(f"  {n:5d} {rel}")
        return 1
    print("\nNo visible Cyrillic in topic READMEs.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
