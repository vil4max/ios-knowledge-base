# Types & Generics

## Типы, протоколы, дженерики, opaque и existentials — описание

| | |
|---|---|
| **Уровни** | Junior, Middle, Senior |
| **Трек** | Язык |
| **Must** | Тут начинается «настоящий Swift». Дженерики, ассоциированные типы, `some` vs `any` — то, что делит middle и senior на собесах. |

**Фокус**

- `some` (opaque) vs `any` (existential): когда что выбирать.
- Дженерик-ограничения: `where`, `==`, `:`, несколько ограничений сразу.
- Phantom types для compile-time контроля состояния.

**Память и ABI рядом с `any` / existential:** экзистенциальные контейнеры, non-frozen, CoW крупных значений в протокольной типизации — [Habr (Avito) — память Swift, ч.1](https://habr.com/en/companies/avito/articles/1017162/); якоря в [`swift/memory-arc/README.md`](../memory-arc/README.md) (разделы **Доп. конспект: Avito ч.1–2**).


## Структура топика

- `notes/` — Q&A + ссылки на Apple docs
- `exercises/` — упражнения с expected outcome

---

## 🎯 Фокус vs можно отложить

### Фокус

  Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols/`
- `some` (opaque) vs `any` (existential): когда что выбирать.
- **Ответ**: `some P` = “возвращаю один конкретный тип, но скрываю его” (тип фиксирован и известен компилятору) → обычно быстрее. `any P` = “храню/передаю разные реализации как один тип” (existential box) → гибче, но есть overhead и ограничения.
  Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/opaquetypes/`
- **Ответ**: type erasure нужен, чтобы скрыть конкретный generic-тип в публичном API и/или собрать разные реализации под единый тип. Обычно делается через “box” (протокол + private concrete boxes) или замыкания (хранить функции `next()/render()` внутри wrapper).
  Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics/`
- Дженерик-ограничения: `where`, `==`, `:`, несколько constraints.
- **Ответ**: ограничения описывают требования к типам, чтобы внутри generic-кода можно было использовать нужные операции. `:` — conformance (например `Element: Equatable`), `==` — равенство типов (например `T == U.Element`), `where` — место для нескольких условий.
  Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics/`
- Phantom types для compile-time контроля состояния.
- **Ответ**: phantom type — параметр типа, который не хранится как данные, но кодирует “состояние” на этапе компиляции (например `Money<USD>`). Это предотвращает целый класс ошибок (например сложение разных валют) без runtime-проверок.
  Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics/`

### Отложить

- Variadic generics (`each T`) — узкий круг задач.
- Метатипы и `Self`-семантика на глубоком уровне — точечно.

## 📊 some vs any (интуиция)

Protocol `P`:

- Визуальная шпаргалка:

- `some P` (opaque)
  - конкретный тип **известен компилятору**
  - обычно **без existential overhead**
  - тип фиксирован для конкретной функции/свойства (не “меняется” в рантайме)

- `any P` (existential)
  - реальный тип может отличаться в рантайме
  - используется existential box → **overhead**
  - удобен для хранения “разных реализаций” в одной переменной/коллекции

Правило-подсказка:
- “возвращаю один конкретный тип, но не хочу его раскрывать” → `some`
- “мне нужно хранить/передавать разные реализации как один тип” → `any`

## 🏋️ Упражнения (8)

`protocol Container { associatedtype Item ... }` → попытаться использовать `Container` как тип → получить ошибку → исправить через `any` или type erasure.

2) `some` vs `any`  
`makeAdder() -> some Numeric` → переписать на `any Numeric` → сравнить через `XCTMetric` (где уместно).

Сделать свой `AnyView` с `SomeView` и `OtherView`. Измерить размер через `MemoryLayout` и посмотреть overhead.

4) Phantom types  
`Money<USD>` и `Money<EUR>` — компилятор должен запретить складывать разные валюты.

5) Generic constraints  
`extension Array where Element: Numeric { var average: Element }` (и продумать “что такое average для Int?”).

6) Sequence/Collection  
Свой `FibonacciSequence: Sequence`, использовать в `for-in`.

7) Result builder  
`HTMLBuilder` для сборки HTML-строки декларативно.

8) Conditional conformance  

## 🌟 Strategic (Senior+)

- **Дизайн API**: важнее “как написать”, чем “как использовать другие”. Читать API Design Guidelines и смотреть stdlib.
- **Источник истины — swift-evolution**: понимать направление языка и последствия для архитектуры.
- **Баланс сложности**: не “упарываться” в generics там, где достаточно простого протокола.

---

## Связка с карточками (Q&A) — `any` vs generics, `associatedtype`, dispatch

Материал в формате **тезис → практика → типичная ошибка → Docs**, совпадает с карточками **Q7 и Q8** в секции **Карточки знаний (Q&A)** ниже. Playground: `06_protocols_generics.playground`.

### Сравниваем не «протокол против дженерика», а **`T: P`** vs **`any P`**

- **Тезис:** при **`T: P`** в конкретном месте вызова тип **`T` зафиксирован** — компилятор знает фактический тип и может **специализировать** реализацию; при **`any P`** значение — это **«любой conforming тип»** (existential), часто с **boxing** и вызовами через **witness table**.
- **Когда осознанно `any`:** гетерогенная коллекция **`[any P]`**, публичный API без лишнего generic-параметра, интеграция с кодом, уже принимающим existential; когда упрощение типов важнее micro-perf **вне hot path**.
- **Частая ошибка:** думать, что протокол «всегда медленнее» или что generic «размывает типизацию». Наоборот: **generic задаёт строгость «какой именно тип здесь»**; **`any`** сознательно её смягчает ради единого типа значения.

### `some P` (opaque) vs `any P` (existential) — коротко

- **`some P`:** один конкретный тип, известный компилятору в области видимости; наружу «виден» протокол; обычно **дешевле**, чем произвольный existential.
- **`any P`:** в рантайме может быть **разный** concrete тип за одной переменной; гибко для хранения, но **overhead** и динамическая диспетчеризация по протоколу чаще, чем у специализированного generic.


- **Тезис:** **`associatedtype`** — **placeholder на уровне протокола**; **конкретный** тип для каждого conforming типа подставляется на этапе **компиляции** (через inference / `typealias`). Протокол описывает **семейство** типов (`Element`, `Key`/`Value` у коллекций), не один зашитый тип.
- **Почему нельзя «просто положить в переменную типа `P`» без дженерика/обёртки:** у разных conformers разные связанные типы → **нет одного стабильного layout** и однозначного набора witness-методов без дополнительной информации.
- **Выходы:** **`func f<T: P>(_: T)`**, **`any P`** там, где язык и протокол это позволяют, **type erasure** (обёртка с конкретным хранилищем), или **конкретный тип** вместо абстракции.
- **Частая ошибка:** говорить, что associated type «подставляется в **runtime** как другой тип». Динамика «любой conforming тип» ближе к **`any`** и **type erasure**, не к подстановке associated type.
- Docs: [Protocols — Associated Types](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols/)

### Dispatch и связь с `any` vs generic (что спрашивают Middle/Senior)

- **Static dispatch:** для данного места вызова компилятор знает целевую функцию → прямой вызов / инлайн; типично для конкретных типов, `final`, часто для **`T: P`** на сайте вызова после специализации.
- **Dynamic dispatch (class):** реализация выбирается по фактическому типу объекта → **vtable** при наследовании классов.
- **Protocol witness table:** для пары **(конкретный тип, протокол)** хранятся указатели на реализации требований; вызов через **`any P`** обычно идёт через эту связку → дороже «голого» статического вызова на известном типе.
- **Связка с вопросом:** на **hot path** держат конкретный тип и **`T: P`**; **`any`** — когда нужна гетерогенность или простота API и это оправдано.
- **Оговорка:** SIL/LLVM может оптимизировать границы; на собесе часто достаточно **концептуальной** разводки.

### Устные опоры (формат карточек)

1. Сравниваем **`T: P`** и **`any P`**, не «протокол vs дженерик».
3. **`some`** — один скрытый конкретный тип; **`any`** — разные реализации под одной «коробкой».

---

## Карточки знаний (Q&A)

Ниже — Q&A по теме.

<!-- knowledge-cards-canonical:start -->

### Q7
- **Question (EN):** `any Protocol` vs generics?

- **Answer (EN):** Generics are usually faster and more type-precise; `any` is flexible but can mean existential boxing and extra dispatch cost.

- **Вводные данные:** здесь сравнивают не «протокол против дженерика», а **два способа абстрагироваться по типу**, когда уже есть **протокол** `P`.

    - **Протокол (protocol):** контракт — какие свойства/методы должен иметь тип. Конкретные типы **conform** (подписываются под протокол). Сам по себе протокол — это не «размытая типизация»; размытость появляется, когда ты используешь значение как **«что угодно, что conforms к P»** — это как раз **`any P`** (existential / экзистенциальный тип).

    - **Generic (обобщённый код):** параметр типа `T` (или несколько), часто с ограничением **`T: P`**. Для **каждого места вызова** компилятор подставляет **конкретный** тип (`String`, `MyModel`, …); один алгоритм работает для разных типов, но в этом месте программы тип **зафиксирован**. Это не «узкая специализация функционала» в бытовом смысле — это **одна реализация на множество типов**, при этом в точке использования тип **строгий**.

    - **`any P` vs `T: P`:** с **`any P`** в рантайме может понадобиться **boxing** (упаковка «любого conformера» в одну форму) и **динамическая** диспетчеризация — гибко (например массив разнородных conformers). С **`T: P`** компилятор знает фактический тип `T` и может **специализировать** код — обычно **быстрее** и типобезопаснее на границах.

    - **Частая ошибка:** думать, что «протокол = без строгой типизации», а «дженерики = уже». Наоборот: **generic как раз даёт строгость «какой именно тип здесь»**; **`any`** осознанно допускает «любой conforming тип» и платит за это.

- **Устная заготовка (EN):**

    1. Compare **`T: P`** vs **`any P`**, not protocols vs generics in the abstract.
    2. Generics fix a concrete type per use site — usually faster and sharper typing.
    3. `any P` erases to “some conforming type” — flexible; can mean boxing and dynamic dispatch.

- **Follow-up:** где осознанно выбираешь **`any`**?

- **Follow-up answer:** когда нужна **одна сущность** или **heterogeneous collection** вроде **`[any P]`** (разные типы, все **conform** к одному `P`). Когда **public API** проще без второго **generic**-параметра или стыкуешься с уже **existential**-кодом. Когда **`associatedtype`**, **`opaque type`** / **`some P`** или размер типовой сигнатуры толкают к **type erasure** (обёртка / **`any`**) — полный разбор **`associatedtype`** в **Q8**. Когда **performance** не на **hot path** (см. **Q2**, follow-up) и важнее простота.

- **Доп. информация (не свёрнуто в коротком Answer про `any` vs generic):** **dispatch** (**dispatch** / диспетчеризация — как рантайм или компилятор выбирает реализацию метода для конкретного типа) — типичное углубление после ответа про existential vs специализацию. Ниже — разводка, которую в основном **не раскрывают** одной фразой про boxing/overhead.

    - **Static dispatch** (**статическая диспетчеризация**): адрес вызываемой функции для **этого места вызова** известен компилятору — часто **прямой вызов** или даже **инлайн**. Нет поиска реализации в runtime. Типично: методы **`struct` / `enum`**, **`final class`**, **`private`** методы без полиморфизма, **специализированные generics** (`func f<T>(_: T)` при конкретном `T` на сайте вызова), часть вызовов после **devirtualization** (компилятор доказал фактический тип).

    - **Dynamic dispatch** (**динамическая диспетчеризация**): **какую реализацию вызвать** выясняется **в runtime** по **фактическому типу** объекта — нужна **косвенность** (чтение указателя → переход по таблице / отправка сообщения). Типично: **`class`**, **`override`**, полиморфный вызов через базовый тип класса.

    - **Vtable** (**virtual method table** / таблица виртуальных методов класса): у экземпляра **`class`** есть указатель на класс → таблица указателей на реализации методов; при **override** подставляется реализация из динамического типа. Это основной механизм **динамической** диспетчеризации наследования в Swift (в духе C++/Objective-C классов).

    - **Protocol witness table** (**witness table** / таблица соответствия протоколу): для каждой пары **(конкретный тип, протокол)** есть таблица «где лежат реализации требований протокола». Вызов через **`any P`** (existential) идёт через эту метаданную связку — поэтому дороже, чем прямой вызов на известном типе; компилятор не всегда может «провалиться» в статический вызов.

    - **Objective-C runtime** (если уводят в UIKit/Foundation): многие классы **`NSObject`** и legacy API используют **`objc_msgSend`** / разрешение селектора в runtime — это тоже **динамическая** диспетчеризация, исторически доминирующая в части стека Apple; Swift-классы без Obj-C корней устроены иначе, но **interop** смешивает модели.

    - **Связка с этим вопросом (`any` vs generic):** **`T: P`** на сайте вызова часто даёт путь к **static** (конкретный `T`); **`any P`** почти по определению тянет **witness / runtime**. На **hot path** сознательно держат конкретный тип, **`final`**, избегают лишнего **`any`**.

    - **Оговорка:** реальный SIL/LLVM может оптимизировать границы; на собесе часто просят именно разводку ниже.

    - **Тезисно для собеседования:**

        - **Static vs dynamic:** **static** — какую функцию звать известно при компиляции для этого места вызова (прямой вызов / инлайн, без поиска в runtime). **dynamic** — реализацию выбирают в **runtime** по фактическому типу (косвенность: таблица / сообщение).

        - **Vtable vs witness:** **vtable** — таблица методов **`class`** и наследования; **`override`** подменяет слоты у подкласса. **Witness table** — таблица «конкретный тип ↔ реализации требований **протокола**»; вызовы через **`any P`** идут через неё.

        - **`final`:** запрещает **наследование класса** и **override** методов → компилятор может **static dispatch** и оптимизации; сигнал, что полиморфизм через подклассы не нужен.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** **`any` P** vs **generics** (`T: P`) — когда что?

- **Answer (RU):** generic чаще быстрее и строже типизирован; existential (экзистенциальный тип) удобнее для абстракций, но может давать boxing (упаковка) и dispatch overhead (накладные расходы диспетчеризации).

- **Устная заготовка (RU):**

    1. Сравниваем **`T: P`** (generic) и **`any P`** (existential), не «протокол против дженерика».
    2. Generic — конкретный тип на месте вызова, часто быстрее.
    3. `any P` — «любой conforming тип», гибче, возможны boxing и лишний dispatch.

</details>
### Q8
- **Question (EN):** Why do protocols use **`associatedtype`** (**associated type** — type placeholder declared in the protocol; each conforming type supplies the concrete `typealias` / inference)?

- **Answer (EN):** An associated type is a protocol-level placeholder; each conforming type supplies its concrete associated types — the protocol describes a **family** without hard-coding one concrete type.

    It lets a protocol describe that family without fixing one concrete type upfront (e.g. collection element/key types).

- **Примечание:** в **Q7** (follow-up про **`any`**) **`associatedtype`** уже назван как типичная причина упростить тип через **`any`** / **type erasure**; в этом блоке ниже — follow-up про **type erasure** и устные заготовки.

- **Частая ошибка:** **`associatedtype`** — не «в **runtime** система подставит другой тип». Связанный тип фиксируется для каждого conforming типа на этапе **компиляции**; гибкость — в **семействе** типов без одного захардкоженного типа в протоколе. Динамика «любой conforming тип» ближе к **`any P`** и **type erasure**, не к **`associatedtype`** как источнику рантайм-подстановки.

- **Устная заготовка (EN):**

    1. **`associatedtype`** is a placeholder type inside the protocol; each conforming type fixes it.
    2. Models relationships like collection element types without hard-coding one concrete type.
    3. The protocol names a **family** of conforming types, not one concrete storage layout.

- **Follow-up:** почему такой протокол нельзя хранить как обычное значение без **type erasure** (стирание типа: один тип API скрывает разные **conforming** типы)?


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** зачем в протоколе **`associatedtype`** (**associated type**, placeholder типа; конкретику задаёт каждый **conforming** тип)?

- **Answer (RU):** связанный тип — placeholder в протоколе; каждый conforming тип фиксирует свои типы данных под контракт — без одного захардкоженного конкретного типа в самом протоколе описывается **семейство** типов.

    Позволяет протоколу описывать семейство типов без фиксированного конкретного типа (примеры: `Element`, `Key`/`Value` у коллекций).

- **Устная заготовка (RU):**

    1. **`associatedtype`** — имя типа внутри протокола; конкретику задаёт каждый conforming тип.
    2. Нужен, чтобы описать API вроде «элемент коллекции связан с типом коллекции», без привязки к одному классу.
    3. Без фиксированного конкретного типа протокол описывает **семейство** типов, а не один размер в памяти.

</details>
### Q9
- **Question (EN):** Why does this `some Equatable` function fail to compile, and how does switching to `any` fix it?

- **Answer (EN):** `some P` opaque return must resolve to **one** concrete type known to the compiler across all return paths. `Int` and `String` both conform to `Equatable` but are different types, so the function can’t pick one hidden concrete type → compile error. `any Equatable` is an existential box that can hold any conforming type at runtime, so it accepts both branches at the cost of boxing and dynamic dispatch.

- **Устная заготовка (EN):**

    1. `some P` — one fixed hidden concrete type per function.
    2. `any P` — existential box, different branches may return different concretes.
    3. Mnemonic: `some` is hide; `any` is erase.

- **Follow-up:** Когда осознанно выбираешь `some`, а когда `any`?

- **Follow-up answer:** **`some`** — когда фактически возвращается один конкретный тип, и хочется скрыть его в публичном API (классика — SwiftUI `body: some View`, фабрики последовательностей `some Sequence<T>`). Это даёт компилятору шанс на специализацию и снимает overhead existential. **`any`** — когда **нужно** хранить/передавать **разные** реализации под одной переменной (`[any Drawable]`, `var current: any State`), или когда упрощение типов в публичном API важнее микро-перформанса вне hot path.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Почему такой код **не компилируется**, и как починить через `any`?
    ```swift
    func make(_ flag: Bool) -> some Equatable {
        if flag { return 1 }
        return "text"
    }
    ```

- **Answer (RU):** Зацепка: **`some P` фиксирует один скрытый конкретный тип на всю функцию; `any P` — existential-контейнер, в котором конкретный тип может быть разным**.

    `some Equatable` означает: «компилятор знает один **конкретный** тип, который я скрываю снаружи». Этот тип должен быть **одинаков на всех ветках возврата**. `Int` и `String` оба conform to `Equatable`, но это **два разных** типа — поэтому `some Equatable` тут собрать нельзя. Допустимо только что-то вроде:

    ```swift
    func make() -> some Equatable { 1 }       // скрытый тип всегда Int
    func make() -> some Equatable { "hello" } // скрытый тип всегда String
    ```

    Версия с `any` компилируется:

    ```swift
    func make(_ flag: Bool) -> any Equatable {
        if flag { return 1 }
        return "text"
    }
    ```

    Потому что `any Equatable` — **existential container**: одна и та же переменная может в рантайме хранить значение **любого** типа, который conforms to `Equatable`. Цена — **boxing** и динамическая диспетчеризация по witness table.

- **Устная заготовка (RU):**

    1. `some P` = «один конкретный скрытый тип», тип фиксирован для функции.
    2. `any P` = existential, разные ветки могут возвращать разные типы.
    3. Ассоциация: `some` = «знаю тип, скрываю»; `any` = «тип заранее неизвестен».

</details>
### Q10
    - **Conforming type** — это любой реальный тип, который **реализует** протокол. `Int`, `String`, `User: Equatable` — все они conforming types для `Equatable`. Это просто факт «тип соответствует протоколу».

    Связка между ними:

    ```swift
    func makeView() -> some View {
        VStack { Text("Hello") }   // реальный conforming type: VStack<Text>
    }
    ```

    - Реальный conforming type здесь — `VStack<Text>`.

    То есть: **conforming type — реальный тип; opaque type — способ его «скрыть» через `some`, не теряя статической типизации**. Противоположен opaque не «conforming», а **existential** (`any P`), потому что existential тоже скрывает конкретный тип, но **разрешает разным значениям** иметь разные конкретные типы в рантайме.

- **Answer (EN):** They’re orthogonal. A **conforming type** is any concrete type that implements a protocol (`Int : Equatable`, `VStack<Text> : View`). An **opaque type** (`some P`) is a syntax that returns one concrete conforming type while hiding which one from callers — the compiler still knows it. The real opposite of opaque is the **existential** (`any P`), which also hides the concrete type but allows different runtime types behind one variable.

- **Устная заготовка (EN):**

    1. Conforming type — a real type that implements the protocol.

- **Follow-up:** Что у `some View` в SwiftUI «под капотом» и почему это важно для перфа?

- **Follow-up answer:** Реальный возвращаемый тип у `body: some View` — раздутая дженерик-структура вроде `_ConditionalContent<…, …>`/`TupleView<…>`/`ModifiedContent<…, …>`. SwiftUI **сравнивает** структуру и решает, что переоснасть. Если бы `body` возвращал `any View`, диффер не мог бы статически опираться на структуру — было бы хуже и для перфа, и для предсказуемости перерисовок.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** В чём разница между **opaque type** и **conforming type**? Это противоположности?

- **Устная заготовка (RU):**

    1. Conforming = «тип реализует протокол» (факт о типе).
    3. Противоположность opaque — **existential** (`any`), не «conforming».

</details>

- **Доп. информация:** Поэтому правило в SwiftUI: **возвращай `some View` из `body`, не `any View`**. `any View` уместен, когда тебе нужно действительно гетерогенно хранить view-значения (редкий случай), и ты сознательно платишь за existential.


<!-- knowledge-cards-canonical:end -->
