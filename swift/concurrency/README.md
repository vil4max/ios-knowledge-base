# Concurrency

## Материалы

- **Combine (interview sprint):** [notes/Combine-Interview-Roadmap.md](notes/Combine-Interview-Roadmap.md) — отдельный 6-дневный роадмап (операторы, Q&A, live-кейсы, recruiter bundle); теория «Combine vs Concurrency» — в Q&A ниже в этом файле
- Вводный конспект (RU): раздел [**Вводный конспект Swift Concurrency**](#concurrency-primer) в этом же файле — перед карточками **Q11–Q20**
- Статья (bookmark): [Actors vs Queues vs Locks в Swift](https://livsycode.com/best-practices/actors-vs-queues-vs-locks-in-swift/) — Livsy Code: защита shared state, плюсы/минусы, практика за пределами собеседований
- Конспект: [Stateless Actors (Matt Massicotte)](notes/Stateless-Actors-Massicotte.md) — [stateless actors](https://www.massicotte.org/stateless-actors/): actor без полей, `@globalActor` BackgroundActor, custom executor, FS как внешнее state; карточка **Q49**
- Конспект: [Swift 6 runtime concurrency crashes](notes/Swift-6-Runtime-Concurrency-Crashes.md) — [onmyway133](https://onmyway133.com/posts/how-to-avoid-swift-6-concurrency-crashes/): inherited isolation, `@Sendable` closures, Combine/delegate traps, crash symbols; карточка **Q50**
- Intro digest (social, URL позже): [notes/Swift-Concurrency-Intro-Social.md](notes/Swift-Concurrency-Intro-Social.md) — playground [SwiftConcurrencyPrimer.playground](SwiftConcurrencyPrimer.playground)
- Structured concurrency: [notes/Structured-Concurrency-What-Structured-Means.md](notes/Structured-Concurrency-What-Structured-Means.md) — [macguru.dev](https://macguru.dev/whats-that-structured-in-structured-concurrency/); playground [StructuredConcurrencyLab.playground](StructuredConcurrencyLab.playground)
- Playground: [ImageLoadingConcurrencyLab.playground](ImageLoadingConcurrencyLab.playground/Contents.swift)

### Actors vs Queues vs Locks (shared state)

Конспект по смыслу статьи выше + собеседовательный минимум «чем отличаются три способа защитить состояние».

- **Actor** — защита состояния на уровне языка (isolation, компилятор, `Sendable`, доступ через `await`).
- **DispatchQueue** — ручная сериализация выполнения (порядок и «кто на какой очереди» задаёшь сам).
- **Lock** — низкоуровневый замок вокруг маленького участка кода (критическая секция).

Все три решают похожую задачу, но **разной ценой** по сложности, проверяемости и интеграции с async-моделью.

**Где хорошо заходят actors**

- код уже в Swift Concurrency;
- состояние логически принадлежит одной сущности;
- хочется помощи компилятора с isolation и `Sendable`;
- нормальная модель доступа через `await`.

Actors полезны не потому что «новые», а потому что **делают границы доступа явными**.

**Нюанс:** `await` внутри метода актора — точка, где **атомарность не гарантируется**. Actor сериализует доступ к своему состоянию, но не отменяет **перезаходы (reentrancy)** и не превращает цепочку вызовов в «транзакцию».

**Где всё ещё уместны queues**

- legacy на GCD;
- нужно аккуратно сериализовать работу без полной миграции на async/await;
- много callback-based API вокруг;
- уже есть выделенная очередь подсистемы: database queue, storage queue, parsing queue.

DispatchQueue — не «устаревший плохой способ», а инструмент, где **порядок, блокировки и переходы между очередями контролируешь сам** → сам же отвечаешь за дедлоки, лишние переключения контекста и растущую сложность.

**Где могут выигрывать locks**

- очень маленькая синхронизация в критической секции;
- доступ должен быть **синхронным**, без `await`;
- защита простого значения или короткой операции;
- actor был бы архитектурно тяжелее самой задачи.

**Минусы locks**

- у компилятора почти нет модели твоей синхронизации;
- нельзя держать lock через `await`;
- длинная critical section быстро бьёт по производительности;
- неправильный порядок захватов → deadlock.

**Сводка**

- **Actors** — разумный дефолт для нового async-кода.
- **Queues** — практичный мост для существующей архитектуры.
- **Locks** — точечный инструмент для маленьких синхронных участков.

Не нужно переводить всё на actors только из‑за строгости Swift 6. Не нужно тащить locks туда, где нужна нормальная модель владения и изоляции.

## Структура топика

- `notes/` — Q&A + ссылки на Apple docs
- `exercises/` — упражнения с expected outcome
- `playgrounds/` — runnable примеры
- `assets/` — файлы и PDF, привязанные к теме

---

## 🎯 Фокус vs можно отложить (вопрос → ответ)

- `async/await`, `Task`, `TaskGroup` — основа.
  - **Ответ**: `async` функция может приостанавливаться; `await` — точка suspension (поток не “занят ожиданием”). `Task` запускает асинхронную работу, `TaskGroup` — структурированную параллельность и контролируемое ожидание всех подзадач.  
    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/`

- `actor`, `@MainActor`, isolation domains.
  - **Ответ**: actor защищает своё состояние: доступ к actor-isolated данным требует `await` (и выполняется последовательно). `@MainActor` — глобальный актор для UI‑кода (всё, что трогает UIKit/SwiftUI state). “Isolation domain” — граница, внутри которой данные считаются безопасными без блокировок.  
    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/`

- `Sendable`, data races на компиляции.
  - **Ответ**: `Sendable` — обещание, что значение безопасно “передавать” между concurrency domains. В strict mode компилятор предупреждает/ошибается, когда потенциально делишь mutable state между задачами. Это не “формальность”, а защита от data race на ранней стадии.  

- Structured vs unstructured concurrency.
  - **Ответ**: structured — задачи живут внутри scope (`withTaskGroup`, `async let`) и автоматически ждутся/отменяются вместе с родителем. Unstructured (`Task {}`) — задача живёт отдельно, ответственность за lifecycle/отмену чаще на тебе.  
    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/`

- Cancellation: `Task.checkCancellation`, `withTaskCancellationHandler`.
  - **Ответ**: отмена — кооперативная. Задача должна проверять cancellation и корректно выходить/чистить ресурсы. `withTaskCancellationHandler` помогает гарантировать cleanup при отмене.  
    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/#Task-Cancellation`

- Bridge от GCD/callback API через `withCheckedContinuation`.
  - **Ответ**: continuations — способ обернуть callback API в `async`. `withCheckedContinuation/withCheckedThrowingContinuation` добавляют runtime‑проверки корректности (resume ровно один раз). Это мост для миграции legacy‑кода.  
    Docs: `https://developer.apple.com/documentation/swift/withcheckedcontinuation(function:_:)`

### Отложить

- Custom Executor — экзотика, нужно редко.
- distributed actor — пока редкость.
- Глубокая интеграция с Combine (если проект новый, можно начинать без).

## 📚 Что учить по уровням

### JUNIOR

- Разница sync/async и зачем нужен `await`.
- `Task { ... }` в UI обработчике + `await URLSession`.
- Обёртка callback API через `withCheckedContinuation`.
- Понимать, что `@MainActor` нужен для UI.

### MIDDLE

- `TaskGroup`/`withTaskGroup` для параллельных задач, сбор результатов.
- Actor для защиты состояния: reentrancy, priority inversion (концептуально).
- `Sendable`, `@unchecked Sendable`, `@preconcurrency import` (и когда это “костыль”).
- Cancellation: `checkCancellation()`, `withTaskCancellationHandler`.
- `AsyncSequence`, `AsyncStream`.

### SENIOR

- Включить Swift 6 strict concurrency на модуле и починить предупреждения.
- Дизайн isolation domains (actors/global actors).
- Осознанное применение `nonisolated(unsafe)` (как исключение).

### TECH LEAD

- План миграции команды на Swift 6 (фазы, временные `@preconcurrency`).
- Code review стандарт: что блокируем сразу, что допускаем временно.
- Onboarding набор по Concurrency.

### STAFF/PRINCIPAL

- Единая стратегия isolation для организации.
- Внутренние библиотеки/абстракции поверх Concurrency.
- Внутренний доклад/гайд по миграции и best practices.

## 🌟 Strategic (Senior+/Tech Lead)

### План миграции на strict concurrency (большой проект)

- **Ответ**: “просто включить” strict mode на крупной кодовой базе обычно нельзя. Нужна поэтапная миграция:
  - начать с одного модуля/границы (Networking/Domain/UI)
  - включать strict concurrency по частям (таргеты/модули)
  - фиксировать прогресс (кол-во warning/ошибок)
  - временно использовать `@preconcurrency import` для legacy зависимостей (как костыль с дедлайном)
  - точечно `@unchecked Sendable` только после доказательства immutability/потокобезопасности
  - добавлять правила в code review, чтобы не плодить регресс
  Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/`

### Архитектурные паттерны: `@MainActor-only` vs Domain actors

- **Ответ**: это стратегическое решение:
  - `@MainActor-only` архитектура упрощает reasoning, но рискует “таскать работу на main” и увеличивать latency UI.
  - Domain actor (например `@DataActor`) даёт “зону” для бизнес-логики/состояния вне main, улучшает масштабируемость и снижает риск data races.
  - Граница должна быть явной: где разрешены мутации, где только immutable snapshots, где переходы на main.
  Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/`

### Обучение команды (enablement)

- **Ответ**: Senior = “команда знает”.
  - code review с фокусом на concurrency (что блокируем, что допускаем временно)
  - короткие доклады/воркшопы и “onboarding набор” (шпаргалка + упражнения)
  - измерять эффект: меньше data races, меньше регрессий, быстрее ревью

## 🏋️ Упражнения (10) — обязательная практика

1) Bridge: `URLSession.dataTask(with:completion:)` -> `async` через `withCheckedContinuation`
  - **Ожидаемый результат**: обёртка возвращает `Data`/`Response` и резюмится ровно один раз; ошибки пробрасываются через `throw` (лучше `withCheckedThrowingContinuation`).  
    Docs: `https://developer.apple.com/documentation/swift/withcheckedcontinuation(function:_:)`

2) TaskGroup: скачать 10 картинок параллельно через `withTaskGroup`, сохранить порядок
  - **Ожидаемый результат**: запуск параллельно, но результат собирается в массив исходного порядка (например, возвращать `(index, image)` и сортировать/складывать по индексу).  
    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/`

3) Actor: `actor BankAccount` с `deposit/withdraw`, 100 параллельных депозитов
  - **Ожидаемый результат**: итоговый баланс корректен (без гонок), потому что доступ к состоянию actor сериализован.  
    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/#Actors`

4) Race condition: class с мутабельным массивом, 1000 паралл. `append`, поймать data race в Thread Sanitizer
  - **Ожидаемый результат**: при включенном TSan получаешь data race; фиксы: actor/serial queue/lock или сделать состояние immutable.  
    Docs (TSan/Xcode): `https://developer.apple.com/documentation/xcode/diagnosing-memory-thread-and-crash-issues-early`

5) `@MainActor`: найти 3 места обновления UI без `@MainActor`, добавить аннотацию
  - **Ожидаемый результат**: компилятор/рантайм гарантирует, что UI-мутирующий код выполняется на main actor.  
    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/`

6) `Sendable`: объявить `struct User` и передать в `Task`
  - **Ожидаемый результат**: если появляются предупреждения strict concurrency — исправить: сделать `User: Sendable` (и гарантировать immutability), либо изолировать доступ через actor.  

7) Cancellation: загрузка, которая корректно отменяется при `Task.cancel()`
  - **Ожидаемый результат**: отмена приводит к выходу из работы без “допрожима”; используешь `Task.checkCancellation()` и/или `withTaskCancellationHandler` и отменяешь underlying `URLSessionTask`/child tasks.  
    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/#Task-Cancellation`

8) AsyncSequence: своя `AsyncSequence`, выдаёт значения каждые 1с
  - **Ожидаемый результат**: корректный producer/consumer, завершение (finish) и реакция на cancellation. Практично делать через `AsyncStream`.  
    Docs: `https://developer.apple.com/documentation/swift/asyncstream`

