# Network unit tests without HTTP

**Purpose:** gateway from Testing topic to networking — fake client vs `URLProtocol`. Full Q card: [Networking Q (H30)](../../../data-and-network/networking/README.md).

**Topic README:** [Testing](../README.md)

---

## TL;DR

## Choosing an approach

## Fake client (preferred)

## URLProtocol stub (brief)

## JSON fixtures

Integration-friendly pattern for mapper + decoder:

```swift
func loadFixture<T: Decodable>(_ name: String, as type: T.Type) throws -> T {
    let url = Bundle(for: BundleToken.self).url(forResource: name, withExtension: "json")!
    let data = try Data(contentsOf: url)
    return try JSONDecoder().decode(T.self, from: data)
}

private final class BundleToken {}
```

`user_ok.json` in the test bundle — unit/integration without network.

---

## What to check in unit tests

## Interview Q&A

## Next

- [Contract-Tests-OpenAPI](Contract-Tests-OpenAPI.md) — fixtures from spec, OpenAPI codegen
- [Networking README — Q H30](../../../data-and-network/networking/README.md)
- [URLSession lifecycle note](../../../data-and-network/networking/notes/URLSession-Lifecycle-iOS-IQ.md)
- [URLProtocol](https://developer.apple.com/documentation/foundation/urlprotocol)
- **Playground:** [URLProtocol demo](../testing.playground/Contents.swift)

---

**Version:** 1.0
