# Metaprogramming

## Materials

- Apple Docs: [Mirror](https://developer.apple.com/documentation/swift/mirror), [`dynamicMemberLookup`](https://developer.apple.com/documentation/swift/dynamicmemberlookup), [Macros](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/)

## Topic structure

---## In 30 seconds

## 🎯 Focus vs Defer

### Defer

## 📚 What to learn by level

### JUNIOR

### MIDDLE

### SENIOR

### TECH LEAD

## 🌟 Strategic (Senior+)

## 🏋️ Exercises (8) — required practice

---

## Notes: Reflection with Mirror

### What reflection is

### API Mirror

### Limits (important for interviews)

### Practice: generic prettyPrint

### What Mirror does not show

---## Notes: @dynamicMemberLookup

### Mechanism

```swift
@dynamicMemberLookup
struct DynamicJSON {
    subscript(dynamicMember member: String) -> DynamicJSON { ... }
}
```

```text
root["user"]["name"]  // conceptually: chained subscript(dynamicMember:)
```

### Typed leaf accessors

```swift
var string: String? { ... }
var int: Int? { ... }
var bool: Bool? { ... }
```

### Pros and cons

### Anti-patterns

### Related mechanisms

---## Runtime vs compile-time

---## TL;DR — Mirror

## TL;DR — @dynamicMemberLookup

---## Interview Q&A (Knowledge cards)

### Q1: What is metaprogramming in Swift?

### Q2: What does `Mirror(reflecting:)` return and why `children`?

### Q3: How is `Mirror` different from Objective-C runtime?

### Q4: Why can a computed property be missing from `children`?

### Q5: How does `@dynamicMemberLookup` work?

### Q6: Mirror vs `Codable` for JSON?

### Q7: When is `Mirror` appropriate in production?

### Q8: Risk of `JSONObject` silent null on missing key?

### Q9: Remote config — dynamic or struct?

### Q10: Runtime vs Swift macros — one line?

---

## Code & examples

Playground: [MetaprogrammingLab.playground](MetaprogrammingLab.playground/Contents.swift)

```swift
struct Profile {
    let name: String
    let age: Int
}

let mirror = Mirror(reflecting: Profile(name: "Alex", age: 30))
for child in mirror.children {
    print(child.label ?? "?", child.value)
}
```

Dynamic JSON:

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

## Links

- [Swift Metaprogramming (Kodeco / Swift Internals)](https://www.kodeco.com/52631262-swift-metaprogramming-writing-code-that-inspects-itself)
- [Mirror](https://developer.apple.com/documentation/swift/mirror)
- [dynamicMemberLookup](https://developer.apple.com/documentation/swift/dynamicmemberlookup)
- [Macros — The Swift Programming Language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/)

---

## Interview Q&A (Knowledge cards)

### Q1
- **Question:** What is `Mirror` for?
- **Answer:** Read-only runtime reflection: walk `children`, `displayStyle`, `subjectType`—for debug/introspection, not hot-path serialization (prefer `Codable`).
