# Metaprogramming

## Materials


<details class="lang-ru">
<summary>По-русски</summary>

- Article (bookmark): [Swift Metaprogramming: Writing Code that Inspects Itself](https://www.kodeco.com/52631262-swift-metaprogramming-writing-code-that-inspects-itself) — Kodeco / выдержка из *Swift Internals*: `Mirror`, `@dynamicMemberLookup`, generic `prettyPrint`
- Playground: [MetaprogrammingLab.playground](MetaprogrammingLab.playground/Contents.swift) — `inspect`, рекурсивный `prettyPrint`, `JSONObject` с цепочкой `json.user.name`

</details>
- Apple Docs: [Mirror](https://developer.apple.com/documentation/swift/mirror), [`dynamicMemberLookup`](https://developer.apple.com/documentation/swift/dynamicmemberlookup), [Macros](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/)

## Topic structure


<details class="lang-ru">
<summary>По-русски</summary>

- `playgrounds/` — runnable examples (`MetaprogrammingLab.playground`)
- `notes/` — при необходимости: внешние конспекты (пока материал в этом README)

</details>

---## In 30 seconds


<details class="lang-ru">
<summary>По-русски</summary>

- **Metaprogramming** — код, который **анализирует или генерирует** другой код. В этом топике — **runtime**: `Mirror` и `@dynamicMemberLookup`. Compile-time (макросы, result builders, `KeyPath`) — см. таблицу ниже.

- **`Mirror`** — read-only рефлексия: обход `children`, имена свойств и значения; `displayStyle` и `subjectType` для форматирования.

- **`@dynamicMemberLookup`** — синтаксис `json.user.name` превращается в вызовы `subscript(dynamicMember:)`.

- Swift **ограничивает** рефлексию (нет вызова методов и мутации в runtime) ради производительности и type safety.

- **Не** использовать `Mirror` на hot path; для логов и JSON в проде — `CustomDebugStringConvertible`, `Codable`, typed models.

</details>
<details class="lang-ru">
<summary>По-русски</summary>

**Metaprogramming** — код, который анализирует или генерирует другой код. В топике — runtime: `Mirror` и `@dynamicMemberLookup`. Compile-time (макросы, result builders) — отдельная ось. Swift ограничивает рефлексию ради производительности и type safety.

</details>

## 🎯 Focus vs Defer


<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- `Mirror(reflecting:)`, `children`, `displayStyle`, `subjectType`.
<details class="lang-ru">
<summary>По-русски</summary>

  - **Answer:** `Mirror` — стандартный способ **прочитать** структуру значения в runtime. `children` — пары `(label?, value)` для stored members. `displayStyle` подсказывает, struct это, class, enum, collection и т.д. `subjectType` — статический тип отражаемого значения.  
    Docs: `https://developer.apple.com/documentation/swift/mirror`

</details>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- Ограничения `Mirror` (read-only, без `perform`).
<details class="lang-ru">
<summary>По-русски</summary>

  - **Answer:** нельзя вызывать методы, менять свойства, создавать типы динамически — в отличие от Objective-C runtime. Только инспекция. Computed properties **без** stored backing часто **не** попадают в `children`.

</details>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- `@dynamicMemberLookup` + `subscript(dynamicMember:)`.
<details class="lang-ru">
<summary>По-русски</summary>

  - **Answer:** атрибут на типе; компилятор перенаправляет неизвестный dot-access в ваш subscript. Удобно для JSON, plist, GraphQL-like деревьев. Ошибка в ключе — **runtime**, автодополнения нет.

</details>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- Runtime vs compile-time metaprogramming.
<details class="lang-ru">
<summary>По-русски</summary>

  - **Answer:** runtime (`Mirror`, dynamic lookup) — когда тип/ключи известны только при выполнении. Compile-time (Swift macros `#...`, `@Observable`, result builders) — генерация и проверка **до** запуска; для boilerplate (`Codable`, `Equatable`) предпочтительнее макросы, не `Mirror`.

</details>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- Когда **не** нужна рефлексия.
<details class="lang-ru">
<summary>По-русски</summary>

  - **Answer:** сериализация → `Codable`; лог известных моделей → `CustomStringConvertible` / ручной `debugDescription`; тестовые моки → протоколы + codegen/macros. `Mirror` — DEBUG, generic diff, exploratory tools.

</details>


</details>


</details>


</details>

### Defer

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- `@dynamicCallable` — редкий sibling для `foo(1, 2)` как dynamic call.

</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- Sourcery / custom macro plugins — отдельная тема codegen.

</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- Глубокий runtime type metadata (`_typeName`, private reflection APIs) — не для продакшена и не стабильный контракт.


</details>


</details>


</details>

## 📚 What to learn by level


### JUNIOR

<details class="lang-ru">
<summary>По-русски</summary>

- Что такое reflection и зачем `Mirror` в отладке.
- Пройти `for child in mirror.children`, вывести `label` и `value`.
- Отличие `Mirror` от `print(struct)` и от `dump()`.
- Базовый `@dynamicMemberLookup` на обёртке над `[String: Any]`.

</details>

### MIDDLE

<details class="lang-ru">
<summary>По-русски</summary>

- `displayStyle` для форматирования (struct vs collection vs dictionary).
- Рекурсивный `prettyPrint` / generic logger с отступами.
- Trade-offs dynamic JSON DSL vs `Codable` + typed `struct`.
- Понимать: missing key в dynamic wrapper — silent failure vs `throws` / `Result`.

</details>

### SENIOR

<details class="lang-ru">
<summary>По-русски</summary>

- Почему Swift режет reflection относительно Obj-C (ARC, layout, devirtualization).
- Выбор: DEBUG-only reflection vs compile-time macros для тестов.
- Design API: typed accessors (`.string`, `.int`) поверх dynamic subscript.
- Performance: не держать `Mirror` в цикле рендера / парсинга.

</details>

### TECH LEAD

<details class="lang-ru">
<summary>По-русски</summary>

- Стандарт команды: где dynamic lookup допустим (config, analytics payload), где запрещён (domain models).
- Code review: force-cast внутри `subscript(dynamicMember:)`, отсутствие ошибок на typo keys.
- Миграция legacy `[String: Any]` → `Codable` по модулям.

</details>

## 🌟 Strategic (Senior+)


<details class="lang-ru">
<summary>По-русски</summary>

- **Единый подход к «полудинамическим» данным**: remote config, feature flags, A/B payloads — либо typed `Decodable`, либо один изолированный dynamic layer с явными границами и тестами на malformed JSON.
- **Тестовая инфраструктура**: generic `assertMirrorEqual` только в test target; не тащить reflection в app target.
- **Обучение**: junior’ам показать `Mirror` в playground, middle — сравнение с macro-generated `Equatable`.

</details>

## 🏋️ Exercises (8) — required practice


<details class="lang-ru">
<summary>По-русски</summary>

1) **Inspect**: struct с 3 полями — вывести все `children` и `displayStyle`.
   - **Ожидаемый результат**: `displayStyle == .struct`, три labeled children.

2) **Enum**: отразить enum с associated values — увидеть, как `Mirror` раскладывает case.
   - **Ожидаемый результат**: понимание, что associated values — children с labels или без.

