# Syntax & Idioms

## Swift: базовый синтаксис и идиоматика — описание

| | |
|---|---|
| **Уровни** | Trainee, Junior |
| **Трек** | Язык |
| **Must** | Optional, value/reference типы, control flow, функции, замыкания, расширения. Swift — выразительный язык, и идиоматичный код легко отличить от «Java на Swift». |

**Фокус**

- Optional и его обработка: `if let`, `guard let`, `??`, optional chaining.
- Замыкания: capture lists, escaping vs non-escaping, trailing syntax.
- Расширения и условные расширения для дженерик-типов.
- Уровни доступа: `open`, `public`, `internal`, `fileprivate`, `private`.
- Property wrappers и result builders на пользовательском уровне.


## Материалы

- `*.playground` / `*.playgroundbook` в корне темы — runnable примеры (см. секцию **Playgrounds** ниже).
- PDF в корне темы (например материалы по closures / error handling), если лежат рядом с prep.

## Структура топики (фактическая)

- Корень `05 Swift — базовый синтаксис и идиоматика/` — один `Swift-Syntax-and-Idioms.md` + playground’ы + опциональные PDF.
- Дополнительные подпапки (`notes/`, `exercises/` и т.д.) не обязательны: не держим пустые каталоги в репозитории.

---

## 🎯 Фокус vs можно отложить

### Фокус

- Optional и обработка: `if let`, `guard let`, `??`, optional chaining.
- **Ответ**: Optional — это enum `.some/.none`. Цель идиоматики — сделать happy path плоским: `guard let` для раннего выхода, `??` для дефолта, optional chaining чтобы “провалиться в nil” без ручных проверок.
  Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/thebasics/`
- Замыкания: capture lists, escaping vs non-escaping, trailing syntax.
  Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/closures/`
- Расширения и условные расширения для generic-типов.
- **Ответ**: extension позволяет добавлять API без наследования. Conditional extension (`where`) добавляет методы только когда тип удовлетворяет constraints — так stdlib строит “богатый” API без runtime-checks.
  Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics/`
- Уровни доступа: `open`, `public`, `internal`, `fileprivate`, `private`.
- **Ответ**: доступы управляют видимостью API. `open` — можно наследоваться/override вне модуля; `public` — видно, но нельзя override; `internal` — по умолчанию внутри модуля; `fileprivate/private` — ограничение области видимости для инкапсуляции.
  Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/accesscontrol/`
- Property wrappers и result builders на пользовательском уровне (использование/простая реализация).
- **Ответ**: property wrapper инкапсулирует повторяемую логику хранения/валидации (например `@Clamped`). Result builder позволяет писать декларативный DSL (как SwiftUI), собирая итоговое значение из набора выражений.
  Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/properties/`

### Отложить

- Полное знание всех глобальных функций Stdlib (учить по мере встречи).
- `@dynamicMemberLookup`, `@dynamicCallable` (экзотика).
- Swift macros на уровне написания (пока достаточно уметь пользоваться).

## Упражнения (10)

1) Optional pyramid -> guard  
Возьмите код с 4 вложенными `if let` и перепишите через `guard let`. Сравните читаемость.

Создайте retain cycle с closure в `UIViewController`. Поймайте Memory Graph. Исправьте через `[weak self]`.

3) Trailing closure  
Перепишите `UIView.animate(withDuration:animations:completion:)` в trailing-стиле с двумя замыканиями.

Напишите `@Clamped(0...100)` который ограничивает `Int`.

5) Result builder  
Сделайте `@AttributedStringBuilder`, собирающий `NSAttributedString` декларативно.

6) Уровни доступа  

`struct` с 3 свойствами — реализуйте `Hashable` вручную (без autosynthesis).

8) Расширения протоколов  
Дефолтная `description` через `Mirror` для типов, реализующих `Reflectable`.

9) Result type  
Перепишите callback `(Data?, Error?)` в `Result<Data, Error>`. Сравните читаемость.

10) `String` как коллекция  
Сравните `str.count` и `str.utf8.count` для `"👨‍👩‍👧‍👦"`. Объясните grapheme clusters vs code units.

## Связка с карточками (Q&A) — defer, type methods, class init

Материал в том же духе, что **Фокус / тезис / ссылка** в `07_memory_arc/Swift-Syntax-and-Idioms.md`: коротко для собеса + куда копать глубже. Соответствует карточкам **Q6, Q9, Q10, Q41** в секции **Карточки знаний (Q&A)** ниже.

### `defer`

- **Тезис:** блок помеченный `defer` выполняется при **выходе из текущего scope** (в т.ч. `return` и `throw`); несколько `defer` подряд выполняются в порядке **LIFO** (последний объявленный — первым при выходе).
- **Зачем на практике:** одна точка **cleanup** (освобождение ресурса) и **teardown** (симметричный разбор после setup) для парных операций — захват `NSLock`/`lock()` → в `defer` снять блокировку, открытый файл/дескриптор → закрыть, временные флаги UI → сбросить. Удобно при **многих ранних выходах** (`guard`, ветки ошибок): не копировать очистку в каждую ветку.
- **Частая ошибка на словах:** путать с «отложенным фоновым выполнением» или с тем, что `defer` выполнится «сразу после следующей строки» как обычный код — нет, только при **закрытии scope**.
- **Оговорка:** `defer` не заменяет асинхронную отмену или `Task`; внутри `defer` управление потоком только локальное.
- Docs: [Defer Statement](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/deferstatement/)

### `static` vs `class` methods (type methods)

- **Тезис:** у **type method** с `static` подкласс **не может** сделать `override`; у метода с `class` на **class** подкласс **может** переопределить реализацию — это полиморфизм через наследование на уровне типа, не экземпляра.
- **Зачем на практике:** в **публичном SDK** `class func` иногда оставляют как **hook** для кастомизации клиентом; `static func` сигнализирует «поведение зафиксировано, на override не рассчитывать». Смена `class` → `static` в released API — типичный **semver major** для тех, кто переопределял.
- **Связь с `final`:** для **instance**-методов запрет наследования/override часто делают через `final class` или `final` метод; для **type methods** роль «финальности на metatype» задаёт как раз пара **`static`** / **`class`**.
- Docs: [Methods](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/methods/) · [Inheritance](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/inheritance/)

### Почему у `class` нет memberwise `init`, как у `struct`

- **Тезис:** у классов нет **синтезируемого** memberwise init как у многих `struct`: **наследование** и **двухфазная инициализация** требуют явных **designated** инициализаторов и цепочки **`super.init`** — автоматическая сборка полей была бы неоднозначной или противоречила бы правилам языка; плюс **контроль доступа** к `init`. Явные `init`, которые ты пишешь сам, нормальны; речь именно об отсутствии **автогенерации** по полям.
- **Следствие в коде:** явные `init`, часто DI через конструктор; в иерархии — цепочка designated инициализаторов. У `struct` memberwise init появляется, когда компилятор может однозначно собрать поля (и нет запретов видимости).
- Docs: [Initialization](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/initialization/) · [Structures and Classes](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/classesandstructures/)

### Optionals (связка с junior-линией)


### Playgrounds под номера карточек (Q)

| Тема | Playground |
|------|------------|
| CoW / value collections | `CopyOnWriteInterview.playground` |
| `defer` | `DeferInterview.playground` |
| `static` vs `class` | `StaticVsClassMethodsInterview.playground` |
| memberwise / class init | `ClassMemberwiseInitInterview.playground` |
| optionals baseline | `OptionalsJuniorInterview.playground` |
| широкий обзор value/reference/layout (не один вопрос) | `SwiftCore.playground` |

---

## TL;DR

- SE-0508 снимает старое ограничение парсера для trailing closure после выражений вида `[T]` и `[K: V]`.
- Это делает DSL и builder-style API проще: меньше промежуточных `Builder.make {}` обёрток.
- Механика не меняет модель выполнения — это синтаксическое улучшение поверх уже существующих инициализаторов/вызовов.
- Практическая выгода: чище тестовые сценарии, конфиги и декларативные списки шагов/секций.

## Источник

- [SE-0508: Array expression trailing closures](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0508-array-expression-trailing-closures.md)

## Что было неудобно до SE-0508

Trailing closure привычно работает для функций и инициализаторов, но долгое время был “особый случай” для array/dictionary expression.

Например, запись в стиле:

```swift
let values = [Int] {
    (0..<10).map { $0 * 2 }
}
```

раньше либо не парсилась, либо требовала обходных форм через отдельные helper-типы/методы.

## Что меняется

Если у типа действительно есть подходящий API (инициализатор или вызов), trailing closure теперь можно писать непосредственно после `[T]`/`[K: V]` expression.

Иными словами, язык убирает синтаксический барьер и позволяет использовать более естественную форму для DSL.

## Пример с Array-инициализатором

```swift
extension Array {
    init(_ build: () -> [Element]) {
        self = build()
    }
}

