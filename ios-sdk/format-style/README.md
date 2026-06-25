# FormatStyle & Parsing

## In 30 seconds


<details class="lang-ru">
<summary>По-русски</summary>

`FormatStyle` — современный Swift-способ форматировать Foundation-типы в локализованные строки (и обратно через `ParseableFormatStyle`). Заменяет тяжёлые `NumberFormatter` / `DateFormatter` для нового кода. В SwiftUI предпочитай `Text(value, format:)` и `TextField(value:format:)` вместо `.formatted()` в `body`.

**Минимум:** iOS 15+ (часть API — iOS 16+, live/attributed — iOS 18+).

</details>
<details class="lang-ru">
<summary>По-русски</summary>

`FormatStyle` — Swift-способ форматировать Foundation-типы локализованно: даты, числа, `Measurement`. Предпочтительнее `DateFormatter`/`NumberFormatter` в новом коде.

</details>

## Apple docs


- [FormatStyle](https://developer.apple.com/documentation/foundation/formatstyle)
- [ParseableFormatStyle](https://developer.apple.com/documentation/foundation/parseableformatstyle)
- [Data formatting](https://developer.apple.com/documentation/foundation/data_formatting)
- [Text init(value:format:)](https://developer.apple.com/documentation/swiftui/text/init(_:format:))

## 🎯 Focus vs Defer


**Focus**

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- `.formatted()` vs `.formatted(_:)` vs `style.format(_)`
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- Числа: `.number`, `.percent`, `.currency(code:)`, rounding, notation, sign

</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- Даты: `.dateTime`, ISO8601, relative, verbatim

</details>

</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- `ParseableFormatStyle` + `TextField` / `Stepper`
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- SwiftUI: typed value + `format:` → locale/calendar из environment

</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- Ловушка: `Double(1.0)` → «100%», `Int(1)` → «1%»

**Defer**


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- Кастомные `FormatStyle` для своих типов

</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- Миграция legacy `NSFormatter` в больших кодовых базах

</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- Objective-C interop (там остаются старые Formatter)


</details>


</details>


</details>

## Key concepts


<details class="lang-ru">
<summary>По-русски</summary>

| API | Вход | Выход | Типичное использование |

</details>
|-----|------|-------|------------------------|
<details class="lang-ru">
<summary>По-русски</summary>

| `.formatted()` | Value | `String` | Быстрый дефолт по locale |
| `.formatted(_:)` | Value + style | `String` | Кастомный вывод вне SwiftUI |
| `style.format(_)` | Style + value | `String` | Переиспользуемый style |
| `Text(v, format:)` | Value + style | View | Display в SwiftUI |
| `TextField(..., format:)` | Binding + parseable style | View | Ввод с парсингом |
| `ParseableFormatStyle` | `String` | Value | Двустороннее форматирование |

</details>

### Three entry points

```swift
let amount = 42.5

amount.formatted()
amount.formatted(.currency(code: "USD"))
Decimal.FormatStyle.Currency(code: "EUR").format(amount)
```

### SwiftUI: do not do this in `body`

```swift
// ❌ String вне environment; дата может не обновиться при смене timeZone
Text(date.formatted(.dateTime))

// ✅ SwiftUI подхватывает locale / calendar / timeZone
Text(date, format: .dateTime.month().day().hour().minute())
TextField("Amount", value: $amount, format: .currency(code: "USD"))
```

## 🏋️ Exercises


<details class="lang-ru">
<summary>По-русски</summary>

1. **Currency row** — `LabeledContent` с EUR, accounting sign для отрицательных.
2. **Percent stepper** — `Stepper` + `.percent`; проверь `0.01` vs `1`.
3. **Relative date** — `Text(date, format: .relative(presentation: .named))`; смени locale в Preview.
4. **Parse back** — `TextField` с `.dateTime.year().month().day()`; введи дату руками.

</details>

## Resources


<details class="lang-ru">
<summary>По-русски</summary>

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

</details>

### Swift Talk — The FormatStyle API
- **Type:** video
- **URL:** https://talk.objc.io/episodes/S01E488-the-formatstyle-api
<details class="lang-ru">
<summary>По-русски</summary>

- **Why:** Environment в SwiftUI, `Stepper` + parseable, практика от авторов гайда

</details>
- **Tags:** `swiftui`, `interview`
- **Added:** 2026-06-19## Links


<details class="lang-ru">
<summary>По-русски</summary>

- [formatstyle.guide](https://formatstyle.guide) — интерактив
- [goshdarnformatstyle.com](https://goshdarnformatstyle.com) — справочник

</details>
- [Swift Talk S01E488](https://talk.objc.io/episodes/S01E488-the-formatstyle-api)
<details class="lang-ru">
<summary>По-русски</summary>

- См. также: [Foundation & Lifecycle](/ios-sdk/foundation/)

</details>

## Interview Q&A (Knowledge cards)


### Q1
- **Question (EN):** FormatStyle vs Formatter?
- **Answer (EN):** `FormatStyle` is value-type, composable, cheap to create—Apple's recommendation for new Swift. `Formatter` is legacy NSObject for Obj-C interop or untouchable legacy.

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** FormatStyle vs Formatter?
- **Answer (RU):** `FormatStyle` — value-type, композируемый; Apple рекомендует для нового Swift. `Formatter` — legacy Obj-C.

</details>

<details class="lang-ru">
<summary>По-русски</summary>

**Доп. информация:** [goshdarnformatstyle.com — FAQ](https://goshdarnformatstyle.com/)

</details>

### Q2
- **Question (EN):** Why not `.formatted()` everywhere in SwiftUI?
- **Answer (EN):** `.formatted()` yields a one-shot `String`; environment (locale, timeZone) changes are not tracked. `Text(value, format:)` stays typed and environment-aware.

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Почему в SwiftUI не `.formatted()`?
- **Answer (RU):** `.formatted()` даёт `String` один раз; environment не отслеживается. `Text(value, format:)` typed и реагирует на locale/timeZone.

</details>

<details class="lang-ru">
<summary>По-русски</summary>

**Доп. информация:** [formatstyle.guide/swiftui](https://formatstyle.guide/swiftui)

</details>

### Q3
- **Question (EN):** Percent style: is 1 equal to 1% or 100%?
- **Answer (EN):** For `Double`/`Float`/`Decimal`, the value is a fraction (0.01 = 1%). For `Int`, 1 formats as 1%.

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Percent: 1 или 100%?
- **Answer (RU):** Для `Double`/`Float`/`Decimal` — доля (0.01 = 1%). Для `Int` — уже проценты (1 = 1%).

</details>
