# Design Patterns

## Creational patterns — digest

**Источник:** [Порождающие паттерны проектирования. Примеры в iOS](https://ios-interview.ru/creational-design-patterns/) (iOS Interview).

**Контекст для собеседования (по смыслу статьи):** часто спрашивают обобщённо — «с какими паттернами работали», «назовите несколько знакомых»; формальные определения всех GoF встречаются реже, но знание идей помогает в коде и в разговоре. Всего в классике **23 GoF**-паттерна ([книга Gang of Four](https://www.litres.ru/dzhon-vlissides/patterny-obektno-orientirovannogo-proektirovaniya-64073196/), [Design Patterns — Wikipedia](https://ru.wikipedia.org/wiki/Design_Patterns)); в статье разобраны только **creational** (порождающие).

### Кратко: pattern → описание

| Pattern | Описание |
|--------|----------|
| **Abstract Factory** | Один абстрактный интерфейс «фабрики» создаёт **согласованное семейство** продуктов (например набор под одного производителя); клиент зависит от абстракций, а не от конкретных классов каждого продукта. |
| **Builder** | Пошаговая сборка **сложного объекта**; обычно отделяют **builder** (шаги конструирования) и **director** (закономерная последовательность шагов). В статье — пример «дом» из частей. |
| **Factory Method** | «Создатель» объявляет **фабричный метод** продукта; конкретный тип продукта выбирают **подклассы**. Близко к идее фабрики, но без акцента на **семействе** связанных продуктов, как в Abstract Factory. |
| **Prototype** | Новый объект через **клонирование** прототипа; важно различать **deep copy** и **shallow copy** (у автора: [копирование массива и структуры](https://ios-interview.ru/difference-copy-array-and-struct/#%D0%93%D0%BB%D1%83%D0%B1%D0%BE%D0%BA%D0%BE%D0%B5-%D0%BA%D0%BE%D0%BF%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5)). В iOS-примере статьи — **`NSCopying`**. |
| **Singleton** | Ровно **один экземпляр** + глобальная точка доступа (`shared`); в тексте отмечено: очень распространён, но нередко называют **anti-pattern** (скрытые зависимости, тестируемость, глобальное состояние). |

**iOS-зацепки из статьи:** `NetworkManager.shared` + `private init` для **Singleton**; **Prototype** через `NSObject`, `NSCopying`, `copy(with:)`.

Полные листинги — на сайте-источнике; в репозитории см. также [`design_patterns.playground`](design_patterns.playground/Contents.swift) и `DesignPatternsInSwift.playgroundbook/` (внизу файла).

<a id="ios-design-patterns-problem-first"></a>

## iOS design patterns — problem-first map

**Инфографика (11 паттернов):** [`assets/ios-design-patterns-overview.png`](assets/ios-design-patterns-overview.png).

### Mindset

- Паттерны — **не** синоним «CLEAN CODE» и не цель сама по себе: это **проверенные ответы на типовые проблемы** в коде.
- На старте звучат тяжело (**Delegate**, **Observer**, **Factory**, **Adapter**, **Strategy**…), но в проде ты уже видишь их в **UIKit**, **Foundation**, **SwiftUI** — важно назвать **какую боль** паттерн снимает.
- **Правило применения:** паттерн уместен, если код становится **проще, яснее и легче менять**; если только усложняет без реальной причины — не вводить.

### Quick reference

| Pattern | Problem it solves | iOS hook |
|--------|-------------------|----------|
| **Delegate** | Объект не должен знать все детали поведения — делегирует решение другому | `UITableViewDelegate`, `UITextFieldDelegate` |
| **DataSource** | UI не хранит данные — спрашивает «сколько и что показать» | `UITableViewDataSource`, `UICollectionViewDataSource` |
| **Observer** | Нужно **реагировать** на изменения / события без жёсткой связи | `NotificationCenter`, Combine, `@Published`, KVO |
| **Singleton** | Один общий экземпляр на приложение | `UserDefaults.standard`, `URLSession.shared` |
| **Factory** | Создание объектов размазано — централизовать и скрыть детали | фабрики модулей, `make*` / DI container |
| **Builder** | Сложная сборка с множеством шагов и параметров | `URLSessionConfiguration`, fluent config |
| **Coordinator** | VC не должен знать весь flow приложения | см. [IV/17 Navigation](../../IV.%20Архитектура/17%20Навигация,%20координаторы,%20deep%20links/Navigation-Coordinators-Deep-Links.md) |
| **Adapter** | Внешний / неудобный API → интерфейс приложения | DTO → domain model, legacy SDK wrapper |
| **Strategy** | Менять алгоритм без переписывания клиента | сортировка, фильтры, форматтеры, pricing rules |
| **Facade** | Подсистема сложная — экрану нужен простой вход | `ProfileService` поверх network + cache + storage |
| **Dependency Injection** | Класс сам создаёт зависимости — плохо тестировать | `init` + протоколы, composition root; см. [IV/16 DI](../../IV.%20Архитектура/16%20MVC%20→%20MVVM%20→%20VIPER%20→%20Clean%20→%20TCA/Architecture-MVC-MVVM-VIPER-Clean-TCA.md) (**Q51**) |

### Delegate (делегирование)

- **Проблема:** один тип не должен **решать всё** о поведении другого (высота ячейки, можно ли редактировать, что делать по тапу).
- **Идея:** владелец **спрашивает** делегата «как поступить»; ответственность **передана**, связь обычно **1:1** и слабая (`weak` delegate).
- **iOS:** `UITableViewDelegate`, `UITextFieldDelegate`, `UIScrollViewDelegate`, `CLLocationManagerDelegate`.
- **Не путать с:** **DataSource** (данные, не поведение) и **Observer** (push событий многим подписчикам).

### DataSource (источник данных)

- **Проблема:** список/сетка **не владеет** моделью данных.
- **Идея:** UI спрашивает: sections, rows, cell content — отдельный объект отвечает.
- **iOS:** `UITableViewDataSource`, `UICollectionViewDataSource`; в SwiftUI аналог — данные + `ForEach` / diffable sources.
- **Связь с Delegate:** часто **один объект** реализует оба протокола на маленьком экране; на собесе полезно **развести роли** в рефакторинге.

### Observer (наблюдатель)

- **Проблема:** при изменении состояния A объекты B, C должны **обновиться**, без прямых ссылок друг на друга.
- **Идея:** подписка на изменения / события; **1:N** доставка.
- **iOS:** `NotificationCenter`, KVO, Combine pipelines, `@Published` + `ObservableObject`, `@Observable`, `AsyncStream` (мост из push-источников — см. [II/08 Concurrency](../../II.%20Swift/08%20Swift%20Concurrency%20—%20async-await,%20actor,%20isolation/Swift-Concurrency.md)).
- **Осторожно:** глобальные нотификации без контракта `userInfo` → хрупкий код; предпочитать **узкий** канал (протокол, store, typed notification).

### Singleton (одиночка)

- **Проблема:** нужен **ровно один** shared resource (настройки, общий клиент).
- **Идея:** `static let shared` + ограниченный `init`.
- **iOS:** `UserDefaults.standard`, `URLSession.shared`, `FileManager.default`.
- **Цена:** скрытые зависимости, сложнее **unit-тесты**, глобальное состояние; альтернатива — **DI** + scoped lifetime в composition root.
- **Собес:** «знаю и использую системные singleton’ы; в своём коде не раздуваю всё в `*.shared`».

### Factory (фабрика)

- **Проблема:** `NewType()` разбросаны по проекту → зависимости и ветвления создания **везде**.
- **Идея:** **одно место** (или иерархия фабрик) знает, **какой конкретный тип** собрать; клиент зависит от абстракции.
- **iOS:** assembly в Coordinator / DI container; `enum Environment { case mock, prod }` → разные реализации репозитория.
- **Рядом с GoF:** **Factory Method** (подкласс выбирает продукт), **Abstract Factory** (семейство согласованных продуктов) — см. [creational digest](#creational-patterns--digest).

### Builder (строитель)

- **Проблема:** объект или конфигурация собирается **по шагам**, много опциональных полей, telescoping `init`.
- **Идея:** пошаговые методы / DSL → в конце `build()`.
- **iOS:** построение запросов, `URLSessionConfiguration`, тестовые фикстуры, сложные model/value types.
- **Не путать с:** **Factory** (кто создаёт **готовый** продукт целиком) и **Coordinator** (сборка **экрана/flow**, не value object).

### Coordinator (координатор)

- **Проблема:** `UIViewController` знает **куда push/present** и как собрать следующий модуль → «божественный» VC.
- **Идея:** отдельный тип владеет **навигацией и composition** экранов; VC/VM сообщает **намерение** («пользователь выбрал item»), не детали стека.
- **iOS:** child coordinators, deep links, tab flows — тема [IV/17](../../IV.%20Архитектура/17%20Навигация,%20координаторы,%20deep%20links/Navigation-Coordinators-Deep-Links.md); стек с **MVVM-C** — [IV/16](../../IV.%20Архитектура/16%20MVC%20→%20MVVM%20→%20VIPER%20→%20Clean%20→%20TCA/Architecture-MVC-MVVM-VIPER-Clean-TCA.md).

### Adapter (адаптер)

- **Проблема:** API бэка / SDK **не совпадает** с тем, что удобно домену и UI.
- **Идея:** тонкий слой **преобразует** интерфейс или модель (`APIUser` → `User`) без переписывания клиента.
- **iOS:** mapping слой в Data module Clean Architecture; wrapper над Objective-C SDK.
- **Не путать с:** **Facade** (упрощает **целую подсистему**, не только формат одной сущности).

### Strategy (стратегия)

- **Проблема:** в коде `switch` на алгоритмы (сортировка, валидация, ценообразование) — каждое новое правило **ломает** клиента.
- **Идея:** семейство взаимозаменяемых стратегий за **общим протоколом**; клиент держит `any SortingStrategy`.
- **iOS:** inject formatter/filter/sort; тесты подставляют stub strategy.
- **Swift:** предпочитать **протокол + struct** вместо иерархии классов GoF.

### Facade (фасад)

- **Проблема:** экрану нужен **один вызов** («загрузи профиль»), а внутри сеть + cache + Keychain + mapper.
- **Идея:** узкий публичный API скрывает подсистему.
- **iOS:** `ProfileService`, `AuthFacade`, repository с внутренними data sources.
- **Риск:** «божественный» фасад на весь app — дробить по **bounded context**.

### Dependency Injection (внедрение зависимостей)

- **Проблема:** тип внутри себя делает `URLSession.shared` / `ConcreteAPI()` → нельзя подменить в тесте.
- **Идея:** зависимости **передаются снаружи** (`init`, property, factory); сборка — в **composition root**.
- **Формы:** constructor (предпочтительно), property, method; container — осознанный компромисс vs service locator.
- **Связь:** улучшает **testability, flexibility, maintainability** (как на инфографике); канон для собеса — [IV/16 Q51](../../IV.%20Архитектура/16%20MVC%20→%20MVVM%20→%20VIPER%20→%20Clean%20→%20TCA/Architecture-MVC-MVVM-VIPER-Clean-TCA.md).

### When to skip a pattern

- Нет повторяющейся боли (один `if`, один экран).
- Абстракция **тяжелее** задачи (стратегия для одного сравнения).
- Паттерн дублирует то, что уже даёт **Swift** (value types, protocols, `async/await` вместо ручного Observer).

<a id="swift-patterns-under-the-hood"></a>

## Swift under the hood — language-level patterns

Паттерны — не только то, что ты **выбираешь** в архитектуре. Часть GoF уже **вшита в Swift и stdlib**: каждый `for-in`, `@State`, `sorted()` — ты стоишь на паттерне, даже если не называешь его. Задача — **узнавать** и применять **осознанно**, а не «случайно правильно».

### Quick reference (language)

| Pattern | Problem it solves | Swift hook | Deep dive |
|--------|-------------------|------------|-----------|
| **Iterator** | Обойти коллекцию, не раскрывая внутреннее устройство | `Sequence`, `IteratorProtocol`, `makeIterator()`, `for-in` | [Syntax & Idioms](../../swift/syntax/README.md) (combinators over `Sequence`) |
| **Decorator** | Добавить поведение полю/свойству без подкласса | `@propertyWrapper` — `@State`, `@Published`, `@AppStorage` | [SwiftUI model data](../../ios-sdk/swiftui/README.md) (`@ViewBuilder` — sibling: DSL-декоратор тела view) |
| **Observer** | Один источник изменений → много подписчиков | `didSet`, `NotificationCenter`, `@Published`, `AsyncStream` | [Observer](#observer-наблюдатель) выше; [Concurrency](../../swift/concurrency/README.md) (`AsyncStream`) |
| **Builder** | Собрать сложное значение по шагам, читаемо на call site | `@resultBuilder`, `ViewBuilder`, `SceneBuilder` | [SwiftUI `View` / `@ViewBuilder`](../../ios-sdk/swiftui/README.md); app-level [Builder](#builder-строитель) (`URLSessionConfiguration`) |
| **Prototype (CoW)** | Дорого копировать value; часто читают, редко мутируют | `Array`, `String`, `Dictionary` — shared buffer до первой мутации | [CoW Q-card](../../swift/syntax/README.md) |
| **Strategy** | Подменить алгоритм без правки клиента | протокол + `struct`; generics / `some` — compile-time; `any` — witness table | [Strategy](#strategy-стратегия) выше |
| **Facade** | Простой API поверх сложной подсистемы | `sorted()`, `JSONDecoder`, большая часть stdlib | [Facade](#facade-фасад) выше; [Foundation](../../ios-sdk/foundation/README.md) |
| **Command** | Отложить действие: определил сейчас, выполнил позже | closures, `Task { }`, `UIAction`, undo stacks | — |

### Nuances (interview)

- **`@Published`** — и Observer (рассылка), и Decorator (обёртка над stored property); на собесе полезно назвать **обе** роли.
- **Strategy «без dynamic dispatch»** — верно для `some Protocol` / monomorphic generics; у **`any Protocol`** — witness tables, паттерн тот же, стоимость другая.
- **Command:** предпочитай **`Task { }`** / async handlers в новом коде; `DispatchQueue.async` — legacy GCD, тот же паттерн.

## Apple docs

- [Cocoa Design Patterns](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaDesignPatterns/CocoaDesignPatterns.html) — MVC, delegation, notifications (классический справочник).
- [Protocols](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols/) — полиморфизм без наследования; основа многих GoF-адаптаций в Swift.
- [Generics](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics/) — параметрический полиморфизм вместо «всё NSObject».

## 🎯 Focus vs Defer

### Focus

- **Problem-first:** для каждого из **11 iOS-паттернов** (Delegate, DataSource, Observer, Singleton, Factory, Builder, Coordinator, Adapter, Strategy, Facade, DI) — **какую боль решает** + **1–2 API из UIKit/Foundation/SwiftUI**.
- **Swift under the hood:** **8 language-level** паттернов ([таблица](#swift-patterns-under-the-hood)) — Iterator, Decorator, Observer, Builder, Prototype/CoW, Strategy, Facade, Command; связь с stdlib и SwiftUI, не только app architecture.
- **Creational (GoF):** **Abstract Factory**, **Builder**, **Factory Method**, **Prototype**, **Singleton** — одна фраза «зачем»; для **Singleton** — плюсы/минусы и **DI** как альтернатива.
- **Развести пары:** Delegate vs DataSource vs Observer; Adapter vs Facade; Factory vs Builder; Coordinator vs «толстый» VC; Decorator (`@propertyWrapper`) vs Adapter (чужой API).

### Defer

- Заучивание всех **23** паттернов с UML до уровня экзамена без привязки к коду.
- Путаница **Adapter vs Decorator** до появления реальной задачи на совместимость API.
- «Паттерн ради паттерна» и «CLEAN CODE ради абстракции» в маленьких фичах без боли в тестах и сопровождении.

## 📚 Key terms (Q&A)

- **Delegate / DataSource:** поведение vs данные для UIKit-списков; слабая ссылка на delegate.
- **Observer:** push-события; носители — NotificationCenter, Combine, `@Published`, `AsyncStream`.
- **Singleton:** один `shared`; риски — тесты и глобальное состояние.
- **Factory / Abstract Factory:** кто создаёт объекты и как изолирует конкретные типы.
- **Builder:** пошаговая сборка сложного value/configuration.
- **Coordinator:** навигация и сборка flow вне VC — [IV/17](../../IV.%20Архитектура/17%20Навигация,%20координаторы,%20deep%20links/Navigation-Coordinators-Deep-Links.md).
- **Strategy:** взаимозаменяемые алгоритмы за протоколом.
- **Adapter / Facade:** один чужой API vs целая подсистема.
- **Dependency Injection:** зависимости снаружи — [IV/16 Q51](../../IV.%20Архитектура/16%20MVC%20→%20MVVM%20→%20VIPER%20→%20Clean%20→%20TCA/Architecture-MVC-MVVM-VIPER-Clean-TCA.md).
- **Prototype / copy:** `NSCopying`, value type copy semantics, deep vs shallow — [CoW](../../swift/syntax/README.md).
- **Iterator:** `Sequence` + `for-in`; custom traversal без раскрытия storage.
- **Decorator:** `@propertyWrapper` — поведение поверх свойства.
- **Command:** closure / `Task` / `UIAction` как отложенное действие.

## 🏋️ Exercises

1. Найти в проекте **три** разумных Singleton и **три** проблемных — обосновать; для проблемных — как перейти на **DI**.
2. На одном экране со списком: кто **DataSource**, кто **Delegate**, что уйдёт в **Coordinator** при добавлении второго flow.
3. Смоделировать **Factory** для аналитики: события разных типов, общий интерфейс `track`.
4. **Adapter:** описать mapping DTO → domain для одного endpoint; **Facade:** один метод сервиса, скрывающий network + cache.
5. **Strategy:** вынести сортировку/фильтр списка в протокол; unit-test с mock strategy.
6. **Swift under the hood:** для каждого из [8 language patterns](#swift-patterns-under-the-hood) — один пример из своего кода или stdlib; где паттерн уже есть «бесплатно», а где вводишь вручную.

## 🌟 Senior+ (strategic)

- Паттерн — имя для **компромисса**; на собесе важнее **мотивация и цена**, чем название из GoF.
- Паттерн полезен, если код **проще менять**; иначе — YAGNI.
- Связка **IV/16** (DI, MVVM), **IV/17** (Coordinator), **II/08** (Observer → async), **VI/23** (тесты фабрик и стратегий).
- Избегать «божественных» фасадов и service locator «на весь app».

## Артефакты

- Notes: `notes/`
- Exercises: `exercises/`
- Assets: `assets/`
- Playgrounds: `playgrounds/`

---

## Карточки знаний (Q&A)

### Q6
- **Question (RU):** Паттерны проектирования — это про «чистый код»? Зачем они на iOS?
- **Question (EN):** Are design patterns about clean code? Why do they matter on iOS?
- **Answer (RU):** Нет — это **именованные решения типовых проблем** (делегирование поведения, источник данных для списка, реакция на события, единая точка создания объектов). На iOS они **уже в SDK**: `UITableViewDelegate`, `NotificationCenter`, `URLSession.shared`. На собесе важнее **какую проблему снимает паттерн**, а не определение из книги.
- **Answer (EN):** Patterns name recurring solutions to recurring problems—not a clean-code badge. iOS APIs embody many of them; interview value is stating the problem solved and trade-offs.
- **Устный канон:** «Паттерн = **проблема → проверенный приём**; не вводить, если только усложняет.»
- **Доп. информация:** [problem-first map](#ios-design-patterns-problem-first); [Swift under the hood](#swift-patterns-under-the-hood); [`assets/ios-design-patterns-overview.png`](assets/ios-design-patterns-overview.png).
- **Playground:** [open](design_patterns.playground/Contents.swift)

### Q7
- **Question (RU):** **Delegate** vs **DataSource** vs **Observer** — в чём разница?
- **Question (EN):** Delegate vs DataSource vs Observer?
- **Answer (RU):** **Delegate** — «как вести себя» (можно ли редактировать, высота, тап); обычно **1:1**, `weak`. **DataSource** — «что показать» (sections/rows/cells). **Observer** — «что изменилось» → реакция у **многих** подписчиков (NotificationCenter, Combine, `@Published`). Не смешивать: список **не хранит** модель — спрашивает DataSource; **не оповещает** через delegate всех о смене темы — Observer/store.
- **Answer (EN):** Delegate answers behavior questions one-to-one; DataSource supplies data for lists; Observer broadcasts or streams changes to subscribers.
- **Устный канон:** «**DataSource** — данные; **Delegate** — поведение; **Observer** — события/состояние многим.»
- **Доп. информация:** [II/08](../../II.%20Swift/08%20Swift%20Concurrency%20—%20async-await,%20actor,%20isolation/Swift-Concurrency.md) (сравнение async API); [Cocoa Design Patterns](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaDesignPatterns/CocoaDesignPatterns.html).
- **Playground:** [open](design_patterns.playground/Contents.swift)

### Q8
- **Question (RU):** **Singleton** — когда ок и когда вреден?
- **Question (EN):** When is Singleton appropriate vs harmful?
- **Answer (RU):** **Ок:** системные shared (`UserDefaults.standard`, `URLSession.shared`), truly global resource с чётким lifecycle. **Вреден:** свой `NetworkManager.shared` на каждый сервис — скрытые зависимости, сложные тесты, глобальное mutable state. Альтернатива — **DI** + composition root ([IV/16 Q51](../../IV.%20Архитектура/16%20MVC%20→%20MVVM%20→%20VIPER%20→%20Clean%20→%20TCA/Architecture-MVC-MVVM-VIPER-Clean-TCA.md)).
- **Answer (EN):** Use system singletons knowingly; avoid sprinkling custom `.shared`—inject dependencies instead for testability and explicit boundaries.
- **Устный канон:** «Системный `shared` — да; **всё приложение в singleton** — нет, лучше **init injection**.»
- **Playground:** [open](design_patterns.playground/Contents.swift)

### Q9
- **Question (RU):** **Adapter** vs **Facade** — не одно и то же?
- **Question (EN):** Adapter vs Facade?
- **Answer (RU):** **Adapter** — **один** несовместимый интерфейс/модель → удобный для app (DTO → Entity, SDK wrapper). **Facade** — **простой вход** в **подсистему** из нескольких частей (network + cache + DB) без знания деталей. Adapter — про **совместимость**; Facade — про **упрощение границы**.
- **Answer (EN):** Adapter translates one foreign interface; Facade offers a narrow API over many internal collaborators.
- **Устный канон:** «**Adapter** — перевод API; **Facade** — один метод вместо трёх сервисов.»
- **Playground:** [open](design_patterns.playground/Contents.swift)

### Q10
- **Question (RU):** Зачем **Coordinator** если есть **MVVM**?
- **Question (EN):** Why Coordinator if you already use MVVM?
- **Answer (RU):** **MVVM** разводит UI и state экрана; **Coordinator** выносит **навигацию и сборку** следующих экранов — VM не должен знать `UINavigationController` и конкретный следующий VC. Вместе: **MVVM-C** ([IV/16](../../IV.%20Архитектура/16%20MVC%20→%20MVVM%20→%20VIPER%20→%20Clean%20→%20TCA/Architecture-MVC-MVVM-VIPER-Clean-TCA.md), детали flow — [IV/17](../../IV.%20Архитектура/17%20Навигация,%20координаторы,%20deep%20links/Navigation-Coordinators-Deep-Links.md).
- **Answer (EN):** MVVM handles screen state; Coordinator owns routing and module assembly so view models stay navigation-agnostic.
- **Устный канон:** «**MVVM** — экран; **Coordinator** — куда дальше и из чего собрать следующий модуль.»
- **Playground:** [open](design_patterns.playground/Contents.swift)

### Q11
- **Question (RU):** Какие паттерны **вшиты в Swift**, а не только в UIKit/SwiftUI?
- **Question (EN):** Which design patterns are built into Swift itself—not only the iOS SDK?
- **Answer (RU):** **Iterator** — `Sequence` / `for-in`; **Decorator** — `@propertyWrapper` (`@State`, `@Published`); **Observer** — `didSet`, notifications, `@Published`; **Builder** — `@resultBuilder` / `ViewBuilder`; **Prototype** — Copy-on-Write у `Array`/`String`; **Strategy** — протоколы и generics; **Facade** — stdlib (`sorted`, `JSONDecoder`); **Command** — closures, `Task`, `UIAction`. Смысл: ты уже пишешь на паттернах — важно **называть** проблему и не изобретать обёртку, если язык уже даёт механизм.
- **Answer (EN):** Swift embeds Iterator (`Sequence`), Decorator (`@propertyWrapper`), Observer, Builder (`@resultBuilder`), Prototype (CoW), Strategy (protocols/generics), Facade (stdlib), and Command (closures/async work items). Recognize them to use the language intentionally.
- **Устный канон:** «Паттерн в Swift — не всегда класс с именем *Strategy*; часто это **языковая фича**.»
- **Доп. информация:** [Swift under the hood](#swift-patterns-under-the-hood); [Syntax CoW](../../swift/syntax/README.md); [SwiftUI `@ViewBuilder`](../../ios-sdk/swiftui/README.md).

<!-- knowledge-cards-canonical:end -->
