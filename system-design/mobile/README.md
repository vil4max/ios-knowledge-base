# Mobile App Design

## За 30 секунд

Mobile system design interviews test whether you can turn a product brief into a **landscape of entities**, **client–server contracts**, and **mobile-specific secondary requirements** (offline, push, analytics, deep links, lifecycle). Start by sketching the entity graph, clarifying read vs write paths, then layer sync, caching, and observability. Senior answers name trade-offs (poll vs push, local source of truth vs network-first) and estimate complexity with concrete ranges.

## Apple docs

- [App lifecycle](https://developer.apple.com/documentation/uikit/app_and_environment/managing_your_app_s_life_cycle) — background limits, state restoration entry points.
- [Background execution](https://developer.apple.com/documentation/uikit/app_and_environment/scenes/preparing_your_app_to_run_in_the_background) — when sync and push handlers may run.
- [URLSession](https://developer.apple.com/documentation/foundation/urlsession) — networking layer for REST/GraphQL clients.
- [Core Data](https://developer.apple.com/documentation/coredata) / [SwiftData](https://developer.apple.com/documentation/swiftdata) — common local persistence choices in iOS designs.

## 🎯 Focus vs Defer

### Focus

- **Entity graph first:** users, sessions, feeds, messages, devices — nodes and relationships before UI patterns.
- **Read path vs write path:** who is source of truth, what is cached, what is optimistic.
- **Secondary requirements:** loading/empty/error states, offline, push, deep links, analytics, accessibility.
- **Mobile constraints:** battery, memory, flaky network, app kill, binary size, App Store review.
- **API alignment:** pagination, idempotency keys, versioning, error taxonomy.
- **45-minute interview structure:** clarify → landscape → deep dive 2–3 areas → trade-offs → wrap-up.

### Defer

- Pixel-perfect UI component inventory unless the prompt is UI-heavy.
- Full backend schema normalization — sketch tables/endpoints, not every index.
- Exotic sync (CRDTs, operational transforms) unless the product is collaborative editing.
- Platform-specific Android details unless the interview is explicitly cross-platform.

## Ключевые понятия

| Concept | Interview use |
|--------|----------------|
| **Landscape / entity graph** | Map domain objects and flows before modules |
| **Primary vs secondary requirements** | Happy path vs offline, errors, analytics |
| **Local source of truth** | UI reads local DB; network reconciles |
| **Optimistic UI** | Show pending state; rollback on failure |
| **Pagination** | Cursor vs offset; stale page handling |
| **Session & auth** | Token refresh, secure storage, logout everywhere |
| **Push vs poll** | Real-time freshness without draining battery |
| **Feature flags / remote config** | Gradual rollout, kill switch |
| **Analytics taxonomy** | Events tied to product questions, not noise |
| **Modular ownership** | Team boundaries map to module boundaries |

**Typical deep-dive areas:** feed/timeline, chat, maps, media upload, checkout, search.

**Estimation anchors (order of magnitude):** simple CRUD screen 1–3 days; offline-first entity with sync 1–3 weeks; full sync engine across many entity types 1–3 months (team-dependent).

## 🏋️ Exercises

1. **Design a message inbox** — Entity graph (conversation, message, read receipt, device). Define read path (local DB + pagination), write path (send queue), push for new messages, and analytics events. *Expected:* diagram with 5–8 entities and explicit offline behavior.

2. **Design a workout history screen** — Network-first vs offline-first trade-off. *Expected:* justify local cache for list/detail, background sync on launch, skeleton loading states.

3. **Clarifying questions drill** — Given “build Instagram Stories,” list 10 clarifying questions for PM/design/backend. *Expected:* audience size, media pipeline, expiry, moderation, analytics, deep link entry.

4. **Secondary requirements pass** — Take any primary flow and add error, empty, offline, and accessibility requirements without changing the core API. *Expected:* checklist applied to one screen.

5. **Estimate with ranges** — Break “offline-first notes app with sync” into milestones with week ranges and risks. *Expected:* local CRUD, outbox, delta sync, conflict policy called out separately.

## Ссылки

- [Mobile System Design: Resourceful Engineering](https://www.mobilesystemdesign.com/) — landscape, holistic development (Tjeerd in 't Veen)
- [Building Mobile Apps at Scale](https://www.mobileatscale.com/) — 39 engineering challenges (Gergely Orosz)
- [WWDC — Background execution overview](https://developer.apple.com/videos/) — search “background” for platform limits
- Related topics: [offline-first](../offline-first/README.md), [sync-engine](../sync-engine/README.md), [push-notifications](../push-notifications/README.md)

## Карточки знаний (Q&A)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question (RU):** С чего начать mobile system design на интервью?
- **Question (EN):** Where do you start in a mobile system design interview?
- **Answer (RU):** Уточнить scope и пользователя, нарисовать **entity graph** (сущности и связи), разделить **read path** и **write path**, затем добить вторичные требования: offline, push, deep links, analytics, error/empty/loading. Только после этого — модули и API.
- **Answer (EN):** Clarify scope, sketch the entity graph, split read vs write paths, then cover secondary requirements (offline, push, deep links, analytics, states). Modules and APIs come after the landscape is stable.

### Q2
- **Question (RU):** Чем mobile system design отличается от backend design?
- **Question (EN):** How is mobile system design different from backend design?
- **Answer (RU):** Ограничения клиента: **offline**, lifecycle и background limits, battery/memory, бинарная доставка через App Store, UX состояний (skeleton, empty). Backend фокусируется на throughput и consistency; mobile — на **локальном источнике истины** и синхронизации с сервером.
- **Answer (EN):** Mobile adds offline behavior, app lifecycle/background limits, battery and memory, App Store delivery, and rich UI states. Backend optimizes throughput and consistency; mobile optimizes local truth plus sync with the server.

### Q3
- **Question (RU):** Как встроить analytics в дизайн фичи, не «прикрутив в конце»?
- **Question (EN):** How do you design analytics into a feature from the start?
- **Answer (RU):** Задать **product questions** (conversion, retention, failure), определить **event taxonomy** (screen_view, action, outcome), свойства события (entity id, source, experiment variant), privacy (PII, consent, ATT). События привязать к шагам user flow в entity graph.
- **Answer (EN):** Start from product questions, define an event taxonomy and properties (ids, source, experiment), plan privacy/consent, and map events to steps in the user flow — not as an afterthought.

### Q4
- **Question (RU):** Push или poll — как выбирать?
- **Question (EN):** Push vs poll — how do you choose?
- **Answer (RU):** **Push** — когда нужна свежесть без постоянного опроса (chat, заказ в пути); учитывать silent push, budget, доставку не guaranteed. **Poll** — редкие обновления или когда push недоступен; комбинировать: push как триггер + fetch delta при открытии. Не poll каждые N секунд в background без причины.
- **Answer (EN):** Use push for timely updates without constant polling; account for silent push, budgets, and non-guaranteed delivery. Poll for rare updates or when push is unavailable; often combine push as a trigger with delta fetch on open. Avoid aggressive background polling.

<!-- knowledge-cards-canonical:end -->
