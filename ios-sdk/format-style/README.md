# FormatStyle & Parsing

## За 30 секунд

`FormatStyle` — современный Swift-способ форматировать Foundation-типы в локализованные строки (и обратно через `ParseableFormatStyle`). Заменяет тяжёлые `NumberFormatter` / `DateFormatter` для нового кода. В SwiftUI предпочитай `Text(value, format:)` и `TextField(value:format:)` вместо `.formatted()` в `body`.

**Минимум:** iOS 15+ (часть API — iOS 16+, live/attributed — iOS 18+).

## Apple docs

- [FormatStyle](https://developer.apple.com/documentation/foundation/formatstyle)
- [ParseableFormatStyle](https://developer.apple.com/documentation/foundation/parseableformatstyle)
- [Data formatting](https://developer.apple.com/documentation/foundation/data_formatting)
- [Text init(value:format:)](https://developer.apple.com/documentation/swiftui/text/init(_:format:))

## 🎯 Focus vs Defer

**Focus**

- `.formatted()` vs `.formatted(_:)` vs `style.format(_)`
- Числа: `.number`, `.percent`, `.currency(code:)`, rounding, notation, sign
- Даты: `.dateTime`, ISO8601, relative, verbatim
- `ParseableFormatStyle` + `TextField` / `Stepper`
- SwiftUI: typed value + `format:` → locale/calendar из environment
- Ловушка: `Double(1.0)` → «100%», `Int(1)` → «1%»

**Defer**

- Кастомные `FormatStyle` для своих типов
- Миграция legacy `NSFormatter` в больших кодовых базах
- Objective-C interop (там остаются старые Formatter)

## Ключевые понятия

| API | Вход | Выход | Типичное использование |
|-----|------|-------|------------------------|
| `.formatted()` | Value | `String` | Быстрый дефолт по locale |
| `.formatted(_:)` | Value + style | `String` | Кастомный вывод вне SwiftUI |
| `style.format(_)` | Style + value | `String` | Переиспользуемый style |
| `Text(v, format:)` | Value + style | View | Display в SwiftUI |
| `TextField(..., format:)` | Binding + parseable style | View | Ввод с парсингом |
| `ParseableFormatStyle` | `String` | Value | Двустороннее форматирование |

### Три entry points

```swift
let amount = 42.5

amount.formatted()
amount.formatted(.currency(code: "USD"))
Decimal.FormatStyle.Currency(code: "EUR").format(amount)
```

### SwiftUI: не делай так в `body`

```swift
// ❌ String вне environment; дата может не обновиться при смене timeZone
Text(date.formatted(.dateTime))

// ✅ SwiftUI подхватывает locale / calendar / timeZone
Text(date, format: .dateTime.month().day().hour().minute())
TextField("Amount", value: $amount, format: .currency(code: "USD"))
```

## 🏋️ Exercises

1. **Currency row** — `LabeledContent` с EUR, accounting sign для отрицательных.
2. **Percent stepper** — `Stepper` + `.percent`; проверь `0.01` vs `1`.
3. **Relative date** — `Text(date, format: .relative(presentation: .named))`; смени locale в Preview.
4. **Parse back** — `TextField` с `.dateTime.year().month().day()`; введи дату руками.

## Ресурсы

### formatstyle.guide
- **Type:** interactive reference (Swift WASM)
- **URL:** https://formatstyle.guide
- **Author:** Chris Eidhof (objc.io)
- **Why:** Живые примеры чисел, дат, измерений; раздел SwiftUI
- **When:** Выбор модификаторов; сравнение locale
- **Tags:** `foundation`, `swiftui`, `localization`
- **Added:** 2026-06-19

### Gosh Darn Format Style
- **Type:** static reference
- **URL:** https://goshdarnformatstyle.com
- **Why:** Полный справочник: decision tree, parsing, custom styles, min OS
- **When:** «У меня X, хочу Y» — когда интерактивки мало
- **Tags:** `foundation`, `parsing`, `reference`
- **Added:** 2026-06-19

### FormatStyle Guide — launch post
- **Type:** article
- **URL:** https://chris.eidhof.nl/post/format-style-guide/
- **Why:** Контекст проекта, WASM, beta-ограничения
- **Tags:** `meta`, `wasm`
- **Added:** 2026-06-19

### Swift Talk — The FormatStyle API
- **Type:** video
- **URL:** https://talk.objc.io/episodes/S01E488-the-formatstyle-api
- **Why:** Environment в SwiftUI, `Stepper` + parseable, практика от авторов гайда
- **Tags:** `swiftui`, `interview`
- **Added:** 2026-06-19

## Ссылки

- [formatstyle.guide](https://formatstyle.guide) — интерактив
- [goshdarnformatstyle.com](https://goshdarnformatstyle.com) — справочник
- [Swift Talk S01E488](https://talk.objc.io/episodes/S01E488-the-formatstyle-api)
- См. также: [Foundation & Lifecycle](/ios-sdk/foundation/)

## Карточки знаний (Q&A)

### Q1. FormatStyle vs Formatter?

**RU:** `FormatStyle` — value-type, композируемый, дешевле создавать; Apple рекомендует для нового Swift. `Formatter` — legacy, Obj-C, оставляй для сложного legacy или Obj-C.

**EN:** Prefer `FormatStyle` in new Swift; keep `Formatter` for Obj-C or untouchable legacy formatters.

**Доп. информация:** [goshdarnformatstyle.com — FAQ](https://goshdarnformatstyle.com/)

### Q2. Почему в SwiftUI не `.formatted()`?

**RU:** `.formatted()` даёт `String` один раз; environment (locale, timeZone) не отслеживается. `Text(value, format:)` остаётся typed и реагирует на environment.

**EN:** Use `format:` overloads in SwiftUI for environment-aware, typed formatting.

**Доп. информация:** [formatstyle.guide/swiftui](https://formatstyle.guide/swiftui)

### Q3. Percent: 1 или 100%?

**RU:** Для `Double`/`Float`/`Decimal` значение **доля** (0.01 = 1%). Для `Int` — уже «проценты» (1 = 1%). Частая ошибка в UI.

**EN:** Floating-point percent styles treat 1.0 as 100%; integer 1 formats as 1%.
