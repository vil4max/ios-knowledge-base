#!/usr/bin/env python3
import re
from pathlib import Path

from topic_tree import DRAFT_MARKER, STUB_TEMPLATE, TOPIC_TREE

KB = Path(__file__).resolve().parents[1]

PLACEHOLDER_LINES = [
    "См. основной раздел темы (**Theme block",
    "См. **Detailed digest** ниже: навигация по теме",
    "См. **Detailed digest** сразу под этой карточкой",
    "what is the core goal of this topic",
    "what is the practical implication for production code",
    "choose data structures, architecture boundaries, and tests based on this topic",
    "start from the most interview-impacting scenarios",
    "one full pass of question, answer, follow-up",
    "this topic defines practical preparation steps",
    "how to measure progress in this topic",
]

THEME_BLOCK_START = re.compile(r"^## Theme block \d+\s*$")
HEADING2 = re.compile(r"^## .+$")


def is_placeholder_line(line: str) -> bool:
    stripped = line.strip()
    if not stripped:
        return False
    return any(p in stripped for p in PLACEHOLDER_LINES)


def remove_theme_blocks(text: str) -> str:
    lines = text.splitlines()
    out: list[str] = []
    skipping = False
    for line in lines:
        if THEME_BLOCK_START.match(line):
            skipping = True
            continue
        if skipping:
            if HEADING2.match(line) and not line.startswith("### "):
                skipping = False
                out.append(line)
            continue
        out.append(line)
    return "\n".join(out)


def remove_placeholder_bullets(text: str) -> str:
    lines = []
    for line in text.splitlines():
        if is_placeholder_line(line):
            continue
        lines.append(line)
    return "\n".join(lines)


def collapse_blank_lines(text: str) -> str:
    text = re.sub(r"\n{4,}", "\n\n\n", text)
    return text.strip() + "\n"


def fix_title(text: str, fallback: str) -> str:
    text = re.sub(
        r"^# \w+ Interview Prep\s*\n+Правило терминов:.*\n+",
        "",
        text,
        count=1,
        flags=re.MULTILINE,
    )
    if not text.lstrip().startswith("# "):
        text = f"# {fallback}\n\n{text}"
    return text


def substantive_chars(text: str) -> int:
    body = re.sub(r"> \*\*Status:\*\* draft.*\n", "", text)
    body = re.sub(r"_\(to be added\)_", "", body)
    body = re.sub(r"#+ ", "", body)
    body = re.sub(r"\s+", "", body)
    return len(body)


def clean_readme(path: Path, title: str) -> None:
    if not path.exists():
        return
    raw = path.read_text(encoding="utf-8")
    cleaned = fix_title(raw, title)
    cleaned = remove_theme_blocks(cleaned)
    cleaned = remove_placeholder_bullets(cleaned)
    cleaned = collapse_blank_lines(cleaned)
    if substantive_chars(cleaned) < 800 and DRAFT_MARKER not in cleaned:
        cleaned = STUB_TEMPLATE.format(title=title) + "\n---\n\n" + cleaned
    elif substantive_chars(cleaned) < 800:
        pass
    else:
        if DRAFT_MARKER in cleaned.split("---")[0]:
            parts = cleaned.split("\n---\n", 1)
            if len(parts) == 2 and substantive_chars(parts[1]) >= 800:
                cleaned = parts[1]
    path.write_text(cleaned, encoding="utf-8")
    print(f"cleaned {path.relative_to(KB)}")


def scaffold_and_sidebar() -> None:
    sidebar_lines = ["- [Home](/)", ""]
    for section_slug, section in TOPIC_TREE.items():
        sidebar_lines.append(f"- **{section['title']}**")
        for topic_slug, topic_title in section["topics"].items():
            if section_slug == "glossary" and topic_slug == ".":
                readme = KB / "glossary" / "README.md"
                url = "/glossary/"
            else:
                readme = KB / section_slug / topic_slug / "README.md"
                url = f"/{section_slug}/{topic_slug}/" if topic_slug != "." else f"/{section_slug}/"
            readme.parent.mkdir(parents=True, exist_ok=True)
            if not readme.exists():
                readme.write_text(STUB_TEMPLATE.format(title=topic_title), encoding="utf-8")
                print(f"stub {readme.relative_to(KB)}")
            sidebar_lines.append(f"  - [{topic_title}]({url})")
        sidebar_lines.append("")
    (KB / "_sidebar.md").write_text("\n".join(sidebar_lines).rstrip() + "\n", encoding="utf-8")
    print("wrote _sidebar.md")


def main() -> None:
    scaffold_and_sidebar()
    for section_slug, section in TOPIC_TREE.items():
        for topic_slug, topic_title in section["topics"].items():
            if section_slug == "glossary" and topic_slug == ".":
                path = KB / "glossary" / "README.md"
            else:
                path = KB / section_slug / topic_slug / "README.md"
            clean_readme(path, topic_title)


if __name__ == "__main__":
    main()
