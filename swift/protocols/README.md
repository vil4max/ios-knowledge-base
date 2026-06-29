# Protocols

## In 30 seconds

**Protocol** in Swift is a **contract**: it declares what properties and methods a type must provide, without prescribing how. Classes, structs, and enums can **conform** to one or many protocols. **Protocol-oriented programming (POP)** builds architecture on composition and extensions instead of deep class hierarchies — delegates, dependency injection, and test doubles all lean on protocols.

Mastering protocols is non-negotiable for every iOS developer: if you truly understand POP, half of your architecture discussions become easier.

| | |

|---|---|

| **Levels** | Junior, Middle |

| **Must** | Top 10 interview questions — basics before `some`/`any` in [Types & Generics](../types-generics/README.md) |

**Related topics:** [Memory & ARC](../memory-arc/README.md) (delegates & retain cycles), [Types & Generics](../types-generics/README.md) (`some`/`any`, `associatedtype`).

## Topic structure

- Playground: `swift/syntax/SwiftInSixtySeconds.playgroundbook` — chapter *Protocols and extensions*
- Playground: `swift/types-generics/06_protocols_generics.playground`

---

## 🎯 Top 10 — quick map

| # | Question | One-line answer |
|---|----------|-----------------|
| Q1 | What is a protocol? | Blueprint of requirements; types adopt it and supply implementations |
| Q2 | Protocol vs class? | Protocol = *what*; class = *how* + stored state + single inheritance |
| Q3 | Protocol extensions? | Add methods and default implementations to conforming types |
| Q4 | Class-only protocols? | `AnyObject` constraint — reference semantics, `weak` delegates |
| Q5 | Optional requirements? | `@objc optional` (ObjC bridge); in pure Swift — extensions with defaults |
| Q6 | Protocol inheritance? | Protocols compose: `protocol B: A` |
| Q7 | Default implementations? | `extension P { func … }` — conformers inherit unless they override |
| Q8 | Delegates & retain cycles? | Delegate is usually `weak`; strong ↔ strong owner = cycle |
| Q9 | Type casting with protocols? | `is` checks conformance; `as?` / `as!` cast to protocol type |
| Q10 | Real-world iOS use cases? | Delegate/DataSource, DI, testability, decoupling |

---

## Key concepts

### Adoption & properties

- Conformance: `struct Person: Greetable` — implement **all** required members.
- Protocols declare property **requirements** (`{ get }` / `{ get set }`), not stored properties.

### Protocol vs class

| | Protocol | Class |
|---|----------|-------|
| Role | Defines **what** to do | Defines **how** + owns identity |
| Stored properties | No (only requirements) | Yes |
| Inheritance | Multiple protocol conformance | Single superclass |
| Instantiation | Cannot create `Protocol()` | `MyClass()` |

### `is` vs `as`

| Operator | Purpose | Result |
|----------|---------|--------|
| `is P` | Runtime conformance / type check | `Bool` |
| `as? P` | Safe cast to protocol or type | Optional |
| `as! P` | Force cast | Crashes if wrong |

---

## Interview Q&A (Knowledge cards)

### Q1 — What is a Protocol in Swift?
- **Question:** What is a protocol in Swift?

- **Answer:** A protocol is a **blueprint** of required properties and methods. Types conform with `: ProtocolName` and supply implementations. Protocols describe capability without prescribing storage.

```swift
protocol Greetable {
    func greet()
}

struct Person: Greetable {
    func greet() {
        print("Hello")
    }
}
```

- **Key points:** Blueprint of methods; adopted by class/struct/enum to provide implementation.

```swift
protocol UserInfo {
    var name: String { get }
    var age: Int { get set }
}

struct User: UserInfo {
    var name: String = "Alex"
    var age: Int
}
```

---

### Q2 — Protocol vs Class
- **Question:** How is a protocol different from a class?

- **Answer:** Protocols define **what**; classes define **how** with stored state and identity. Protocols allow multiple conformance; classes allow single inheritance.

- **Key points:** Protocol defines a blueprint of methods; classes can have stored properties; protocols support multiple inheritance (conformance); classes support single inheritance. Protocols define *what to do*, classes define *how to do*.

---

### Q3 — Protocol Extensions
- **Question:** What are protocol extensions for?

- **Answer:** Protocol extensions add methods and default implementations to all conformers without a base class — core of POP and shared behavior.

```swift
protocol Drawable {
    func draw()
}

extension Drawable {
    func drawBorder() {
        print("--- border ---")
        draw()
    }
}

struct Square: Drawable {
    func draw() { print("Square") }
}
```

