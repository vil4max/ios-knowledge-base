# Development Principles

> **Source:** [@swiftynew](https://t.me/swiftynew) — *Development Principles* (KISS, DRY, YAGNI, BDUF, SOLID, APO, Occam's Razor).

## In 30 seconds

Development principles are decision guides, not dogma. They help you keep code readable, testable, and easy to change. Interviewers rarely test acronym recall — they want you to **reason about trade-offs**: when to extract shared logic (DRY), when to stop adding layers (YAGNI, KISS, Occam), when to plan before coding (BDUF), how SOLID reduces coupling in Swift (protocols, SRP), and when to optimize only after measurement (APO). Middle+ engineers explain **why** a solution is simple enough, not just that they "follow SOLID."

## Apple docs

- [The Swift Programming Language — Protocols](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols) — abstraction boundaries for DIP and ISP.
- [Improving app performance](https://developer.apple.com/documentation/xcode/improving-app-performance) — measure before optimizing (APO).
- [Analyzing performance](https://developer.apple.com/documentation/xcode/analyzing-performance) — Instruments, Time Profiler, Allocations.

## 🎯 Focus vs Defer

### Focus

- **YAGNI** — ship only what the current task needs; delete dead code during refactors (git history preserves it).
- **DRY + SSOT** — one source of truth for rules and data; duplication multiplies maintenance and test surface.
- **KISS** — simplest solution that satisfies requirements; complexity should come from the product, not from tooling fashion.
- **BDUF (lightweight)** — think through constraints and architecture **before** large implementation; align with the team early.

### Defer

- Memorizing SOLID letter expansions without Swift examples.
- Treating BDUF as months of upfront design with no iteration.
- Applying DRY to three-line UI duplicates that will diverge anyway.
- Micro-optimizing before profiling.

## Key concepts

| Principle | Full name | One-line meaning |
|-----------|-----------|------------------|
| **YAGNI** | You Aren't Gonna Need It | Write only what today's task requires |
| **DRY** | Don't Repeat Yourself | One source of truth for important logic |
| **SSOT** | Single Source of Truth | Change data/rules in one place |
| **KISS** | Keep It Simple, Stupid | Pick the simplest adequate solution |
| **BDUF** | Big Design Up Front | Plan task, constraints, and architecture before coding |
| **SOLID** | — | Five OOP design principles that reduce coupling |
| **APO** | Avoid Premature Optimization | Optimize only confirmed performance problems |
| **Occam's Razor** | — | Do not multiply entities without necessity |

### SOLID breakdown

| Letter | Principle | iOS hook |
|--------|-----------|----------|
| **S** | Single Responsibility | VC = UI; service = network; ViewModel = screen state |
| **O** | Open/Closed | Extend via new types/protocols, not endless edits to core logic |
| **L** | Liskov Substitution | Subtypes honor the contract of the base type |
| **I** | Interface Segregation | Several small protocols beat one "god" protocol |
| **D** | Dependency Inversion | High-level modules depend on `protocol`, not concrete services |

### How principles combine

```mermaid
flowchart LR
    subgraph simplicity [Simplicity]
        KISS
        YAGNI
        Occam[Occam's Razor]
    end
    subgraph structure [Structure]
        DRY
        SSOT
        SOLID
    end
    subgraph perf [Performance]
        APO
    end
    subgraph planning [Planning]
        BDUF
    end
```

- **KISS + YAGNI** — keep solutions small; avoid speculative code.
- **DRY + SSOT** — do not scatter the same business rule across the project.
- **SOLID** — lower coupling so changes stay local.
- **APO + Occam** — do not add complexity without proven need.
- **BDUF** — fewer rewrites when architecture is agreed early.

## How to answer in interviews

1. **Name the trade-off**, not the acronym — e.g. "I'd extract shared validation once the second screen needs the same rules (DRY), but I wouldn't add a generic framework after one use (YAGNI)."
2. **Give a Swift boundary** — SRP: "This ViewModel owns screen state; networking lives in a `UserFetching` protocol implementation."
3. **Show measurement for performance** — "I'd profile with Time Profiler before caching or switching data structures (APO)."
4. **Acknowledge tension** — DRY vs YAGNI: abstract when the pattern is stable, not on the first duplicate.
5. **Connect to team process** — BDUF as a short design discussion or ADR, not a waterfall spec.

## Code & examples

### YAGNI vs speculative abstraction

```swift
// ❌ YAGNI violation — generic "future" hook nobody asked for
protocol FeatureFlagRouting {
    func route(for flag: String, payload: [String: Any])
}

// ✅ Enough for the current story
func openProfile(userID: String) {
    router.push(ProfileView(userID: userID))
}
```

### DRY + SSOT — one validation rule

```swift
enum EmailValidator {
    static func isValid(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        return email.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
    }
}
```

Sign-up and password-reset screens both call `EmailValidator.isValid` — the regex lives in one place.

### KISS — prefer clarity over cleverness

```swift
// ✅ Straightforward
func formattedPrice(_ cents: Int) -> String {
    let dollars = Double(cents) / 100
    return String(format: "$%.2f", dollars)
}
```

### SOLID: SRP + DIP in MVVM

```swift
protocol SessionStoring: Sendable {
    func save(token: String) async throws
}

@MainActor
@Observable
final class LoginViewModel {
    private let sessionStore: any SessionStoring

    var email = ""
    var isLoading = false

    init(sessionStore: any SessionStoring) {
        self.sessionStore = sessionStore
    }

    func submit(token: String) async throws {
        isLoading = true
        defer { isLoading = false }
        try await sessionStore.save(token: token)
    }
}
```

ViewModel owns UI state (SRP). Storage is injected through a protocol (DIP). Tests swap a fake `SessionStoring`.

### SOLID: OCP + ISP — extend without editing core

```swift
protocol ImageLoading {
    func load(from url: URL) async throws -> Data
}

struct RemoteImageLoader: ImageLoading {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func load(from url: URL) async throws -> Data {
        let (data, _) = try await session.data(from: url)
        return data
    }
}

struct CachingImageLoader: ImageLoading {
    private let loader: any ImageLoading
    private var cache: [URL: Data] = [:]

    init(loader: any ImageLoading) {
        self.loader = loader
    }

    func load(from url: URL) async throws -> Data {
        if let cached = cache[url] { return cached }
        let data = try await loader.load(from: url)
        cache[url] = data
        return data
    }
}
```

New behavior wraps existing loaders (OCP). Callers depend only on `ImageLoading` (ISP), not every concrete type.

### APO — measure first

Workflow for a "slow list":

1. Reproduce on device with realistic data.
2. **Time Profiler** — is layout, decoding, or I/O the hotspot?
3. **Allocations** — unexpected churn?
4. Fix the proven bottleneck (cell reuse, decode off main actor, pagination).
5. Re-profile to confirm.

Optimizing cell height caching before step 2 often adds code with no measurable win.

### Occam's Razor vs extra layers

Ask before adding a new service or coordinator:

- Does it remove real duplication or coupling?
- Can an existing type own this with one clear method?
- Will onboarding cost exceed the benefit?

If two designs work, pick the one with fewer moving parts.

## Links

- [Clean Code (Martin)](https://www.pearson.com/en-us/subject-catalog/p/clean-code-a-handbook-of-agile-software-craftsmanship/P200000003284) — craftsmanship context for SOLID and readability
- [Refactoring (Fowler)](https://martinfowler.com/books/refactoring.html) — when and how to improve structure safely
- [The Pragmatic Programmer](https://pragprog.com/titles/tpp20/the-pragmatic-programmer-20th-anniversary-edition/) — DRY, tracer bullets, good-enough design
- Related in this knowledge base: [MVVM → TCA](../../architecture/patterns/) (SOLID Q&A, KISS/DRY/YAGNI **Q52**), [Design Patterns](../../algorithms/design-patterns/), [Performance](../../quality/performance/)

---

## Interview Q&A (Knowledge cards)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question:** What is YAGNI and when do teams violate it?

- **Answer:** Build only what you need now. Violations include speculative features, unused extension points, and premature generalization. Delete dead code during refactors; version control preserves history.

### Q2
- **Question:** DRY vs SSOT — what's the difference?

- **Answer:** DRY avoids repeating meaningful logic. SSOT means a single place owns data or rules. DRY is the principle; SSOT is the structural outcome.

### Q3
- **Question:** Does KISS mean writing primitive code?

- **Answer:** No — as simple as the problem allows. Complexity should come from requirements, not from pattern chasing. Simple designs are easier to read, review, and maintain.

### Q4
- **Question:** Is BDUF the same as waterfall?

- **Answer:** Not full waterfall. It means thinking through constraints and architecture before large implementation — short design notes, team alignment, fewer rewrites.

### Q5
- **Question:** List SOLID and give an iOS SRP example.

- **Answer:** Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion. SRP example: VC handles UI, network service handles HTTP, ViewModel holds screen state.

### Q6
- **Question:** How do you demonstrate OCP and DIP in Swift?

- **Answer:** OCP: add behavior with new conforming types instead of editing stable code. DIP: depend on protocols; wire concretes at the composition root.

### Q7
- **Question:** APO — what should you say about iOS?

- **Answer:** Optimize only proven bottlenecks. Profile with Instruments first; otherwise you risk complexity without measurable gain.

### Q8
- **Question:** Occam's Razor vs KISS and YAGNI?

- **Answer:** Occam picks the fewest entities among valid designs. KISS favors simple solutions. YAGNI avoids unneeded features. Together they curb unnecessary layers.

### Q9
- **Question:** DRY vs YAGNI — how do you resolve the tension?

- **Answer:** Extract when duplication reflects the same stable rule. Wait if the pattern might diverge; premature abstraction breaks on the next use case.

### Q10
- **Question:** How are these principles tested in interviews?

- **Answer:** Interviewers want reasoning about simplicity, boundaries, and trade-offs — not acronym recitation. Senior candidates justify design choices with principles.

<!-- knowledge-cards-canonical:end -->
