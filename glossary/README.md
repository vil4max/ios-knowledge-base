# Glossary

Раздел **XI · Резюме** на [iosiq roadmap](https://iosiq.ru/roadmap.html): термины и короткие определения.

## Theme

### Q1
- **Question (EN):** What should this folder contain?
- **Answer (EN):** An extensible glossary (or digests from topics I–X) for quick recall before interviews or reviews.

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** что держать в этой папке?
- **Answer (RU):** свой расширяемый глоссарий (или выжимки из заметок по темам **I–X**), чтобы быстро вспоминать формулировки перед собесом или ревью.
- **Follow-up (RU):** как не дублировать темы?
- **Follow-up answer (RU):** здесь только термин → строка определения; развёрнутые Q&A остаются в папке соответствующей темы.

</details>

---

## Glossary of key terms


### Memory and data model

<a id="glossary-arc"></a>
**ARC** — *Automatic Reference Counting* — автоматический подсчёт ссылок; объект освобождается, когда у него 0 strong-ссылок.

<a id="glossary-weak"></a>
**weak** — необязательная ссылка (`Optional`); не удерживает объект в памяти — типичный способ разорвать цикл с делегатом или замыканием.

<a id="glossary-unowned"></a>
**unowned** — ссылка без удержания; предполагается, что объект переживёт ссылку; при ошибке жизненного цикла возможен краш при обращении.

<a id="glossary-retain-cycle"></a>
**Retain cycle** — взаимные strong-ссылки между объектами (или `self` в `@escaping` без `weak`), из-за чего память не освобождается.

<a id="glossary-value-type"></a>
**Value type** — `struct` / `enum` (и др.): семантика копирования; разделяемое владение через ссылку на буфер при COW у коллекций.

<a id="glossary-reference-type"></a>
**Reference type** — `class`: одна копия в куче, идентичность через ссылку; жизнь управляется ARC.

<a id="glossary-cow"></a>
**COW** — *Copy-On-Write* — при копировании крупных value-type (например `Array`) буфер разделяется до первой мутации, затем копируется.

<a id="glossary-shallow-copy"></a>
**Shallow copy** — *поверхностное копирование* — дублируется контейнер верхнего уровня, но вложенные **ссылочные** объекты остаются теми же экземплярами: копия и оригинал разделяют ссылки на общие `class` (или общий буфер до COW-разрыва).

<a id="glossary-deep-copy"></a>
**Deep copy** — *глубокое копирование* — копируется граф данных «вглубь»: вложенные объекты тоже получают независимые копии по смыслу задачи (часто вручную или через `Codable`/архивацию); в Swift универсального автоматического deep copy для классов нет.

### Swift Concurrency

<a id="glossary-actor"></a>
**actor** — тип в Swift, гарантирующий *serialised access* (последовательный доступ) к своему состоянию через изоляцию на своём executor.

<a id="glossary-mainactor"></a>
**@MainActor** — глобальный actor, привязывающий выполнение к main queue (UI и типичный main-thread API).

<a id="glossary-sendable"></a>
**Sendable** — маркерный протокол для типов, безопасных для пересечения *isolation domains* (границ изоляции) без гонок по данным.

<a id="glossary-nonisolated"></a>
**nonisolated** — член типа с actor isolation (например `@MainActor`), явно выполняемый **вне** изоляции этого актора; снимает автоматическую сериализацию с метода/свойства — нужна дисциплина, что туда передаётся и откуда вызывается.

<a id="glossary-nonisolated-unsafe"></a>
**nonisolated(unsafe)** — как `nonisolated`, но компилятор **не проверяет** безопасность доступа к состоянию; только как узкое исключение, когда инвариант доказан вручную.

<a id="glossary-async-await"></a>
**async / await** — на `await` выполнение приостанавливается; поток не занят блокирующим ожиданием I/O — рантайм может выполнять другую работу (альтернатива цепочкам completion handler).

<a id="glossary-task"></a>
**Task** — единица structured concurrency: наследует приоритет и контекст (в т.ч. отмену от родительской задачи).

<a id="glossary-structured-concurrency"></a>
**Structured concurrency** — иерархия `Task`/`async let`/`TaskGroup`: при выходе из scope родитель дожидается вложенных задач; отмена распространяется вниз.

<a id="glossary-isolation"></a>
**Isolation** — правило компилятора: код актора/`@MainActor` вызывается только с допустимого executor или через `await` при пересечении границы.

### Types and protocols

<a id="glossary-existential"></a>
**Existential** — тип `any P`: «коробка» для произвольной реализации протокола `P` в runtime (existential container / witness table).

<a id="glossary-opaque"></a>
**Opaque** — тип `some P`: конкретный тип известен компилятору, наружу виден только как соответствие `P` (opaque result type).

<a id="glossary-pat"></a>
**PAT** — *Protocol with Associated Types* — протокол с ассоциированными типами; нельзя использовать как обычный тип без конкретизации, `any`/`some` или type erasure по смыслу задачи.

<a id="glossary-generic"></a>
**Generic** — параметризация типа или функции placeholder-типом (`Array<Element>`, `func foo<T>(_: T)`).

<a id="glossary-type-erasure"></a>
**Type erasure** — обёртка (`AnySequence`, `AnyView`), скрывающая конкретный generic за одним протокольным типом для хранения в коллекции или публичного API.

<a id="glossary-pop"></a>
**POP** — *Protocol-Oriented Programming* — композиция поведения через протоколы и `extension` вместо глубокого наследования классов.

<a id="glossary-codable"></a>
**Codable** — синоним `Encodable & Decodable`; автоматический или ручной маппинг в JSON/plist и обратно.

<a id="glossary-equatable"></a>
**Equatable** — протокол логического равенства (`==`); основа для сравнения в тестах, `contains`, ветвлений по значению.

<a id="glossary-hashable"></a>
**Hashable** — над `Equatable`: хэш для элементов `Set` и ключей `Dictionary`; реализуют через `hash(into:)` — значение хэша между запусками процесса не гарантировано (рандомизация `Hasher`).

### UIKit

<a id="glossary-diffable-data-source"></a>
**Diffable Data Source** — API для `UICollectionView` / `UITableView` с автоматическими анимациями через snapshot диффа.

<a id="glossary-compositional-layout"></a>
**Compositional Layout** — декларативный layout для `UICollectionView`: items → groups → sections.

<a id="glossary-auto-layout"></a>
**Auto Layout** — система ограничений между view: позиция и размер выводятся из constraints, а не из фиксированных frame (адаптация к экрану и локализации).

<a id="glossary-safe-area"></a>
**Safe Area** — область контента внутри экрана с учётом вырезов, индикатора Home и клавиатуры; привязка UI к `safeAreaLayoutGuide`.

<a id="glossary-uiviewcontroller-lifecycle"></a>
**UIViewController lifecycle** — цепочка `loadView` → `viewDidLoad` → `viewWillAppear` → `viewDidAppear` → …; точки для загрузки данных и подписки на уведомления.

<a id="glossary-intrinsic-content-size"></a>
**Intrinsic Content Size** — «естественный» размер view по содержимому; влияет на разрешение constraints без явной ширины/высоты.

<a id="glossary-runloop"></a>
**RunLoop** — цикл обработки событий потока (на main: жесты, таймеры, источники ввода); долгая синхронная работа на main блокирует UI и отзывчивость.

<a id="glossary-kvo"></a>
**KVO** — *Key-Value Observing* — уведомления об изменении свойства по key-path; в Swift нужны `@objc` и `dynamic` (или NSObject-подклассы); аккуратно снимать наблюдение, чтобы не держать мёртвые ссылки.

### SwiftUI

<a id="glossary-state"></a>
**@State** — хранение value-type состояния, принадлежащего view; обновление `body` при изменении.

<a id="glossary-binding"></a>
**@Binding** — двусторонняя связь с состоянием родителя (`$foo`); не владеет значением.

<a id="glossary-observable"></a>
**@Observable** — (Swift 5.9+) макрос наблюдаемой модели; тонкие обновления view при изменении полей без ручного `objectWillChange`.

<a id="glossary-viewbuilder"></a>
**ViewBuilder** — `@resultBuilder` для DSL вложенных view в `body` и модификаторах.

### Swift syntax / DSL

<a id="glossary-optional"></a>
**Optional** — перечисление с кейсами `.some(Wrapped)` и `.none`; суффиксы `?` и `!` — сахар над Optional.

<a id="glossary-optional-chaining"></a>
**Optional chaining** — цепочка доступа через `?.`: если какое-то звено `nil`, результат всей цепочки — `nil`, правые выражения не вычисляются (*short-circuit*); тип результата остаётся Optional.

<a id="glossary-nil-coalescing-operator"></a>
**Nil-coalescing operator** — *оператор объединения с nil* — бинарный `??`: если слева не `.none`, возвращается развёрнутое значение; иначе вычисляется и возвращается правый операнд (правая часть **не** выполняется, если слева есть значение).

<a id="glossary-implicitly-unwrapped-optional"></a>
**Implicitly unwrapped optional** — *IUO* — тип `Wrapped!`; по сути тот же `Optional<Wrapped>`, но компилятор допускает доступ к `Wrapped` без явного `?`/`!`; при значении `.none` обращение даёт runtime-ошибку; уместен только там, где инвариант «значение есть к моменту использования» реально гарантирован (часто `@IBOutlet`, фазы инициализации).

<a id="glossary-pattern-matching"></a>
**Pattern matching** — сопоставление значения с **шаблоном**: `switch` / `if case` / `guard case` / `for case`, извлечение связанных значений у enum, распаковка кортежей, условия `where`; основа выразительного ветвления в Swift.

<a id="glossary-swift-operators-overview"></a>
**Операторы Swift (обзор)** — *Swift operators* — тернарный `? :`; **nil-coalescing** `??` и **optional chaining** `?.` — в отдельных пунктах; арифметика `+ - * / %`, сравнение `== != < > <= >=`, логика `&& || !`, присваивание `=` и составные `+=` … `>>=`; диапазоны `...` `..<` (в т.ч. односторонние); переполнение `&+ &- &* &/ &%`; идентичность ссылок `=== !==`; приведение `is` `as` `as?` `as!`; оператор замыкания `{ }`; пользовательские операторы через `operator` (`prefix` / `infix` / `postfix`) с приоритетом и ассоциативностью.

<a id="glossary-capture-list"></a>
**Capture list** — в замыкании `{ [weak self] in … }` явный список захвата; без него по умолчанию сильные ссылки и риск retain cycle.

<a id="glossary-concatenation"></a>
**Конкатенация** — *concatenation* — объединение данных в одно целое; чаще всего термин используют в значении склеивания строк.

<a id="glossary-escaping"></a>
**@escaping** — замыкание, которое может быть вызвано после выхода из функции (например callback в `URLSession`); захват `self` нужно делать осознанно (`weak`/`unowned` при необходимости).

<a id="glossary-guard"></a>
**guard** — ранний выход из функции; выпрямляет «happy path».

<a id="glossary-defer"></a>
**defer** — блок кода, выполняемый при **любом** выходе из текущего scope (в обратном порядке при нескольких `defer`) — удобно для симметричного cleanup.

<a id="glossary-throws-rethrows"></a>
**throws / rethrows** — `throws` — функция может завершиться с `Error`; `rethrows` — пробрасывает ошибку только если её кидает переданное замыкание.

<a id="glossary-inout"></a>
**inout** — параметр передаётся по ссылке для мутации внутри функции и виден снаружи после выхода.

<a id="glossary-property-wrapper"></a>
**Property wrapper** — синтаксис `@Wrapper var x`: компилятор генерирует хранение и доступ через тип обёртки (`@State`, `@Published`, …).

<a id="glossary-result-builder"></a>
**Result Builder** — декларативный синтаксис «как в SwiftUI `body`»; собирается через атрибут `@resultBuilder`.

### Network and storage

<a id="glossary-urlsession"></a>
**URLSession** — API HTTP(S): `data(for:)`, upload/download tasks, конфигурации и кэш; типичная основа REST-клиента.

<a id="glossary-rest"></a>
**REST** — стиль HTTP API: ресурсы, глаголы методов, коды ответа; не протокол, а соглашение.

<a id="glossary-json"></a>
**JSON** — текстовый формат обмена данными; в Swift обычно парсится через `Codable`.

<a id="glossary-keychain"></a>
**Keychain** — хранилище секретов, изолированное от приложения и защищённое системой (шифрование, политики доступа).

<a id="glossary-ats"></a>
**ATS** — *App Transport Security* — политика платформы: по умолчанию требование безопасного транспорта (HTTPS, современный TLS и ограничения на исключения).

<a id="glossary-certificate-pinning"></a>
**Certificate pinning** — клиент сверяет сертификат или публичный ключ сервера с заранее вложенным отпечатком (pin), а не только с системным trust store; усложняет MITM при компрометации CA, но усложняет ротацию сертификатов.

### Metrics, diagnostics, and tests

<a id="glossary-metrickit"></a>
**MetricKit** — фреймворк сбора метрик стабильности и производительности с реальных устройств (диагностика в поле).

<a id="glossary-instruments"></a>
**Instruments** — набор профайлеров Xcode: CPU, память, сеть, энергия, SwiftUI; поиск узких мест и утечек.

<a id="glossary-mcp"></a>
**MCP** — *Model Context Protocol* — открытый протокол подключения AI-ассистентов к внешним инструментам и данным.

<a id="glossary-unit-test"></a>
**Unit test** — проверка изолированной логики (модели, сервисы) с моками/стабами; без ручного UI.

<a id="glossary-ui-test"></a>
**UI test** — XCTest сценарии по accessibility tree на симуляторе или устройстве: сквозные пользовательские потоки.

### Build and project architecture

<a id="glossary-spm"></a>
**SPM** — *Swift Package Manager* — менеджер пакетов и зависимостей от Apple.

<a id="glossary-tuist"></a>
**Tuist** — инструмент генерации Xcode-проекта из Swift-описания (модули, таргеты, согласованная структура).

<a id="glossary-tca"></a>
**TCA** — *The Composable Architecture* (Point-Free) — модель **Reducer / State / Action** для композиции логики, часто со SwiftUI.

<a id="glossary-dsym"></a>
**dSYM** — отладочные символы для сопоставления адресов в crash-логах с исходными строками (в т.ч. из TestFlight/App Store Connect).

<a id="glossary-ci-cd"></a>
**CI/CD** — непрерывная интеграция и доставка: автоматические сборки, тесты и выкладка артефактов по пайплайну.

<a id="glossary-app-thinning"></a>
**App Thinning** — на стороне App Store пользователь получает «урезанный» билд: только исполняемый **binary slice** под архитектуру устройства и подходящие варианты ресурсов по idiom/scale; уменьшает размер загрузки (при необходимости вместе с *On-Demand Resources*).

### Processes and documents

<a id="glossary-rfc"></a>
**RFC** — *Request For Comments* — документ с предложением технического изменения (в т.ч. Swift Evolution).

<a id="glossary-adr"></a>
**ADR** — *Architecture Decision Record* — короткая запись принятого архитектурного решения с контекстом и последствиями.
