# Mobile App Design

## In 30 seconds

## Materials

### Interview answer depth

| Material | Focus |
|----------|-------|
| [interview-answer-depth.md](/reference/curated/notes/interview-answer-depth.md) | Candidate → Senior → Staff+ framing for the same technical question |

### immh — Mobile System Design

| Material | Status |
|----------|--------|
| [immh-series-index.md](notes/immh-series-index.md) | index + integration checklist |
| [immh-interview-glava-1.md](notes/immh-interview-glava-1.md) | stub only (URL in [Curated](/reference/curated/)) |
| [immh-logger.md](notes/immh-logger.md) | stub only |

### Playgrounds

| Playground | Focus |
|------------|-------|
| [mobile_system_design.playground](mobile_system_design.playground) | STAR template, entity graph, interview outline |

### Child topics (deep dives)

| Topic | Focus |
|-------|-------|
| [Backend-Driven UI](/system-design/bdui/) | Server-driven screens |
| [Offline First](/system-design/offline-first/) | Cache, stale data |
| [Sync Engine](/system-design/sync-engine/) | Conflict resolution |
| [Push Notifications](/system-design/push-notifications/) | Delivery, payload |
| [Deep Links](/system-design/deep-links/) | Cold start, attribution |
| [Feature Flags](/system-design/feature-flags/) | Rollout |
| [Analytics](/system-design/analytics/) | Events, remote config |
| [Scaling Teams](/system-design/scaling-teams/) | Standards, ownership |

## 🎯 Focus vs Defer

**Focus**

- Entity graph: users, content, sessions, local vs remote source of truth
- Read path vs write path (online, offline, optimistic)
- API shape, pagination, idempotency

## Key concepts

| Phase | What to cover |
|-------|----------------|
| Clarify | Users, scale, offline?, platforms, constraints |
| High-level | Modules, data flow, main APIs |
| Deep dive | Storage, sync, errors, caching |
| Secondary | Observability, security, rollout |
| Trade-offs | Alternatives + why chosen |

## 🏋️ Exercises

1. **Feed app** — entities, pagination API, offline read, image cache. _(extend after immh glava 1 paste)_
2. **Chat** — write path, ordering, push, background delivery.
3. **Checkout** — idempotent payment, optimistic UI, rollback.

## Code & examples

## Resources

### immh — Mobile System Design Interview (chapter 1)
- **Type:** article
- **URL:** https://immh.tech/blog/mobile-system-design-interview-glava-1
- **Author:** immh

- **Tags:** `system-design`, `interview`, `immh`, `mobile`
- **Note:** [immh-interview-glava-1.md](notes/immh-interview-glava-1.md)
- **Added:** 2026-06-19

### immh — Logger (system design)
- **Type:** article
- **URL:** https://immh.tech/blog/system-design-logger
- **Author:** immh

- **When:** Observability, production logging architecture
- **Tags:** `system-design`, `logging`, `observability`, `immh`
- **Note:** [immh-logger.md](notes/immh-logger.md)
- **Added:** 2026-06-19

### Mike Salari — Senior iOS Interview Playbook
- **Type:** book
- **URL:** https://leanpub.com/senior-ios-playbook
- **Author:** Mike Salari
- **Why:** Senior / staff / principal interview depth — judgment, architecture, leadership; companion to *The iOS Interview Blueprint (Elite Edition 2026)*
- **When:** Preparing for senior+ technical and leadership loops; pair with [interview-answer-depth.md](/reference/curated/notes/interview-answer-depth.md)
- **Tags:** `interview`, `senior`, `staff`, `leadership`, `system-design`, `swift-6`
- **Added:** 2026-06-19

## Links

- Answer depth tiers: [interview-answer-depth.md](/reference/curated/notes/interview-answer-depth.md)
- Series index: [notes/immh-series-index.md](notes/immh-series-index.md)
- Service vs Repository: [architecture/patterns/](/architecture/patterns/) → [immh note](/architecture/patterns/notes/immh-service-vs-repository.md)
- BDUI: [system-design/bdui/](/system-design/bdui/)

## Interview Q&A (Knowledge cards)

### Q1
- **Question:** Where do you start a mobile system design on the whiteboard?
- **Answer:** Clarify requirements and constraints, draw the entity graph and read/write paths, then deepen storage, APIs, and errors.

### Q2
- **Question:** What are secondary requirements?
- **Answer:** Non-core but senior-level: logging, metrics, analytics, feature flags, deep links, accessibility.

### Q3
- **Question:** How do child topics under system-design relate?
- **Answer:** Mobile is the umbrella; offline, sync, push, deep links, flags, and analytics are subsystems you attach when the scenario needs them.
