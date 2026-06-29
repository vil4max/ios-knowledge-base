# Memory & ARC

## Materials

- Playgrounds: [ARCAdvanced.playground](ARCAdvanced.playground) (retain cycles, `Task`, Combine) · [ARCCompileTimeVsRuntime.playground](ARCCompileTimeVsRuntime.playground) · [HHMemoryLayout.playground](HHMemoryLayout.playground)

## Topic structure

- `notes/` — Q&A + links to Apple docs
- `exercises/` — exercises with expected outcome
- `playgrounds/` — runnable examples

---

## Senior notes: autorelease pool and ARC (topic **II·07**)

## Extra notes: Avito pt.1 (theory)

### Memory regions

### Value vs Reference

### Copy-on-Write

### Existential container

### Reference types (cost / safety)

### Side table

### Object lifecycle

### Class vs struct (Apple criteria)

### Non-frozen types

### Alignment

### Tools

### ~60s interview: side table + lifecycle

## Extra notes: Avito pt.2 (practice)

## 🎯 Focus vs Defer

### Focus

### Defer

## 📚 What to learn by level

### JUNIOR

### MIDDLE

### SENIOR

## 🌟 Strategic (Senior+) — team practices

## 📚 Key terms (question → answer)

    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/`

## 🏋️ Exercises (12) — expected outcomes

    Docs: `https://developer.apple.com/documentation/foundation/timer`

2) `weak` vs `unowned`

    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/`

3) NotificationCenter (iOS 9+)

    Docs: `https://developer.apple.com/documentation/foundation/notificationcenter`

4) `autoreleasepool` + 1000 `UIImage(contentsOfFile:)`

    Docs: `https://developer.apple.com/documentation/swift/autoreleasepool(_:_:)/`

    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/`

7) Combine cycle

    Docs: `https://developer.apple.com/documentation/combine`

8) UIView retain cycle (parent/child)

    Docs: `https://developer.apple.com/documentation/uikit/uiview`

9) Memory Graph CLI

    Docs: `https://developer.apple.com/documentation/xcode/instruments`

10) MemoryLayout (Bool/UInt8/Pair)

    Docs: `https://developer.apple.com/documentation/swift/memorylayout`

    Docs: `https://developer.apple.com/documentation/swift/isknownuniquelyreferenced(_:)`

    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/`

---

## TL;DR

## 1) CPU registers

## 2) Cache memory (L1 / L2 / L3)

## 3) RAM

## 4) Persistent storage (SSD / HDD)

## 5) Virtual memory

## Why this matters to iOS developers

## Practical example (iOS)

## Practical rules

## Terms often asked in interviews

---## Interview Q&A (Knowledge cards)

Interview Q&A below.

<!-- knowledge-cards-canonical:start -->

### Q3
- **Question:** Does ARC work at compile time or at runtime?

- **Answer:** Both stages. At **compile time** the compiler inserts and may optimize **retain/release** where lifetimes and scope dictate. At **runtime** those updates change the strong refcount; at zero the object is deallocated.

    2. At compile time the compiler inserts retain/release where lifetimes and scope dictate — assignments, entering/leaving scope, call arguments.
    3. At runtime those updates change the strong reference count; at zero the object is deallocated.

### Q4
- **Question:** What is the difference between `weak` and `unowned` references?

- **Answer:** `weak` is optional and becomes `nil` after deallocation; it does not keep the referenced object alive like a strong reference. `unowned` is non-optional and assumes the referenced instance **outlives** this reference (lifetime guarantee); breaking that assumption is a dangling reference / crash risk.

    1. `weak` is optional and becomes `nil`; it doesn't extend the object's lifetime.
    2. `unowned` is non-optional and needs a guarantee the referenced object outlives this reference.

### Q5
- **Question:** How do you catch retain cycles in closures?

- **Answer:** Classic pattern is **self → closure → self** (the object holds the closure; the closure strongly captures `self`). Break it with a **capture list** — often `[weak self]` or `[unowned self]` plus optional binding — or avoid a strong `self` capture; alternatively redesign ownership.

    1. Pattern: self → closure → self — strong capture.
    2. Fix: capture list (`[weak self]` / `[unowned self]`) or redesign ownership.

### Q42
- **Question:** ARC in brief—roles of `strong`, `weak`, and `unowned`?

- **Answer:** Strong refs keep instances alive; `weak` avoids cycles and zeroes out; `unowned` is non-optional and crashes if the instance dies early.

### Q43
- **Question:** iOS memory management—ARC, retain cycles, and `strong` / `weak` / `unowned`?

- **Answer:** ARC counts strong references to class instances; at zero strong refs, `deinit` runs. A retain cycle is a **cycle of strong references** so refcounts never reach zero. Break cycles with `weak` (optional, zeroes out) or `unowned` (non-optional, needs lifetime guarantees), capture lists, or ownership redesign.

### Q44
- **Question:** What is a retain cycle and how do you fix it?

- **Answer:** A cycle of strong references prevents deallocation; break with `weak`/`unowned`, capture lists, weak delegates, cancel tasks/subscriptions.

### Q45
- **Question:** ARC vs MRC?

- **Answer:** ARC is compiler-managed retain/release; MRC required manual retain/release in Obj-C.

### Q46
- **Question:** Stack vs heap?

- **Answer:** Stack holds per-call frames; heap holds longer-lived reference types and dynamic buffers—ARC manages class lifetime.

### Q47
- **Question:** Objective-C `weak` vs `assign`—what do they do?

- **Answer:** `weak` does not retain; zeroes to `nil` after deallocation—objects only. `assign` stores the address without ownership—safe for primitives, dangling for objects after dealloc. Use `weak` for delegates.

    1. `weak` — no retain, zeroing to `nil` for objects.
    2. `assign` — raw address; primitives only; objects → dangling.
    3. Delegates use `weak`.

<!-- knowledge-cards-canonical:end -->
