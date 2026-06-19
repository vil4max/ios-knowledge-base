#!/usr/bin/env python3
import re
from pathlib import Path

KB = Path(__file__).resolve().parents[1]

DROP_LINE = [
    "Theme block",
    "V. Данные и сеть/",
    "II. Swift/",
    "IV. Архитектура/",
    "III. iOS SDK/",
    "XI. Резюме/",
    "X. Карьера",
]


from typing import Optional


def local_playground_link(readme: Path) -> Optional[str]:
    for pg in readme.parent.glob("*.playground"):
        return f"{pg.name}/Contents.swift"
    for pg in readme.parent.glob("*.playgroundbook"):
        return f"{pg.name}/"
    return None


def strip_empty_sections(text: str) -> str:
    blocks = re.split(r"(?=\n## )", text)
    kept = [blocks[0]]
    for block in blocks[1:]:
        body = block.split("\n", 1)[-1] if "\n" in block else ""
        meaningful = [
            ln
            for ln in body.splitlines()
            if ln.strip()
            and not ln.strip().startswith("_(")
            and ln.strip() != "---"
        ]
        if len(meaningful) >= 2:
            kept.append(block)
    return "".join(kept)


def polish(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    lines = []
    for line in text.splitlines():
        if any(d in line for d in DROP_LINE):
            continue
        line = re.sub(
            r"\[open\]\([^)]+\.playground[^)]*\)",
            lambda _: f"[open]({local_playground_link(path) or 'README.md'})",
            line,
        )
        line = re.sub(r"\[([^\]]+)\]\([^)]*Career[^)]*\)", r"\1", line)
        lines.append(line)
    text = "\n".join(lines)
    text = strip_empty_sections(text)
    text = re.sub(r"\n{4,}", "\n\n\n", text).strip() + "\n"
    path.write_text(text, encoding="utf-8")


def main() -> None:
    for readme in KB.rglob("README.md"):
        if readme.parent.name == ".git":
            continue
        polish(readme)
        print(f"polish {readme.relative_to(KB)}")


if __name__ == "__main__":
    main()
