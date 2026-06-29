# Syntax & Idioms

## Swift: basic syntax and idioms — overview

**Focus**

## Materials

## Topic structure (actual)

---## 🎯 Focus vs Defer

### Focus

  Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/thebasics/`

  Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/closures/`

  Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics/`

  Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/accesscontrol/`

  Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/properties/`

### Defer

## Exercises (10)

1) Optional pyramid -> guard

3) Trailing closure

5) Result builder

9) Result type

## Q-card tie-in — defer, type methods, class init

### `defer`

### `static` vs `class` methods (type methods)

### Why `class` has no memberwise `init` like `struct`

### Optionals (junior track tie-in)

### Playgrounds by Q-card number

|------|------------|
| CoW / value collections | `CopyOnWriteInterview.playground` |
| `defer` | `DeferInterview.playground` |
| `static` vs `class` | `StaticVsClassMethodsInterview.playground` |
| memberwise / class init | `ClassMemberwiseInitInterview.playground` |
| optionals baseline | `OptionalsJuniorInterview.playground` |
| `map` / `flatMap` / `compactMap` / `reduce` | `MapFlatMapCompactMapInterview.playground` |

---## TL;DR

## Source

- [SE-0508: Array expression trailing closures](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0508-array-expression-trailing-closures.md)

## What was awkward before SE-0508

```swift
let values = [Int] {
    (0..<10).map { $0 * 2 }
}
```

## What changes

## Example with Array initializer

```swift
extension Array {
    init(_ build: () -> [Element]) {
        self = build()
    }
}

let values = [Int] {
    (0..<10).map { $0 * 2 }
}
```

## Where especially useful

```swift
// Before
let sections = SectionsBuilder.build {
    if user.isPremium { premiumSection() }
    commonSection()
}

