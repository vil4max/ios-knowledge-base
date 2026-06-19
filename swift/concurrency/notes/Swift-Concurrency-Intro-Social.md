# Swift Concurrency in iOS — Explained Simply

- **Source:** social post (LinkedIn-style intro; URL to be added)
- **Series:** primer
- **Migrated:** 2026-06-19
- **Status:** digest
- **Playground:** [SwiftConcurrencyPrimer.playground](../SwiftConcurrencyPrimer.playground)

---

## TL;DR

- Modern iOS work is concurrent: API, images, DB, background tasks.
- Legacy: completion handlers, nested closures, GCD → callback hell.
- Swift Concurrency: `async`/`await`, `Task`, `actor`, `@MainActor`.
- `async let` runs independent work in parallel inside one async function.

---

## 1. async / await

**Before**

```swift
fetchUser { user in
    fetchPosts(user) { posts in
        print(posts)
    }
}
```

**After**

```swift
func loadData() async throws {
    let user = try await fetchUser()
    let posts = try await fetchPosts(user)
    print(posts)
}
```

Benefits: linear control flow, `throws` with `try await`, easier to read.

---

## 2. Task

Start async work from synchronous context:

```swift
Task {
    await loadData()
}
```

`Task.detached` runs outside the caller's actor context — use sparingly; prefer structured `Task` / task groups when parent lifetime matters.

---

## 3. MainActor

UI-bound state and updates belong on the main actor:

```swift
@MainActor
final class HomeViewModel: ObservableObject {
    @Published var users: [User] = []

    func fetchUsers() async {
        users = await api.getUsers()
    }
}
```

For new SwiftUI code, consider `@Observable` + `@MainActor` on the model type.

---

## 4. Actor

Isolated mutable state — one serial executor per actor instance:

```swift
actor CounterManager {
    private var count = 0

    func increment() {
        count += 1
    }
}
```

---

## 5. Parallel execution — async let

```swift
async let users = fetchUsers()
async let posts = fetchPosts()

let (u, p) = try await (users, posts)
```

Use for independent network calls, parallel downloads, fan-out inside one async entry point.

---

## Чего нет в посте (см. основной README и другие материалы)

| Тема | Где углубиться |
|------|----------------|
| Structured vs unstructured `Task` | [Structured-Concurrency-What-Structured-Means.md](Structured-Concurrency-What-Structured-Means.md), [StructuredConcurrencyLab.playground](../StructuredConcurrencyLab.playground) |
| Cancellation | [StructuredConcurrencyLab.playground](../StructuredConcurrencyLab.playground) |
| `Sendable`, data races | README Q-cards, Swift 6 notes |
| GCD migration | `GCD.playground`, `ConcurrencyEvolutionFromThreads.playground` |
| Actor vs locks | `ActorsQueuesLocksInterview.playground` |

---

## Связь с базой

- [Concurrency README](../README.md)
- [StructuredConcurrencyLab.playground](../StructuredConcurrencyLab.playground)
- [SwiftConcurrencyPrimer.playground](../SwiftConcurrencyPrimer.playground)
