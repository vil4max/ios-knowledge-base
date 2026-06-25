# Bilingual format (RU + EN)

Mandatory for all substantive topic content. Site UX: **English visible by default**; Russian behind **«По-русски»** (`<details class="lang-ru">`).

Spec for authors and migration scripts. Full audit: `scripts/bilingual-audit-baseline.txt`.

## Prose

```markdown
## За 30 секунд

English paragraph — visible by default.

<details class="lang-ru">
<summary>По-русски</summary>

Русский абзац — тот же смысл.

</details>
```

Use **`## За 30 секунд`** only (not `## In 30 seconds`).

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

Code blocks, URLs, playground paths, `_sidebar.md`, curated meta stubs without interview body.

## Tooling

- `python3 scripts/lint_bilingual.py` — compliance check
- `python3 scripts/migrate_bilingual.py` — structural Q-card migration
- `assets/bilingual.js` — collapses legacy `*(RU):*` lines until files are migrated