---

### Q4 — Class-only Protocols
- **Question:** What is a class-only protocol?

- **Answer:** A protocol constrained to **`AnyObject`**: only classes can conform. Required for `weak` delegates and reference identity.

```swift
protocol DetailDelegate: AnyObject {
    func detailDidFinish()
}

final class DetailViewController {
    weak var delegate: DetailDelegate?
}
```

---

### Q5 — Optional Protocol Requirements
- **Question:** What are optional protocol requirements?

- **Answer:** Pure Swift has no optional requirements — use protocol extensions with defaults. For Objective-C: `@objc optional` on an `@objc` protocol.

```swift
@objc protocol Car {
    func start()
    func stop()
    @objc optional func honk()
}

class MyCar: NSObject, Car {
    func start() { print("Start") }
    func stop() { print("Stop") }
    func honk() { print("Beep!") }
}
```

---

### Q6 — Protocol Inheritance
- **Question:** What is protocol inheritance?

- **Answer:** One protocol can inherit another (`protocol B: A`). Conforming types must satisfy the full chain.

```swift
protocol A {
    func aMethod()
}

protocol B: A {
    func bMethod()
}

class MyClass: B {
    func aMethod() { print("A") }
    func bMethod() { print("B") }
}
```

- **Key points:** Use `:` to inherit protocols; conforming type must implement all methods.

---

### Q7 — Default Implementations
- **Question:** Can we provide default implementations in a protocol?

- **Answer:** Yes — use a **protocol extension**. Conformers get the default; they can provide a custom implementation.

```swift
protocol Logger {
    func log(message: String)
}

extension Logger {
    func log(message: String) {
        print("LOG: \(message)")
    }
}

struct FileLogger: Logger { }
// inherits default log(message:)
```

---

### Q8 — Delegates & Retain Cycles
- **Question:** How do protocols relate to delegates and retain cycles?

- **Answer:** The owner holds the delegate as `weak` when the delegate also references the owner. Two strong references → retain cycle.

```swift
protocol ListDelegate: AnyObject {
    func didSelect(item: String)
}

final class ListViewController {
    weak var delegate: ListDelegate?
}

final class Coordinator: ListDelegate {
    var viewController: ListViewController?

    func showList() {
        let list = ListViewController()
        list.delegate = self
        viewController = list
    }

    func didSelect(item: String) { }
}
```

- **Deep dive:** [Memory & ARC](../memory-arc/README.md).

---

### Q9 — Type Casting with Protocols
- **Question:** How do you check conformance? What is the difference between `is` and `as`?

- **Answer:** `is` checks conformance; `as?` returns optional; `as!` force casts and may crash.

```swift
protocol Printable {
    func printData()
}

struct Document: Printable {
    func printData() { print("doc") }
}

let value: Any = Document()

if value is Printable {
    print("Conforms to Printable")
}

if let printable = value as? Printable {
    printable.printData()
}

let obj: Any = "Hi"

if obj is String {
    print("It is a String")
}

let str = obj as? String
print(str ?? "Not String")

let str2 = obj as! String
print(str2)
```

- **Key points:** `is` checks conformance; `as?` safe cast; `as!` force cast and may crash.

---

### Q10 — Real-world iOS Use Cases
- **Question:** What is the use of protocols in iOS development?

- **Answer:** Delegates & data sources, decoupling, dependency injection, test doubles, shared behavior. Protocols achieve loose coupling, flexibility, and scalability.

**Typical patterns:**

- `UITableViewDelegate` / `UITableViewDataSource`
- `protocol NetworkClient` for DI and mocks
- SwiftUI `View` + `some View`
- Coordinator / router interfaces

```swift
protocol NetworkClient {
    func fetchData(from url: URL) async throws -> Data
}

struct URLSessionClient: NetworkClient {
    func fetchData(from url: URL) async throws -> Data {
        try await URLSession.shared.data(from: url).0
    }
}
```

---

## 🏋️ Exercises

7. **DI mock** — `protocol Clock`; production vs test conformers.

---

## Links

- [The Swift Programming Language — Protocols](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols/)
- [Protocol-Oriented Programming in Swift (WWDC 2015)](https://developer.apple.com/videos/play/wwdc2015/408/)
- [Optional Protocol Requirements](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols/#Optional-Protocol-Requirements)
- Next level: [Types & Generics — `some` / `any` / `associatedtype`](../types-generics/README.md)
- Retain cycles: [Memory & ARC](../memory-arc/README.md)

---

> Practice. Understand. Design. That's how you master **Protocols** in Swift.
