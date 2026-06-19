# Metaprogramming

Runtime techniques for inspecting and accessing values when types or keys are not fully known at compile time: `Mirror` for reflection and `@dynamicMemberLookup` for dynamic property syntax.

## In 30 seconds

- **Metaprogramming** — code that inspects or transforms other code. This topic covers **runtime** tools only (not macros or result builders).
- **`Mirror`** — read-only reflection: walk `children` to see property labels and values; use `displayStyle` and `subjectType` for formatting.
- **`@dynamicMemberLookup`** — compile `json.user.name` into `subscript(dynamicMember:)` calls; great for JSON and dictionaries, weaker on type safety.
- Swift limits reflection (no runtime method calls or mutation) to protect performance and type safety.
- Do not use `Mirror` on hot paths; prefer `Codable` / `CustomDebugStringConvertible` for production logging and serialization.

## Key concepts

### Reflection with Mirror

`Mirror(reflecting: instance)` exposes:

| Property | Purpose |
|----------|---------|
| `children` | `(label?, value)` tuples for stored properties |
| `subjectType` | Static type of the reflected value |
| `displayStyle` | `.struct`, `.class`, `.enum`, `.tuple`, `.optional`, `.collection`, `.set`, `.dictionary`, … |

Swift reflection is **read-only**. Unlike Objective-C runtime, you cannot invoke methods, mutate properties, or create types dynamically.

Typical uses: debug `prettyPrint`, generic test diff helpers, exploratory logging in DEBUG builds.

### Dynamic member lookup

Annotate a type with `@dynamicMemberLookup` and implement:

```swift
subscript(dynamicMember member: String) -> ReturnType { ... }
```

The compiler rewrites dot syntax into subscript calls. Chainable wrappers (each subscript returns another wrapper) enable `json.user.name` style access over `[String: Any]` or parsed JSON.

Trade-offs:

| Pros | Cons |
|------|------|
| Cleaner than nested `if let` / casts | No autocomplete; typos fail at runtime |
| Readable DSL over dynamic data | Easy to hide force-casts and silent failures |

### Runtime vs compile-time

| Runtime (this topic) | Compile-time (elsewhere) |
|----------------------|---------------------------|
| `Mirror`, `@dynamicMemberLookup` | Macros (`#Predicate`, `@Observable`), `KeyPath`, result builders |
| Inspects live values | Generates or checks code before run |

For boilerplate (`Equatable`, `Codable`, mocks), prefer **macros** or explicit protocols over `Mirror`.

## Interview Q&A

**Q: What can `Mirror` do and what can it not do?**  
A: It can list children (property names and values), report `subjectType` and `displayStyle`. It cannot call methods, write properties, or construct arbitrary types at runtime.

**Q: When would you use `Mirror` in production?**  
A: Rarely on hot paths. Acceptable for DEBUG-only logging, crash reporters, or generic test utilities. For user-visible logging of known types, use `CustomStringConvertible` / `CustomDebugStringConvertible`.

**Q: How does `@dynamicMemberLookup` work?**  
A: The attribute tells the compiler to route unknown member access to `subscript(dynamicMember:)`. You implement that subscript to read from a dictionary, JSON tree, or other dynamic storage.

**Q: `Mirror` vs `Codable` for JSON?**  
A: `Codable` — typed, compile-time checked, fast. `Mirror` — generic introspection, not a serialization API. Dynamic JSON wrappers use subscripts, not `Mirror`.

**Q: Why is Swift reflection limited compared to Objective-C?**  
A: Performance, optimization, and type safety. Full runtime manipulation fights Swift’s static model and ARC/layout guarantees.

## Code and examples

Playground: [MetaprogrammingLab.playground](MetaprogrammingLab.playground)

### Mirror: inspect properties

```swift
struct User {
    let name: String
    let age: Int
}

let mirror = Mirror(reflecting: User(name: "Alex", age: 30))
for child in mirror.children {
    print(child.label ?? "?", child.value)
}
```

### Mirror: recursive prettyPrint

See playground — walks `children`, branches on `displayStyle` for collections vs structs, recurses into nested values.

### @dynamicMemberLookup: JSON-style access

```swift
@dynamicMemberLookup
struct JSONObject {
    private let value: Any

    init(_ value: Any) { self.value = value }

    subscript(dynamicMember member: String) -> JSONObject {
        guard let dict = value as? [String: Any], let next = dict[member] else {
            return JSONObject(NSNull())
        }
        return JSONObject(next)
    }

    var string: String? { value as? String }
    var int: Int? { value as? Int }
}
```

Usage: `let name = json.user.name.string` instead of multiple optional casts.

## Links

- [Swift Metaprogramming: Writing Code that Inspects Itself (Kodeco / Swift Internals excerpt)](https://www.kodeco.com/52631262-swift-metaprogramming-writing-code-that-inspects-itself)
- [Mirror — Swift Documentation](https://developer.apple.com/documentation/swift/mirror)
- [dynamicMemberLookup — Swift Documentation](https://developer.apple.com/documentation/swift/dynamicmemberlookup)
