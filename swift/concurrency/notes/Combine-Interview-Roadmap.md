# Combine — interview roadmap

**Goal:** confident answers on Combine (3+ years commercial framing) + two live implementation stories from real projects.  
**Format:** short daily blocks (~15–20 min) or one 2-hour sprint.  

**Related in this repo:** [Swift-Concurrency.md](../Swift-Concurrency.md) (Q&A: Combine vs async/await, when to choose what) · [SECTION_MAP](../../SECTION_MAP.md)

---

## Progress tracker

| Phase | Topic | Done |
|-------|--------|------|
| 0 | Baseline + interview pitch | ☐ |
| 1 | Core model (Publisher / Subject / Cancellable) | ☐ |
| 2 | Operators you must name on interview | ☐ |
| 3 | Memory, threads, errors | ☐ |
| 4 | 10 Q&A — rehearse out loud | ☐ |
| 5 | 2 live cases — rehearse out loud | ☐ |
| 6 | Mock interview round (3 questions) | ☐ |

---

## Phase 0 — Baseline (Day 0, ~15 min)

**Learn**

- Combine = reactive streams for async events (not only network).
- Four pieces: **Publisher → Operator → Subscription → Subscriber**.
- Pull model: subscriber requests demand; `cancel()` tears down the chain.

**Say on interview (30 sec)**

> «Около 3+ лет коммерческого опыта с Combine: state/event streams, auth/session, debounce-поиск, пайплайны с операторами. В новых модулях чаще `async/await` для one-shot задач, Combine — где нужны долгоживущие потоки событий.»

**Self-check**

- [ ] Могу объяснить разницу Combine vs `async/await` без «Combine устарел».
- [ ] Знаю, зачем тестируют **Presenter / ViewModel**, а не View: там ветвления и бизнес-решения.

---

## Phase 1 — Core types (Day 1, ~20 min)

| Concept | One line | When to use |
|---------|----------|-------------|
| `Publisher` | Source of values over time | Any stream |
| `PassthroughSubject` | Events only, no stored value | UI actions, one-shot signals |
| `CurrentValueSubject` | Last value + new events | Auth flag, shared state |
| `@Published` | Property wrapper → publisher | SwiftUI / ObservableObject VM |
| `AnyPublisher` | Type-erased publisher | Public API of services |
| `AnyCancellable` | Holds subscription alive | Always store in `Set` |

**Practice**

1. Explain: why `CurrentValueSubject` for `authorizationStatePublisher` in auth service, not `PassthroughSubject`.
2. Explain: what happens if you do not store `AnyCancellable`.

**Project anchor**

- `SearchScreenViewModel`: `@Published` state + `sink` on `isUserAuthorizedPublisher`.

---

## Phase 2 — Operators map (Day 2, ~20 min)

**Must know (name + one sentence)**

| Operator | Interview one-liner |
|----------|---------------------|
| `map` | Sync transform value → value |
| `flatMap` | Value → new Publisher (e.g. request per event) |
| `switchToLatest` | Keep only latest inner publisher; cancel stale |
| `combineLatest` | Merge latest from several publishers |
| `merge` | Interleave events from publishers |
| `debounce` | Wait for pause (search typing) |
| `throttle` | Max rate of events |
| `removeDuplicates` | Skip repeated values |
| `filter` / `compactMap` | Drop / map+drop nil |
| `catch` / `retry` | Error recovery |
| `subscribe(on:)` | Where upstream runs |
| `receive(on:)` | Where downstream receives (UI → main) |
| `handleEvents` | Side effects without changing stream |

**Practice drill**

- Search field: which chain? → `debounce` + `removeDuplicates` + `flatMap`/`switchToLatest` + `receive(on: .main)`.
- Duplicate UI updates from `@Published`: → `removeDuplicates()` or fix equality.

---

## Phase 3 — Pitfalls (Day 3, ~15 min)

| Problem | Fix |
|---------|-----|
| Retain cycle in `sink` | `[weak self]` |
| Subscription dies immediately | Store in `Set<AnyCancellable>` |
| Stale search results | `switchToLatest` (not bare `flatMap` without cancel) |
| UI off main thread | `receive(on: DispatchQueue.main)` |
| `@Published` fires on same value | `removeDuplicates()` or custom `Equatable` |
| Hard to test | Mock publishers / subjects; no real timers in unit tests |

