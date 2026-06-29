# Concurrency

## Materials

- Intro digest (social, URL TBD): [notes/Swift-Concurrency-Intro-Social.md](notes/Swift-Concurrency-Intro-Social.md) — playground [SwiftConcurrencyPrimer.playground](SwiftConcurrencyPrimer.playground)
- Structured concurrency: [notes/Structured-Concurrency-What-Structured-Means.md](notes/Structured-Concurrency-What-Structured-Means.md) — [macguru.dev](https://macguru.dev/whats-that-structured-in-structured-concurrency/); playground [StructuredConcurrencyLab.playground](StructuredConcurrencyLab.playground)

- Playground: [ImageLoadingConcurrencyLab.playground](ImageLoadingConcurrencyLab.playground/Contents.swift)

### Actors vs Queues vs Locks (shared state)

## Topic structure

- `notes/` — Q&A + links to Apple docs
- `exercises/` — exercises with expected outcome
- `playgrounds/` — runnable examples
- `assets/` — files and PDFs for this topic

---

## 🎯 Focus vs Defer

### Defer

## 📚 What to learn by level

### JUNIOR

### MIDDLE

### SENIOR

### TECH LEAD

### STAFF/PRINCIPAL

## 🌟 Strategic (Senior+/Tech Lead)

### Strict concurrency migration plan (large project)

### Architecture patterns: `@MainActor-only` vs domain actors

### Team enablement

## 🏋️ Exercises (10) — required practice

    Docs: `https://developer.apple.com/documentation/swift/withcheckedcontinuation(function:_:)`

    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/`

    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/#Actors`

    Docs (TSan/Xcode): `https://developer.apple.com/documentation/xcode/diagnosing-memory-thread-and-crash-issues-early`

    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/`

    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/#Task-Cancellation`

    Docs: `https://developer.apple.com/documentation/swift/asyncstream`

    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/#Actors`

    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/`

---

## TL;DR

## Basic model

## When to use

## Common mistakes

## Practical rules

## Mini example

```swift
func loadUserAndPosts(api: APIClient) async throws -> (User, [Post]) {
    async let user = api.fetchUser()
    async let posts = api.fetchPosts()
    return try await (user, posts)
}
```

## Links

- Swift Book — Concurrency: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/`

---

## TL;DR

## Source

- [The versatility of tasks](https://macguru.dev/the-versatility-of-tasks/)

## 1) Task as future/promise contract

## 2) Task as coordination point

## 3) Task as entry to async from sync API

## 4) `Task.detached` vs `Task { @concurrent in }`

## Why it matters in architecture

## Practical takeaways

## Mini checklist

---## TL;DR

## Source

- Swift Evolution:
  - `https://github.com/apple/swift-evolution/blob/main/proposals/0431-isolated-any-functions.md`
  - `https://github.com/swiftlang/swift-evolution/blob/main/proposals/0420-inheritance-of-actor-isolation.md`

## Why the problem arises

```swift
func withDependencies<R>(
    operation: () async throws -> R
) async rethrows -> R {
    try await operation()
}
```

## What `@isolated(any)` gives (SE-0431)

```swift
operation: @isolated(any) () async throws -> R
```

## What `#isolation` gives (SE-0420)

## Where it is especially useful

## Practical takeaways

## Mini checklist

---## 1) Team contract (code review rules)

### Must

  Docs: `https://developer.apple.com/documentation/swift/sendable`

### Avoid

### Temporarily allowed (ticket + deadline only)

## 2) Migration: phases, metrics, Definition of Done

### Phase 0 — Inventory

### Phase 1 — Async API at boundaries

### Phase 2 — Isolation domains

### Phase 3 — Strict concurrency (gradual)

### Progress metrics

### Definition of Done (per module)

## 3) Mini code review checklist

---

<a id="concurrency-primer"></a>## Intro notes: Swift Concurrency

---## 1. Why the app needs this

---## 2. Synchronous vs asynchronous code

---## 3. `Task` — unit of async work

<a id="concurrency-primer-s3-1"></a>

### 3.1. What “context” means for `Task` vs `Task.detached`

---

<a id="concurrency-primer-s4"></a>## 4. Actor and isolation (**actor isolation**)

---

<a id="concurrency-primer-s5"></a>## 5. `@MainActor`

---

<a id="concurrency-primer-s6"></a>## 6. `Sendable`

---

<a id="concurrency-primer-s7"></a>## 7. Cancellation

---

<a id="concurrency-primer-s8"></a>## 8. `async let` and `TaskGroup` (very brief)

---## 9. Continuation (**withCheckedContinuation**)

---## 10. Common misconceptions

---## 11. Map: intro notes → Q11–Q20

---## 12. Next in the plan

---## Interview Q&A (Knowledge cards)

Interview Q&A below.

<!-- knowledge-cards-canonical:start -->

### Q11
- **Question:** `Task {}` vs `Task.detached`?

- **Answer:** `Task { }` is a structured child task that inherits context from where it was created: `actor` / `MainActor` isolation, `TaskLocal` values, and the relationship to the parent `Task` (cancellation and errors propagate through the hierarchy in broad strokes). `Task.detached { }` starts without inheriting that bundle—it’s a fresh slate for those inherited attributes.

    “Context” here means inherited concurrency context, not “anything external”; `detached` is easy to misuse because execution may leave the isolation or locals you relied on.

    1. `Task` inherits parent context: `MainActor`, `TaskLocal`, structured hierarchy.
    2. `detached` drops inheritance—classic bug is UI updates off the main actor or lost `TaskLocal`.
    3. Use `detached` only when you want that clean break.

### Q12
- **Question:** What is actor isolation?

- **Answer:** Actor isolation means the language/runtime ensures serialized access to an actor’s mutable state: isolated calls run one at a time on the actor’s executor, so two mutations can’t race inside that actor. That prevents data races on the actor’s own storage.

    Note: `await` inside an actor method can suspend and let another actor call run—reentrancy is a separate caveat (see Q13).

    1. Actor isolation serializes mutations to the actor’s state—one at a time.
    2. It prevents data races on that actor’s storage.
    3. `await` can allow interleaving—state may change across suspension (Q13).

### Q13
- **Question:** Why is actor reentrancy dangerous?

- **Answer:** Actor reentrancy is tied to `await`: while an isolated method is suspended waiting on async work, the actor can process other isolated calls. Those calls may mutate the actor’s state. When the first method resumes, assumptions checked before the suspension may no longer hold—even though you still don’t get an intra-actor data race on that storage (Q12).

    Isolation serializes entry, but it does not freeze state across `await`.

    1. `await` lets other isolated calls run and mutate state.
    2. Re-check invariants after suspension—or use value snapshots.
    3. Contrast reentrancy vs deadlock: state can drift across `await` even without classic deadlock.

### Q14
- **Question:** How does cancellation work in Swift concurrency?

- **Answer:** Cancellation sets a flag (cancellation request) on the `Task` and does not forcibly abort that task’s execution—the app process keeps running; work continues until the task observes cancellation. That makes it cooperative, not preemptive (the runtime does not forcibly interrupt arbitrary synchronous work mid-instruction). `Task.cancel()` / parent cancellation marks the task; your code checks `Task.isCancelled`, calls `try Task.checkCancellation()` (throws `CancellationError`), and many `await` APIs observe cancellation when implemented that way.

    In structured tasks, parent cancellation typically propagates to child tasks; `Task.detached` and tight synchronous loops without checks can ignore cancellation until they `await` or poll.

    1. Cancellation is a flag; you `checkCancellation` / read `isCancelled`.
    2. A tight sync loop won’t stop by itself—still cooperative.
    3. `try Task.checkCancellation()` before expensive work is a common explicit cancellation point.

### Q15
- **Question:** When do you use `@MainActor`?

- **Answer:** Use `@MainActor` to isolate UI-touching code on the `MainActor` global actor. On Apple platforms that aligns with main-thread UI work for `UIKit` / `SwiftUI` (and models the UI reads/writes directly). It’s actor isolation, not “sprinkle `Thread.isMainThread` everywhere”—the compiler/runtime enforce hopping via `async`/`await`.

    `MainActor` is the UI boundary: keep direct UI work there; run non-UI work elsewhere (own `actor`, non-`MainActor` services, `Task` off the main actor), then hop back (`await MainActor.run`, `@MainActor` methods) to publish results into UI-visible state—not only “redraw”, but any mutation the UI observes.

    Don’t park heavy synchronous work on `MainActor` or you’ll block UI responsiveness.

    1. `@MainActor` isolates UI-facing code on `MainActor`.
    2. On Apple platforms that maps to main-thread UI rules—say main actor, not only “main thread”.
    3. Offload heavy work, hop back with `await MainActor.run` / isolated `Task`.
    4. Non-UI off `MainActor`; `MainActor` only for what the UI observes (`UIKit`/`SwiftUI` state).

### Q16
- **Question:** What does `Sendable` guarantee?

- **Answer:** `Sendable` means values of the type can cross concurrency domains (tasks, actors, `MainActor`, …) without introducing data races—the compiler uses that in isolation checking.

    It is not automatic immutability for arbitrary classes; reference types often need an explicit story (`final` + immutable state, `actor` wrapping, or `@unchecked Sendable` with manual proof).

    1. `Sendable` marks types safe to pass across concurrency boundaries.
    2. It’s about avoiding data races when sharing across domains.
    3. For legacy classes: refactor, wrap in an `actor`, or `@unchecked` with care.

### Q17
- **Question:** `TaskGroup` vs `async let`?

- **Answer:** Use `TaskGroup` when the child-task count is dynamic (e.g. loop over inputs and `addTask` per item). Use `async let` for a fixed, explicitly written fan-out—a small set of parallel bindings known up front, not a variable-length blast of tasks.

    Rule of thumb: group for “however many items”; `async let` for “these specific concurrent steps”.

    1. `TaskGroup` — dynamic task count.
    2. `async let` — fixed parallel bindings.
    3. Don’t fake a dynamic fan-out with many `async let`s—use a group.
    4. Follow-up (partial results): `TaskGroup` when many tasks + you care about failure policy; `async let` when few parallel steps in one scope.

### Q18
- **Question:** What rule must `withCheckedContinuation` satisfy (often phrased as its “invariant”)?

- **Answer:** Call `resume` exactly once per continuation—never forget it (hang) and never call it twice (undefined behavior / trap in checked builds).

    1. Bridge legacy callbacks into `async`/`await`.
    2. `resume` exactly once.
    3. Zero resumes hang; double resume breaks the task.

### Q19
- **Question:** What is priority inversion?

- **Answer:** High-priority work blocks on a shared resource held by lower-priority work (often worsened by intermediate-priority threads starving the low-priority holder).

    1. QoS shapes scheduling—high usually runs ahead of low.
    2. Inversion—high waits because low holds a needed lock/resource.
    3. Tie to UI when main code waits on background work.

### Q20
- **Question:** How do you test async code?

- **Answer:** Same principles: deterministic dependencies (repeatable: controlled inputs/time—no flaky real network or wall-clock luck), explicit cancellation/error coverage, avoid relying on real time delays.

    Modern Swift Testing (`import Testing`) uses `@Test`, `async`/`await`-friendly test functions, and `#expect`/`#require`. XCTest-heavy codebases still lean on expectations/`wait` or async-capable test methods—name both and explain trade-offs.

    1. Deterministic (repeatable) fakes/clocks—no flaky timing.
    2. Swift Testing: `@Test`, async, `#expect`.
    3. XCTest: expectations or async tests; don’t sleep blindly.

- **Playground:** [open](ActorsQueuesLocksInterview.playground/Contents.swift)

---
### Q43
- **Question:** GCD basics—what about the main queue?

- **Answer:** Main queue drives UI; offload heavy work; return with `main.async`—avoid `main.sync` unless you fully understand reentrancy/deadlock risk.

### Q44
- **Question:** What is `AsyncStream`, when do you reach for it, and how is it produced?

    - WebSocket / network events;

    - GPS/CoreLocation;

- **Answer:** `AsyncStream` is the bridge from push-style sources (callbacks, delegates, `Timer`, sockets) into `AsyncSequence` and `for await`. You construct it with a closure that captures a `Continuation`; the producer calls `continuation.yield(value)` and `continuation.finish()`. Always set `continuation.onTermination` to tear down the underlying source when the consumer goes away. It’s the standard tool to convert callback-based iOS APIs into Swift Concurrency.

    1. `AsyncStream` exposes a push source as `AsyncSequence`.
    2. Build with a `Continuation`: `yield`, `finish`, `onTermination`.
    3. Use it to bridge callback APIs into async.

### Q45
- **Question:** Can Swift Concurrency fully replace Combine?

    ```swift
    let user = try await api.loadUser()
    ```

    ```swift
    api.loadUserPublisher()
        .sink { ... }
        .store(in: &cancellables)
    ```

    - **networking** → `async/await`;

    - **streams/events** → `AsyncStream` / `AsyncSequence`;

- **Answer:** Partially yes, fully no. Swift Concurrency replaces most of what people used Combine for: request/response networking, sequential async, single-source event streams (`AsyncStream`), and shared-state protection (`actor`/`@MainActor`). Combine still wins on **rich operator pipelines**: `debounce`, `merge`, `combineLatest`, multi-source reactive UI like type-ahead search or form validation. `AsyncSequence` covers basic operators; advanced ones live in `swift-async-algorithms`. In modern iOS projects, the typical split is: networking with async/await, events with `AsyncStream`, UI state with **Observation** (or Combine in legacy). Combine isn’t dead — Apple keeps it; it’s just no longer the default for async work.

    1. They’re different abstractions, not 1:1 replacements.
    2. async/await wins on request/response and single streams.
    3. Combine still wins on multi-source operator pipelines.

### Q46
- **Question:** Compare Combine, Swift Concurrency (async/await + AsyncStream) and older native iOS async/event APIs (callbacks, delegate, NotificationCenter, KVO, GCD, Operation). When do you reach for what?

    |---|---|---|---|---|---|---|---|---|

    ```swift
    // 1) Completion handler (legacy style)
    func loadUser(id: String, completion: @escaping (Result<User, Error>) -> Void) { ... }
    loadUser(id: id) { result in
        DispatchQueue.main.async {
            switch result {
            case .success(let user): self.render(user)
            case .failure(let error): self.show(error)
            }
        }
    }

    // 2) Combine
    api.userPublisher(id: id)
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { if case .failure(let e) = $0 { self.show(e) } },
            receiveValue: { self.render($0) }
        )
        .store(in: &cancellables)

    // 3) async/await
    Task { @MainActor in
        do {
            let user = try await api.user(id: id)
            render(user)
        } catch {
            show(error)
        }
    }
    ```

    ```swift
    // Combine — most concise
    queryPublisher
        .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
        .removeDuplicates()
        .flatMap { api.searchPublisher(query: $0) }
        .sink { results in self.render(results) }
        .store(in: &cancellables)

    // async/await + AsyncStream + swift-async-algorithms
    Task { @MainActor in
        for await query in queryStream
            .debounce(for: .milliseconds(300))   // from swift-async-algorithms
            .removeDuplicates()
        {
            let results = try await api.search(query: query)
            render(results)
        }
    }
    ```

    1. Frame the axes: single/many × push/pull.
    2. async/await for request/response and structured parallelism with compile-time safety.
    3. Combine for multi-source operator pipelines; `AsyncStream` to bridge push sources into async.

### Q47
- **Question:** Swift async landscape—GCD, Operation, Combine, Swift Concurrency—in one interview pass?

- **Answer:** See **Q46** for the full matrix. GCD/Operation = scheduling; Combine = reactive streams; Swift Concurrency = async/await + structured tasks + actor isolation for data-race safety.

### Q48
- **Question:** GCD `DispatchQueue.async` vs `sync`—semantics and pitfalls?

- **Answer:** `async` schedules and returns; `sync` runs the block on the target queue before returning—handy for “read consistent snapshot on that queue” but deadly if you `sync` onto the queue you’re already running on.

### Q49
- **Question:** When is a stateless actor justified?

- **Answer:** A property-less actor is odd unless you can articulate why synchronization matters. Valid: Sendable network service (sync work off main, but serializes sync sections), custom-executor bridge, filesystem as external state. Prefer `Sendable struct` + `@concurrent` for parallel CPU work without shared mutable state. Avoid a global background actor—it serializes and spreads isolation.

    1. Stateless actor needs a clear sync/isolation reason—not a Sendable shortcut.
    2. Compare actor service vs `@concurrent struct` for parallel heavy work.
    3. Custom executors and external state are fine; global background actors are not.

- **Notes:** [notes/Stateless-Actors-Massicotte.md](notes/Stateless-Actors-Massicotte.md)
### Q50
- **Question:** Why can Swift 6 strict concurrency still crash at runtime with a clean build?

- **Answer:** Strict concurrency catches many races at compile time, but the compiler injects dynamic isolation checks when thread provenance is unclear. Mismatch traps with `_swift_task_checkIsolatedSwift` or `_dispatch_assert_queue_fail`. Common cases: MainActor-inherited closures run on background (Core Data perform, Combine before receive(on), notifications), MainActor classes with SDK delegates on private queues, misuse of assumeIsolated. Fixes: `@Sendable` closures, reorder receive(on), nonisolated delegates with explicit MainActor hop.

    1. Runtime traps exist beyond compile-time race checks.
    2. Inherited MainActor closures + background SDK/Combine = classic crashes.
    3. nonisolated delegates with explicit MainActor hop for UI.
    4. @Sendable or receive(on) first to break inheritance.

- **Notes:** [notes/Swift-6-Runtime-Concurrency-Crashes.md](notes/Swift-6-Runtime-Concurrency-Crashes.md)

<!-- knowledge-cards-canonical:end -->
