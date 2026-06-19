# Content curation gate

Before adding or migrating any material into the knowledge base, run this gate. **Default: do not add.**

## What belongs here

Durable knowledge for interviews and production — not news, not social digests.

| Must have | Examples |
|-----------|----------|
| **Gap** — topic README or Q-cards do not already cover it | New mechanism (e.g. `@concurrent`), missing trade-off, production pitfall |
| **Depth** — fits topic template | 30-sec summary → concepts → interview Q&A → code → Apple/official links |
| **Durability** — still useful in ~2 years | Isolation rules, module boundaries, testing patterns |
| **Action** — changes how you build, review, or answer on interview | Migration steps, code review rules, ownership diagrams |

## What does not belong

| Reject | Why |
|--------|-----|
| Release overviews, infographics, “What’s new in Swift N” | Changelog marketing; concurrency/README already goes deeper |
| Social carousel posts (architecture ABC, tip threads) | Intro-level; duplicates topic README |
| Restating definitions without Q&A, trade-offs, or code | Not interview-ready |
| “Bookmark for later” with no source body | Use [BACKLOG.md](BACKLOG.md) or [External Links](README.md) only |
| One-line pros/cons copied from a post | Enhance existing section instead |

## Decision flow

```
New material
    │
    ├─ Already in topic README / Q-cards? ──► STOP (tell user: redundant)
    │
    ├─ Only URL / stub / no body? ──► BACKLOG or External Links (one row)
    │
    ├─ One new sentence or framing? ──► Patch existing README (TL;DR / one bullet)
    │
    └─ Real gap + enough depth for notes/? ──► New note + link from topic README
```

## Agent checklist (before any write)

1. Search the repo for the same terms; read the target topic `README.md`.
2. State the outcome: **reject** / **bookmark** / **enhance** / **new note** — and why in one sentence.
3. Ask the user before creating files unless they explicitly requested the add.
4. Never fan out one social post into multiple topic folders if a single existing page already covers it.

## Examples from this repo

| Input | Verdict |
|-------|---------|
| Swift 6 infographic (12 bullets) | **Reject** — covered in `swift/concurrency/`, `quality/testing/`, etc. |
| iOS architectures social post (MVC…TCA) | **Reject** — `architecture/patterns/README.md` is deeper |
| immh article, no full text | **Bookmark** — stub + BACKLOG row |
| onmyway133 Swift 6 runtime crashes | **New note** — gap + depth → `notes/` + Q-card |

**Related:** [BACKLOG.md](BACKLOG.md) · [External Links](README.md) · repo `AGENTS.md` (Conventions)
