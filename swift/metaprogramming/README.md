# Metaprogramming

## Материалы

- Статья (bookmark): [Swift Metaprogramming: Writing Code that Inspects Itself](https://www.kodeco.com/52631262-swift-metaprogramming-writing-code-that-inspects-itself) — Kodeco / выдержка из *Swift Internals*: `Mirror`, `@dynamicMemberLookup`, generic `prettyPrint`
- Playground: [MetaprogrammingLab.playground](MetaprogrammingLab.playground/Contents.swift) — `inspect`, рекурсивный `prettyPrint`, `JSONObject` с цепочкой `json.user.name`
- Apple Docs: [Mirror](https://developer.apple.com/documentation/swift/mirror), [`dynamicMemberLookup`](https://developer.apple.com/documentation/swift/dynamicmemberlookup), [Macros](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/)

## Структура топика

- `playgrounds/` — runnable примеры (`MetaprogrammingLab.playground`)
- `notes/` — при необходимости: внешние конспекты (пока материал в этом README)

---

## За 30 секунд


- **Metaprogramming** — код, который **анализирует или генерирует** другой код. В этом топике — **runtime**: `Mirror` и `@dynamicMemberLookup`. Compile-time (макросы, result builders, `KeyPath`) — см. таблицу ниже.

- **`Mirror`** — read-only рефлексия: обход `children`, имена свойств и значения; `displayStyle` и `subjectType` для форматирования.

- **`@dynamicMemberLookup`** — синтаксис `json.user.name` превращается в вызовы `subscript(dynamicMember:)`.

- Swift **ограничивает** рефлексию (нет вызова методов и мутации в runtime) ради производительности и type safety.

- **Не** использовать `Mirror` на hot path; для логов и JSON в проде — `CustomDebugStringConvertible`, `Codable`, typed models.


<details class="lang-ru">
<summary>По-русски</summary>

**Metaprogramming** — код, который анализирует или генерирует другой код. В топике — runtime: `Mirror` и `@dynamicMemberLookup`. Compile-time (макросы, result builders) — отдельная ось. Swift ограничивает рефлексию ради производительности и type safety.

</details>



## 🎯 Фокус vs можно отложить (вопрос → ответ)

- `Mirror(reflecting:)`, `children`, `displayStyle`, `subjectType`.
  - **Ответ**: `Mirror` — стандартный способ **прочитать** структуру значения в runtime. `children` — пары `(label?, value)` для stored members. `displayStyle` подсказывает, struct это, class, enum, collection и т.д. `subjectType` — статический тип отражаемого значения.  
    Docs: `https://developer.apple.com/documentation/swift/mirror`

- Ограничения `Mirror` (read-only, без `perform`).
  - **Ответ**: нельзя вызывать методы, менять свойства, создавать типы динамически — в отличие от Objective-C runtime. Только инспекция. Computed properties **без** stored backing часто **не** попадают в `children`.

- `@dynamicMemberLookup` + `subscript(dynamicMember:)`.
  - **Ответ**: атрибут на типе; компилятор перенаправляет неизвестный dot-access в ваш subscript. Удобно для JSON, plist, GraphQL-like деревьев. Ошибка в ключе — **runtime**, автодополнения нет.

- Runtime vs compile-time metaprogramming.
  - **Ответ**: runtime (`Mirror`, dynamic lookup) — когда тип/ключи известны только при выполнении. Compile-time (Swift macros `#...`, `@Observable`, result builders) — генерация и проверка **до** запуска; для boilerplate (`Codable`, `Equatable`) предпочтительнее макросы, не `Mirror`.

- Когда **не** нужна рефлексия.
  - **Ответ**: сериализация → `Codable`; лог известных моделей → `CustomStringConvertible` / ручной `debugDescription`; тестовые моки → протоколы + codegen/macros. `Mirror` — DEBUG, generic diff, exploratory tools.

### Отложить

- `@dynamicCallable` — редкий sibling для `foo(1, 2)` как dynamic call.
- Sourcery / custom macro plugins — отдельная тема codegen.
- Глубокий runtime type metadata (`_typeName`, private reflection APIs) — не для продакшена и не стабильный контракт.

## 📚 Что учить по уровням

### JUNIOR

- Что такое reflection и зачем `Mirror` в отладке.
- Пройти `for child in mirror.children`, вывести `label` и `value`.
- Отличие `Mirror` от `print(struct)` и от `dump()`.
- Базовый `@dynamicMemberLookup` на обёртке над `[String: Any]`.

### MIDDLE

- `displayStyle` для форматирования (struct vs collection vs dictionary).
- Рекурсивный `prettyPrint` / generic logger с отступами.
- Trade-offs dynamic JSON DSL vs `Codable` + typed `struct`.
- Понимать: missing key в dynamic wrapper — silent failure vs `throws` / `Result`.

### SENIOR

- Почему Swift режет reflection относительно Obj-C (ARC, layout, devirtualization).
- Выбор: DEBUG-only reflection vs compile-time macros для тестов.
- Design API: typed accessors (`.string`, `.int`) поверх dynamic subscript.
- Performance: не держать `Mirror` в цикле рендера / парсинга.

### TECH LEAD

- Стандарт команды: где dynamic lookup допустим (config, analytics payload), где запрещён (domain models).
- Code review: force-cast внутри `subscript(dynamicMember:)`, отсутствие ошибок на typo keys.
- Миграция legacy `[String: Any]` → `Codable` по модулям.

## 🌟 Strategic (Senior+)

- **Единый подход к «полудинамическим» данным**: remote config, feature flags, A/B payloads — либо typed `Decodable`, либо один изолированный dynamic layer с явными границами и тестами на malformed JSON.
- **Тестовая инфраструктура**: generic `assertMirrorEqual` только в test target; не тащить reflection в app target.
- **Обучение**: junior’ам показать `Mirror` в playground, middle — сравнение с macro-generated `Equatable`.

## 🏋️ Упражнения (8) — обязательная практика

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

---

## Конспект: Reflection с Mirror

Источник: [Kodeco — Swift Metaprogramming](https://www.kodeco.com/52631262-swift-metaprogramming-writing-code-that-inspects-itself).

### Что такое reflection

Программа **во время выполнения** узнаёт структуру объекта: имена полей, вложенные значения, kind (struct/class/enum). В Swift основной публичный API — **`Mirror`**.

Вопросы, на которые отвечает reflection:

- Что это за сущность? (struct, class, tuple, optional…)
- Какие **stored** свойства и какие у них значения сейчас?
- Как красиво напечатать неизвестный на compile time тип?

### API Mirror

| Свойство | Назначение |
|----------|------------|
| `children` | `AnyCollection<(label: String?, value: Any)>` — stored members |
| `subjectType` | Статический тип значения |
| `displayStyle` | `.struct`, `.class`, `.enum`, `.tuple`, `.optional`, `.collection`, `.set`, `.dictionary`, … |
| `superclassMirror` | Для class — mirror суперкласса (если есть) |

### Ограничения (важно для собеса)

| Можно | Нельзя |
|-------|--------|
| Читать labels и values stored properties | Вызывать методы по имени |
| Рекурсивно обходить дерево значений | Менять поля через mirror |
| Узнать `displayStyle` / `subjectType` | Создавать новые типы в runtime |
| DEBUG / test utilities | Hot path, сериализация в проде |

**Vs Objective-C:** `objc_msgSend`, KVC, dynamic method resolution — в Swift сознательно урезаны.

### Практика: generic prettyPrint

Алгоритм (см. playground):

1. `let mirror = Mirror(reflecting: value)`
2. Если `children.isEmpty` — leaf, печатаем скаляр.
3. Иначе — открывающая скобка: `[]` для collection/set/dictionary, `()` для struct-like.
4. Для каждого child — отступ, optional `label:`, рекурсия в `value`.
5. Закрывающая скобка с отступом родителя.

Не требует знания конкретного типа на этапе компиляции — цена: runtime cost и отсутствие type checking.

### Что Mirror не показывает

- Чистые **computed** properties без storage.
- Методы и subscripts (только данные в `children`).
- Private members — зависит от контекста и optimization; не полагаться на «увижу всё».

---

## Конспект: @dynamicMemberLookup

### Механизм

```swift
@dynamicMemberLookup
struct DynamicJSON {
    subscript(dynamicMember member: String) -> DynamicJSON { ... }
}
```

Выражение `root.user.name` компилируется как:

```text
root["user"]["name"]  // conceptually: chained subscript(dynamicMember:)
```

Можно вернуть тот же wrapper для цепочки или `String?` / `throws` на листьях.

### Typed leaf accessors

Поверх dynamic subscript — явные свойства:

```swift
var string: String? { ... }
var int: Int? { ... }
var bool: Bool? { ... }
```

Так читается `json.user.name.string` вместо каскада `as?`.

### Плюсы и минусы

| Плюсы | Минусы |
|-------|--------|
| Меньше вложенных `if let` | Typo в ключе — runtime |
| DSL для config / analytics | Нет autocomplete |
| Читаемые цепочки | Скрытые force-cast |
| Быстрый прототип | Сложнее рефакторить |

### Антипаттерны

- Domain models (`User`, `Order`) через `@dynamicMemberLookup` вместо `Codable`.
- Возврат «пустого» wrapper на missing key **без** способа отличить missing от `null`.
- Dynamic layer без unit-тестов на malformed / partial JSON.

### Родственные механизмы

- **`@dynamicCallable`** — dynamic call syntax `value(1, 2)`.
- **`KeyPath`** — compile-time безопасный доступ к свойствам; не замена для unknown keys.
- **Swift macros** — codegen для repetitive accessors при **известной** схеме.

---

## Runtime vs compile-time

| Runtime (этот топик) | Compile-time |
|----------------------|--------------|
| `Mirror`, `@dynamicMemberLookup` | `#Predicate`, `@Observable`, `@Model` |
| Ключи/типы неизвестны заранее | Схема известна или генерируется |
| Гибкость, слабая type safety | Проверка компилятором |
| Стоимость в runtime | Расширение кода при компиляции |

**Правило:** boilerplate (`Equatable`, `Hashable`, `Codable`, memberwise init) — **макросы** или Sourcery; introspection unknown payloads — dynamic layer на границе; core domain — typed structs.

---

## TL;DR — Mirror

- `Mirror(reflecting:)` — безопасный read-only взгляд внутрь value type / class instance.
- `children` — имена и значения **stored** свойств.
- `displayStyle` — как форматировать (collection vs struct).
- Только DEBUG, тесты, generic prettyPrint — не production hot path.
- Не заменяет `Codable`, не вызывает методы.

## TL;DR — @dynamicMemberLookup

- Dot-syntax для ключей, известных только в runtime.
- Реализация — `subscript(dynamicMember:)`.
- Чище, чем cast-лесенка; опаснее, чем `Decodable`.
- На границе системы (JSON in) — ок; в domain — typed models.

---

## Карточки знаний (Q&A)

### Q1: Что такое metaprogramming в контексте Swift?

**Ответ:** Код, который работает **с кодом или данными как со структурой**: inspect (Mirror), dynamic access (subscripts), или generate (macros). Этот топик — **runtime** inspect/access.

### Q2: Что возвращает `Mirror(reflecting:)` и зачем `children`?

**Ответ:** Объект `Mirror` с метаданными экземпляра. `children` — последовательность пар `(label?, value)` для обхода stored state без знания типа на compile time.

### Q3: Чем `Mirror` отличается от Objective-C runtime?

**Ответ:** Obj-C — message send, KVO, dynamic class creation. Swift `Mirror` — **только чтение** структуры значения; нет universal method invocation и mutation.

### Q4: Почему computed property может отсутствовать в `children`?

**Ответ:** Mirror отражает **storage**, не вычисления. `var x: Int { 42 }` без backing storage не даёт child `x`.

### Q5: Как работает `@dynamicMemberLookup`?

**Ответ:** Компилятор заменяет доступ к несуществующему member на вызов `subscript(dynamicMember:)`. Вы решаете, что вернуть — другой wrapper, optional, или `throws`.

### Q6: Mirror vs `Codable` для JSON?

**Ответ:** `Codable` — decode в typed model, ошибки на этапе decode, performance. `Mirror` — не API сериализации. Dynamic JSON — subscripts / `JSONDecoder`, не reflection.

### Q7: Когда `Mirror` уместен в production?

**Ответ:** Почти никогда на hot path. Допустимо: crash reporting metadata, DEBUG-only logging, test helpers. Для штатных логов — `CustomDebugStringConvertible`.

### Q8: Риск `JSONObject` с silent null на missing key?

**Ответ:** `json.usre.name` не падает — typo маскируется. Решения: `subscript` throws, `Result`, enum `JSONValue` с explicit `.missing`, или typed `Codable`.

### Q9: Что выбрать для remote config — dynamic или struct?

**Ответ:** Если схема стабильна — `Decodable` struct + versioning. Если payload произвольный (analytics) — dynamic wrapper **за протоколом** с тестами; не размазывать по domain.

### Q10: Runtime vs Swift macros — одна фраза?

**Ответ:** Macros расширяют код **до запуска** при известных паттернах; Mirror/dynamic lookup — гибкость **во время выполнения** при неизвестной форме данных.

---

## Код и примеры

Playground: [MetaprogrammingLab.playground](MetaprogrammingLab.playground/Contents.swift)

Краткий фрагмент — inspect:

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

Полный `prettyPrint`, enum reflection и демо missing key — в playground.

## Ссылки

- [Swift Metaprogramming (Kodeco / Swift Internals)](https://www.kodeco.com/52631262-swift-metaprogramming-writing-code-that-inspects-itself)
- [Mirror](https://developer.apple.com/documentation/swift/mirror)
- [dynamicMemberLookup](https://developer.apple.com/documentation/swift/dynamicmemberlookup)
- [Macros — The Swift Programming Language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/)

---

## Карточки знаний (Q&A)

### Q1
- **Question (EN):** What is `Mirror` for?
- **Answer (EN):** Read-only runtime reflection: walk `children`, `displayStyle`, `subjectType`—for debug/introspection, not hot-path serialization (prefer `Codable`).

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Зачем нужен `Mirror`?
- **Answer (RU):** Read-only рефлексия в runtime: обход `children`, `displayStyle`, `subjectType` — для debug/инспекции, не для hot path (в проде — `Codable`).

</details>
