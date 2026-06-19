# Mobile App Design

## За 30 секунд

Mobile system design — собеседование на **сеньорность**: не только язык и UI, а **система целиком** — сущности, API, кэш, offline, push, observability, границы модулей. Ответ строят за ~45 минут: requirements → entity graph → read/write paths → trade-offs → secondary requirements (логи, аналитика, флаги).

## Материалы

### immh — Mobile System Design

| Material | Status |
|----------|--------|
| [immh-series-index.md](notes/immh-series-index.md) | index + integration checklist |
| [immh-interview-glava-1.md](notes/immh-interview-glava-1.md) | awaiting paste |
| [immh-logger.md](notes/immh-logger.md) | awaiting paste |

### Playgrounds

| Playground | Focus |
|------------|-------|
| [mobile_system_design.playground](mobile_system_design.playground) | STAR template, entity graph, interview outline |

### Child topics (углубления)

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
- Non-functional: battery, memory, background limits
- Secondary: logging, analytics, feature flags, deep links

**Defer**

- Pixel-perfect UI на доске
- Полная схема БД до обсуждения use cases
- Выбор MVVM vs TCA как единственный критерий

## Ключевые понятия

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

## Код и примеры

[mobile_system_design.playground](mobile_system_design.playground) — шаблон ответа (STAR + placeholders).

## Ресурсы

### immh — Mobile System Design Interview (глава 1)
- **Type:** article
- **URL:** https://immh.tech/blog/mobile-system-design-interview-glava-1
- **Author:** immh
- **Why:** Ввод в mobile SD interview: рамка, отличия, структура ответа
- **When:** Старт подготовки к senior mobile system design
- **Tags:** `system-design`, `interview`, `immh`, `mobile`
- **Note:** [immh-interview-glava-1.md](notes/immh-interview-glava-1.md)
- **Added:** 2026-06-19

### immh — Logger (system design)
- **Type:** article
- **URL:** https://immh.tech/blog/system-design-logger
- **Author:** immh
- **Why:** Логирование как secondary requirement на собесе
- **When:** Observability, production logging architecture
- **Tags:** `system-design`, `logging`, `observability`, `immh`
- **Note:** [immh-logger.md](notes/immh-logger.md)
- **Added:** 2026-06-19

## Ссылки

- Series index: [notes/immh-series-index.md](notes/immh-series-index.md)
- Service vs Repository: [architecture/patterns/](/architecture/patterns/) → [immh note](/architecture/patterns/notes/immh-service-vs-repository.md)
- BDUI: [system-design/bdui/](/system-design/bdui/)

## Карточки знаний (Q&A)

### Q1. С чего начать mobile system design на доске?

**RU:** Уточни требования и constraints (offline, scale, platforms). Нарисуй entity graph и два потока — read и write. Потом углубляй storage, API, ошибки.

**EN:** Clarify requirements, draw entities and read/write paths, then deepen storage and APIs.

**Доп. информация:** [immh-interview-glava-1.md](notes/immh-interview-glava-1.md) _(fill after paste)_

### Q2. Что такое secondary requirements?

**RU:** То, что не ядро фичи, но ожидают на senior: логи, метрики, аналитика, feature flags, deep links, accessibility.

**EN:** Non-core but senior-level: observability, analytics, flags, navigation, a11y.

**Доп. информация:** [immh-logger.md](notes/immh-logger.md) _(fill after paste)_

### Q3. Как связаны child topics в system-design?

**RU:** `mobile` — зонтик; offline/sync/push/deeplinks/flags/analytics — отдельные подсистемы, которые вставляешь в ответ, когда релевантно.

**EN:** Mobile is the umbrella; child topics are deep dives you attach when the scenario needs them.