let values = [Int] {
    (0..<10).map { $0 * 2 }
}
```

## Где особенно полезно

- DSL для UI/конфигов/разметки.
- Тестовые сценарии и шаги.
- Результат-билдеры, где важна читаемость декларативного кода.

Пример “до/после”:

```swift
// До
let sections = SectionsBuilder.build {
    if user.isPremium { premiumSection() }
    commonSection()
}

// После
let sections = [Section] {
    if user.isPremium { premiumSection() }
    commonSection()
}
```

## Что важно понимать

- Это не новая concurrency/архитектурная модель и не изменение semantics.
- Сахар работает только когда существует корректная цель вызова (подходящий init/call).
- Непрозрачные или двусмысленные API всё ещё могут требовать явной формы.

## Практические выводы / что брать в работу

- В DSL-подобных местах упрощать синтаксис до `[Type] { ... }`, если это улучшает читаемость.
- Сохранять явные helper-обёртки только там, где они добавляют реальную доменную ценность.
- При code review оценивать, уменьшает ли новая запись когнитивную нагрузку в конкретном модуле.

## Мини-чеклист

- Есть ли у выражения `[Type]` подходящий инициализатор/вызов под trailing closure.
- Улучшает ли новая форма читабельность относительно builder-обёртки.
- Не создаёт ли запись двусмысленность для команды и автокомплита.
- Покрыты ли DSL-ветки тестами, если синтаксис активно используется в критичных сценариях.

---

## Карточки знаний (Q&A)

Ниже — Q&A по теме.

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question (RU):** **`struct`** vs **`class`** — когда что?
- **Question (EN):** When do you choose `struct` vs `class`?
- **Answer (RU):** `struct` — **value semantics** (семантика значений) и независимые копии; `class` — **reference semantics** (ссылочная семантика), когда нужны **identity** (идентичность экземпляра), **shared mutable state** (разделяемое изменяемое состояние), **inheritance** (наследование).

    - **Value semantics** (`struct`): при присваивании/передаче — логически независимая копия; мутация меняет только её (у `Array`, `Dictionary`, `Set`, `String` физическая копия буфера часто откладывается до первой мутации — Copy-on-Write).

    - **Reference semantics** (`class`): несколько ссылок на один экземпляр, мутация видна через все алиасы; также выбор для **identity**, **shared mutable state**, **inheritance**.
- **Answer (EN):** `struct` — value semantics and independent copies; `class` — reference semantics when you need stable identity, inheritance, or shared mutable state.

    - **Value semantics** (`struct`): assignment/passing yields logically independent copies; mutation affects only that value (`Array`, `Dictionary`, `Set`, `String` often defer the buffer copy until the first mutation — Copy-on-Write).

    - **Reference semantics** (`class`): aliases refer to one instance, so mutations are visible through every reference; also use `class` for stable identity, inheritance, or shared mutable state.
- **Устная заготовка (RU):**

    1. `struct` — **value semantics** (семантика значений) и независимые копии.
    2. При присваивании и передаче — логически своя копия, мутация меняет только её.
    3. У `Array`, `Dictionary`, `Set`, `String` часто Copy-on-Write до первой мутации.
    4. `class` — **reference semantics** (ссылочная семантика): много ссылок на один экземпляр.
    5. Мутация видна через все ссылки.
    6. Плюс **identity**, **shared mutable state**, **inheritance** — когда это нужно.

- **Устная заготовка (EN):**

    1. I use `struct` for value semantics and independent copies.
    2. Assignment and passing give logically separate copies; mutation affects that value only.
    3. `Array`, `Dictionary`, `Set`, `String` often use copy-on-write until the first mutation.
    4. I use `class` for reference semantics: many references, one instance.
    5. Mutations are visible through every reference.
    6. Also for stable identity, shared mutable state, or inheritance when I need those.

- **Follow-up:** где ты сознательно мигрировал **`class` → `struct`** и что это дало?

### Q2
- **Question (RU):** что такое **Copy-on-Write (CoW)** (копирование при записи)?
- **Question (EN):** What is Copy-on-Write (CoW)?
- **Answer (RU):** для `Array`, `Dictionary`, `Set`, `String` физическая копия откладывается до мутации, если storage (хранилище) разделяется.
- **Answer (EN):** Standard collections share storage until the first write; they copy the buffer only when you mutate and the storage is still shared.
- **Устная заготовка (RU):**

    1. У `Array`, `Dictionary`, `Set`, `String` буфер могут делить между «копиями», пока нет мутации.
    2. Физическая копия буфера — при первой мутации, если storage ещё разделяют.
    3. Так не платят за полную копию при одном чтении.

- **Устная заготовка (EN):**

    1. `Array`, `Dictionary`, `Set`, `String` can share storage across copies until someone mutates.
    2. The first mutation copies the buffer only if storage is still shared.
    3. That avoids eager copies when you only read.

- **Follow-up:** как ловить лишние копии на **hot path** (горячий путь — код, который выполняется очень часто или с жёстким perf-бюджетом)?
- **Follow-up answer:** в **custom CoW type** (кастомном CoW-типе) проверяю уникальность **`storage`** через **`isKnownUniquelyReferenced(&storage)`** перед мутацией: если ссылка не уникальна — копирую **`storage`**, если уникальна — **in-place mutation** (мутация на месте). Для стандартных коллекций **CoW** уже встроен, поэтому на практике фокус на профилировании мутаций на **hot path** и снижении промежуточных копий.
- **Доп. информация:** CoW связывают с **большими value-type контейнерами**: дешевая шаринг-read-копия + дорогая мутация только при необходимости; на интервью иногда спрашивают про **промежуточные копии** (цепочки `filter`/`map`, временные массивы) — это уже зона профилирования, не определения CoW.

    **Углубление (чат / Habr Q7):** CoW — **паттерн**, не только коллекции: разделяемое хранилище, **физическая копия буфера при записи**, пока buffer **shared** (не «ждём изменения оригинала» как сущности). Свой тип: **`class`**-буфер + **`isKnownUniquelyReferenced`**. **`mutating`** не делает `struct` **reference type** — только помечает метод, который может изменить `self`. Про размещение полей и кучу — **Q47**; про **`var b = a` и мутацию `b`** — **Q49**.

### Q6
- **Question (RU):** `static` vs `class` methods?
- **Question (EN):** `static` vs `class` methods?
- **Answer (RU):** у **`static`** methods **`override`** (переопределение) в **`subclass`** (подклассе) нет; у **`class`** methods на классе — **`override`** в **`subclass`** возможен.
- **Answer (EN):** **`static`** methods **cannot be overridden**. **`class`** methods **can be overridden in subclasses** (use `class` when you want polymorphic dispatch through inheritance).
- **Устная заготовка (RU):**

    1. `static` — без **`override`** в **`subclass`**.
    2. `class` — можно **`override`** в **`subclass`**.

- **Устная заготовка (EN):**

    1. `static` — no overrides in subclasses.
    2. `class` — subclasses can override.

- **Follow-up:** где это важно для **SDK API contract** (контракта API)?
- **Follow-up answer:** в точках **расширяемости** для клиента SDK: `class` method оставляет hook для override в подклассе (кастомизация без форка); `static` фиксирует поведение на типе и сигнализирует «не рассчитывайте на override». Это влияет на **semver** (semantic versioning / семантическое версионирование: `MAJOR.MINOR.PATCH` — major при breaking changes (ломающих изменениях), minor при обратно совместимых фичах, patch при правках без смены контракта API) и ожидания интеграторов: смена `class` → `static` — ломающее изменение для тех, кто переопределял.

### Q9
- **Question (RU):** практический **`defer` use case** (случай использования)?
- **Question (EN):** A practical `defer` use case?
- **Answer (RU):** `defer` — отложенное выполнение кода при выходе из scope (в т.ч. по `return` / `throw`); несколько `defer` выполняются в обратном порядке объявления (LIFO).

    Одна точка для cleanup (cleanup / освобождение ресурса и приведение к безопасному состоянию) и teardown (teardown / симметричный разбор после setup): `lock` → в `defer` снять блокировку, открыли файл → в `defer` закрыть, откат транзакции или временные UI-флаги после `begin`/`commit`.
- **Answer (EN):** `defer` runs code when the current scope exits (including `return` / `throws`); multiple `defer`s run in reverse declaration order (LIFO).

    One place for cleanup (freeing resources / restoring safe state) and teardown (symmetric unwind after setup): acquire `lock` then `defer { unlock }`, open then `defer { close }`, rollback or restore temporary flags.
- **Устная заготовка (RU):**

    1. `defer` — при выходе из scope, не «следующая строка кода».
    2. cleanup / teardown: парные операции — lock/unlock, open/close.
    3. Много ранних `return` — очистка один раз, без копипаста.

- **Устная заготовка (EN):**

    1. `defer` at scope exit, returns and errors included.
    2. cleanup / teardown: paired operations like locks and handles.
    3. Many early exits — write teardown once.

- **Follow-up:** где `defer` заметно улучшает читаемость?
- **Follow-up answer:** когда много ранних выходов (`guard`, ошибки): блок освобождения ресурса пишется один раз рядом с захватом, основной путь без дублирования очистки в конце каждой ветки. Плюс восстановление временных флагов или настроек UI после короткого scope.
- **Доп. информация:** тело `defer` видит те же локальные имена, что и окружающий scope (в т.ч. переменные, объявленные выше по функции); несколько `defer` при **`throw`** всё равно отрабатывают при выходе из scope. **`defer`** не отменяет тяжёлую синхронную работу и не заменяет явную отмену **`Task`** — это про синхронный порядок очистки, не про concurrency.

### Q10
- **Question (RU):** почему у **`class`** нет **memberwise `init`** (автогенерируемого инициализатора), в отличие от **`struct`**?
- **Question (EN):** Why no memberwise initializer for classes like structs?
- **Answer (RU):** у классов нет **синтезируемого** memberwise init как у многих `struct`: при **наследовании** и **двухфазной инициализации** нужны явные **designated** инициализаторы и цепочка **`super.init`** — автоматическая сборка полей была бы неоднозначной или противоречила бы правилам языка; ещё **контроль доступа** к `init`.

    Речь не о том, что «явный init у класса небезопасен», а о том, что **компилятор не генерирует** такой init сам по полям, как часто делает для `struct`.
- **Answer (EN):** Classes don’t get a **synthesized** memberwise initializer like many structs: **inheritance** and **two-phase initialization** call for explicit **designated** initializers and a **`super.init`** chain—auto-generating a field-by-field initializer would be ambiguous or violate Swift’s rules; **access control** over `init` matters too.

    It’s not that explicit class initializers are “unsafe”—it’s that the compiler **won’t synthesize** a memberwise initializer from stored properties the way it commonly does for `struct`s.
- **Устная заготовка (RU):**

    1. Наследование + **двухфазная инициализация** → нужны **designated** и **`super.init`**, а не автосборка полей как у `struct`.
    2. **`convenience`** / **`required`** и доступность **`init`** — часть той же модели; без этого memberwise для всей иерархии не склеить.
    3. В итоге явные **`init`** и часто фабрики на **composition root**.

- **Устная заготовка (EN):**

    1. Inheritance plus **two-phase initialization** means **designated** inits and **`super.init`**, not a synthesized field bundle like many structs.
    2. **`convenience`** / **`required`** and **`init`** visibility are part of the same model—you can’t glue one memberwise across the hierarchy.
    3. So you write explicit `init`s and often factories at the composition root.

- **Follow-up:** как это влияет на **dependency injection** (внедрение зависимостей)?
- **Follow-up answer:** без memberwise у класса зависимости обычно явно перечислены в **`init`** или собираются в **фабрике на composition root** — это хорошо стыкуется с **constructor injection** и подстановкой моков в тестах. У **`struct`** автоматический memberwise иногда скрывает раздувание набора полей; у **`class`** «толстый» конструктор виден раньше. Минус — больше бойлерплейта, зато граф зависимостей прозрачнее на границе модуля.
- **Доп. информация:** запрет на полное использование **`self`** до завершения designated фазы (детали двухфазной модели) — частый oral follow-up; **`convenience`** только внутри класса, **`required`** протягивает контракт в подклассы. Про DI — в **Follow-up answer** выше.

---

### Q41
- **Question (RU):** как объяснить Optional / optionals (опционалы) на базовом уровне?
- **Question (EN):** Explain optionals at a junior level?
- **Answer (RU):** Зацепка: Optional — **явное «может не быть»** (`nil`); язык заставляет это учесть до использования значения.

    опционал — значение может отсутствовать (`nil`). Разворачивание: `if let`, `guard let`, optional chaining `?.`, значение по умолчанию `??`. Force unwrap (`!`) — только когда логически невозможно `nil` или это preconditionfailure уровня программиста.

- **Answer (EN):** Optionals model absence at the type level; unwrap safely (`if/guard let`, `?.`, `??`)—reserve `!` for provably non-nil cases.

- **Устная заготовка (RU):** «есть или nil» — не force unwrap по умолчанию.

- **Устная заготовка (EN):** Encode missing values; safe unwrap first.

- **Follow-up:** когда уместен force unwrap (`!`), и почему это риск?
- **Follow-up answer:** уместен для констант после инициализации известного ресурса или после guarded входа; риск — краш в проде при изменении предположений.

- **Доп. информация:** для ошибок операций предпочтительнее `throws`/`Result`, чем опционал «на всё».


### Q42
- **Question (RU):** как в Swift устроен **`Optional<Wrapped>`** (реализация, не только синтаксис `?`)?
- **Question (EN):** How is `Optional<Wrapped>` implemented in Swift?
- **Answer (RU):** Это **generic `enum`** с **двумя** кейсами: **`.none`** (значения нет) и **`.some(Wrapped)`** (есть associated value). Модель бинарная: «пусто / не пусто». Синтаксис: `T?` — псевдоним `Optional<T>`; литерал **`nil`** — то же, что **`.none`** (отдельного третьего кейса нет).

    **Память / ABI (устный upgrade):** для **reference-типов** часто **одно слово**: нулевой указатель = отсутствие значения, ненулевой = `.some` без лишнего тега. Для **мелких value-типов**, где все битовые паттерны `Wrapped` заняты, компилятор может добавить **discriminator** (напр. `Optional<Bool>`: `true` / `false` / «нет»).

    `if let` / `guard let` / `?.` — по сути **pattern matching** по enum.

- **Answer (EN):** `Optional` is a **generic `enum`** with two cases: **`.none`** and **`.some(Wrapped)`**. `T?` is sugar for `Optional<T>`; **`nil`** is **`.none`**. For class existentials, `Optional` often uses a **nullable pointer** representation; small value types may need an extra tag when no spare bit pattern exists.

- **Устная заготовка (RU):** «Два кейса enum, не три; `nil` = `.none`; для классов часто nullable pointer; `if let` — разбор `.some`.»

- **Устная заготовка (EN):** «Two-case enum; `nil` is `.none`; references often use a null pointer; unwrapping is pattern matching on `.some`.»

- **Follow-up (RU):** почему не три кейса? / `nil` и `.none` одно и то же? / `Optional` — протокол? / чем `T!` отличается от `T?`? / `==` для двух optionals? / optional chaining?
- **Follow-up answer (RU):** три кейса не нужны — модель «есть/нет». `nil` ≡ `.none` для Optional. Протоколом не является. **`ImplicitlyUnwrappedOptional`** / `T!` — тот же optional с другим контрактом проверки (ожидается non-nil к использованию); в новом коде редко. `Equatable` для `Optional` при `Wrapped: Equatable`. Chaining: при `.none` на шаге — вся цепочка даёт `.none`.

- **Доп. информация:** базовый сценарий опционалов — **Q41**; внешний чеклист: [Habr — iOS interview prep](https://habr.com/en/articles/726388/) (вопросы 2–3).


### Q43
- **Question (RU):** есть ли разница между **`.none`** и **`nil`** для `Optional`?
- **Question (EN):** Is there a difference between `.none` and `nil`?
- **Answer (RU):** **Семантической разницы нет:** `nil` — литерал, который в контексте `Optional` означает **`.none`**. Не отдельный «третий» кейс enum.

    Уточнение к формулировке «в памяти нет объекта»: для **`SomeClass?`** `.none` часто совпадает с **нулевым указателем** (объекта в куче нет). Для **`Int?` / `Bool?`** говорить «нет объекта» неточнее — нет **wrapped-значения**, состояние enum «пусто» (иногда с **tag** у value).

- **Answer (EN):** **No semantic difference:** `nil` is sugar for **`.none`** in `Optional` contexts. For class optionals, `.none` is often a null reference; for small value optionals, think “no wrapped value” / tagged empty state—not “no heap object.”

- **Устная заготовка (RU):** «`nil` и `.none` — одно состояние optional; для классов это про отсутствие ссылки, для value — про отсутствие wrapped-значения.»

- **Follow-up (RU):** `nil` без типа? / `==` двух optionals? / в чём отличие от «переменной нет»?
- **Follow-up answer (RU):** `nil` требует контекста `Optional`. При `Wrapped: Equatable` сравнение optionals стандартное. Переменная есть — **нет значения** в смысле `Wrapped`.

- **Доп. информация:** см. **Q42**; источник сценария: [Habr Q3](https://habr.com/en/articles/726388/).


### Q44
- **Question (RU):** способы **развернуть** (unwrap) optional?
- **Question (EN):** Ways to unwrap optional variables?
- **Answer (RU):** База с собеса: **`if let`** / **`guard let`** (pattern matching на `.some`); **`??`** — **nil-coalescing** (если слева `nil`, взять правое; правая часть **не оценивается**, если слева не `nil`); **`!`** — force unwrap, только если `nil` невозможен по логике.

    Дополнить: **`?.`** optional chaining (цепочка с optional-результатом); **`switch` / `if case` / `guard case`** по optional; **`map` / `flatMap`** на `Optional`.

- **Answer (EN):** Core: **`if let` / `guard let`**, **`??`** (*nil-coalescing*; short-circuit), **`!`** when non-nil is provable. Also: **`?.`**, **`switch`/`if case`**, **`map`/`flatMap`**.

- **Устная заготовка (RU):** «Разворот — `if`/`guard let`; дефолт — `??` без лишнего вычисления; `!` — осознанно; плюс `?.` и `switch`.»

- **Follow-up (RU):** `guard let` vs `if let`? / сайд-эффект в правой части `??`? / shorthand `if let x`?
- **Follow-up answer (RU):** `guard` — ранний выход, плоский happy path. В `??` правая часть не выполняется при non-nil слева. В Swift есть shorthand optional binding (`if let x`, `guard let self`).

- **Доп. информация:** **Q41**; [Habr Q4](https://habr.com/en/articles/726388/).


### Q45
- **Question (RU):** чем **reference types** отличаются от **value types** в Swift? Примеры типов?
- **Question (EN):** What’s the difference between reference and value types? Examples?
- **Answer (RU):** Главный критерий на собесе — **семантика**, не «куча vs стек». **Reference** (`class`, замыкания): несколько переменных могут указывать на **один экземпляр** — **общая identity** (**object identity** / **reference identity**): мутация через одну ссылку видна через другую; проверка «тот же объект» — **`===`** (*identical to*). **Value** (`struct`, `enum`, **tuple**): при присваивании/передаче — **логически независимая копия**; сравнение значения — **`==`** (*equality*, `Equatable`), не «тот же экземпляр в смысле ссылок».

    **Уточнение:** «value = стек, reference = куча» и «value = static dispatch, reference = dynamic» — **частые упрощения**. `String`, `Array`, `Dictionary` — **`struct`** с **value semantics**, но буфер может быть в **куче** (**Copy-on-Write**). Диспетчеризация зависит от **`final`**, generics, **existential** — не от одного только class/struct.

- **Answer (EN):** Lead with **semantics**: **reference** types share **identity**—aliases mutate one instance; use **`===`**. **Value** types copy independently; compare with **`==`**. Heap/stack and static/dynamic dispatch are **implementation details**, not definitions (`Array`/`String` are heap-backed COW structs).

- **Устная заготовка (RU) — одна фраза:** «**Value vs reference** — про **семантику**: у **class** — **общая identity** (`===`), одна мутация на все ссылки; у **value** — **независимые копии** и **`==`** по значению; **стек/куча** и **static/dynamic dispatch** — не визитка, **`Array`/`String`** — **struct** с **CoW** в куче.»

- **Устная заготовка (EN) — one line:** «**Value vs reference** is about **semantics**: classes share **identity** (`===`); values copy and compare with **`==`**; heap/stack and dispatch are details—**COW** collections are still **structs**.»

- **Follow-up (RU):** что такое **identity** vs **equality**? / почему `Array` — struct, но большой? / `===` для struct?
- **Follow-up answer (RU):** **Identity** — «тот же экземпляр» для ссылок (`===`). **Equality** — одинаковое **значение** (`==`). `Array` — **value semantics** + **CoW**, буфер в куче. У `struct` обычно **`===` не про копии значений** — сравнивают **`==`**.

- **Доп. информация:** выбор **`struct` vs `class`** — карточка **Q1**; отличия `class`/`struct` и нюанс коллекций — **Q46**; layout + dispatch — **Q47**, **Q48**; [Habr Q5](https://habr.com/en/articles/726388/).


### Q46
- **Question (RU):** чем **`class`** отличается от **`struct`**?
- **Question (EN):** What’s the difference between `class` and `structure`?
- **Answer (RU):** Зацепка с собеса: **`class` — reference semantics** (ссылочная семантика, **ARC**, общая **identity**); **`struct` — value semantics** (логически независимые копии, **`mutating`** для изменения в методе).

    **Таблица (часто догоняют):** у `struct` **нет наследования** и **`deinit`**; у `class` — **есть**. ARC считает ссылки на **экземпляр класса**; у `struct` ARC только на **хранимые reference-поля**.

    **Нюанс коллекций:** `Array` / `Dictionary` / `Set` — это **`struct`** (**value semantics** у контейнера), но элементы могут быть **ссылками** (`[UIViewController]`): копия массива — **своя** как значение контейнера, а **объекты классов** внутри остаются **теми же экземплярами** (алиасы на один объект), пока явно не копируешь граф объектов. Связка с **Copy-on-Write** у буфера — **Q2**.

- **Answer (EN):** `class` — **reference** semantics, **ARC**, inheritance, `deinit`. `struct` — **value** semantics, `mutating`, no inheritance/`deinit`. Standard collections are **structs** but may **store references**—copying the collection copies the container value, not necessarily duplicating class instances inside.

- **Устная заготовка (RU):** «`class` — ссылки и ARC; `struct` — копии и `mutating`; `Array` — struct, но элементы могут быть class — value у коробки, не у содержимого.»

- **Follow-up (RU):** когда выбираешь `struct` vs `class`? / CoW у `Array`? / shallow vs deep copy?
- **Follow-up answer (RU):** см. **Q1**; CoW — **Q2**; копия `[SomeClass]` — **shallow** по элементам по умолчанию.

- **Доп. информация:** **Q1** (выбор типа), **Q45** (value vs reference), **Q2** (CoW), **Q47–Q49** (layout, dispatch, `var b = a` / `inout`); [Habr Q6](https://habr.com/en/articles/726388/).


### Q47
- **Question (RU):** как **в памяти** устроены **`struct` с полем `class`**, **`class` со stored `struct`**, и **`let` struct** внутри класса? Связь со **стеком / кучей**?
- **Question (EN):** Memory layout: `struct` holding a class reference; `class` storing a `struct`; `let` struct property—vs stack/heap?
- **Answer (RU):** **`struct` с `var`/`let` полем класса** — тип остаётся **value**; в **inline-представлении** значения лежит **указатель** (обычно одно слово), объект класса — **в куче**. Копия `struct` — **shallow** по указателю: две структуры могут ссылаться на **один** объект. **«Struct = стек»** — неверно универсально: тот же `struct` может быть **полем класса** и тогда **весь inline-snapshot** лежит **внутри аллокации объекта в куче**.

    **`class` со stored property типа `struct`:** поля `struct` **встроены (embedded)** в layout экземпляра класса **на куче** — отдельной «кучи для struct» нет.

    **`let` vs `var` у property:** про **место** то же (inline в объекте класса); **`let`** — нельзя **перепривязать** свойство целиком после init, а не «struct переехал в стек».

- **Answer (EN):** A `struct` holding a class reference stores a **pointer inline** in the struct’s value; the class instance lives on the **heap**. Copying the struct copies the **pointer** (aliases). A `struct` stored inside a `class` is **embedded in that class instance’s heap allocation**. `let` affects **reassignment**, not “struct lives on stack.”

- **Устная заготовка (RU):** «Value-обёртка может держать pointer на кучу; копия struct — копия слов, не дублирование объекта класса. Где лежит snapshot — стек/куча/регистры от **контекста**; внутри `class` — всегда кусок **кучи** класса.»

- **Follow-up (RU):** shallow vs deep copy `[SomeClass]`? / retain cycles через поле класса?
- **Follow-up answer (RU):** массив копирует контейнер — элементы class **те же**; deep — явная логика. ARC — на **объект в куче**; циклы — через сильные ссылки, не «struct стал class».


### Q48
- **Question (RU):** как связаны **стек/куча** и выбор **реализации метода**? Что такое **vtable**, **witness table**, **static dispatch**?
- **Question (EN):** How do stack/heap relate to method dispatch? What are vtable, witness table, static dispatch?
- **Answer (RU):** Оси **разные**: стек/куча — **где лежат данные и кадры**; **таблицы** — **как** в рантайме выбрать реализацию при полиморфизме.

    - **Static dispatch** — компилятор знает конкретный тип: **прямой вызов** / инлайн (**`final`**, конкретный `struct`, generic с известным `T`).

    - **Динамика у `class`** — **vtable** в **class metadata**: массив указателей на реализации; вызов через **косвенный** слот (override подкласса).

    - **Протоколы / existential** — **witness table**: для пары (тип, протокол) хранятся указатели на реализации требований протокола; часто рядом **value witness** (copy/destroy/move) для упакованного value.

    - **@objc / NSObject** — отдельная линия **`objc_msgSend`** (селектор → IMP, кэш).

- **Answer (EN):** Stack/heap describe **where** values live; **dispatch** chooses **which function runs**. **Static** = direct call. **Classes** = **vtable** in metadata. **Protocols** = **witness tables** (+ value witnesses for existentials). **Obj-C interop** = `objc_msgSend` / runtime.

- **Устная заготовка (RU):** «Память и dispatch не путать: vtable у class metadata, witness у протокола, static — когда тип известен компилятору.»

- **Follow-up (RU):** почему existential «дороже»? / `final` и деvirtualization?
- **Follow-up answer (RU):** existential несёт **контейнер + witness**; `final`/`private` помогают компилятору снять динамику.


### Q49
- **Question (RU):** `var b = a` (**два `struct`**) и меняю **`b`** — что под капотом? И передача **`struct`** в функцию: по значению vs **`inout`**?
- **Question (EN):** Under the hood: `var b = a` for structs then mutate `b`; passing `struct` by value vs `inout`?
- **Answer (RU):** База — **value semantics**: **`b = a`** даёт **логически отдельное** значение `b`.

    - **Плоский маленький `struct`** (без внутреннего разделяемого буфера): копия **битового образа** полей; мутация **`b`** не трогает **`a`**.

    - **CoW-типы** (`Array`, `String`, `Dictionary`, …): после присваивания часто **общий буфер** в куче; при **первой мутации `b`**, если буфер ещё **разделяют** с `a`, делается **копия буфера**, затем запись — **`a`** остаётся со **старым** содержимым.

    - **`struct` с полем `class`**: в `b` копируется **указатель**; мутация **объекта по ссылке** видна через оба алиаса; переприсвоение **ссылочного поля** в `b` — не трогает `a` как value snapshot.

    - **В функцию `f(_ x: T)`** — семантика **копии** входного значения (ABI может оптимизировать передачу, модель для языка та же). **`inout`** — контракт **мутировать тот же** экземпляр по **адресу**, изменения видны вызывателю.

- **Answer (EN):** `b = a` copies value semantics-wise. Plain structs: field-wise copy; CoW containers may share a buffer until `b` mutates, then copy-on-write if still shared. `struct` with a class field copies the **pointer** (shallow). `f(_ x:)` passes a copy; `inout` mutates the caller’s storage in place.

- **Устная заготовка (RU):** «Две переменные struct — две копии значения; CoW откладывает копию **буфера** до записи; `inout` — мутируем исходный экземпляр по адресу.»

- **Follow-up (RU):** чем это отличается от **ARC**? / почему `Array` — struct?
- **Follow-up answer (RU):** ARC — учёт **ссылок на class**; CoW — **когда дублировать буфер** value-контейнера. `Array` — struct с **value semantics** + CoW.

- **Доп. информация:** **Q2**, **Q47**, **Q46**; [Habr Q7](https://habr.com/en/articles/726388/).


### Q50
- **Question (RU):** что значит префикс **`NS`** в типах Foundation?
- **Question (EN):** What does the `NS` prefix mean in Foundation types?
- **Answer (RU):** Зацепка: **`NS` = NeXTSTEP** — префикс символов **библиотек NeXTSTEP** (**Foundation**, **AppKit**); инженеры **NeXT** так пометили **свой** API. **NeXT** — компания Стива Джобса **после** ухода из Apple; **Apple купила NeXT** (сделка **1996–1997**), и **OPENSTEP / Cocoa** выросли из этого стека — префикс **сохранили** по всей платформе.

    **Почему вообще префикс:** в **Objective-C** у классов **глобальное** пространство имён (как в **C**), **нет** модулей/namespace как в C++ — префикс снижает **коллизии** между фреймворками и кодом приложения. В гайдлайнах Apple: **двухбуквенные** префиксы (**`NS`**, **`UI`**, **`CA`**, …) **зарезервированы** для **системных** фреймворков; **свои** классы в Obj-C — обычно **три буквы** (например `ABCMyController`).

    **Линия времени (устно):** **NeXTSTEP** (ОС) → участие в **OpenStep** (спецификация API с Sun) → **OPENSTEP** у Apple → **macOS / Cocoa**, **iOS / Cocoa Touch** — те же **NS*** типы поверх **Obj-C runtime**.

    **В Swift:** `NSString`, `NSArray`, `NSObject`… — **Obj-C классы**; со Swift-типами — **автоматический bridging** (`String` ↔ `NSString`, `Array` ↔ `NSArray` где применимо). Имена **без** `NS` у `String`/`Array` — потому что это **stdlib Swift**, не наследие NeXTSTEP. На платформах **без** Obj-C рантайма Foundation реализован как **swift-corelibs-foundation** (те же имена API, другой слой под капотом).

    **Рядом по смыслу:** **`CF*`** (**Core Foundation**, C API) — другой слой; с частью `NS*` существует **toll-free bridging** (например `NSString` ↔ `CFString`).

- **Answer (EN):** `NS` stands for **NeXTSTEP**: NeXT engineers prefixed symbols in NeXTSTEP’s **Foundation** / **AppKit**. After Apple acquired NeXT (1996–1997), that API became the core of Cocoa/Cocoa Touch. Objective-C has a **global class namespace**, so prefixes avoid collisions; Apple **reserves two-letter prefixes** for its frameworks (`NS`, `UI`, `CA`, …). In Swift, `NS*` types are Objective-C classes with **bridging** to Swift value types where defined; Swift stdlib types don’t carry the prefix.

- **Устный канон (опросник п.19 / H19, drill):** «**`NS` — NeXTSTEP**: API **NeXT**, после **покупки NeXT** стало основой **Cocoa**; в Obj-C **глобальные имена классов** → **префикс**; у Apple **`NS`/`UI`/… — системные**, свои классы — **три буквы**. В Swift — **bridging** к `String`/`Array` и т.д.»

- **Follow-up (RU):** почему в Swift нет префикса у `Array`?
- **Follow-up answer (RU):** нативные Swift-типы в **stdlib** без Obj-C префикса; `NSArray` — другой слой рантайма.

- **Follow-up (RU):** чем **`NS`** от **`UI`** / **`CA`**?
- **Follow-up answer (RU):** разные **фреймворки** в экосистеме Apple; в [Conventions](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Conventions/Conventions.html) у Apple есть таблица: **`NS`** — Foundation + AppKit (macOS), **`UI`** — UIKit (iOS), **`CA`** — Core Animation и т.д.


### Q51
- **Question (RU):** **`map`**, **`flatMap`**, **`compactMap`**, **`reduce`** в Swift и в **Combine**; чем **`flatMap`** от **`compactMap`**; какие ещё **комбинаторы** последовательностей полезно знать?
- **Question (EN):** `map` / `flatMap` / `compactMap` / `reduce` in Swift and Combine—distinctions and related sequence operators?
- **Answer (RU):** Зацепка: это в основном **функции высшего порядка** над **`Sequence` / `Collection`** (и над **`Publisher`** в Combine) — **трансформируют или агрегируют** поток элементов **без ручного цикла** (часто **читаемее** и композируемо с **`lazy`**).

    **`map`:** по каждому элементу **один результат** того же «размера» (тип может меняться): `[1,2].map { $0 * 2 }` → `[2,4]`.

    **`compactMap`:** как `map`, но замыкание возвращает **`Optional`**; из результата **выкидываются** `.none`, **остаются развёрнутые** значения. (Исторически тот кейс называли `flatMap` на последовательности — **deprecated** в пользу `compactMap`, см. **SE-0187**.)

    **`flatMap` (последовательность):** замыкание возвращает **другую последовательность**; все куски **склеиваются в один уровень** (не рекурсивно «до атома» — **один** уровень flatten). Пример: `[[1,2],[3]].flatMap { $0 }` → `[1,2,3]`. **Не путать** с `compactMap`: если вернуть **`String`** из `Character`-последовательности, `flatMap` может **развернуть посимвольно** — классический собеседовательский подводный камень.

    **`Optional.map` / `Optional.flatMap`:** `map` поднимает `Wrapped`; `flatMap` — **bind**: если внутри снова optional, **не получаем** `T??` «лесенку», а один уровень.

    **`reduce` / `reduce(into:)`:** свёртка в **одно значение**: начальное **accumulator** + замыкание `(acc, elem) -> newAcc`. **`reduce(into:)`** часто эффективнее для **мутируемого** накопителя (например `Set`, `Dictionary`), потому что не обязан каждый раз **копировать** весь аккумулятор.

    **Другие частые комбинаторы `Sequence`/`Collection` (не исчерпывающе):** **`filter`**, **`forEach`** (побочные эффекты, не цепочка значения), **`sorted` / `sorted(by:)`**, **`contains` / `allSatisfy` / `first(where:)`**, **`prefix` / `suffix` / `dropFirst` / `dropLast`**, **`prefix(while:)` / `drop(while:)`**, **`split`**, **`joined`**, **`enumerated`**, **`reversed`**, **`shuffled`**, **`min` / `max`**, **`count`**, **`elementsEqual`**, **`starts(with:)`**; **`zip`** — функция над двумя последовательностями; **`Dictionary(grouping:by:)`** — группировка. Расширения вроде **`chunked` / `windows`** — в пакете **Swift Algorithms**, не в stdlib.

    **Combine (идеи те же, другой тип):** **`map`**, **`tryMap`**, **`compactMap`**, **`flatMap(maxPublishers:)`** (подписка на **вложенный** publisher + политика **вложенных** потоков), **`scan`** (как «reduce во времени» по событиям), **`collect`**, **`reduce`**, **`filter`**, **`replaceNil`**, **`ignoreOutput`**, и т.д.

- **Таблица (Swift stdlib — комбинаторы и соседи):** ниже **практический набор** имён из **`Sequence` / `Collection` / `LazySequence`** и связанного API; **не** все сотни overload’ов из документации — полный индекс: [`Sequence`](https://developer.apple.com/documentation/swift/sequence), [`Collection`](https://developer.apple.com/documentation/swift/collection).

| Функция / метод | Описание |
| --- | --- |
| `map` | По каждому элементу строит новое значение; длина совпадает с исходной (для коллекций). |
| `compactMap` | Как `map`, но замыкание возвращает `Optional`; `.none` отбрасываются, остальное разворачивается. |
| `flatMap` (`Sequence`) | Замыкание возвращает **последовательность**; результаты **склеиваются на один уровень** (один проход flatten). |
| `filter` | Оставляет элементы, для которых предикат `true`. |
| `reduce` | Свёртка: начальное значение + `(acc, elem) -> acc` слева направо. |
| `reduce(into:)` | Свёртка с **мутируемым** аккумулятором `inout` — часто дешевле для `Set`/`Dictionary`. |
| `forEach` | Выполняет замыкание для побочных эффектов; **не** возвращает новую коллекцию для цепочки. |
| `sorted` / `sorted(by:)` | Возвращает **отсортированную** копию (для `Sequence` — массив). |
| `reversed` | Ленивое **обращение порядка** (`ReversedCollection`). |
| `contains` | Есть ли элемент (`Equatable`) или подстрока в строке — зависит от типа. |
| `contains(where:)` | Есть ли элемент, удовлетворяющий предикату. |
| `allSatisfy` | Все элементы удовлетворяют предикату (пустая — `true`). |
| `first(where:)` | Первый элемент по предикату или `nil`. |
| `last(where:)` | Последний элемент по предикату или `nil` (для bidirectional). |
| `first` / `last` | Первый/последний элемент коллекции (свойства). |
| `firstIndex(of:)` / `firstIndex(where:)` | Индекс первого вхождения. |
| `prefix(_:)` | Первые *n* элементов (тип зависит от базы). |
| `suffix(_:)` | Последние *n* (для коллекций с концом). |
| `prefix(while:)` | Префикс, пока предикат `true`. |
| `dropFirst` / `dropLast` | Отбросить первые/последние *n*. |
| `drop(while:)` | Отбросить префикс, пока предикат `true`. |
| `split(separator:)` / `split(...)` | Разбиение (часто для `String` / подпоследовательностей). |
| `joined` / `joined(separator:)` | Склейка подпоследовательностей в одну (`String`, массив массивов и т.д.). |
| `enumerated` | Пары `(offset, element)` с целочисленным смещением (с 0). |
| `zip` (глобальная) | Попарно сшивает **две** последовательности до минимальной длины. |
| `min` / `max` | Минимум/максимум по `Comparable`. |
| `min(by:)` / `max(by:)` | Минимум/максимум по пользовательскому сравнению. |
| `count` | Число элементов (для `Sequence` может быть O(n)). |
| `isEmpty` | Пустая ли последовательность. |
| `randomElement()` | Случайный элемент (нужен `RandomNumberGenerator`). |
| `shuffled()` | Перемешанная **копия** (для коллекций). |
| `elementsEqual` | Попарное равенство другой последовательности. |
| `starts(with:)` | Начинается ли с заданного префикса-последовательности. |
| `lazy` | Обёртка **`LazySequence`/`LazyCollection`** — цепочки `map`/`filter` без немедленных массивов до обхода. |
| `Optional.map` | Если есть `Wrapped`, применить функцию; иначе `.none`. |
| `Optional.flatMap` | «Bind»: если есть `Wrapped`, встроить второй `Optional` без `T??`. |
| `Dictionary(uniqueKeysWithValues:)` | Словарь из пар `(key, value)`; **дубликаты ключей** — нарушение предусловия (часто **trap** в debug). |
| `Dictionary(grouping:by:)` | Группировка элементов по ключу из замыкания. |

- **Таблица (Combine — частые операторы над `Publisher`):** неполный список; см. [Combine](https://developer.apple.com/documentation/combine).

| Оператор | Описание |
| --- | --- |
| `map` | Преобразует каждое значение потока. |
| `tryMap` | Как `map`, но может **бросить ошибку** → завершение с failure. |
| `compactMap` | Отбрасывает `nil` из опциональных результатов. |
| `flatMap(maxPublishers:_:)` | Подписка на **вложенный** `Publisher`; политика **сколько** внутренних одновременно. |
| `filter` | Пропускает только значения, проходящие предикат. |
| `reduce` | Свёртка потока в одно итоговое значение (по мере событий). |
| `scan` | Накопительное состояние на каждом событии (часто «как reduce, но эмитит промежуточные»). |
| `collect` | Собирает **все** (или по условию) значения в коллекцию и эмитит её. |
| `removeDuplicates` | Подавляет подряд идущие дубликаты (`Equatable` / ключ). |
| `replaceNil(with:)` | Заменяет `nil` на значение по умолчанию. |
| `ignoreOutput` | Игнорирует значения (оставляет завершения/тайминги для side-channel сценариев). |
| `merge` | Объединяет несколько потоков в один (порядок — кто пришёл). |
| `combineLatest` | При изменении любого из входов эмитит кортеж **последних** значений. |
| `zip` | Попарно синхронизирует потоки (как «медленный» задаёт темп). |
| `debounce` | Эмитит после **тишины** в окне времени. |
| `throttle` | Пропускает события не чаще заданного интервала (политики latest/first). |

- **Answer (EN):** `map` transforms each element. `compactMap` maps to `Optional` and drops `nil`s (replaces the old optional `flatMap` overload—SE-0187). `flatMap` on `Sequence` flattens one level of nested sequences—don’t confuse with `compactMap`. `reduce` folds a collection into one value; `reduce(into:)` is often better for in-place accumulation. Combine reuses the same vocabulary on `Publisher`s with streaming semantics (`flatMap` controls inner publishers, `scan` accumulates over time).

- **Устный канон (опросник п.21 / H21, drill):** «**`map`** — поэлементно; **`compactMap`** — `map` + **убрать nil**; **`flatMap`** на последовательности — **сплющить вложенные последовательности** (не то же, что `compactMap`); **`reduce`** — **свёртка** в одно значение, для мутации часто **`reduce(into:)`**. В **Combine** — те же идеи над **потоком событий**, плюс **`flatMap`** по **внутренним publisher’ам**.»

- **Follow-up (RU):** зачем **`lazy`**?
- **Follow-up answer (RU):** цепочка **`lazy.map.filter`** не строит **промежуточные массивы** целиком — элементы вычисляются **по требованию** при обходе (**индекс/итератор**); полезно на **больших** данных, но каждый проход может заново вычислять замыкания.

- **Доп. информация:** [Habr H21](https://habr.com/en/articles/726388/); [SE-0187 `compactMap`](https://github.com/apple/swift-evolution/blob/main/proposals/0187-introduce-filtermap.md); [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.21; [Swift Algorithms](https://github.com/apple/swift-algorithms); **V/20 Networking** (Combine в сетевом слое при необходимости).


### Q52
- **Question (RU):** **п.31 / H31** — зачем **`final`** у **класса** в Swift?
- **Question (EN):** Why mark a Swift class `final`?
- **Answer (RU):** Зацепка: **`final class`** — **наследование запрещено** целиком (ни один подкласс). Это **не** синоним слова **`static`** на методах: **`static`** у type method на классе означает **не переопределяется в подклассах** и вызывается как **`Type.method`** без полиморфизма по подтипу; **`final`** на **instance**-методе запрещает **override**; **`final class`** запрещает **весь** подкласс.

    **Зачем на собесе:** (1) **дизайн** — «этот тип не задуман как база». (2) **оптимизация** — компилятору проще **devirtualize** вызовы instance-методов, когда известно, что динамического подкласса нет (**не** «vtable исчезает всегда» как абсолют — формулировка «чаще прямой вызов / WMO» точнее). (3) **ясность** для читателя и ревью.

    **Связка с `open`:** **`public class`** вне модуля **наследовать нельзя** по умолчанию; **`open class`** — можно наследовать **вне модуля**; **`final`** добавляет запрет наследования **даже внутри модуля** (для `class` без `open` подклассы и так только внутри модуля — `final` всё равно усиливает намерение и оптимизации).

- **Answer (EN):** `final class` forbids subclassing entirely—design signal and enables more static devirtualization when the dynamic type can’t be a subclass. Don’t conflate with `static` on class methods (non-overridable, statically dispatched on the metatype). `open` controls subclassing across modules; `final` is stronger than “no open subclasses”—it means no subclasses at all.

- **Устный канон (опросник п.31 / H31, drill):** «**`final class`** — **никаких подклассов**; **замысел API** + **проще оптимизировать вызовы**; не путать с **`static`** на **type methods**.»

- **Формулировка с drill (п.31):** «**`final`** говорит системе, что **наследования не будет**; тогда компилятору проще **убрать лишнюю динамику** у вызовов (**devirtualize**), но это **не** то же самое, что ключевое слово **`static`** на **type method** — **`static`** про **метод типа** и отсутствие **override** у подклассов, а **`final class`** про **запрет всего класса как базы**.»

- **Follow-up (RU):** чем **`final`** от **`private` класса** по наследованию?
- **Follow-up answer (RU):** **`private class`** — видимость в файле; наследовать внутри файла теоретически можно, если не `final`. **`final`** — про **запрет подкласса**, не про видимость.

- **Доп. информация:** [Habr H31](https://habr.com/en/articles/726388/); [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.31; **Q48** (static vs dynamic dispatch); **`static` vs `class`** на type methods — рядом с темой **instance `final`** в начале файла (блок про методы и наследование).


### Q53
- **Question (RU):** **п.32 / H32** — что такое **`lazy`** в Swift?
- **Question (EN):** What is `lazy` in Swift?
- **Answer (RU):** Зацепка: **`lazy var`** — **хранимое** свойство, которое **инициализируется при первом обращении** (чтении), а не в момент готовности всего `self` в `init` (если только инициализация не началась и не упала раньше присваивания).

    - Только **`lazy var`**, не **`lazy let`**: после первого вычисления значение **фиксируется** как у обычного `var`.

    - Инициализатор обычно **`{ … }()`**; выполняется **один раз** при первом чтении.

    - **`self` должен быть полностью инициализирован** до доступа к `lazy` — отсюда типичный порядок: тяжёлые/зависимые поля выносят в `lazy`, чтобы не блокировать конструктор и не создавать циклы инициализации.

    - **Потокобезопасности нет:** первый одновременный доступ с нескольких потоков — **гонка**; для общего тяжёлого singleton в проде чаще **actor**, очередь или явная инициализация.

    - Не путать с **`lazy` у `Sequence`/`Collection`**: там ленивость цепочки **`map`/`filter`** без немедленных материализаций до обхода — см. follow-up у **Q51**.

- **Answer (EN):** `lazy var` defers initialization of a stored property until the first read; typically a once-run closure. Not `lazy let`. Requires fully initialized `self` before first access. Not thread-safe by default. Don’t confuse with `lazy` on sequences/collections.

- **Устный канон (опросник п.32 / H32, drill):** «**`lazy var`** — **первое чтение** запускает инициализацию **один раз**; не **`let`**; **`self` уже собран**; **потоки сами не защищены**; отдельно — **`lazy` на коллекциях** про **отложенный pipeline**, не про stored property.»

- **Формулировка с drill (п.32):** «**`lazy`** — это когда сущность **создаётся/поднимается только при первом обращении** к свойству, а не заранее.»

- **Follow-up (RU):** есть ли **`lazy var` на уровне файла/модуля** как у свойства типа?
- **Follow-up answer (RU):** **нет:** компилятор сообщает, что **глобальная** переменная **уже** инициализируется с отложенной семантикой (`lazy` там **нельзя** навесить явно — «already-lazy global»). Для **типа** (`struct`/`class`) — отдельное правило **`lazy var`**.

- **Доп. информация:** [Habr H32](https://habr.com/en/articles/726388/); [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.32; **Q51** follow-up про **`lazy.map`**.


### Q54
- **Question (RU):** **п.34 / H34** — чем **`Codable`** отличается от **`Encodable & Decodable`**?
- **Question (EN):** How does `Codable` differ from `Encodable & Decodable`?
- **Answer (RU):** **`Codable`** — это **`typealias`** для **`Encodable & Decodable`**; для типа, которому нужны **обе** стороны сериализации, пишут `Codable` как **короткий синоним**. Семантика та же, что «тип и кодируется, и декодируется».
- **Answer (EN):** `Codable` is a typealias for `Encodable & Decodable`—syntactic sugar when both directions are required.
- **Устный канон (опросник п.34 / H34, drill):** «**`Codable` = `Encodable & Decodable`** — **alias**, не отдельный магический протокол.»
- **Follow-up (RU):** когда писать только **`Decodable`**?
- **Follow-up answer (RU):** DTO **только ответа** API, конфиг «только читаем из JSON» — не обязан быть `Encodable`.
- **Доп. информация:** [Habr H34](https://habr.com/en/articles/726388/); [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.34; [Glossary Codable](../../XI.%20Резюме/Глоссарий/Glossary.md#glossary-codable).

### Q55
- **Question (RU):** **п.35 / H35** — зачем раздельно **`Encodable`** и **`Decodable`**?
- **Question (EN):** Why split `Encodable` and `Decodable`?
- **Answer (RU):** Разделение **контракта**: тип может **только уходить** на сервер (`Encodable`) или **только приходить** из JSON (`Decodable`) — не реализуешь лишнюю сторону; уже **поверхность API** и проще **тесты**/моки. Плюс явная документация намерения в публичных типах.
- **Answer (EN):** Split protocols narrow requirements—encode-only vs decode-only models without implementing both.
- **Устный канон (опросник п.35 / H35, drill):** «**Раздельно** — чтобы тип был **только вход** или **только выход** по контракту, без лишней реализации.»
- **Follow-up (RU):** можно ли **`Codable`** и вручную **`init(from:)`** без `encode`?
- **Follow-up answer (RU):** если нужен только decode — достаточно **`Decodable`**; `Codable` потребует и **`encode(to:)`** (или синтез с обеими сторонами).
- **Доп. информация:** [Habr H35](https://habr.com/en/articles/726388/); [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.35; **V/20 Networking** (DTO).

### Q56
- **Question (RU):** **п.38 / H38** — **`@escaping`** vs **non-escaping** closure?
- **Question (EN):** `@escaping` vs non-escaping closures?
- **Answer (RU):** **По умолчанию** замыкание в параметре функции — **non-escaping**: компилятор знает, что оно **не живёт дольше** вызова функции (вызов только синхронно внутри тела). **`@escaping`** — замыкание может быть **сохранено** и вызвано **позже** (completion handler, property, async) → нужна пометка; чаще вспоминают **`[weak self]`** против **retain cycle**.
- **Answer (EN):** Non-escaping closures can’t outlive the function call; `@escaping` allows storing/async completion—think capture lists and cycles.
- **Устный канон (опросник п.38 / H38, drill):** «**Non-escaping** — только **внутри** вызова; **`@escaping`** — **позже**; тогда **`weak self`**.»
- **Follow-up (RU):** почему компилятор разрешает **оптимизации** для non-escaping?
- **Follow-up answer (RU):** известен **контрольный поток** — нет утечки замыкания наружу, можно агрессивнее с захватами и порядком освобождения (детали — компилятор; на собесе достаточно «не уходит за пределы вызова»).
- **Доп. информация:** [Habr H38](https://habr.com/en/articles/726388/); [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.38; **II/07** retain cycles.

### Q57
- **Question (RU):** **п.39 / H39** — что делает **`inout`** у параметра?
- **Question (EN):** What does `inout` on a parameter mean?
- **Answer (RU):** Параметр передаётся как **ссылка на уже существующее** хранилище: функция может **мутировать** значение «на месте»; после выхода из функции изменения **видны** вызывающему. Для **value types** под капотом часто **копия + write-back**; для **классов** — мутируются **поля объекта** по ссылке на экземпляр. Нельзя передавать **let**, нужен **l-value**.
- **Answer (EN):** `inout` passes an addressable slot so the callee can mutate the caller’s variable; copy-in/copy-out for values; classes mutate fields through the reference.
- **Устный канон (опросник п.39 / H39, drill):** «**`inout`** — **изменить переданное** место в памяти вызывающего; не путать с **копией по значению**.»
- **Follow-up (RU):** можно ли **`inout`** и **`async`** вместе?
- **Follow-up answer (RU):** в современном Swift есть правила изоляции; на собесе достаточно: **`inout`** + асинхронность требуют **аккуратности** (эксклюзивный доступ, не держать `inout` через **suspension** без понимания — см. актуальные правила Swift про overlapping access).
- **Доп. информация:** [Habr H39](https://habr.com/en/articles/726388/); [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.39.

### Q58
- **Question (RU):** **п.40 / H40** — множественное **наследование классов** в Swift?
- **Question (EN):** Multiple class inheritance in Swift?
- **Answer (RU):** У **классов** — **нет** множественного наследования реализации (**single inheritance**). Можно **много протоколов** (`class C: P, Q`), композицию (**has-a**), **protocol extensions** для общего кода. Повторить «ромб» C++ в Swift для `class` нельзя.
- **Answer (EN):** Swift classes have single concrete superclass; compose behavior via protocols and extensions.
- **Устный канон (опросник п.40 / H40, drill):** «**Класс** — **один суперкласс**; **много протоколов**; композиция вместо второго суперкласса.»
- **Follow-up (RU):** чем **`protocol`** + default implementation от наследования?
- **Follow-up answer (RU):** нет **хранимого состояния** в протоколе (до **extension** с ограничениями); нет единой иерархии инициализации как у `class`; гибче миксовать поведение.
- **Доп. информация:** [Habr H40](https://habr.com/en/articles/726388/); [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.40.

<!-- knowledge-cards-canonical:end -->
