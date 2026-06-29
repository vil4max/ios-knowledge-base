# Testing

## Apple docs

- [XCTest](https://developer.apple.com/documentation/xctest) — unit / performance, `XCTestCase`, assertions, expectations.

- [UI Testing (XCUITest)](https://developer.apple.com/documentation/xcuiautomation) — black-box UI, accessibility tree.

## 🎯 Focus vs Defer

### Focus

### Defer

## Topic map (iOS)

## 📚 Key terms (Q&A)

## 🏋️ Exercises

## 🌟 Senior+ (strategic)

## Artifacts

- Notes: `notes/`
- Exercises: `exercises/`
- Assets: `assets/`
- Playgrounds: `playgrounds/`

### Recent notes

|---------|---------|
| Fundamentals | [Testing-Fundamentals-RU](notes/Testing-Fundamentals.md) · [TDD-Basics-RU](notes/TDD-Basics.md) |
| Frameworks | [Swift-Testing-vs-XCTest-RU](notes/Swift-Testing-vs-XCTest.md) |

| Delivery | [Test-Plans-CI-RU](notes/Test-Plans-CI.md) · [CI/CD](../../devops/ci-cd/README.md) |
| Senior + AI | [Senior-Unit-Testing-Mastery-RU](notes/Senior-Unit-Testing-Mastery.md) · [AI-assisted TDD](notes/ai-assisted-tdd.md) |

**Exercises:** [exercises/README.md](exercises/README.md)

---

## TL;DR

## Source

- `https://www.massicotte.org/blog/testing-event-stream/`

## Problem when migrating from XCTest

## Idea: test event stream, not callback

## Basic template

```swift
import Testing

@Test
func testSystemEventOrder() async {
    let (stream, continuation) = AsyncStream<String>.makeStream()

    system.callbackA = { continuation.yield("a") }
    system.callbackB = { continuation.yield("b") }

    await system.go()
    continuation.finish()

    let events = await stream.collect()
    #expect(events == ["a", "b"])
}
```

## Handy AsyncSequence extensions

```swift
extension AsyncSequence {
    func collect() async rethrows -> [Element] {
        try await reduce(into: [Element]()) { result, element in
            result.append(element)
        }
    }
}
```

```swift
extension AsyncSequence where Element: Equatable {
    func collect(until match: Element) async rethrows -> [Element] {
        var result: [Element] = []
        for try await element in self {
            result.append(element)
            if element == match { break }
        }
        return result
    }
}
```

## Phased validation

```swift
@Test
func testSystemInPhases() async {
    let (stream, continuation) = AsyncStream<String>.makeStream()

    system.callbackA = { continuation.yield("a") }
    system.callbackB = { continuation.yield("b") }
    system.callbackC = { continuation.yield("c") }

    await system.startPhase1()
    continuation.yield("phase1.done")

    let phase1 = await stream.collect(until: "phase1.done")
    #expect(phase1 == ["a", "b", "phase1.done"])

    await system.startPhase2()
    continuation.yield("phase2.done")

    let phase2 = await stream.collect(until: "phase2.done")
    #expect(phase2 == ["c", "phase2.done"])

    continuation.finish()
}
```

## What you gain

## Practical takeaways

## Mini checklist

---## Interview Q&A (Knowledge cards)

Interview Q&A below.

<!-- knowledge-cards-canonical:start -->

### Q60
- **Question:** Why write tests if you can run the app manually?

- **Answer:** Manual checks don't scale or catch regressions on every change. Tests provide regression safety and act as executable specification.

- **Notes:** [Testing-Fundamentals-RU](notes/Testing-Fundamentals.md)
### Q61
- **Question:** Testing pyramid—levels and why not all UI tests?

- **Answer:** Many fast isolated unit tests, fewer integration, minimal UI for critical paths. All UI is slow, brittle, and hard to debug.

- **Notes:** [Testing-Fundamentals-RU](notes/Testing-Fundamentals.md)
### Q62
- **Question:** What does FIRST stand for in testing?

- **Answer:** Fast, Isolated, Repeatable, Self-validating, Timely—write tests with the code, no shared state, no flaky CI.

- **Notes:** [Testing-Fundamentals-RU](notes/Testing-Fundamentals.md)
### Q63
- **Question:** Stub vs Mock—and other test doubles?

- **Answer:** Stub supplies canned data; Mock verifies interactions. Dummy fills a parameter; Spy records calls; Fake is a simplified working implementation.

- **Notes:** [Testing-Fundamentals-RU](notes/Testing-Fundamentals.md)
### Q64
- **Question:** Swift Testing vs XCTest—when to use which?

- **Answer:** Swift Testing for new async unit tests; XCTest for UI and legacy; both can live in one target.

- **Notes:** [Swift-Testing-vs-XCTest-RU](notes/Swift-Testing-vs-XCTest.md)
### Q65
- **Question:** How do you stabilize UI tests?

- **Answer:** Stable identifiers, test launch args, isolated data, explicit waits, few critical flows in a dedicated plan.

- **Notes:** [XCUITest-Essentials-RU](notes/XCUITest-Essentials.md)
### Q66
- **Question:** How do you unit-test networking without HTTP?

- **Answer:** Inject a fake client or stub URLProtocol on a dedicated session—never poison URLSession.shared.

- **Notes:** [Testing-Network-Stub-RU](notes/Testing-Network-Stub.md)
### Q67
- **Question:** When are snapshot tests appropriate?

- **Answer:** Stable components with pinned simulator/OS—not whole screens during active redesign.

- **Notes:** [Snapshot-Testing-Discipline-RU](notes/Snapshot-Testing-Discipline.md)
### Q68
- **Question:** Test Plans in CI—PR vs Nightly?

- **Answer:** Fast subset on every PR; slow UI/snapshots nightly; quarantine flaky tests explicitly.

- **Notes:** [Test-Plans-CI-RU](notes/Test-Plans-CI.md)
### Q69
- **Question:** TDD vs test-after?

- **Answer:** TDD when designing behavior; test-after under deadline with risk-based prioritization.

- **Notes:** [TDD-Basics-RU](notes/TDD-Basics.md)
### Q70
- **Question:** Contract tests and OpenAPI—why and how on iOS?

- **Answer:** Fixture-based decode/mapping tests against spec examples; OpenAPI codegen for large APIs; keep domain rules in unit tests.

- **Notes:** [Contract-Tests-OpenAPI-RU](notes/Contract-Tests-OpenAPI.md)
### Q52
- **Question:** How do you validate LLM-generated Swift code?

- **Answer:** Deterministic unit/integration tests plus human review; project constraints encode TDD rules. Engineer owns triangulation and test lifecycle. Product LLM features need eval suites separately.

- **Notes:** [AI-assisted TDD](notes/ai-assisted-tdd.md)
### Q37
- **Question:** Which tests first under a deadline?

- **Answer:** Under time pressure: business-critical flows and domain rules first, API contract second, regression tests for fixed bugs third—defer vanity coverage and flaky snapshots.

- **Playground:** [open](testing.playground/Contents.swift) — `user_ok.json`, `user_401.json` → `ProfileError`

- **Notes:** [Testing-Fundamentals-RU](notes/Testing-Fundamentals.md) · [TDD-Basics-RU](notes/TDD-Basics.md) · [Test-Plans-CI-RU](notes/Test-Plans-CI.md)
### Q46
- **Question:** Testing baseline—cover what first?

- **Answer:** Fast feedback: unit-test domain/rules with mocks; fewer integration tests for real wiring (decoder + fixtures, URLProtocol stubs)—use AAA.

- **Playground:** [open](testing.playground/Contents.swift) — `user_ok.json`, `user_401.json` → `ProfileError`

- **Notes:** [Testing-Fundamentals-RU](notes/Testing-Fundamentals.md) · [Testing-Network-Stub-RU](notes/Testing-Network-Stub.md)

---

<!-- knowledge-cards-canonical:end -->
