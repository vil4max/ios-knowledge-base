# FormatStyle & Parsing

## In 30 seconds

## Apple docs

- [FormatStyle](https://developer.apple.com/documentation/foundation/formatstyle)
- [ParseableFormatStyle](https://developer.apple.com/documentation/foundation/parseableformatstyle)
- [Data formatting](https://developer.apple.com/documentation/foundation/data_formatting)
- [Text init(value:format:)](https://developer.apple.com/documentation/swiftui/text/init(_:format:))

## 🎯 Focus vs Defer

**Focus**

## Key concepts

|-----|------|-------|------------------------|

### Three entry points

```swift
let amount = 42.5

amount.formatted()
amount.formatted(.currency(code: "USD"))
Decimal.FormatStyle.Currency(code: "EUR").format(amount)
```

### SwiftUI: do not do this in `body`

```swift
// ❌ String outside environment; date may not update when timeZone changes
Text(date.formatted(.dateTime))

// ✅ SwiftUI picks up locale / calendar / timeZone
Text(date, format: .dateTime.month().day().hour().minute())
TextField("Amount", value: $amount, format: .currency(code: "USD"))
```

## 🏋️ Exercises

## Resources

### Swift Talk — The FormatStyle API
- **Type:** video
- **URL:** https://talk.objc.io/episodes/S01E488-the-formatstyle-api

- **Tags:** `swiftui`, `interview`
- **Added:** 2026-06-19## Links

- [Swift Talk S01E488](https://talk.objc.io/episodes/S01E488-the-formatstyle-api)

## Interview Q&A (Knowledge cards)

### Q1
- **Question:** FormatStyle vs Formatter?
- **Answer:** `FormatStyle` is value-type, composable, cheap to create—Apple's recommendation for new Swift. `Formatter` is legacy NSObject for Obj-C interop or untouchable legacy.

### Q2
- **Question:** Why not `.formatted()` everywhere in SwiftUI?
- **Answer:** `.formatted()` yields a one-shot `String`; environment (locale, timeZone) changes are not tracked. `Text(value, format:)` stays typed and environment-aware.

### Q3
- **Question:** Percent style: is 1 equal to 1% or 100%?
- **Answer:** For `Double`/`Float`/`Decimal`, the value is a fraction (0.01 = 1%). For `Int`, 1 formats as 1%.
