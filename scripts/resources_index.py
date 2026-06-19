#!/usr/bin/env python3
"""Build reference/curated/README.md from ## Ресурсы blocks in topic READMEs."""

import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional

KB = Path(__file__).resolve().parents[1]
OUTPUT = KB / "reference" / "curated" / "README.md"
RESOURCES_HEADING = re.compile(r"^## Ресурсы\s*$", re.MULTILINE)
CARD_HEADING = re.compile(r"^### (.+)$", re.MULTILINE)
FIELD = re.compile(r"^- \*\*(.+?):\*\* (.+)$")


@dataclass
class ResourceCard:
    name: str
    topic_path: str
    topic_title: str
    fields: dict[str, str] = field(default_factory=dict)


def topic_from_readme(path: Path) -> tuple[str, str]:
    rel = path.relative_to(KB)
    parts = rel.parts
    if len(parts) == 2 and parts[0] == "glossary":
        return "/glossary/", "Glossary"
    section, topic = parts[0], parts[1]
    title = ""
    raw = path.read_text(encoding="utf-8")
    first_line = raw.splitlines()[0] if raw else ""
    if first_line.startswith("# "):
        title = first_line[2:].strip()
    return f"/{section}/{topic}/", title or topic


def parse_resources_section(text: str) -> Optional[str]:
    match = RESOURCES_HEADING.search(text)
    if not match:
        return None
    start = match.end()
    rest = text[start:]
    next_section = re.search(r"\n## [^#]", rest)
    return rest[: next_section.start()] if next_section else rest


def parse_cards(section: str, topic_path: str, topic_title: str) -> list[ResourceCard]:
    cards: list[ResourceCard] = []
    headings = list(CARD_HEADING.finditer(section))
    for index, heading in enumerate(headings):
        name = heading.group(1).strip()
        block_start = heading.end()
        block_end = headings[index + 1].start() if index + 1 < len(headings) else len(section)
        block = section[block_start:block_end]
        fields: dict[str, str] = {}
        for line in block.splitlines():
            field_match = FIELD.match(line.strip())
            if field_match:
                fields[field_match.group(1)] = field_match.group(2).strip()
        url = fields.get("URL", "")
        if url.startswith("http"):
            cards.append(
                ResourceCard(
                    name=name,
                    topic_path=topic_path,
                    topic_title=topic_title,
                    fields=fields,
                )
            )
    return cards


def collect_cards() -> list[ResourceCard]:
    all_cards: list[ResourceCard] = []
    for readme in sorted(KB.glob("**/README.md")):
        if readme == OUTPUT:
            continue
        if "reference/curated" in readme.as_posix():
            continue
        text = readme.read_text(encoding="utf-8")
        section = parse_resources_section(text)
        if not section:
            continue
        topic_path, topic_title = topic_from_readme(readme)
        all_cards.extend(parse_cards(section, topic_path, topic_title))
    return all_cards


def tag_cell(tags: str) -> str:
    if not tags:
        return "—"
    return ", ".join(part.strip().strip("`") for part in tags.split(","))


def build_markdown(cards: list[ResourceCard]) -> str:
    lines = [
        "# External Links",
        "",
        "Auto-generated from `## Ресурсы` sections in topic READMEs.",
        "",
        "Regenerate:",
        "",
        "```bash",
        "python3 scripts/resources_index.py",
        "```",
        "",
        "Add a resource: edit the topic README → `## Ресурсы` → run the script above.",
        "",
        "| Name | Type | Tags | Topic | URL |",
        "|------|------|------|-------|-----|",
    ]
    if not cards:
        lines.append("| _(none yet)_ | | | | |")
    else:
        for card in cards:
            url = card.fields.get("URL", "")
            link = f"[{card.name}]({url})" if url else card.name
            topic_link = f"[{card.topic_title}]({card.topic_path})"
            lines.append(
                f"| {link} | {card.fields.get('Type', '—')} "
                f"| {tag_cell(card.fields.get('Tags', ''))} "
                f"| {topic_link} | {url} |"
            )
    lines.append("")
    return "\n".join(lines)


def main() -> None:
    cards = collect_cards()
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(build_markdown(cards), encoding="utf-8")
    print(f"wrote {OUTPUT.relative_to(KB)} ({len(cards)} resources)")


if __name__ == "__main__":
    main()