3) **prettyPrint**: реализовать рекурсию как в playground; прогнать вложенный struct + `[User]`.
   - **Ожидаемый результат**: читаемый indented output; collections в `[]`, structs в `()`.

4) **Computed property**: struct с `var fullName: String { name + " " + surname }` — есть ли `fullName` в `children`?
   - **Ожидаемый результат**: только stored `name`/`surname`; вывод — computed не в mirror без backing.

5) **JSONObject**: доступ `json.profile.displayName.string`; typo `json.profil` — что вернётся?
   - **Ожидаемый результат**: осознание silent null / empty wrapper; предложить `throws` или `Optional` API.

6) **Codable vs dynamic**: один JSON — `struct User: Codable` и dynamic wrapper; сравнить type safety и размер кода.
   - **Ожидаемый результат**: typed model для domain; dynamic только на границе сети.

7) **DEBUG logger**: `#if DEBUG` функция `logReflection(_:)` через `Mirror`; в Release — no-op.
   - **Ожидаемый результат**: zero cost в release при правильной компиляции.

8) **Test diff**: две struct instances — обойти `children` обеих, сравнить labels и `String(describing: value)`.
   - **Ожидаемый результат**: простой generic diff без знания типа на compile time (ограничения — только stored props).

</details>

---

## Notes: Reflection with Mirror


<details class="lang-ru">
<summary>По-русски</summary>

