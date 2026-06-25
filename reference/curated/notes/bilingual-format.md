# Bilingual format (RU + EN)

Mandatory for all substantive topic content. Site UX: **English visible by default**; Russian behind **«По-русски»** (`<details class="lang-ru">`).

Spec for authors and migration scripts. Full audit: `scripts/bilingual-audit-baseline.txt`.

## Prose

```markdown
## In 30 seconds

English paragraph — visible by default.

<details class="lang-ru">
<summary>По-русски</summary>

Русский абзац — тот же смысл.

</details>
```

Use **`## In 30 seconds`** only (not `## За 30 секунд`).

## Headings

All markdown headings (`#` … `######`) must be **English only**. Russian prose stays in `<details class="lang-ru">` or Q-card RU fields — not in visible headings.

Canonical section titles: `Key concepts`, `Links`, `Interview Q&A (Knowledge cards)`, `Resources`, `Artifacts`, `Materials`, `Focus vs Defer`.

Migration: `python3 scripts/headings_to_en.py`.

## README files

Topic `README.md` files are **English-first** like the rest of the site: visible prose, bullets, tables, and Q-card EN fields in English. Russian is the helper — inside `<details class="lang-ru">` or Q-card RU fields only.

Excluded from the visible-Cyrillic lint (by design): `glossary/README.md`, `ai-engineering/roadmap/README.md`.

Migration: `python3 scripts/migrate_readme_en.py`.

## Q-cards

```markdown
### Q1
- **Question (EN):** What is YAGNI?
- **Answer (EN):** Build only what you need now.

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Что такое YAGNI?
- **Answer (RU):** Пишите только код для текущей задачи.

</details>
```

EN fields first; all RU fields (`Question`, `Answer`, `Устная заготовка`, `Follow-up`, `Follow-up answer`, `Итог одной фразой`) inside one `<details>` per card.

## Focus bullets

EN bullets visible; one `<details class="lang-ru">` after the list with RU mirror (preferred when 4+ items).

## Tables

EN table visible; RU table inside `<details class="lang-ru">`.

## Out of scope

Code blocks (including comments inside ` ``` ` fences), URLs, playground paths, `_sidebar.md`, curated meta stubs without interview body.

## Tooling

- `python3 scripts/lint_bilingual.py` — compliance check
- `python3 scripts/headings_to_en.py` — heading EN migration
- `python3 scripts/migrate_readme_en.py` — README EN-visible migration
- `python3 scripts/migrate_bilingual.py` — structural Q-card migration
- `assets/bilingual.js` — collapses legacy `*(RU):*` lines until files are migrated
