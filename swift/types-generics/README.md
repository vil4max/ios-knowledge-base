# Types & Generics

## Types, protocols, generics, opaque and existentials — overview

**Focus**

## Topic structure

- `notes/` — Q&A + links to Apple docs
- `exercises/` — exercises with expected outcome

---

## 🎯 Focus vs Defer

### Focus

  Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols/`

### Defer

## 📊 some vs any (intuition)

Protocol `P`:

## 🏋️ Exercises (8)

2) `some` vs `any`

4) Phantom types

5) Generic constraints

6) Sequence/Collection

7) Result builder

8) Conditional conformance

## 🌟 Strategic (Senior+)

---## Q-card tie-in — `any` vs generics, `associatedtype`, dispatch

### Compare `T: P` vs `any P`, not protocol vs generic

### `some P` (opaque) vs `any P` (existential) — brief

### Dispatch and `any` vs generic (Middle/Senior)

### Oral anchors (card format)

---## Interview Q&A (Knowledge cards)

Interview Q&A below.

<!-- knowledge-cards-canonical:start -->

### Q7
- **Question:** `any Protocol` vs generics?

- **Answer:** Generics are usually faster and more type-precise; `any` is flexible but can mean existential boxing and extra dispatch cost.

    1. Compare **`T: P`** vs **`any P`**, not protocols vs generics in the abstract.
    2. Generics fix a concrete type per use site — usually faster and sharper typing.
    3. `any P` erases to “some conforming type” — flexible; can mean boxing and dynamic dispatch.

### Q8
- **Question:** Why do protocols use **`associatedtype`** (**associated type** — type placeholder declared in the protocol; each conforming type supplies the concrete `typealias` / inference)?

- **Answer:** An associated type is a protocol-level placeholder; each conforming type supplies its concrete associated types — the protocol describes a **family** without hard-coding one concrete type.

    It lets a protocol describe that family without fixing one concrete type upfront (e.g. collection element/key types).

    1. **`associatedtype`** is a placeholder type inside the protocol; each conforming type fixes it.
    2. Models relationships like collection element types without hard-coding one concrete type.
    3. The protocol names a **family** of conforming types, not one concrete storage layout.

### Q9
- **Question:** Why does this `some Equatable` function fail to compile, and how does switching to `any` fix it?

- **Answer:** `some P` opaque return must resolve to **one** concrete type known to the compiler across all return paths. `Int` and `String` both conform to `Equatable` but are different types, so the function can’t pick one hidden concrete type → compile error. `any Equatable` is an existential box that can hold any conforming type at runtime, so it accepts both branches at the cost of boxing and dynamic dispatch.

    1. `some P` — one fixed hidden concrete type per function.
    2. `any P` — existential box, different branches may return different concretes.
    3. Mnemonic: `some` is hide; `any` is erase.

### Q10

    ```swift
    func makeView() -> some View {
        VStack { Text("Hello") }   // actual conforming type: VStack<Text>
    }
    ```

- **Answer:** They’re orthogonal. A **conforming type** is any concrete type that implements a protocol (`Int : Equatable`, `VStack<Text> : View`). An **opaque type** (`some P`) is a syntax that returns one concrete conforming type while hiding which one from callers — the compiler still knows it. The real opposite of opaque is the **existential** (`any P`), which also hides the concrete type but allows different runtime types behind one variable.

    1. Conforming type — a real type that implements the protocol.

<!-- knowledge-cards-canonical:end -->
