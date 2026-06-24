#!/usr/bin/env python3
"""Append AI Engineering track prev/next navigation to topic READMEs."""

from pathlib import Path

KB = Path(__file__).resolve().parents[1]

TRACK = [
    ("llm-basics", "01 · LLM Basics"),
    ("tokens", "02 · Tokens"),
    ("context-window", "03 · Context Window"),
    ("embeddings", "04 · Embeddings"),
    ("vector-search", "05 · Vector Search"),
    ("rag", "06 · RAG"),
    ("structured-output", "07 · Structured Output"),
    ("tool-calling", "08 · Tool Calling"),
    ("agents", "09 · Agents"),
    ("mcp", "10 · MCP"),
    ("foundation-models", "11 · Foundation Models"),
    ("apple-intelligence", "12 · Apple Intelligence"),
    ("dynamic-profiles", "13 · Dynamic Profiles"),
    ("evaluations", "14 · Evaluations"),
]

MARKER_START = "<!-- ai-engineering-nav:start -->"
MARKER_END = "<!-- ai-engineering-nav:end -->"


def build_nav(index: int) -> str:
    parts = [f"[Track overview](../README.md)"]
    if index == 0:
        parts.append(f"[← Roadmap](../roadmap/)")
    elif index > 0:
        slug, title = TRACK[index - 1]
        parts.append(f"[← {title}](../{slug}/)")
    if index < len(TRACK) - 1:
        slug, title = TRACK[index + 1]
        parts.append(f"[{title} →](../{slug}/)")
    body = " · ".join(parts)
    return f"{MARKER_START}\n\n---\n\n**AI Engineering:** {body}\n\n{MARKER_END}\n"


def strip_existing(text: str) -> str:
    start = text.find(MARKER_START)
    if start == -1:
        return text.rstrip() + "\n"
    end = text.find(MARKER_END, start)
    if end == -1:
        return text.rstrip() + "\n"
    end += len(MARKER_END)
    trimmed = text[:start].rstrip() + "\n"
    trailing = text[end:].lstrip("\n")
    if trailing:
        trimmed += "\n" + trailing
    return trimmed


def main() -> None:
    for index, (slug, _title) in enumerate(TRACK):
        path = KB / "ai-engineering" / slug / "README.md"
        if not path.exists():
            print(f"skip missing {path}")
            continue
        text = strip_existing(path.read_text(encoding="utf-8"))
        text = text.rstrip() + "\n\n" + build_nav(index)
        path.write_text(text, encoding="utf-8")
        print(f"nav {path.relative_to(KB)}")


if __name__ == "__main__":
    main()