**Combine vs async/await (15 sec)**

- **async/await:** one async operation, linear code.
- **Combine:** multiple event sources over time, composition, backpressure-style control.

---

## Phase 4 — 10 interview Q&A (Day 4, ~20 min)

Rehearse each answer in **1–2 sentences** out loud.

1. **What is Combine and where did you use it?**  
   Reactive framework for async event streams; auth state, search debounce, UI state in production iOS apps.

2. **`PassthroughSubject` vs `CurrentValueSubject`?**  
   Passthrough = events only. CurrentValue = holds last value; new subscriber gets it immediately.

3. **Why `eraseToAnyPublisher()`?**  
   Hides concrete publisher type; cleaner API and easier refactoring.

4. **`subscribe(on:)` vs `receive(on:)`?**  
   Where work runs vs where subscriber receives; UI updates on main.

5. **`map` vs `flatMap`?**  
   Sync transform vs spawn inner publisher per value.

6. **Why `switchToLatest`?**  
   Cancels outdated inner publishers (e.g. old search requests).

7. **Error handling?**  
   `catch`, `retry`, map to UI state; separate recoverable vs fatal errors.

8. **Memory leaks?**  
   `weak self`, store cancellables, verify `deinit` in debug.

9. **Testing Combine?**  
   XCTest + mocks + assert state sequence; avoid real network/timers.

10. **Combine vs async/await today?**  
    async/await for one-shot; Combine for long-lived multi-source streams.

---

## Phase 5 — Live cases (Day 5, ~20 min)

### Case A — Search with debounce

**Prompt:** «How do you avoid API call on every keystroke?»

**Answer skeleton**

1. Stream from search text (`@Published` or subject).
2. `debounce(300–500ms)` + `removeDuplicates()`.
3. Ignore too-short query.
4. `flatMap` / `switchToLatest` → repository request.
5. Map to `ViewState`; `receive(on: .main)`.

**Your story:** `SearchScreenViewModel` — debounce via `Task.sleep` + cancel previous task (same idea; be ready to say «можно и через Combine debounce»).

### Case B — Global auth state

**Prompt:** «How does the app react to login/logout everywhere?»

**Answer skeleton**

1. `CurrentValueSubject<Bool>` (or service-owned state) in auth layer.
2. Expose `AnyPublisher<Bool, Never>`.
3. Screens `sink` / combine with local state; reload data on change.
4. Low coupling: modules do not poll keychain directly.


---

## Phase 6 — Mock round (Day 6, ~15 min)

Answer without notes:

1. When `CurrentValueSubject` vs `@Published`?  
2. Why `switchToLatest` in search, not only `flatMap`?  
3. What if `AnyCancellable` is not stored?

**Target answers (check yourself)**

1. **Subject** in services crossing modules; **`@Published`** inside a single VM/ObservableObject for SwiftUI binding.  
2. **`flatMap`** keeps all inners alive; **`switchToLatest`** cancels stale requests.  
3. Subscription cancelled immediately; no updates / flaky behavior.

---

## Recruiter bundle (same repo thread)

### Q1 — Unit tests (UA-ready summary)

- Covered: subscription statuses, pay/renew/cancel, `noEnoughBonuses`, loyalty edge cases.
- Tests on **Presenter / ViewModel** (business branches, fast, no UI).
- Caught regression before QA; safe release.

### Q2 — Interesting challenge

- UIKit → SwiftUI migration experiment (UX, analytics, maintainability).
- watchOS AI voice assistant (WebSocket backend, agent-driven UI, platform limits).

### Q3 — Combine experience

- **3+ years** commercial Combine; see Phase 0 pitch above.

---

## Deep dive (optional, +1–2 days)

- [ ] Read: `KnowledgeDB/iOS/Combine Swiss Army Knife For Ios.md`
- [ ] Skim: `ecosystem-ios-sdk/.../CombineHelpersTests.swift`

---

## One-page cheat sheet (print / phone)

```
Subject: Pass = events | Current = state + events
Store: Set<AnyCancellable> + [weak self]
UI: receive(on: .main)
Search: debounce → removeDuplicates → switchToLatest
Auth: CurrentValueSubject → AnyPublisher
Test: Presenter/VM + mocks
Pitch: 3+ yrs, streams + operators, async/await for one-shot
```

---

