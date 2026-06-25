#!/usr/bin/env python3
"""Rename *-RU.md notes and update inbound links."""

from __future__ import annotations

import re
from pathlib import Path

KB = Path(__file__).resolve().parents[1]

RENAMES = [
    (
        "quality/testing/notes/Contract-Tests-OpenAPI-RU.md",
        "quality/testing/notes/Contract-Tests-OpenAPI.md",
    ),
    (
        "quality/testing/notes/Senior-Unit-Testing-Mastery-RU.md",
        "quality/testing/notes/Senior-Unit-Testing-Mastery.md",
    ),
    (
        "quality/testing/notes/Snapshot-Testing-Discipline-RU.md",
        "quality/testing/notes/Snapshot-Testing-Discipline.md",
    ),
    (
        "quality/testing/notes/Swift-Testing-vs-XCTest-RU.md",
        "quality/testing/notes/Swift-Testing-vs-XCTest.md",
    ),
    (
        "quality/testing/notes/TDD-Basics-RU.md",
        "quality/testing/notes/TDD-Basics.md",
    ),
    (
        "quality/testing/notes/Test-Plans-CI-RU.md",
        "quality/testing/notes/Test-Plans-CI.md",
    ),
    (
        "quality/testing/notes/Testing-Fundamentals-RU.md",
        "quality/testing/notes/Testing-Fundamentals.md",
    ),
    (
        "quality/testing/notes/Testing-Network-Stub-RU.md",
        "quality/testing/notes/Testing-Network-Stub.md",
    ),
    (
        "quality/testing/notes/XCUITest-Essentials-RU.md",
        "quality/testing/notes/XCUITest-Essentials.md",
    ),
    (
        "swift/concurrency/notes/Approachable-Swift-Concurrency-Site-RU.md",
        "swift/concurrency/notes/Approachable-Swift-Concurrency-Site.md",
    ),
]


def main() -> None:
    for old_rel, new_rel in RENAMES:
        old = KB / old_rel
        new = KB / new_rel
        if not old.exists():
            print(f"skip missing {old_rel}")
            continue
        old_name = old.name
        new_name = new.name
        old.rename(new)
        print(f"renamed {old_rel} -> {new_rel}")

        for md in KB.rglob("*.md"):
            text = md.read_text(encoding="utf-8")
            if old_name not in text and old_rel not in text:
                continue
            updated = text.replace(old_rel, new_rel).replace(old_name, new_name)
            if updated != text:
                md.write_text(updated, encoding="utf-8")
                print(f"  updated links in {md.relative_to(KB)}")


if __name__ == "__main__":
    main()