9) Reentrancy: внутри actor вызвать `await` другого actor и объяснить “переплетение”
  - **Ожидаемый результат**: понимать, что actor может освобождать executor на `await`, и другие сообщения к actor могут выполняться между suspension points (reentrancy).  
    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/#Actors`

10) Migrate to Swift 6: включить `SWIFT_STRICT_CONCURRENCY=complete`, исправить warning
  - **Ожидаемый результат**: проект собирается в strict mode; решения: `Sendable`, `@MainActor`, actors, изоляция, временно `@preconcurrency import`/`@unchecked Sendable` только когда доказана безопасность.  
    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/`

---

## TL;DR

- `async` означает, что функция может быть приостановлена и продолжена позже.
- `await` обозначает suspension point — место, где выполнение может уступить executor.
- Во время ожидания поток не блокируется, а используется для другой работы.
- `async` API вызываются только из async-контекста или через `Task { }`.

## Базовая модель

`async/await` — это не просто синтаксис для callback. Компилятор строит state machine:

- при `await` текущее состояние сохраняется;
- задача может быть приостановлена;
- после завершения операции выполнение продолжится с той же точки.

Это даёт линейный читаемый код, но требует дисциплины по cancellation и actor isolation.

## Когда использовать

- Любой код, который требует асинхронных операций (сетевые запросы, I/O), но нужно писать в линейном стиле.

## Частые ошибки

- `await` в sync-функции без `Task` или без перевода функции в `async`.
- Избыточные `Task { }` вместо structured concurrency.
- Игнорирование cancellation (`Task.isCancelled`, `CancellationError`).
- Ожидание, что `await` автоматически отправит работу на background thread.

## Практические правила

- Если нужно стартовать асинхронную работу из sync-кода — создавай `Task { }`.
- Держи список suspension points коротким и понятным для дебага.
- Для UI-обновлений используй `MainActor` явно.
- Для небольшого числа независимых параллельных вызовов чаще подходит `async let`.

## Мини-пример

```swift
func loadUserAndPosts(api: APIClient) async throws -> (User, [Post]) {
    async let user = api.fetchUser()
    async let posts = api.fetchPosts()
    return try await (user, posts)
}
```

## Ссылки

- Swift Book — Concurrency: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/`

---

## TL;DR

- `Task` — это не только “запустить что-то в фоне”, а универсальная абстракция будущего значения.
- Дескриптор задачи можно передавать между слоями как контракт: “результат появится позже”.
- Во многих сценариях координации достаточно одного `Task` + `await value`, без лишних `DispatchGroup`/семафоров.
- Для запуска async-кода из sync callback `Task` остаётся базовым мостом.
- В современных сценариях важно различать `Task.detached` и `Task { @concurrent in }` с точки зрения контекста.

## Источник

