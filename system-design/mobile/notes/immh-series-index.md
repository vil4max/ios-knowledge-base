# Mobile System Design — immh series index

- **Author:** [immh](https://immh.tech/) (IT Makes Me Hate)
- **Series:** Mobile System Design (миграция с Boosty / Notion)
- **Updated:** 2026-06-19
- **Finalized:** 2026-06-19 — каркас и ссылки в базе; **полного текста статей нет и не планируется искать** до появления доступа. Stub-файлы и URL в [Curated](/reference/curated/) остаются как закладки.

---

## Articles



| # | Title | URL | Topic folder | Note file | Status |
|---|-------|-----|--------------|-----------|--------|
| 1 | Interview — глава 1 | https://immh.tech/blog/mobile-system-design-interview-glava-1 | `system-design/mobile/` | [immh-interview-glava-1.md](immh-interview-glava-1.md) | stub only |
| 2 | Service vs Repository | https://immh.tech/blog/system-design-service-vs-repository | `architecture/patterns/` | [immh-service-vs-repository.md](../../architecture/patterns/notes/immh-service-vs-repository.md) | stub + README card |
| 3 | BDUI | https://immh.tech/blog/system-design-bdui | `system-design/bdui/` | [immh-bdui.md](../bdui/notes/immh-bdui.md) | stub + README card |
| 4 | Logger | https://immh.tech/blog/system-design-logger | `system-design/mobile/` | [immh-logger.md](immh-logger.md) | stub only |

---

## Integration checklist (if source appears later)

_English summary — expand «По-русски» for full text (Integration checklist (if source appears later))._

<details class="lang-ru">
<summary>По-русски</summary>

1. Fill **TL;DR** and **Ключевые идеи** in the note.
2. Set note `**Status:**` to `digest` or `integrated`.
3. Mark the table row above as integrated.
4. Pull unique interview phrases into topic `README.md` → Q&A cards (do not duplicate whole note).
5. Add or extend exercises if the article has a practice case.
6. Run `python3 scripts/resources_index.py`.
7. Update [mobile_system_design.playground](../mobile_system_design.playground) if the article adds a diagram or template.

### Glava 1 — planned README updates (after paste)

- [ ] **In 30 seconds** — framing: what a mobile SD interview is vs backend
- [ ] **Ключевые понятия** — entity graph, read/write paths, constraints, 45-min flow
- [ ] **Q1** — «С чего начать ответ на mobile system design?»
- [ ] **Q2** — «Чем mobile SD отличается от backend SD?»
- [ ] **Exercise 1** — разобрать заданный продукт: сущности + API + offline
- [ ] Playground — STAR blocks под конкретные bullet из главы 1

### Service vs Repository — planned updates

- [ ] `architecture/patterns/README.md` — Q-card: граница Service / Repository / Use Case
- [ ] Cross-link from `system-design/mobile` (data layer on interview)

### BDUI — planned updates

- [ ] `system-design/bdui/README.md` — concepts from paste
- [ ] Cross-link: `feature-flags`, `analytics`, `ios-sdk/swiftui`

### Logger — planned updates

- [ ] `immh-logger.md` digest
- [ ] Cross-link: `quality/debug`, `devops/monitoring`, observability bullet in `sync-engine`

---

</details>

## Workflow



```
Paste in chat or into notes/immh-*.md
        → agent or you fill digest
        → README Q&A / exercises
        → resources_index.py
```