Источник: [Kodeco — Swift Metaprogramming](https://www.kodeco.com/52631262-swift-metaprogramming-writing-code-that-inspects-itself).

</details>

### What reflection is

<details class="lang-ru">
<summary>По-русски</summary>

Программа **во время выполнения** узнаёт структуру объекта: имена полей, вложенные значения, kind (struct/class/enum). В Swift основной публичный API — **`Mirror`**.

Вопросы, на которые отвечает reflection:

- Что это за сущность? (struct, class, tuple, optional…)
- Какие **stored** свойства и какие у них значения сейчас?
- Как красиво напечатать неизвестный на compile time тип?

</details>

### API Mirror

<details class="lang-ru">
<summary>По-русски</summary>

| Свойство | Назначение |
|----------|------------|
| `children` | `AnyCollection<(label: String?, value: Any)>` — stored members |
| `subjectType` | Статический тип значения |
| `displayStyle` | `.struct`, `.class`, `.enum`, `.tuple`, `.optional`, `.collection`, `.set`, `.dictionary`, … |
| `superclassMirror` | Для class — mirror суперкласса (если есть) |

</details>

### Limits (important for interviews)

<details class="lang-ru">
<summary>По-русски</summary>

| Можно | Нельзя |
|-------|--------|
| Читать labels и values stored properties | Вызывать методы по имени |
| Рекурсивно обходить дерево значений | Менять поля через mirror |
| Узнать `displayStyle` / `subjectType` | Создавать новые типы в runtime |
| DEBUG / test utilities | Hot path, сериализация в проде |

**Vs Objective-C:** `objc_msgSend`, KVC, dynamic method resolution — в Swift сознательно урезаны.

</details>

### Practice: generic prettyPrint

<details class="lang-ru">
<summary>По-русски</summary>

Алгоритм (см. playground):

1. `let mirror = Mirror(reflecting: value)`
2. Если `children.isEmpty` — leaf, печатаем скаляр.
3. Иначе — открывающая скобка: `[]` для collection/set/dictionary, `()` для struct-like.
4. Для каждого child — отступ, optional `label:`, рекурсия в `value`.
5. Закрывающая скобка с отступом родителя.

Не требует знания конкретного типа на этапе компиляции — цена: runtime cost и отсутствие type checking.

</details>

### What Mirror does not show

<details class="lang-ru">
<summary>По-русски</summary>

- Чистые **computed** properties без storage.
- Методы и subscripts (только данные в `children`).
- Private members — зависит от контекста и optimization; не полагаться на «увижу всё».

</details>

---## Notes: @dynamicMemberLookup

### Mechanism

```swift
@dynamicMemberLookup
struct DynamicJSON {
    subscript(dynamicMember member: String) -> DynamicJSON { ... }
}
```

<details class="lang-ru">
<summary>По-русски</summary>

Выражение `root.user.name` компилируется как:

</details>

```text
root["user"]["name"]  // conceptually: chained subscript(dynamicMember:)
```

<details class="lang-ru">
<summary>По-русски</summary>

Можно вернуть тот же wrapper для цепочки или `String?` / `throws` на листьях.

</details>

### Typed leaf accessors

<details class="lang-ru">
<summary>По-русски</summary>

Поверх dynamic subscript — явные свойства:

</details>

```swift
var string: String? { ... }
var int: Int? { ... }
var bool: Bool? { ... }
```

<details class="lang-ru">
<summary>По-русски</summary>

Так читается `json.user.name.string` вместо каскада `as?`.

</details>

### Pros and cons

<details class="lang-ru">
<summary>По-русски</summary>

| Плюсы | Минусы |
|-------|--------|
| Меньше вложенных `if let` | Typo в ключе — runtime |
| DSL для config / analytics | Нет autocomplete |
| Читаемые цепочки | Скрытые force-cast |
| Быстрый прототип | Сложнее рефакторить |

</details>

### Anti-patterns

<details class="lang-ru">
<summary>По-русски</summary>

- Domain models (`User`, `Order`) через `@dynamicMemberLookup` вместо `Codable`.
- Возврат «пустого» wrapper на missing key **без** способа отличить missing от `null`.
- Dynamic layer без unit-тестов на malformed / partial JSON.

</details>

### Related mechanisms

<details class="lang-ru">
<summary>По-русски</summary>

- **`@dynamicCallable`** — dynamic call syntax `value(1, 2)`.
- **`KeyPath`** — compile-time безопасный доступ к свойствам; не замена для unknown keys.
- **Swift macros** — codegen для repetitive accessors при **известной** схеме.

</details>

---## Runtime vs compile-time

<details class="lang-ru">
<summary>По-русски</summary>

| Runtime (этот топик) | Compile-time |
|----------------------|--------------|
| `Mirror`, `@dynamicMemberLookup` | `#Predicate`, `@Observable`, `@Model` |
| Ключи/типы неизвестны заранее | Схема известна или генерируется |
| Гибкость, слабая type safety | Проверка компилятором |
| Стоимость в runtime | Расширение кода при компиляции |

**Правило:** boilerplate (`Equatable`, `Hashable`, `Codable`, memberwise init) — **макросы** или Sourcery; introspection unknown payloads — dynamic layer на границе; core domain — typed structs.

</details>

---## TL;DR — Mirror

<details class="lang-ru">
<summary>По-русски</summary>

- `Mirror(reflecting:)` — безопасный read-only взгляд внутрь value type / class instance.
- `children` — имена и значения **stored** свойств.
- `displayStyle` — как форматировать (collection vs struct).
- Только DEBUG, тесты, generic prettyPrint — не production hot path.
- Не заменяет `Codable`, не вызывает методы.

</details>

## TL;DR — @dynamicMemberLookup


<details class="lang-ru">
<summary>По-русски</summary>

- Dot-syntax для ключей, известных только в runtime.
- Реализация — `subscript(dynamicMember:)`.
- Чище, чем cast-лесенка; опаснее, чем `Decodable`.
- На границе системы (JSON in) — ок; в domain — typed models.

</details>

---## Interview Q&A (Knowledge cards)


### Q1: What is metaprogramming in Swift?

<details class="lang-ru">
<summary>По-русски</summary>

**Answer:** Код, который работает **с кодом или данными как со структурой**: inspect (Mirror), dynamic access (subscripts), или generate (macros). Этот топик — **runtime** inspect/access.

</details>

### Q2: What does `Mirror(reflecting:)` return and why `children`?

<details class="lang-ru">
<summary>По-русски</summary>

**Answer:** Объект `Mirror` с метаданными экземпляра. `children` — последовательность пар `(label?, value)` для обхода stored state без знания типа на compile time.

</details>

### Q3: How is `Mirror` different from Objective-C runtime?

<details class="lang-ru">
<summary>По-русски</summary>

**Answer:** Obj-C — message send, KVO, dynamic class creation. Swift `Mirror` — **только чтение** структуры значения; нет universal method invocation и mutation.

</details>

### Q4: Why can a computed property be missing from `children`?

<details class="lang-ru">
<summary>По-русски</summary>

**Answer:** Mirror отражает **storage**, не вычисления. `var x: Int { 42 }` без backing storage не даёт child `x`.

</details>

### Q5: How does `@dynamicMemberLookup` work?

<details class="lang-ru">
<summary>По-русски</summary>

**Answer:** Компилятор заменяет доступ к несуществующему member на вызов `subscript(dynamicMember:)`. Вы решаете, что вернуть — другой wrapper, optional, или `throws`.

</details>

### Q6: Mirror vs `Codable` for JSON?

<details class="lang-ru">
<summary>По-русски</summary>

**Answer:** `Codable` — decode в typed model, ошибки на этапе decode, performance. `Mirror` — не API сериализации. Dynamic JSON — subscripts / `JSONDecoder`, не reflection.

</details>

### Q7: When is `Mirror` appropriate in production?

<details class="lang-ru">
<summary>По-русски</summary>

**Answer:** Почти никогда на hot path. Допустимо: crash reporting metadata, DEBUG-only logging, test helpers. Для штатных логов — `CustomDebugStringConvertible`.

</details>

### Q8: Risk of `JSONObject` silent null on missing key?

<details class="lang-ru">
<summary>По-русски</summary>

**Answer:** `json.usre.name` не падает — typo маскируется. Решения: `subscript` throws, `Result`, enum `JSONValue` с explicit `.missing`, или typed `Codable`.

</details>

### Q9: Remote config — dynamic or struct?

<details class="lang-ru">
<summary>По-русски</summary>

**Answer:** Если схема стабильна — `Decodable` struct + versioning. Если payload произвольный (analytics) — dynamic wrapper **за протоколом** с тестами; не размазывать по domain.

</details>

### Q10: Runtime vs Swift macros — one line?

<details class="lang-ru">
<summary>По-русски</summary>

**Answer:** Macros расширяют код **до запуска** при известных паттернах; Mirror/dynamic lookup — гибкость **во время выполнения** при неизвестной форме данных.

</details>

---

## Code & examples


Playground: [MetaprogrammingLab.playground](MetaprogrammingLab.playground/Contents.swift)

<details class="lang-ru">
<summary>По-русски</summary>

Краткий фрагмент — inspect:

</details>
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

<details class="lang-ru">
<summary>По-русски</summary>

Полный `prettyPrint`, enum reflection и демо missing key — в playground.

</details>

## Links


- [Swift Metaprogramming (Kodeco / Swift Internals)](https://www.kodeco.com/52631262-swift-metaprogramming-writing-code-that-inspects-itself)
- [Mirror](https://developer.apple.com/documentation/swift/mirror)
- [dynamicMemberLookup](https://developer.apple.com/documentation/swift/dynamicmemberlookup)
- [Macros — The Swift Programming Language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/)

---

## Interview Q&A (Knowledge cards)


### Q1
- **Question (EN):** What is `Mirror` for?
- **Answer (EN):** Read-only runtime reflection: walk `children`, `displayStyle`, `subjectType`—for debug/introspection, not hot-path serialization (prefer `Codable`).

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Зачем нужен `Mirror`?
- **Answer (RU):** Read-only рефлексия в runtime: обход `children`, `displayStyle`, `subjectType` — для debug/инспекции, не для hot path (в проде — `Codable`).

</details>