// After
let sections = [Section] {
    if user.isPremium { premiumSection() }
    commonSection()
}
```## What to understand

## Practical takeaways

## Mini checklist

---## Interview Q&A (Knowledge cards)

Interview Q&A below.

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question:** When do you choose `struct` vs `class`?

- **Answer:** `struct` — value semantics and independent copies; `class` — reference semantics when you need stable identity, inheritance, or shared mutable state.

    - **Value semantics** (`struct`): assignment/passing yields logically independent copies; mutation affects only that value (`Array`, `Dictionary`, `Set`, `String` often defer the buffer copy until the first mutation — Copy-on-Write).

    - **Reference semantics** (`class`): aliases refer to one instance, so mutations are visible through every reference; also use `class` for stable identity, inheritance, or shared mutable state.

    1. I use `struct` for value semantics and independent copies.
    2. Assignment and passing give logically separate copies; mutation affects that value only.
    3. `Array`, `Dictionary`, `Set`, `String` often use copy-on-write until the first mutation.
    4. I use `class` for reference semantics: many references, one instance.
    5. Mutations are visible through every reference.
    6. Also for stable identity, shared mutable state, or inheritance when I need those.

### Q2
- **Question:** What is Copy-on-Write (CoW)?

- **Answer:** Standard collections share storage until the first write; they copy the buffer only when you mutate and the storage is still shared.

    1. `Array`, `Dictionary`, `Set`, `String` can share storage across copies until someone mutates.
    2. The first mutation copies the buffer only if storage is still shared.
    3. That avoids eager copies when you only read.

### Q6
- **Question:** `static` vs `class` methods?

- **Answer:** **`static`** methods **cannot be overridden**. **`class`** methods **can be overridden in subclasses** (use `class` when you want polymorphic dispatch through inheritance).

    1. `static` — no overrides in subclasses.
    2. `class` — subclasses can override.

### Q9
- **Question:** A practical `defer` use case?

- **Answer:** `defer` runs code when the current scope exits (including `return` / `throws`); multiple `defer`s run in reverse declaration order (LIFO).

    One place for cleanup (freeing resources / restoring safe state) and teardown (symmetric unwind after setup): acquire `lock` then `defer { unlock }`, open then `defer { close }`, rollback or restore temporary flags.

    1. `defer` at scope exit, returns and errors included.
    2. cleanup / teardown: paired operations like locks and handles.
    3. Many early exits — write teardown once.

### Q10
- **Question:** Why no memberwise initializer for classes like structs?

- **Answer:** Classes don’t get a **synthesized** memberwise initializer like many structs: **inheritance** and **two-phase initialization** call for explicit **designated** initializers and a **`super.init`** chain—auto-generating a field-by-field initializer would be ambiguous or violate Swift’s rules; **access control** over `init` matters too.

    It’s not that explicit class initializers are “unsafe”—it’s that the compiler **won’t synthesize** a memberwise initializer from stored properties the way it commonly does for `struct`s.

    1. Inheritance plus **two-phase initialization** means **designated** inits and **`super.init`**, not a synthesized field bundle like many structs.
    2. **`convenience`** / **`required`** and **`init`** visibility are part of the same model—you can’t glue one memberwise across the hierarchy.
    3. So you write explicit `init`s and often factories at the composition root.

---
### Q41
- **Question:** Explain optionals at a junior level?

- **Answer:** Optionals model absence at the type level; unwrap safely (`if/guard let`, `?.`, `??`)—reserve `!` for provably non-nil cases.

### Q42
- **Question:** How is `Optional<Wrapped>` implemented in Swift?

- **Answer:** `Optional` is a **generic `enum`** with two cases: **`.none`** and **`.some(Wrapped)`**. `T?` is sugar for `Optional<T>`; **`nil`** is **`.none`**. For class existentials, `Optional` often uses a **nullable pointer** representation; small value types may need an extra tag when no spare bit pattern exists.

### Q43
- **Question:** Is there a difference between `.none` and `nil`?

- **Answer:** **No semantic difference:** `nil` is sugar for **`.none`** in `Optional` contexts. For class optionals, `.none` is often a null reference; for small value optionals, think “no wrapped value” / tagged empty state—not “no heap object.”

### Q44
- **Question:** Ways to unwrap optional variables?

- **Answer:** Core: **`if let` / `guard let`**, **`??`** (*nil-coalescing*; short-circuit), **`!`** when non-nil is provable. Also: **`?.`**, **`switch`/`if case`**, **`map`/`flatMap`**.

### Q45
- **Question:** What’s the difference between reference and value types? Examples?

- **Answer:** Lead with **semantics**: **reference** types share **identity**—aliases mutate one instance; use **`===`**. **Value** types copy independently; compare with **`==`**. Heap/stack and static/dynamic dispatch are **implementation details**, not definitions (`Array`/`String` are heap-backed COW structs).

### Q46
- **Question:** What’s the difference between `class` and `structure`?

- **Answer:** `class` — **reference** semantics, **ARC**, inheritance, `deinit`. `struct` — **value** semantics, `mutating`, no inheritance/`deinit`. Standard collections are **structs** but may **store references**—copying the collection copies the container value, not necessarily duplicating class instances inside.

### Q47
- **Question:** Memory layout: `struct` holding a class reference; `class` storing a `struct`; `let` struct property—vs stack/heap?

- **Answer:** A `struct` holding a class reference stores a **pointer inline** in the struct’s value; the class instance lives on the **heap**. Copying the struct copies the **pointer** (aliases). A `struct` stored inside a `class` is **embedded in that class instance’s heap allocation**. `let` affects **reassignment**, not “struct lives on stack.”

### Q48
- **Question:** How do stack/heap relate to method dispatch? What are vtable, witness table, static dispatch?

- **Answer:** Stack/heap describe **where** values live; **dispatch** chooses **which function runs**. **Static** = direct call. **Classes** = **vtable** in metadata. **Protocols** = **witness tables** (+ value witnesses for existentials). **Obj-C interop** = `objc_msgSend` / runtime.

### Q49
- **Question:** Under the hood: `var b = a` for structs then mutate `b`; passing `struct` by value vs `inout`?

- **Answer:** `b = a` copies value semantics-wise. Plain structs: field-wise copy; CoW containers may share a buffer until `b` mutates, then copy-on-write if still shared. `struct` with a class field copies the **pointer** (shallow). `f(_ x:)` passes a copy; `inout` mutates the caller’s storage in place.

### Q50
- **Question:** What does the `NS` prefix mean in Foundation types?

- **Answer:** `NS` stands for **NeXTSTEP**: NeXT engineers prefixed symbols in NeXTSTEP’s **Foundation** / **AppKit**. After Apple acquired NeXT (1996–1997), that API became the core of Cocoa/Cocoa Touch. Objective-C has a **global class namespace**, so prefixes avoid collisions; Apple **reserves two-letter prefixes** for its frameworks (`NS`, `UI`, `CA`, …). In Swift, `NS*` types are Objective-C classes with **bridging** to Swift value types where defined; Swift stdlib types don’t carry the prefix.

### Q51
- **Question:** `map` / `flatMap` / `compactMap` / `reduce` in Swift and Combine—distinctions and related sequence operators?

| --- | --- |

| --- | --- |

- **Answer:** `map` transforms each element. `compactMap` maps to `Optional` and drops `nil`s (replaces the old optional `flatMap` overload—SE-0187). `flatMap` on `Sequence` flattens one level of nested sequences—don’t confuse with `compactMap`. `reduce` folds a collection into one value; `reduce(into:)` is often better for in-place accumulation. Combine reuses the same vocabulary on `Publisher`s with streaming semantics (`flatMap` controls inner publishers, `scan` accumulates over time).

### Q52
- **Question:** Why mark a Swift class `final`?

- **Answer:** `final class` forbids subclassing entirely—design signal and enables more static devirtualization when the dynamic type can’t be a subclass. Don’t conflate with `static` on class methods (non-overridable, statically dispatched on the metatype). `open` controls subclassing across modules; `final` is stronger than “no open subclasses”—it means no subclasses at all.

### Q53
- **Question:** What is `lazy` in Swift?

- **Answer:** `lazy var` defers initialization of a stored property until the first read; typically a once-run closure. Not `lazy let`. Requires fully initialized `self` before first access. Not thread-safe by default. Don’t confuse with `lazy` on sequences/collections.

### Q54
- **Question:** How does `Codable` differ from `Encodable & Decodable`?

- **Answer:** `Codable` is a typealias for `Encodable & Decodable`—syntactic sugar when both directions are required.

### Q55
- **Question:** Why split `Encodable` and `Decodable`?

- **Answer:** Split protocols narrow requirements—encode-only vs decode-only models without implementing both.

### Q56
- **Question:** `@escaping` vs non-escaping closures?

- **Answer:** Non-escaping closures can’t outlive the function call; `@escaping` allows storing/async completion—think capture lists and cycles.

### Q57
- **Question:** What does `inout` on a parameter mean?

- **Answer:** `inout` passes an addressable slot so the callee can mutate the caller’s variable; copy-in/copy-out for values; classes mutate fields through the reference.

### Q58
- **Question:** Multiple class inheritance in Swift?

- **Answer:** Swift classes have single concrete superclass; compose behavior via protocols and extensions.

### Q59
- **Question:** Tuples in Swift—when should you use them?

- **Answer:** A tuple groups unnamed values with value semantics—good for ad-hoc multi-return (`minMax`) and local tuples. Prefer `struct` for domain models, public APIs, and types with behavior.

<!-- knowledge-cards-canonical:end -->