- [The versatility of tasks](https://macguru.dev/the-versatility-of-tasks/)

## 1) Task как future/promise-контракт

Когда сохраняем `Task<Success, Failure>` и передаём дальше, мы передаём не поток/очередь, а дескриптор будущего результата.  
Это позволяет:

- ожидать значение в другом месте приложения;
- координировать потребителей одного и того же результата;
- не плодить отдельные примитивы синхронизации.

Ключевая идея: думать не “где выполнится код”, а “какое значение появится потом”.

## 2) Task как точка согласования

Состояние самой задачи (завершена/отменена/вернула значение) безопасно для конкурентного доступа на уровне модели задачи.  
Практический эффект:

- несколько async-потребителей могут ждать один и тот же `task.value`;
- первый “производитель” результата закрывает потребность остальных;
- меньше инфраструктурного кода вокруг оркестрации.

Это не отменяет требований к thread safety данных внутри вашего домена, но упрощает слой координации.

## 3) Task как вход в async из sync API

Completion handlers, делегаты, callback-и UI часто синхронные, а внутри нужно вызвать `async` функцию.  
`Task` даёт стандартный и читаемый вход в async-контекст без обходных решений.

## 4) `Task.detached` vs `Task { @concurrent in }`

В статье акцент на том, что у `detached` есть семантическая цена: потеря части контекста задачи (включая Task Local values).  
Для “вынести выполнение в concurrent-контекст, но не потерять важную связность” в новых подходах рассматривается `Task { @concurrent in }`.

Практическое правило: использовать `detached` только когда действительно нужна изоляция от родительского контекста.

## Почему это важно в архитектуре

Если воспринимать `Task` только как “фон”, архитектура быстро обрастает лишними abstraction layers.  
Если воспринимать `Task` как value-oriented контракт зависимости, можно:

- упростить orchestration-код;
- сделать зависимые операции более прозрачными;
- уменьшить число ручных точек синхронизации.

## Практические выводы / что брать в работу

- Перед добавлением нового coordination-механизма проверить, можно ли выразить сценарий через `Task` дескриптор.
- Хранить и передавать `Task` там, где нужен shared future result для нескольких потребителей.
- `Task.detached` использовать только по явной архитектурной причине.
- При миграции legacy callback-кода сначала строить корректный async boundary через `Task`, потом упрощать поток данных.

## Мини-чеклист

- В задаче действительно нужен новый actor/publisher, или хватит `Task` + `await value`.
- Нет ли лишнего `detached`, где критичен контекст родительской задачи.
- Явно ли описано, кто создаёт `Task`, кто владеет жизненным циклом и кто ждёт `value`.
- Нет ли дублирующих синхронизационных примитивов поверх того, что уже даёт `Task`.

---

## TL;DR

- В Swift 6 компилятор строже проверяет actor isolation и `Sendable`, особенно в DI/callback API.
- Обычный параметр `operation: () async throws -> R` часто воспринимается как потенциально cross-actor.
- `@isolated(any)` на типе функции позволяет переносить информацию об изоляции вместе с function value.
- `#isolation` помогает явно подхватить и передать текущий isolation context вызывающего кода.
- На практике это уменьшает boilerplate (`@MainActor` в каждом втором closure) и делает concurrency-контракты чище.

## Источник

- Статья: `https://fatbobman.com/en/posts/letting-swift-closures-automatically-inherit-isolation/`
- Swift Evolution:
  - `https://github.com/apple/swift-evolution/blob/main/proposals/0431-isolated-any-functions.md`
  - `https://github.com/swiftlang/swift-evolution/blob/main/proposals/0420-inheritance-of-actor-isolation.md`

## Почему возникает проблема

В коде вида:

```swift
func withDependencies<R>(
    operation: () async throws -> R
) async rethrows -> R {
    try await operation()
}
```

компилятор не всегда может вывести, что замыкание безопасно выполняется в том же actor-контексте, что и caller (например, `MainActor`).  
Из-за этого появляются ошибки/предупреждения по изоляции и `Sendable`, даже когда логически код “должен работать”.

## Что даёт `@isolated(any)` (SE-0431)

Аннотация на function type:

```swift
operation: @isolated(any) () async throws -> R
```

говорит, что closure несёт динамическую информацию о своём actor-isolation.  
Итог:

- вызывающая сторона может передавать closure без лишних ручных аннотаций;
- компилятор лучше понимает, что не любой вызов — cross-actor;
- меньше ложного “шумового” concurrency-boilerplate.

## Что даёт `#isolation` (SE-0420)

`#isolation` предоставляет текущее isolation окружение в вызывающем контексте и помогает “пробросить” его дальше в API.  
Это особенно полезно в обёртках и инфраструктурном коде (DI helpers, тестовые harness-обёртки, callback bridges).

## Где это особенно полезно

- DI utilities (`withDependencies`, `withEnvironment`, scoped overrides).
- Test helpers, где важно сохранить контекст изоляции test actor/`MainActor`.
- API-мосты между sync callbacks и async функциями.
- Переиспользуемые обёртки вокруг `Task`/операций, где раньше приходилось добавлять `@MainActor in` вручную.

## Практические выводы / что брать в работу

- Для closure-параметров в concurrency-heavy API рассматривать `@isolated(any)` как дефолтный кандидат.
- В инфраструктурных helper-функциях использовать `#isolation`, когда нужно явно наследовать контекст caller-а.
- Не превращать это в “магическую панацею”: всё равно проектируй явные границы actor ownership.
- При миграции на Swift 6 сначала чистить контракты изоляции в общих utility-слоях — это убирает большую часть шума в feature-коде.

## Мини-чеклист

- Closure-параметр в API теряет isolation-контекст? Проверь необходимость `@isolated(any)`.
- Есть повторяющиеся `@MainActor` аннотации только ради компилятора? Проверь `#isolation`/API-контракт.
- DI/test helper явно документирует, в каком actor-контексте выполняет `operation`.
- Нет ли реального cross-actor доступа, который случайно замаскирован синтаксическим “успокоением” компилятора.

---

## 1) Командный контракт (code review rules)

### Must

- **UI updates только на MainActor**  
  **Правило**: любые изменения UI/API UIKit/SwiftUI делаем из `@MainActor` контекста.  
  Docs: `https://developer.apple.com/documentation/swift/mainactor`

- **Shared mutable state защищаем isolation доменом**  
  **Правило**: мутабельное состояние либо внутри `actor`, либо строго на одном actor’е/очереди (если legacy), но не “просто class + locks по настроению”.  
  Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/#Actors`

- **Cancellation — часть API**  
  **Правило**: любая длительная async-операция корректно реагирует на отмену (периодические `Task.checkCancellation()` или cancellation-aware primitives).  
  Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/`

  Docs: `https://developer.apple.com/documentation/swift/sendable`

### Avoid

- **`Task.detached` без явной причины**  
  **Почему**: отрывает контекст (priority, task-local, actor), усложняет отмену/трассировку.  
  Разрешено только для реально независимых фоновых работ.

- **`@unchecked Sendable` “чтобы заткнуть warning”**  
  **Почему**: это ручное обещание отсутствия data race, которое невозможно проверить автоматически.  

- **`nonisolated(unsafe)` как дефолт**  
  **Почему**: быстро превращает строгую модель в набор исключений.

### Temporary allowed (только с тикетом и дедлайном)

- `@unchecked Sendable` — только для обёрток над immutable/атомарными структурами, с описанием инвариантов.
- Legacy GCD/locks — только в “legacy boundary” слое, который закрыт адаптерами/фасадами.

## 2) Миграция: фазы, метрики, Definition of Done

### Фаза 0 — Инвентаризация

- Выделить зоны:\n  - UI слой (`@MainActor`)\n  - Domain/State слой (actors)\n  - Networking/Storage слой (async API)\n  - Legacy boundary (GCD/callback)\n+- Составить список “горячих точек”: shared state, callbacks, глобальные синглтоны.

### Фаза 1 — Async API на границах

- Перевести публичные API на `async/await`.\n- Обернуть callback-API через continuations (checked).  
Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/`

### Фаза 2 — Isolation domains

- Определить ownership состояния:\n  - `actor` для долгоживущего state\n  - `@MainActor` для UI state\n- Убрать “параллельные” записи в один объект.

### Фаза 3 — Strict concurrency (постепенно)

- Включать строгий режим по модулям/таргетам.\n- Сначала чинить warnings в критических модулях (где больше всего гонок).

### Метрики прогресса

- Количество concurrency warnings (по модулю).\n- Количество “temporary allowed” аннотаций (`@preconcurrency`, `@unchecked Sendable`) — должно падать.\n- Количество data race/crash в TSAN на целевых сценариях.

### Definition of Done (для модуля)

- 0 concurrency warnings в выбранном режиме.\n- Нет “temporary allowed” без тикета.\n- Добавлен smoke-набор тестов/сценариев (минимум TSAN прогон в CI или локально по чеклисту).\n- Документирован isolation дизайн (кто владеет каким state).

## 3) Мини чеклист code review

- Есть ли `@MainActor` там, где трогаем UI?\n- Переходит ли мутабельный state между тасками/очередями?\n- Отрабатывает ли cancellation?\n- Если появился `@unchecked Sendable`/`@preconcurrency` — есть ли причина и тикет?\n- Используется ли structured concurrency (`TaskGroup`) вместо разрозненных `Task`?

---

<a id="concurrency-primer"></a>

## Вводный конспект Swift Concurrency

Правило терминов: **English term (кратко по-русски)**.

Цель: **опорные вводные**, если Swift Concurrency пока «плывёт». Дальше в этом же файле — секция **Карточки знаний (Q&A)** (**Q11–Q20**). Примеры: [`TaskVersatility.playground/Contents.swift`](TaskVersatility.playground/Contents.swift).

Официальная база: [Concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/) в Swift Language Guide.

Параллельное чтение «в одну идею» (изоляция, офисная метафора, Approachable Concurrency, типичные ошибки): [notes/Approachable-Swift-Concurrency-Site-RU.md](notes/Approachable-Swift-Concurrency-Site-RU.md).

---

## 1. Зачем это приложению

- **Main thread** (**главный поток**) обслуживает ввод и отрисовку UI. Долгая работа на нём даёт **freeze** (подвисание интерфейса).
- Нужно уметь **делать работу не на main** и **безопасно** возвращать результат туда, где разрешено трогать UI.
- Старая модель: **GCD** (`DispatchQueue`), completion handlers. Новая нативная модель языка: **`async`/`await`**, **`Task`**, **`actor`**, **`Sendable`**.

---

## 2. Синхронный код vs асинхронный

- **Синхронная** функция выполняется до конца без «остановок посередине» с точки зрения вызывающего (пока не вернула значение или не бросила ошибку).
- **`async` function** (**асинхронная функция**) может **приостановиться** на **`await`**: поток не обязан простаивать — runtime может занять его другой задачей. После **`await`** выполнение **продолжается**, но состояние мира могло измениться (**suspension point** / **точка приостановки**).

Интуиция: **`await`** — это «жду результат другой асинхронной операции», без блокировки потока навечно в одном стеке как при busy-wait.

---

## 3. `Task` — единица асинхронной работы

- **`Task { ... }`** создаёт задачу, которая выполняет **`async`** код.
- У задачи есть **родитель** (кто её создал) в иерархии **structured concurrency** (**структурированная конкурентность**): отмена и ошибки могут распространяться по дереву задач (упрощённо).
- **`Task.detached { ... }`** (**detached task** / отсоединённая задача) стартует **без наследования контекста** родителя — отдельная тема для Q11.

<a id="concurrency-primer-s3-1"></a>

### 3.1. Что такое «context» в вопросе про `Task` vs `Task.detached`

Грубо **context** (**контекст**) — это «из какой изолированной области и с какими наследуемыми настройками эта задача живёт». В наследование входят не все детали мира, но практически важны:

- изоляция (**actor** / **`MainActor`**) — если родительская задача была привязана к **`MainActor`**, дочерняя **`Task { }`** это часто **наследует**, и код внутри может трогать UI без отдельного **`await MainActor.run`**;
- **`TaskLocal`** — локальные для задачи значения (аналог «контекста запроса»), которые **`Task { }`** наследует, а **`detached`** — по умолчанию нет;
- связанные с политикой выполнения ожидания (упрощённо: приоритеты / кооперативная отмена в связке с родителем).

**Вывод для Q11:** **`Task { }`** — наследует контекст; **`Task.detached`** — стартует «с чистого листа» по этим наследуемым вещам. Это не значит, что **`detached`** «всегда плохой» — его используют, когда нужен работник **вне** текущего контекста (осторожно с UI).

---

<a id="concurrency-primer-s4"></a>

## 4. Actor и изоляция (**actor isolation**)

- **`actor`** — тип, который **сериализует** доступ к своим **mutable** (**изменяемым**) полям: в один момент времени выполняется только один **`async`** метод актора для мутаций (упрощённо). Это снижает **data race** (**гонку данных**) на этих полях.
- **Изоляция** (**isolation**): код «принадлежит» актору или глобальному актору **`MainActor`** — компилятор проверяет, откуда можно вызывать.

---

<a id="concurrency-primer-s5"></a>

## 5. `@MainActor`

- **`@MainActor`** помечает тип или метод как выполняемый на **main actor** (грубо — связка с главным потоком для UI).
- UIKit/SwiftUI состояние экрана обычно трогают с **`MainActor`**. Тяжёлую работу не кладут туда.

---

<a id="concurrency-primer-s6"></a>

## 6. `Sendable`

- **`Sendable`** (**протокол передачи между доменами конкурентности**) — контракт «это значение можно безопасно передать в другую изолированную область» без порчи данных.
- Для **reference types** (**ссылочных типов**) это часто боль; язык требует явных решений (**`actor`**, **`@unchecked Sendable`**, рефакторинг).

---

<a id="concurrency-primer-s7"></a>

## 7. Отмена (**cancellation**)

- В Swift Concurrency отмена **кооперативная** (**cooperative**): **`task.cancel()`** выставляет флаг; код должен периодически проверять **`Task.isCancelled`** или **`try Task.checkCancellation()`**.
- Отмена **не гарантирует** мгновенную остановку тяжёлого синхронного куска без проверок.

---

<a id="concurrency-primer-s8"></a>

## 8. `async let` и `TaskGroup` (очень кратко)

- **`async let`** — несколько фиксированных параллельных подзадач в одной области.
- **`TaskGroup`** — динамическое число дочерних задач (например по массиву id).

---

## 9. Continuation (**withCheckedContinuation**)

- Мост из callback-API в **`async`**: получаешь **`continuation`**, вызываешь **`resume`** ровно один раз, когда пришёл legacy callback. Инвариант Q18: **ровно один** **`resume`**.

---

## 10. Частые заблуждения

1. **`async` сам по себе не создаёт поток** — он описывает приостанавливаемую работу; исполнение планирует runtime.
2. **`MainActor`** ≠ «всё потокобезопасно»: разные акторы и **`nonisolated`** код всё ещё могут дать гонки без дисциплины.
3. **`actor`** не отменяет долгую работу сам — нужна отмена и разбиение на **`await`**.
4. **`Task.detached`** не «быстрее по умолчанию» — он **другой по контексту** и часто опаснее для UI.

---

## 11. Карта: вводный конспект → Q11–Q20

| Q | О чём |
|------|--------|
| Q11 | `Task {}` vs **`Task.detached`** — наследование **context** |
| Q12 | **Actor isolation** — зачем актор |
| Q13 | **Reentrancy** — состояние между **`await`** |
| Q14 | **Cancellation** — кооперативность, проверки |
| Q15 | **`@MainActor`** — UI vs тяжёлая работа |
| Q16 | **`Sendable`** — границы доменов |
| Q17 | **`async let`** vs **`TaskGroup`** |
| Q18 | **Continuation** — один **`resume`** |
| Q19 | **Priority inversion** — см. также GCD-плейграунд |
| Q20 | Тестирование **`async`** кода |

---

## 12. Дальше по плану

1. Прочитать этот раздел целиком (можно два прохода).
2. Открыть **`TaskVersatility.playground`** и пройти примеры глазами.
3. Пройти секцию **Карточки знаний (Q&A)** ниже (в т.ч. **Q11–Q20**, если держишь эти id).

---

## Карточки знаний (Q&A)

Ниже — Q&A по теме.

<!-- knowledge-cards-canonical:start -->

### Q11
- **Question (RU):** **structured `Task { }`** vs **`Task.detached { }`**?
- **Question (EN):** `Task {}` vs `Task.detached`?
- **Answer (RU):** `Task { }` (structured task / дочерняя задача в иерархии) наследует контекст места создания: изоляцию (`actor` / `@MainActor`), значения `TaskLocal`, связь с родительским `Task` (отмена и ошибки распространяются по дереву упрощённо). `Task.detached { }` стартует без этого наследования — «чистый лист» по перечисленным вещам.

    Важно: речь не про «внешний мир приложения», а про наследуемый concurrency-context родительской задачи; из‑за `detached` код часто оказывается не там, где ожидал разработчик (см. follow-up).
- **Answer (EN):** `Task { }` is a structured child task that inherits context from where it was created: `actor` / `MainActor` isolation, `TaskLocal` values, and the relationship to the parent `Task` (cancellation and errors propagate through the hierarchy in broad strokes). `Task.detached { }` starts without inheriting that bundle—it’s a fresh slate for those inherited attributes.

    “Context” here means inherited concurrency context, not “anything external”; `detached` is easy to misuse because execution may leave the isolation or locals you relied on.
- **Устная заготовка (RU):**

    1. `Task` — наследует контекст родителя: `MainActor`, `TaskLocal`, дерево задач.
    2. `detached` — без наследования; типичный баг — UI не на main или потерян request-id из `TaskLocal`.
    3. `detached` осознанно — когда нужен работник вне текущего контекста.

- **Устная заготовка (EN):**

    1. `Task` inherits parent context: `MainActor`, `TaskLocal`, structured hierarchy.
    2. `detached` drops inheritance—classic bug is UI updates off the main actor or lost `TaskLocal`.
    3. Use `detached` only when you want that clean break.

- **Follow-up:** пример бага из-за потери **inherited task context** (наследуемого контекста задачи)?
- **Follow-up answer:** `Task.detached` после вызова с `@MainActor` или из актора: внутри detached нет наследования `MainActor` — прямое изменение `UIKit`/`SwiftUI` state может дать предупреждения рантайма, артефакты или crash; лечение — `await MainActor.run { … }` или не использовать `detached` для UI-bridge. Второй пример: потерян `TaskLocal` (например request ID / correlation id) — логи и метрики перестают склеиваться с цепочкой запроса. Третий угол: ожидали связанную отмену родителя — поведение для `detached` иное, задача «оторвана» от structured отмены (детали зависят от кода, но на собесе достаточно назвать риск).
- **Доп. информация:** приоритеты и тонкие эффекты планировщика — вторичны для короткого ответа; если уводят глубже — см. [§ 3.1 (Task и context)](#concurrency-primer-s3-1) и TaskVersatility (detached vs `TaskLocal`). Когда `detached` оправдан: долгоживущий фон без привязки к UI-актору, явная изоляция своим `actor`, сознательный обход наследования `MainActor`.

### Q12
- **Question (RU):** что такое **actor isolation** (изоляция актора)?
- **Question (EN):** What is actor isolation?
- **Answer (RU):** actor isolation (изоляция актора) — правило языка и рантайма: код и данные актора доступны извне через его интерфейс так, что мутации состояния актора не выполняются параллельно — доступ сериализован (serialized / выстроен в очередь), в один момент времени обрабатывается один изолированный вызов, который может менять `mutable state` (изменяемое состояние). Это убирает data races (гонки данных) на состоянии этого актора.

    Интуиция: не «один HTTP-запрос», а одна очередь исполнения (executor) для изолированных методов актора; `await` внутри метода может отпустить актор для другого вызова — см. Q13 (reentrancy).
- **Answer (EN):** Actor isolation means the language/runtime ensures serialized access to an actor’s mutable state: isolated calls run one at a time on the actor’s executor, so two mutations can’t race inside that actor. That prevents data races on the actor’s own storage.

    Note: `await` inside an actor method can suspend and let another actor call run—reentrancy is a separate caveat (see Q13).
- **Устная заготовка (RU):**

    1. Изоляция актора — сериализованный доступ к его **mutable state** (изменяемому состоянию), одна мутация за раз.
    2. Цель — убрать data race на состоянии этого актора.
    3. `await` не отменяет изоляцию навсегда — между `await` состояние могло измениться (Q13).

- **Устная заготовка (EN):**

    1. Actor isolation serializes mutations to the actor’s state—one at a time.
    2. It prevents data races on that actor’s storage.
    3. `await` can allow interleaving—state may change across suspension (Q13).

- **Follow-up:** какие проблемы actor не решает?
- **Follow-up answer:** актор не делает «всё приложение безопасным»: **data races** возможны между разными акторами, между `actor isolation` и `nonisolated`-участками (`nonisolated` — см. блок Пояснения к атрибутам выше), и при передаче ссылок без `Sendable` / без копирования value-снимков. `@MainActor` — отдельный глобальный актор для UI; ошибочно думать, что любой `actor` «автоматически про UI». Актор не отменяет долгий синхронный CPU (центральный процессор) сам по себе — нужна кооперативная отмена (Q14). Диск/сеть и внешние ресурсы остаются отдельными контрактами (идемпотентность, транзакции, ошибки). Два актора + общий reference type без дисциплины — классический источник гонок вне одного актора.
- **Доп. информация:** формально изоляция — в Swift Book (Concurrency); связка с `Sendable` — Q16. Карта терминов — [§§ 4–5](#concurrency-primer-s4) (actor / `@MainActor`).

### Q13
- **Question (RU):** почему опасна **actor reentrancy** (повторный вход в актор)?
- **Question (EN):** Why is actor reentrancy dangerous?
- **Answer (RU):** reentrancy (повторный вход) у актора — это не «второй поток внутри одной мутации», а следствие suspension (приостановки) на `await`: текущий изолированный метод отпускает актор, пока ждёт внешнюю `async` работу. За это время другой изолированный вызов к тому же актору может выполниться и изменить `mutable state`. Когда первый метод продолжается, его локальные предположения об инвариантах могут быть уже ложными — классический источник логических багов при том, что data race на одном хранилище актора по-прежнему запрещён правилами изоляции (Q12).

    Иными словами: изоляция сериализует входы, но не замораживает состояние на время `await`.
- **Answer (EN):** Actor reentrancy is tied to `await`: while an isolated method is suspended waiting on async work, the actor can process other isolated calls. Those calls may mutate the actor’s state. When the first method resumes, assumptions checked before the suspension may no longer hold—even though you still don’t get an intra-actor data race on that storage (Q12).

    Isolation serializes entry, but it does not freeze state across `await`.
- **Устная заготовка (RU):**

    1. На `await` метод отпускает актор — другой вызов может поменять состояние.
    2. Инвариант «проверил до `await`» после `await` может быть сломан — перепроверить или работать со снимком.
    3. Reentrancy ≠ deadlock: у актора часто нет mutual deadlock на своём методе, но состояние «плывёт» между `await`.

- **Устная заготовка (EN):**

    1. `await` lets other isolated calls run and mutate state.
    2. Re-check invariants after suspension—or use value snapshots.
    3. Contrast reentrancy vs deadlock: state can drift across `await` even without classic deadlock.

- **Итог одной фразой (RU):** на `await` актор отпускается, другой изолированный вызов может изменить state; инварианты после `await` перепроверяю или работаю со снимком значений.
- **Итог одной фразой (EN):** on `await` the actor is released; another isolated call may change state; after `await` I re-check invariants or work from a value snapshot.

- **Follow-up:** как проектировать **invariants** вокруг **suspension point** (точки приостановки)?
- **Follow-up answer:** паттерн «проверил инвариант → `await` → перепроверить или работать на снимке значений»; разбить алгоритм на фазы и хранить минимум shared mutable между фазами. Учитывать вложенные пути к тому же актору (другой метод или косвенный вызов), которые могут выполниться во время вашего `await`. На собесе полезно явно сказать reentrancy vs deadlock: изоляция не даёт «блокировки навсегда» — она сериализует входы, но не замораживает состояние между `await`; для долгих операций добавляют отмену (Q14).
- **Доп. информация:** связка с Q12 (изоляция) и Q14 (отмена между фазами). Подробнее о терминах — [вводный конспект](#concurrency-primer).

### Q14
- **Question (RU):** как работает **cancellation** (отмена) в Swift Concurrency?
- **Question (EN):** How does cancellation work in Swift concurrency?
- **Answer (RU):** отмена в Swift Concurrency в первую очередь выставляет флаг (запрос на отмену) у `Task` и не обрывает выполнение задачи насильно — не процесс приложения, а именно исполнение этой задачи продолжается, пока код сам не «увидит» отмену. Это кооперативная (cooperative) модель, не преемптивная (не вытесняющая: рантайм не прерывает насильно выполнение посередине произвольного синхронного куска). `Task.cancel()` или отмена родителя в structured concurrency именно помечают задачу; код задачи должен явно проверять отмену: `Task.isCancelled`, `try Task.checkCancellation()` (кидает `CancellationError`), часть `async` точек на `await` учитывает отмену в зависимости от API (например `try await Task.sleep`).

    В structured задачах отмена родителя обычно доходит до дочерних задач в том же дереве; `Task.detached` и долгоживущие задачи без проверок могут «не заметить» отмену долго.
- **Answer (EN):** Cancellation sets a flag (cancellation request) on the `Task` and does not forcibly abort that task’s execution—the app process keeps running; work continues until the task observes cancellation. That makes it cooperative, not preemptive (the runtime does not forcibly interrupt arbitrary synchronous work mid-instruction). `Task.cancel()` / parent cancellation marks the task; your code checks `Task.isCancelled`, calls `try Task.checkCancellation()` (throws `CancellationError`), and many `await` APIs observe cancellation when implemented that way.

    In structured tasks, parent cancellation typically propagates to child tasks; `Task.detached` and tight synchronous loops without checks can ignore cancellation until they `await` or poll.
- **Устная заготовка (RU):**

    1. Отмена — флаг / запрос, код сам проверяет `isCancelled` / `checkCancellation`.
    2. Без проверок цикл на CPU (центральном процессоре) может закончиться полностью — отмена не «убивает поток».
    3. Перед дорогим шагом — `try Task.checkCancellation()` как явная cancellation point.

- **Устная заготовка (EN):**

    1. Cancellation is a flag; you `checkCancellation` / read `isCancelled`.
    2. A tight sync loop won’t stop by itself—still cooperative.
    3. `try Task.checkCancellation()` before expensive work is a common explicit cancellation point.

- **Итог одной фразой (RU):** выставляется флаг отмены у задачи, выполнение не обрывается само по себе — кооперативно выходим через `await` / `checkCancellation`.
- **Итог одной фразой (EN):** cancellation sets a flag on the `Task`—execution doesn’t stop by itself; the task cooperatively exits via `checkCancellation` / `await`.

- **Follow-up:** где добавлять **explicit cancellation point** (явную точку отмены)?
- **Follow-up answer:** перед тяжёлым шагом (сеть, большой парсинг, пакетная обработка): `try Task.checkCancellation()`; в циклах — периодическая проверка `Task.isCancelled` или `checkCancellation`, чтобы не крутить миллионы итераций после отмены. Для `async let` и `TaskGroup` важно понимать, как отмена родителя взаимодействует с дочерними задачами (structured propagation). Отмена не заменяет таймауты на уровне `URLSession` и не гарантирует мгновенный stop произвольного `defer`/cleanup без `Task`-aware логики — на собесе достаточно назвать кооперативность и явные точки. Связка с Q13: между фазами с `await` состояние могло измениться и задача могла быть отменена — проверять перед следующей мутацией.
- **Доп. информация:** [§ 7 (отмена)](#concurrency-primer-s7); детали API — Swift Language Guide (Concurrency). Пересечение с Q11 (`detached` и дерево отмены).

### Q15
- **Question (RU):** когда ставить `@MainActor`?
- **Question (EN):** When do you use `@MainActor`?
- **Answer (RU):** `@MainActor` помечает тип / метод / свойство так, чтобы выполнение шло в изоляции `MainActor` (глобальный актор для main actor). На Apple-платформах это стык к UI: обновление `UIKit` / `SwiftUI` и `Observable` / моделей, напрямую читаемых UI, держат на `MainActor`, потому что визуальный контур ожидается на главном потоке (практически тот же смысл, что «UI — с main»). `@MainActor` — не ручной `Thread.isMainThread`, а контракт изоляции, который компилятор и рантайм соблюдают вместе с `async`/`await`.

    `MainActor` — про связку с UI: на нём держат то, что напрямую кормит интерфейс (`UIKit` / `SwiftUI`, `Observable`, состояние экрана). Задачи не про UI (сеть, парсинг, диск, тяжёлая работа на **CPU** (центральном процессоре)) выносят из-под глобальной изоляции `MainActor` — отдельный `actor`, сервис без `@MainActor` на типе, `Task` вне `MainActor` — а результат подтягивают на `MainActor`, когда нужно обновить UI-состояние (`await MainActor.run { … }`, вызов `@MainActor`-метода и т.п.): это не только **redraw** (перерисовка), но и любая легальная мутация того, что UI читает.

    Не размещают на `MainActor` тяжёлую работу CPU (центрального процессора) / IO — иначе главный актор (и главный поток для UI) захламляется, растёт latency и фризы.
- **Answer (EN):** Use `@MainActor` to isolate UI-touching code on the `MainActor` global actor. On Apple platforms that aligns with main-thread UI work for `UIKit` / `SwiftUI` (and models the UI reads/writes directly). It’s actor isolation, not “sprinkle `Thread.isMainThread` everywhere”—the compiler/runtime enforce hopping via `async`/`await`.

    `MainActor` is the UI boundary: keep direct UI work there; run non-UI work elsewhere (own `actor`, non-`MainActor` services, `Task` off the main actor), then hop back (`await MainActor.run`, `@MainActor` methods) to publish results into UI-visible state—not only “redraw”, but any mutation the UI observes.

    Don’t park heavy synchronous work on `MainActor` or you’ll block UI responsiveness.
- **Устная заготовка (RU):**

    1. `@MainActor` — **main actor**, для UI и состояния, с которым UI в одном **concurrency domain** (домене конкурентности).
    2. На iOS это по сути **main thread** (главный поток) для интерфейса, но формулировка «изоляция `MainActor`» точнее для экзаменатора.
    3. Тяжёлое — в фон (отдельный `actor`, `Task` не на `MainActor`), потом `await MainActor.run { … }` для апдейта UI.
    4. Связка: не-UI считаем вне `MainActor`, на `MainActor` — только то, что UI должен увидеть (состояние, вызовы `UIKit`/`SwiftUI`).

- **Устная заготовка (EN):**

    1. `@MainActor` isolates UI-facing code on `MainActor`.
    2. On Apple platforms that maps to main-thread UI rules—say main actor, not only “main thread”.
    3. Offload heavy work, hop back with `await MainActor.run` / isolated `Task`.
    4. Non-UI off `MainActor`; `MainActor` only for what the UI observes (`UIKit`/`SwiftUI` state).

- **Итог одной фразой (RU):** `@MainActor` — чтобы UI и связанное состояние жили на **`MainActor`** (на практике — **main thread** для UI), без тяжёлой работы там же.
- **Итог одной фразой (EN):** `@MainActor` keeps UI-bound work on `MainActor` (main-thread UI on Apple)—never heavy work there.

- **Follow-up:** как избежать **over-serialization** (чрезмерной сериализации)?
- **Follow-up answer:** `nonisolated` (для `@MainActor`-типа — см. блок Пояснения к атрибутам выше: член вне `MainActor`) там, где к `MainActor` не нужно привязывать каждый метод; разрезать тип: фасад UI `@MainActor`, сервис/репозиторий без глобальной пометки; тяжёлое — в своём `actor` или вне `MainActor`, затем узкий `await MainActor.run` для мутации UI. Антипаттерн — весь `APIService` `@MainActor`, хотя сеть и парсинг не про UI.
- **Доп. информация:** связка с Q11 (`Task` vs `detached` и потеря `MainActor`). См. [§ 5 (`@MainActor`)](#concurrency-primer-s5).

### Q16
- **Question (RU):** что гарантирует `Sendable`?
- **Question (EN):** What does `Sendable` guarantee?
- **Answer (RU):** `Sendable` говорит, что тип безопасен для использования в конкурентности в смысле пересечения границ: значение можно передавать между concurrency domains (другая задача, другой актор, `MainActor` и т.д.) так, что это не вносит data races — компилятор связывает это с изоляцией и проверками в строгом режиме.

    Это не «волшебная неизменяемость» любого `class`: для ссылочных типов conform часто явный (`final`, иммутабельность, изоляция на `actor`) или спорный (`@unchecked Sendable` — ответственность на авторе).
- **Answer (EN):** `Sendable` means values of the type can cross concurrency domains (tasks, actors, `MainActor`, …) without introducing data races—the compiler uses that in isolation checking.

    It is not automatic immutability for arbitrary classes; reference types often need an explicit story (`final` + immutable state, `actor` wrapping, or `@unchecked Sendable` with manual proof).
- **Устная заготовка (RU):**

    1. `Sendable` — тип можно безопасно передавать между **concurrency domains** (доменами конкурентности).
    2. Цель — не наделать **data races** при передаче значений.
    3. У классов без дисциплины — либо рефакторинг, либо `@unchecked` с риском.

- **Устная заготовка (EN):**

    1. `Sendable` marks types safe to pass across concurrency boundaries.
    2. It’s about avoiding data races when sharing across domains.
    3. For legacy classes: refactor, wrap in an `actor`, or `@unchecked` with care.

- **Итог одной фразой (RU):** `Sendable` — тип безопасен для передачи между **concurrency domains** (частями конкурентной программы), чтобы не ловить **data races**.
- **Итог одной фразой (EN):** `Sendable` means the type is safe to share across Swift concurrency domains without data races.

- **Follow-up:** как мигрировать **legacy reference type** (легаси ссылочный тип)?
- **Follow-up answer:** по шагам: сузить мутабельность и сделать состояние **thread-safe** (иммутабельный `final` класс, **value**-снимки вместо «шареного» экземпляра); вынести **mutable state** в `actor`; где нельзя быстро доказать — `@unchecked Sendable` только с явным аргументом «почему здесь нет **data race**», иначе ложное спокойствие. На собесе полезно назвать риск `@unchecked` и альтернативу `actor`-обёрткой / копированием **struct**.
- **Доп. информация:** формально — Swift Book (Concurrency) и раздел про `Sendable`; см. [§ 6 (`Sendable`)](#concurrency-primer-s6). Связка с Q12 — общие ссылки между акторами без дисциплины.

### Q17
- **Question (RU):** `TaskGroup` vs `async let`?
- **Question (EN):** `TaskGroup` vs `async let`?
- **Answer (RU):** `TaskGroup` — когда число дочерних задач динамическое (например цикл по массиву id — каждый раз `addTask`). `async let` — когда набор подзадач фиксирован заранее и задаётся явно в коде как несколько привязок (условно «статическая» развилка: два-три параллельных `async let`, а не «сколько элементов — столько задач» из переменной коллекции).

    Интуиция: группа — для «запустить N штук», где N из рантайма; `async let` — для «параллельно сделать эти известные шаги».
- **Answer (EN):** Use `TaskGroup` when the child-task count is dynamic (e.g. loop over inputs and `addTask` per item). Use `async let` for a fixed, explicitly written fan-out—a small set of parallel bindings known up front, not a variable-length blast of tasks.

    Rule of thumb: group for “however many items”; `async let` for “these specific concurrent steps”.
- **Устная заготовка (RU):**

    1. `TaskGroup` — динамическое число задач (цикл, список).
    2. `async let` — фиксированное число параллельных подзадач в тексте функции.
    3. Динамика из коллекции без группы — неудобно и неидиоматично.
    4. Follow-up (частичные результаты): `TaskGroup` — много задач и что делать при ошибке посередине; `async let` — мало шагов в одном scope.

- **Устная заготовка (EN):**

    1. `TaskGroup` — dynamic task count.
    2. `async let` — fixed parallel bindings.
    3. Don’t fake a dynamic fan-out with many `async let`s—use a group.
    4. Follow-up (partial results): `TaskGroup` when many tasks + you care about failure policy; `async let` when few parallel steps in one scope.

- **Итог одной фразой (RU):** `TaskGroup` — динамическое N задач; `async let` — заранее известное небольшое число параллельных подзадач.
- **Итог одной фразой (EN):** `TaskGroup` for dynamic fan-out; `async let` for a fixed small fan-out.

- **Follow-up:** когда важна обработка **partial results** (частичных результатов)?
- **Follow-up answer:** когда задач много и они из списка — берут `TaskGroup`: можно по очереди забирать уже готовые и решить, что делать, если одна упала (прервать всё или оставить то, что успело). Когда шагов немного и они известны заранее — чаще `async let`: один scope, все привязки рядом; «тащить результаты по мере готовости из длинного списка» там обычно не нужно.

    Устно коротко: группа — много элементов и политика при ошибке; `async let` — мало параллельных шагов в одном блоке.
- **Доп. информация:** технически — async iterator группы и `throwing TaskGroup` (первая ошибка может отменить остальных); см. [§ 8 (`async let` / `TaskGroup`)](#concurrency-primer-s8). Связка с Q14 — отмена родителя и дочерние задачи в группе.

### Q18
- **Question (RU):** какое главное правило у **`withCheckedContinuation`** (на собесе часто **invariant** / «инвариант»)?
- **Question (EN):** What rule must `withCheckedContinuation` satisfy (often phrased as its “invariant”)?
- **Вводные данные:** слово «инвариант» (invariant) здесь — не магия: это правило вида «всегда должно выполняться», если ты хочешь, чтобы код работал правильно. Его нельзя нарушать; иначе контракт API ломается (как «нельзя делить на ноль» для деления — условие, которое держим всегда). На собесе про continuation спрашивают не определение слова из словаря, а какое именно правило нельзя сломать при мосте колбэк → `await`.

    Дальше — контекст API: многие старые API не `async`: они говорят «вызови completion, когда закончишь». Чтобы внутри своего кода написать `await` и ждать этот результат, Swift даёт обёртку `withCheckedContinuation { continuation in … }`: внутри блока ты сохраняешь `continuation` и позже, когда сработал legacy-колбэк, вызываешь `continuation.resume(...)` — будто «пробудить» ожидающий `await`. Интуиция: это мост «closure-колбэк ↔ async-код». Слово «инвариант» на собесе = одно формальное правило этого моста, которое нельзя нарушать (см. ответ ниже).

- **Answer (RU):** картина верная: API нужен, чтобы связать колбэки в замыканиях с `async`/`await`. Сам инвариант при этом формулируют узко: на каждый заход в `withCheckedContinuation` нужно вызвать `resume` ровно один раз — не ноль раз (иначе `await` повиснет навсегда), не два и больше (иначе состояние задачи сломано; в checked-сборке это часто ловится как ошибка).

- **Answer (EN):** Call `resume` exactly once per continuation—never forget it (hang) and never call it twice (undefined behavior / trap in checked builds).

- **Устная заготовка (RU):**

    1. Это мост: callback → `await`.
    2. `resume` строго один раз: ни забыл, ни дважды.
    3. Два раза — слом; ноль раз — вечное ожидание.

- **Устная заготовка (EN):**

    1. Bridge legacy callbacks into `async`/`await`.
    2. `resume` exactly once.
    3. Zero resumes hang; double resume breaks the task.

- **Итог одной фразой (RU):** мост колбэка в `await`; инвариант — один `resume` на один такой мост.
- **Итог одной фразой (EN):** One `resume` per continuation—exactly once.

- **Follow-up:** что при **double resume** (двойном **resume**) / **missing resume** (пропущенном **resume**)?
- **Follow-up answer:** два `resume` — нарушение контракта, задача уже «завершена» первым вызовом; повтор ломает машину состояний (в debug checked это видно). Ноль `resume` — колбэк не пришёл или забыли вызвать — ожидающий код никогда не продолжится. На практике все ветки completion (успех, ошибка, отмена) должны сходиться в ровно один `resume`.
- **Доп. информация:** `withCheckedContinuation` в debug помогает поймать нарушение; `withUnsafeContinuation` проверки не делает, но контракт «один раз» тот же. Имена `withCheckedThrowingContinuation` / `resume(throwing:)` — вариант с ошибкой, правило «ровно один раз» не меняется.

### Q19
- **Question (RU):** что такое **priority inversion** (инверсия приоритетов)?
- **Question (EN):** What is priority inversion?
- **Вводные данные:** приоритеты/QoS действительно задают, какую работу планировщик предпочитает: выше приоритет обычно получает время CPU (центрального процессора) раньше, низкий может подождать — это нормальная «иерархия». Термин priority inversion описывает не саму иерархию, а сбой: работа с высоким приоритетом вынуждена ждать, пока освободится ресурс (блокировка, синхронный вызов, общий объект), удерживаемый работой с низким приоритетом. Итог против интуиции: «важный» поток стоит из‑за «медленного» — это и есть инверсия.

- **Answer (RU):** классическая формулировка: высокоприоритетная задача ждёт ресурс, который держит низкоприоритетная (или пока та не успеет отпустить lock / закончить критический участок). Частый усилитель проблемы — ещё потоки среднего приоритета вытесняют низкий, поэтому высокий ждёт дольше, чем кажется «по приоритету».

- **Answer (EN):** High-priority work blocks on a shared resource held by lower-priority work (often worsened by intermediate-priority threads starving the low-priority holder).

- **Устная заготовка (RU):**

    1. Приоритеты — про порядок конкурирования за CPU (центральный процессор) в штатном случае.
    2. Inversion — высокий ждёт низкий из‑за lock/ресурса.
    3. На UI: главный контур ждёт фон — возможен фриз.

- **Устная заготовка (EN):**

    1. QoS shapes scheduling—high usually runs ahead of low.
    2. Inversion—high waits because low holds a needed lock/resource.
    3. Tie to UI when main code waits on background work.

- **Итог одной фразой (RU):** инверсия — когда высокий приоритет вынужден ждать низкий из‑за общего ресурса, не просто «низкий реже получает CPU (центральный процессор)».
- **Итог одной фразой (EN):** Priority inversion—high-priority work waits on lower-priority work holding a resource.

- **Follow-up:** как это проявляется в **UI freeze** (фризе интерфейса)?
- **Follow-up answer:** **`MainActor`** / UI-код ждёт результат или **lock**, который держит фон с более низким **QoS** (или цепочка через общий сервис); кадры не обновляются — кажется «приложение зависло». Лечение на уровне идей: не блокировать **`main thread`** долгим синхронным ожиданием, разносить ресурсы, укорачивать **critical sections**, асинхронные границы; на платформе частично помогают механизмы вроде **priority donation** — это уже углубление.
- **Доп. информация:** классический пример с mutex и тремя уровнями приоритета — в учебниках по ОС; на iOS собес связывают с GCD QoS, блокировками и перегрузом `MainActor`. Playground по теме — ниже.

### Q20
- **Question (RU):** как тестировать **async** code (асинхронный код)?
- **Question (EN):** How do you test async code?
- **Answer (RU):** принципы те же: детерминированные (предсказуемые: тест задаёт ввод и время, без случайности реальной сети и «живых» задержек) зависимости — часы, клиенты, очереди под контролем; отдельные сценарии отмены и ошибок; без «магических» реальных sleep как единственной синхронизации.

    Современный слой инструментов — Swift Testing (`import Testing`): тест помечают `@Test`, функция может быть `async throws`, внутри спокойно `await` и проверки через `#expect` / `#require` без обязательной связки expectation + wait для простых случаев. В проектах на XCTest по-прежнему типичны `XCTestExpectation` и `wait(for:timeout:)` с явным таймаутом либо async-методы тестов там, где версия стека это поддерживает; выбор рамки зависит от проекта, на собесе полезно назвать оба подхода.

- **Answer (EN):** Same principles: deterministic dependencies (repeatable: controlled inputs/time—no flaky real network or wall-clock luck), explicit cancellation/error coverage, avoid relying on real time delays.

    Modern Swift Testing (`import Testing`) uses `@Test`, `async`/`await`-friendly test functions, and `#expect`/`#require`. XCTest-heavy codebases still lean on expectations/`wait` or async-capable test methods—name both and explain trade-offs.

- **Устная заготовка (RU):**

    1. Детерминированность (предсказуемость теста): подменяем время и внешний мир — те же входы дают тот же результат.
    2. Swift Testing: `@Test`, async тест, `#expect`.
    3. XCTest: expectation + wait или async тест; без вечного sleep.

- **Устная заготовка (EN):**

    1. Deterministic (repeatable) fakes/clocks—no flaky timing.
    2. Swift Testing: `@Test`, async, `#expect`.
    3. XCTest: expectations or async tests; don’t sleep blindly.

- **Итог одной фразой (RU):** детерминированные (предсказуемые) зависимости + явные ветки отмены/ошибки; инструментально — Swift Testing для async «из коробки», иначе XCTest с expectation/wait.
- **Итог одной фразой (EN):** Deterministic (repeatable) deps plus cancellation/error paths; Swift Testing for first-class async tests, XCTest patterns where legacy demands.

- **Follow-up:** как убрать **flaky tests** (нестабильные тесты)?
- **Follow-up answer:** убрать гонки реального времени: фейковые часы/диспетчеры, стабильные фикстуры, явные таймауты только там, где контракт это допускает. `MainActor.assumeIsolated` — только если изоляция главного актора гарантирована средой теста. Разделить unit (моки протоколов) и integration (`URLProtocol`, локальный сервер) — разный источник флаков. В Swift Testing следить за изоляцией параллельных тестов и общими синглтонами так же, как в XCTest.
- **Доп. информация:** детали и примеры по Swift Testing — [VI. Качество/23 Тестирование — Unit, UI, Snapshot, Test Plans/Testing-Unit-UI-Snapshot.md](VI. Качество/23 Тестирование — Unit, UI, Snapshot, Test Plans/Testing-Unit-UI-Snapshot.md) (в т.ч. потоки событий, `confirmation`). На CI полезно помнить про параллельный запуск и общие глобальные состояния.
- **Playground:** [open](ActorsQueuesLocksInterview.playground/Contents.swift)
- **Notes:** [VI. Качество/23 Тестирование — Unit, UI, Snapshot, Test Plans/Testing-Unit-UI-Snapshot.md](VI. Качество/23 Тестирование — Unit, UI, Snapshot, Test Plans/Testing-Unit-UI-Snapshot.md)

---

### Q43
- **Question (RU):** GCD basics (база GCD): что важно про DispatchQueue.main (главную очередь)?
- **Question (EN):** GCD basics—what about the main queue?
- **Answer (RU):** Зацепка: **main queue = main thread** для UI; работа с интерфейсом — с main; тяжёлое — в сторону, обратно через **`main.async`**, не **`sync`** без крайней нужды.

    UIKit/SwiftUI состояние, привязанное к главному потоку, обновляют с main queue; долгие задачи — на фоновый `DispatchQueue` или async API. С фона на UI — `DispatchQueue.main.async`.

- **Answer (EN):** Main queue drives UI; offload heavy work; return with `main.async`—avoid `main.sync` unless you fully understand reentrancy/deadlock risk.

- **Устная заготовка (RU):** UI на main; с фона — `async` на main; `sync` на main от main — deadlock.

- **Устная заготовка (EN):** Background compute, `main.async` for UI updates.

- **Follow-up:** чем опасен sync на DispatchQueue.main (синхронный вызов в главную очередь)?
- **Follow-up answer:** если текущий поток уже main — deadlock при `sync`; с фона `sync` на main блокирует фон до завершения UI-работы — риск инверсии приоритетов и зависаний.

- **Доп. информация:** в новом коде часто `@MainActor` вместо ручного GCD для UI state.


### Q44
- **Question (RU):** Что такое **`AsyncStream`**, для чего он нужен и как его создавать?
- **Question (EN):** What is `AsyncStream`, when do you reach for it, and how is it produced?
- **Answer (RU):** Зацепка: **`AsyncStream` — мост из push-источника событий (callback, делегат, `Timer`, `WebSocket`) в `for await`**.

    Это конкретная реализация `AsyncSequence`, у которой значения **производятся извне** через объект `Continuation`. Получатель читает их обычным `for await`. Базовая форма:

    ```swift
    let stream = AsyncStream<Int> { continuation in
        continuation.yield(1)
        continuation.yield(2)
        continuation.yield(3)
        continuation.finish()
    }

    for await value in stream {
        print(value) // 1, 2, 3
    }
    ```

    `continuation.yield(_:)` — отправить значение, `continuation.finish()` — закрыть поток (получатель выйдет из `for await`).

    Реальный паттерн — обернуть callback API. Например, `Timer`, который тикает раз в секунду:

    ```swift
    func timerStream() -> AsyncStream<Int> {
        AsyncStream { continuation in
            var count = 0

            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                continuation.yield(count)
                count += 1
                if count > 5 {
                    timer.invalidate()
                    continuation.finish()
                }
            }

            continuation.onTermination = { @Sendable _ in
                timer.invalidate()
            }
        }
    }

    for await value in timerStream() { print(value) }
    ```

    Ключевое — `continuation.onTermination`: даёт **корректно остановить источник**, когда стрим закрыт (вышли из `for await`, отменили задачу, читатель умер).

    Где применяется в iOS:

    - WebSocket / network events;
    - GPS/CoreLocation;
    - события UI/жесты;
    - прогресс загрузки;
    - любой legacy callback API → async.

- **Answer (EN):** `AsyncStream` is the bridge from push-style sources (callbacks, delegates, `Timer`, sockets) into `AsyncSequence` and `for await`. You construct it with a closure that captures a `Continuation`; the producer calls `continuation.yield(value)` and `continuation.finish()`. Always set `continuation.onTermination` to tear down the underlying source when the consumer goes away. It’s the standard tool to convert callback-based iOS APIs into Swift Concurrency.

- **Устная заготовка (RU):**

    1. `AsyncStream` — push-источник, который читают через `for await`.
    2. Создаёшь через `Continuation`: `yield`, `finish`, `onTermination`.
    3. Идеален для `Timer`, сокетов, делегатов, GPS.

- **Устная заготовка (EN):**

    1. `AsyncStream` exposes a push source as `AsyncSequence`.
    2. Build with a `Continuation`: `yield`, `finish`, `onTermination`.
    3. Use it to bridge callback APIs into async.

- **Follow-up:** В чём разница между `AsyncStream` и `AsyncThrowingStream`, и какие у `AsyncStream` есть `BufferingPolicy`?
- **Follow-up answer:** `AsyncThrowingStream` отличается тем, что итерация может **бросить** ошибку: `continuation.finish(throwing:)` завершает поток ошибкой, `for try await` её ловит. Полезно для сетевых/IO-источников. **Buffering policy** задаётся при создании: `.unbounded` (по умолчанию — копит всё, риск памяти), `.bufferingNewest(n)` (хранить только последние `n`, выкидывать старые), `.bufferingOldest(n)` (хранить первые `n`). Для частых событий (touch-моушены, биржа) почти всегда `.bufferingNewest(1)`, иначе хвост событий растёт быстрее, чем читается.

- **Доп. информация:** `AsyncStream` это **cold stream**: `Continuation` не запустится, пока кто-то не подпишется через `for await`. Многократного broadcast «из коробки» нет — для нескольких потребителей нужен ручной мультиплексер или `AsyncChannel` из swift-async-algorithms. Сравнение с другими экосистемами: **Combine `Publisher`**, **Kotlin Flow**, **JS AsyncIterator**.


### Q45
- **Question (RU):** Может ли **Swift Concurrency** полностью заменить **Combine**?
- **Question (EN):** Can Swift Concurrency fully replace Combine?
- **Answer (RU):** Зацепка: **частично — да; полностью — нет**. Это инструменты разного уровня абстракции.

    Что Concurrency покрывает уверенно (и за счёт чего Combine стал нужен реже):

    - запросы вида «спросил → получил результат» (networking, БД, файлы) — `async/await` чище любого `sink`;
    - последовательная асинхронность — `Task`, `async let`, `withTaskGroup`;
    - один источник событий → один читатель — `AsyncStream` / `AsyncSequence`;
    - защита состояния — `actor`, `@MainActor`.

    Пример, где async/await явно лучше:

    ```swift
    let user = try await api.loadUser()
    ```

    против

    ```swift
    api.loadUserPublisher()
        .sink { ... }
        .store(in: &cancellables)
    ```

    Где **Combine** всё ещё сильнее (до появления стабильных `swift-async-algorithms` в проекте):

    - сложные пайплайны: `debounce`, `throttle`, `merge`, `combineLatest`, `zip`;
    - реактивный UI с несколькими источниками событий;
    - живой поиск с задержкой ввода;
    - валидация формы по нескольким полям;
    - бекплейн на UIKit-привязках через `assign(to:on:)`.

    `AsyncSequence` уже умеет `map`/`filter`/`compactMap`/`prefix`/`drop`, но **экосистема операторов слабее**, и комбинаторы вроде `combineLatest` живут в отдельном пакете `swift-async-algorithms`.

    Что используют в реальных iOS-проектах сейчас:

    - **networking** → `async/await`;
    - **streams/events** → `AsyncStream` / `AsyncSequence`;
    - **UI bindings / реактивность** → `Combine` (легаси) или **Observation** (`@Observable`) для state;

- **Answer (EN):** Partially yes, fully no. Swift Concurrency replaces most of what people used Combine for: request/response networking, sequential async, single-source event streams (`AsyncStream`), and shared-state protection (`actor`/`@MainActor`). Combine still wins on **rich operator pipelines**: `debounce`, `merge`, `combineLatest`, multi-source reactive UI like type-ahead search or form validation. `AsyncSequence` covers basic operators; advanced ones live in `swift-async-algorithms`. In modern iOS projects, the typical split is: networking with async/await, events with `AsyncStream`, UI state with **Observation** (or Combine in legacy). Combine isn’t dead — Apple keeps it; it’s just no longer the default for async work.

- **Устная заготовка (RU):**

    1. Concurrency и Combine — **разный уровень абстракции**, не конкуренты 1:1.
    2. async/await отлично закрывает «спросил-получил» и одиночные стримы.
    3. Combine силён на multi-source реактиве (`debounce`, `combineLatest`, …).

- **Устная заготовка (EN):**

    1. They’re different abstractions, not 1:1 replacements.
    2. async/await wins on request/response and single streams.
    3. Combine still wins on multi-source operator pipelines.

- **Follow-up:** Когда осознанно выбираешь Combine в новом коде в 2025+?
- **Follow-up answer:** Если команда уже на Combine и есть зрелый набор операторов — переписывать ради «новизны» нет смысла. Если фича действительно про **реактивные потоки**: live search с `debounce`, объединение нескольких источников через `combineLatest`/`merge`, цепочки трансформаций над событиями UI — Combine компактнее, чем эквивалент через `AsyncStream` + ручные комбинаторы. В чисто request/response слоях, наоборот, Combine — оверкилл, async/await проще.

- **Доп. информация:** Apple явно двигает стек в сторону Swift Concurrency: даже `URLSession` сегодня async/await-first. Для `@Published`-style state-management официальная замена — **Observation** (`@Observable`), не Combine. Поэтому корректнее формулировать: Concurrency не заменяет Combine, а **Observation + Concurrency вместе** покрывают большую часть бывших задач Combine.


### Q46
- **Question (RU):** Сравни **Combine**, **async/await + AsyncStream** и **старые нативные подходы** (callback, delegate, NotificationCenter, KVO, GCD, Operation). Когда что выбирать на собесе и в проде?
- **Question (EN):** Compare Combine, Swift Concurrency (async/await + AsyncStream) and older native iOS async/event APIs (callbacks, delegate, NotificationCenter, KVO, GCD, Operation). When do you reach for what?
- **Answer (RU):** Зацепка: **на оси «один результат ↔ много результатов» × «push ↔ pull» эти подходы покрывают разные клетки**. Никто не «заменяет всё».

    **Краткая ось — что про что:**

    - **Один результат, async** → исторически callback / completion handler → сейчас **`async/await`**.
    - **Параллелизм/диспетчеризация** → исторически GCD/Operation → сейчас **`Task` / `TaskGroup` / `actor`**.

    **Сводная таблица:**

    | Подход | Один/много | Стиль | Композиция | Ошибки | Cancellation | Threading | Тестируемость | Уместен сегодня для |
    |---|---|---|---|---|---|---|---|---|
    | **Completion handler** (`(Result) -> Void`) | один | push (callback) | вложенные замыкания → callback hell | `Result.failure` | вручную через токен | сам выбираешь queue | средняя (надо моки) | bridging legacy API через `withCheckedContinuation` |
    | **Target-Action** | много (UI events) | push | нет | нет | weak-цикл UIControl | main по контракту | хорошая | UIKit-кнопки, gesture, controls |
    | **NotificationCenter** | много (1:N) | push (event bus) | нет операторов | нет | вручную (`removeObserver`) | post с любого, observer на main по `OperationQueue.main` | средняя (глобальное состояние) | системные нотификации (keyboard, app lifecycle) — для своего домена не лучший выбор |
    | **GCD (`DispatchQueue`, `DispatchGroup`, `DispatchSource`)** | низкоуровневая параллельность | push | вручную | нет (или `Result`) | вручную (`DispatchWorkItem.cancel`) | сам управляешь | средняя (нужны фейковые очереди) | мост к async, отдельные сериализованные queue, низкоуровневая работа с FD/таймерами |
    | **Combine** (`Publisher`/`Subscriber`) | много | push, реактивно | богатые операторы (`map`, `debounce`, `merge`, `combineLatest`, `zip`) | typed `Failure` | через `Cancellable` | `subscribe(on:)`/`receive(on:)` | хорошая (`TestScheduler` сторонний / fake schedulers) | живой UI с несколькими источниками: live search, форма с валидацией, многосорсовая логика; legacy-проекты на Combine |
    | **`async/await` + `Task`** | один результат | pull (await) | линейный код, `try`/`throw`, `async let`, `withTaskGroup` | `throws` | кооперативная (`Task.cancel()` + `checkCancellation`) | по isolation (`@MainActor`, `actor`) | высокая (фейковые async-зависимости, `Clock`) | request/response: networking, DB, файлы; параллельный fan-out/fan-in |
    | **`AsyncStream` / `AsyncSequence`** | много | pull (`for await`) | базовые операторы (`map`/`filter`/`prefix`); продвинутые в `swift-async-algorithms` | `for try await` для throwing-варианта | по отмене Task + `onTermination` | по isolation | высокая | мост push-источников (Timer, sockets, делегаты) в async; одиночный консьюмер |
    | **Observation (`@Observable`)** | много (state) | pull (read-driven) | нет операторов, это система трекинга | нет | автоматически по lifecycle View | через `@MainActor`-модель | высокая (обычные state-тесты) | state-management в SwiftUI (замена `ObservableObject` + `@Published`) |

    **Ключевые отличия по семантике:**

    - **Push vs pull.** Combine, делегаты, NotificationCenter, KVO, AsyncStream — push (источник кладёт значения). `async/await` — pull (потребитель «тянет» одно значение через `await`). Это влияет на естественную модель **backpressure**: у Combine нужно явно управлять `Demand`, у `AsyncSequence` потребитель сам решает скорость, у NotificationCenter backpressure нет вообще.
    - **Cancellation.** В `async/await` отмена — **первоклассная** часть модели (`Task.cancel()` + кооперативные точки). У Combine отмена через `Cancellable`. У GCD/Operation/делегатов — вручную, легко забыть. У NotificationCenter «отмена» = `removeObserver`, что часто и приводит к утечкам.
    - **Композиция.** Combine силён операторами для **multi-source** реактива (`combineLatest`, `merge`, `zip`, `debounce`, `throttle`). `AsyncSequence` штатно покрывает базу; продвинутые операторы — отдельный пакет [`swift-async-algorithms`](https://github.com/apple/swift-async-algorithms). Нативные API (`delegate`, `Notification`, `KVO`) операторов не имеют — каждый раз пишешь руками.
    - **Threading / isolation.** GCD — ручной `DispatchQueue`. Operation — `qualityOfService`. Combine — `subscribe(on:)`/`receive(on:)`. Concurrency — на уровне типов (`@MainActor`, `actor`), компилятор проверяет `Sendable`. У старых API безопасности на компиляции нет.
    - **Compile-time safety.** Только Swift Concurrency даёт **компиляторные** гарантии против data race. У Combine, GCD, Operation, делегатов — гонки ловишь TSan-ом или ревью.

    **Что из старого реально использовать сейчас:**

    - **Delegate** — да, для системных API: `URLSessionDelegate`, `MKMapViewDelegate`, `AVCaptureSession`, многие UIKit-контроллеры. В своём коде новый event API делать через `AsyncStream` или Combine.
    - **Target-Action** — да, для UIKit-control'ов и жестов. В SwiftUI его роль занимает биндинг через `@Bindable` / замыкания.
    - **NotificationCenter** — оставить для **системных** нотификаций (keyboard frame, app lifecycle, low memory). Для своих доменных событий — `AsyncStream` / Combine, потому что NotificationCenter — это глобальная шина без типов, без отмены и без backpressure.
    - **GCD** — для низкоуровневых вещей (свои сериализованные очереди подсистем, `DispatchSource`, таймеры). Для бизнес-логики — `Task`, `actor`.
    - **OperationQueue** — для пайплайнов с **явным графом зависимостей** и приоритетов; в новых сценариях чаще достаточно `TaskGroup` + `actor`.
    - **Completion handlers** — только как **граница** с легаси: оборачивать через `withCheckedContinuation` / `withCheckedThrowingContinuation` и идти дальше в `async`.
    - **Combine** — там, где он уже принят командой и нужны **multi-source реактивные пайплайны**; в новом проекте без таких сценариев в 2025+ можно обходиться парой Concurrency + Observation.

    **Скелетные примеры одной задачи в трёх стилях.** «Загрузить пользователя по id и обновить UI»:

    ```swift
    // 1) Completion handler (старый стиль)
    func loadUser(id: String, completion: @escaping (Result<User, Error>) -> Void) { ... }
    loadUser(id: id) { result in
        DispatchQueue.main.async {
            switch result {
            case .success(let user): self.render(user)
            case .failure(let error): self.show(error)
            }
        }
    }

    // 2) Combine
    api.userPublisher(id: id)
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { if case .failure(let e) = $0 { self.show(e) } },
            receiveValue: { self.render($0) }
        )
        .store(in: &cancellables)

    // 3) async/await
    Task { @MainActor in
        do {
            let user = try await api.user(id: id)
            render(user)
        } catch {
            show(error)
        }
    }
    ```

    То же для **«поток событий, который надо дебаунсить»** (live search):

    ```swift
    // Combine — короче всего
    queryPublisher
        .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
        .removeDuplicates()
        .flatMap { api.searchPublisher(query: $0) }
        .sink { results in self.render(results) }
        .store(in: &cancellables)

    // async/await + AsyncStream + swift-async-algorithms
    Task { @MainActor in
        for await query in queryStream
            .debounce(for: .milliseconds(300))   // из swift-async-algorithms
            .removeDuplicates()
        {
            let results = try await api.search(query: query)
            render(results)
        }
    }
    ```

    Combine компактнее в multi-source реактиве; async-вариант линейнее и не требует `Cancellable`/`store(in:)`, но тянет внешний пакет операторов.


- **Устная заготовка (RU):**

    1. Это разные клетки: один-результат vs много-значений, push vs pull.
    2. async/await — request/response и параллелизм с компиляторной безопасностью.
    3. Combine — multi-source реактив с операторами; AsyncStream — мост для push-источников.
    4. Старое (delegate, KVO, NotificationCenter, GCD, Operation) живёт там, где это API системы или нужный низкий уровень.

- **Устная заготовка (EN):**

    1. Frame the axes: single/many × push/pull.
    2. async/await for request/response and structured parallelism with compile-time safety.
    3. Combine for multi-source operator pipelines; `AsyncStream` to bridge push sources into async.

- **Follow-up:** Что из этого даёт **компиляторные** гарантии против data race?

- **Доп. информация:** Reactive-инструменты разных эпох делятся на «реактивный pull» (`AsyncSequence`), «реактивный push с операторами» (Combine, RxSwift), «push без операторов» (delegate, KVO, Notification). Понимание этой оси важнее, чем «Combine быстрее или медленнее». В дискуссиях с командой полезно проговаривать: «нам нужен богатый комбинатор сразу нескольких источников» → Combine; «нам нужен мост одного push-источника в линейный код с отменой» → `AsyncStream`; «у нас системный API с делегатом, который мы не контролируем» → оставляем delegate, при необходимости поверх него строим `AsyncStream`.


### Q47
- **Question (RU):** **п.28 / H28** — асинхронность в Swift: **GCD**, **Operation**, **Combine**, **async/await / Task / actor** — одним заходом для собеса?
- **Question (EN):** Swift async landscape—GCD, Operation, Combine, Swift Concurrency—in one interview pass?
- **Answer (RU):** Зацепка: это **не одна ось «только потоки»**: есть **диспетчеризация** (GCD/Operation), **реактивные потоки** (Combine), **структурированная асинхронность и изоляция** (`async`/`await`, `Task`, `actor`, `@MainActor`). Полная сводная таблица и примеры — в **Q46** этом же файле.

    **Уточнения к частым формулировкам:** **GCD** всё ещё массово в легаси, но для **новой** бизнес-логики чаще **`Task` + изоляция**; **Combine** — не «про потоки», а про **`Publisher`/`Subscriber`**, операторы и отмену через **`Cancellable`**. **`OperationQueue`** даёт **граф зависимостей** и **`cancel()`**, на Apple-платформах исторически стоит на GCD-подобной диспетчеризации. **`actor`** — **reference type** с **сериализацией доступа** к mutable state **на уровне компилятора** (не «просто класс», отдельная модель изоляции + `Sendable`).

- **Answer (EN):** See **Q46** for the full matrix. GCD/Operation = scheduling; Combine = reactive streams; Swift Concurrency = async/await + structured tasks + actor isolation for data-race safety.

- **Устный канон (опросник п.28 / H28, drill):** «**GCD/Operation** — **очереди и задачи**; **Combine** — **реактивные потоки**; **async/await + Task + actor** — **структурированная асинхронность** и **изоляция**; новый код — **Concurrency**, легаси и система — **GCD/делегаты**; см. **Q46**.»

- **Follow-up (RU):** что даёт **компиляторную** защиту от data race?
- **Follow-up answer (RU):** **`actor` / `@MainActor` / `Sendable`** при строгой concurrency; не Combine и не GCD сами по себе.

- **Доп. информация:** [Habr H28](https://habr.com/en/articles/726388/); [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.28; **Q46** (таблица).


### Q48
- **Question (RU):** **п.48 / J08** — в **GCD**: **`DispatchQueue.async`** vs **`sync`** — семантика и типичный риск?
- **Question (EN):** GCD `DispatchQueue.async` vs `sync`—semantics and pitfalls?
- **Answer (RU):** **`async(execute:)`** — поставить блок **в очередь** и **сразу вернуться**; выполнение **позже** (на том потоке/executor’е, который обслуживает очередь). **`sync(execute:)`** — **дождаться**, пока блок **выполнится на целевой очереди**, и только потом продолжить вызывающий поток — это **барьер по отношению к порядку** на той очереди относительно уже поставленной работы.

    **Риск:** **`sync`** на **ту же** очередь, на которой уже выполняешься (или цикл ожиданий через несколько очередей) → **взаимная блокировка** (**deadlock**). На **`main`** почти всегда предпочитают **`async`** к UI-работе, а не **`sync`** с главного.

- **Answer (EN):** `async` schedules and returns; `sync` runs the block on the target queue before returning—handy for “read consistent snapshot on that queue” but deadly if you `sync` onto the queue you’re already running on.

- **Устный канон (опросник п.48 / J08, drill):** «**`async`** — **в очередь и дальше**; **`sync`** — **ждём выполнения на целевой**; **`sync` на себя** — **deadlock**; не путать с **`async`/`await`** Swift.»

- **Follow-up (RU):** это про **`URLSession`**?
- **Follow-up answer (RU):** в этом слоте опросника — именно **GCD**; для сети — отдельно completion / **`async`/`await`** поверх URLSession (**V/20**).

- **Доп. информация:** [ios-interview Junior](https://ios-interview.ru/top-20-junior-ios-interview-questions/); [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.48; опросник **п.61** (код + GCD); **Q47** (ландшафт асинхронности).


### Q49
- **Question (RU):** Имеет ли смысл **actor без mutable state** (stateless actor)?
- **Question (EN):** When is a stateless actor justified?
- **Answer (RU):** Зацепка: actor без свойств **странен по умолчанию**, но **не всегда ошибка** — нужно назвать **зачем** нужна изоляция (**first rule of actors**).

    **Легитимные случаи:**

    1. **Sendable service type** — `NetworkClient`-actor: sync work (decode) не на main, тип `Sendable`; минус — **сериализация** всех sync-блоков (один decode за раз) и боль с **protocols** / `Sendable` на API.
    2. **`Sendable struct` + `@concurrent`** — часто лучше для CPU-heavy без shared state: параллельные вызовы, проще протоколы.
    3. **Custom executor actor** — мост к `DispatchQueue` / AVFoundation; stateless по полям, но есть **внешняя** очередь (`unownedExecutor`).
    4. **Внешнее state** — файловая система / on-disk cache: state вне процесса, actor сериализует доступ (компилятор не проверяет FS).
    5. **`@globalActor` «BackgroundActor»** — Massicotte **не рекомендует**: та же сериализация + viral isolation, как у `@MainActor`.

- **Answer (EN):** A property-less actor is odd unless you can articulate why synchronization matters. Valid: Sendable network service (sync work off main, but serializes sync sections), custom-executor bridge, filesystem as external state. Prefer `Sendable struct` + `@concurrent` for parallel CPU work without shared mutable state. Avoid a global background actor—it serializes and spreads isolation.

- **Устная заготовка (RU):**

    1. Без полей — подозрительно; объясни **зачем** actor, не «чтобы Sendable».
    2. NetworkClient-actor vs **`struct` + `@concurrent`** — trade-off сериализации vs параллелизма.
    3. Custom executor и FS — ок; **`@BackgroundActor`** — антипаттерн.

- **Устная заготовка (EN):**

    1. Stateless actor needs a clear sync/isolation reason—not a Sendable shortcut.
    2. Compare actor service vs `@concurrent struct` for parallel heavy work.
    3. Custom executors and external state are fine; global background actors are not.

- **Follow-up (RU):** почему actor-`NetworkClient` может быть **медленнее**, чем `@concurrent struct`?
- **Follow-up answer (RU):** actor **сериализует синхронный код** на своём executor: N параллельных `loadCart()` → decode **по одному**. `@concurrent` снимает это ограничение для CPU-heavy без shared mutable state.

- **Доп. информация:** [Stateless Actors — Matt Massicotte](notes/Stateless-Actors-Massicotte.md); Q12 (isolation); [Approachable Concurrency](notes/Approachable-Swift-Concurrency-Site-RU.md) (`@concurrent`).

- **Notes:** [notes/Stateless-Actors-Massicotte.md](notes/Stateless-Actors-Massicotte.md)

### Q50
- **Question (RU):** Почему после включения **Swift 6 strict concurrency** возможны **runtime crash** без compile warnings?
- **Question (EN):** Why can Swift 6 strict concurrency still crash at runtime with a clean build?
- **Answer (RU):** Зацепка: compile-time ловит **data races**, но compiler **вставляет runtime isolation checks** там, где поток closure **не доказан статически**. Нарушение → **trap** (Swift 6), не «тихий wrong thread» (Swift 5).

    **Символы в crash report:**

    - `_swift_task_checkIsolatedSwift` — ожидали `@MainActor`/actor, выполнили **вне** isolation.
    - `_dispatch_assert_queue_fail` — ожидали **конкретную queue**, выполнили на другой.

    **Типичные callsites:**

    1. **Closure наследует isolation** из `@MainActor`-метода → передали в Core Data `perform`, Combine `map` до `receive(on:)`, `NotificationCenter.sink` — callback с **background**.
    2. **`@MainActor` class + SDK delegate** — `NSDocument`, `CLLocationManagerDelegate`, `WKNavigationDelegate` — framework зовёт **не с main**.
    3. **`MainActor.assumeIsolated`** без гарантии main → instant crash.

    **Fix-паттерны:** `{ @Sendable in }` (снять inheritance), `receive(on: .main)` **до** isolated operators, `nonisolated` на delegate + `Task { @MainActor in }`, не злоупотреблять `assumeIsolated`.

- **Answer (EN):** Strict concurrency catches many races at compile time, but the compiler injects dynamic isolation checks when thread provenance is unclear. Mismatch traps with `_swift_task_checkIsolatedSwift` or `_dispatch_assert_queue_fail`. Common cases: MainActor-inherited closures run on background (Core Data perform, Combine before receive(on), notifications), MainActor classes with SDK delegates on private queues, misuse of assumeIsolated. Fixes: `@Sendable` closures, reorder receive(on), nonisolated delegates with explicit MainActor hop.

- **Устная заготовка (RU):**

    1. Clean build ≠ safe runtime — injected checks на actor/GCD границах.
    2. Closure в `@MainActor` **наследует** isolation — Core Data / Combine / notifications.
    3. Delegate у `@MainActor` class → `nonisolated` + `Task { @MainActor in }`.
    4. `@Sendable` closure или `receive(on:)` **раньше** — снять ложное наследование.

- **Устная заготовка (EN):**

    1. Runtime traps exist beyond compile-time race checks.
    2. Inherited MainActor closures + background SDK/Combine = classic crashes.
    3. nonisolated delegates with explicit MainActor hop for UI.
    4. @Sendable or receive(on) first to break inheritance.

- **Follow-up (RU):** Core Data — почему `{ @Sendable in }` в `perform`?
- **Follow-up answer (RU):** Без `@Sendable` closure **наследует `@MainActor`** от метода ViewModel, а `perform` вызывает блок на **своей background queue** → `_dispatch_assert_queue_fail`. `@Sendable` = нет implied actor context → runtime assertion не вставляется.

- **Follow-up (RU):** Combine — почему `receive(on:)` **после** `map` опасен?
- **Follow-up answer (RU):** `map`-closure унаследовал `@MainActor`, publisher emit'ит с **background** → `map` выполняется там **до** hop на main → crash. Переставить `receive(on: .main)` **перед** `map`/`sink` или пометить closure `@Sendable`.

- **Доп. информация:** [Swift 6 runtime concurrency crashes](notes/Swift-6-Runtime-Concurrency-Crashes.md); Q13 (reentrancy); [Combine-Interview-Roadmap](notes/Combine-Interview-Roadmap.md); Q20 (`assumeIsolated` в тестах).

- **Notes:** [notes/Swift-6-Runtime-Concurrency-Crashes.md](notes/Swift-6-Runtime-Concurrency-Crashes.md)

<!-- knowledge-cards-canonical:end -->

## Ресурсы

### Swift Concurrency in iOS — Explained Simply
- **Type:** article / social
- **URL:** _(add when available)_
- **Why:** Линейный intro: callbacks → async/await → Task → MainActor → actor → async let
- **When:** Быстро освежить основы перед интервью
- **Tags:** `concurrency`, `async-await`, `mainactor`, `actor`, `primer`
- **Playground:** [SwiftConcurrencyPrimer.playground](SwiftConcurrencyPrimer.playground)
- **Added:** 2026-06-19
