# Content format (English only)

All substantive topic content is **English only**. No Russian helpers or collapsible translation blocks.

## Prose

```markdown
## In 30 seconds

English paragraph — visible content.
```

Use **`## In 30 seconds`** only (not `## За 30 секунд`).

## Headings

All markdown headings (`#` … `######`) must be **English only**.

Canonical section titles: `Key concepts`, `Links`, `Interview Q&A (Knowledge cards)`, `Resources`, `Artifacts`, `Materials`, `Focus vs Defer`.

## Q-cards

```markdown
### Q1
- **Question:** What is YAGNI?
- **Answer:** Build only what you need now.
```

No `(EN)` / `(RU)` suffixes. No `<details class="lang-ru">`.

## Tooling

- `python3 scripts/en_only_knowledge_base.py` — strip legacy RU helpers
- `python3 scripts/lint_bilingual.py` — flags any remaining Cyrillic in topic READMEs and notes

## Out of scope

Code blocks (including comments inside fences where legacy may remain), URLs, playground paths, `_sidebar.md`, curated meta stubs without interview body.
