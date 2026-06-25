# Concurrency evolution on Apple platforms: threads to Swift Concurrency

**Назначение:** одна линия развития абстракций — **что появилось позже чем что**, зачем, и **минимальный пример**. Для интервью и миграции легаси. Связка с темой **08:** [вводный конспект `Swift-Concurrency.md`](../Swift-Concurrency.md) (якорь [`#concurrency-primer-s0`](../Swift-Concurrency.md#concurrency-primer-s0)).

**Плейграунд** (все подходы подряд, с комментариями в коде): [`ConcurrencyEvolutionFromThreads.playground/Contents.swift`](../ConcurrencyEvolutionFromThreads.playground/Contents.swift).

---

## Table of contents

_English summary — expand «По-русски» for full text (Оглавление)._

<details class="lang-ru">
<summary>По-русски</summary>

1. [Процесс и поток ОС](#1-процесс-и-поток-ос)
2. [Явный поток: `Thread`](#2-явный-поток-thread)
3. [[RunLoop](../../../XI. Резюме/Глоссарий/Glossary.md#glossary-runloop) и один поток](#3-runloop-и-один-поток)
4. [GCD: очереди и блоки](#4-gcd-очереди-и-блоки)
5. [`Operation` и `OperationQueue`](#5-operation-и-operationqueue)
6. [Callbacks и делегаты (без `async`)](#6-callbacks-и-делегаты-без-async)
7. [Combine как слой поверх GCD](#7-combine-как-слой-поверх-gcd)
8. [Swift Concurrency](#8-swift-concurrency)
9. [Одна и та же задача: четыре эпохи](#9-одна-и-та-же-задача-четыре-эпохи)
10. [Сводная таблица](#10-сводная-таблица)
11. [Ссылки](#11-ссылки)

---

</details>

## 1. OS process and thread

_English summary — expand «По-русски» for full text (1. Процесс и поток ОС)._

<details class="lang-ru">
<summary>По-русски</summary>

**Процесс** — изолированное адресное пространство и ресурсы (файловые дескрипторы, учёт времени CPU). **Поток (thread)** — единица планирования внутри процесса: свой стек, общая куча с соседними потоками того же процесса.

На iOS приложение обычно в **одном процессе**; система поднимает потоки для **main**, для **GCD worker pool**, для **I/O**, для **Swift concurrency** и т.д. Прикладной код редко создаёт сотни **явных** `Thread`: чаще используют очереди и языковые примитивы.

---

</details>

## 2. Explicit thread: `Thread`

_English summary — expand «По-русски» for full text (2. Явный поток: `Thread`)._

<details class="lang-ru">
<summary>По-русски</summary>

**Идея:** ты сам создаёшь **долгоживущий** поток и решаешь, что на нём крутить.

**Плюсы:** предсказуемая модель «один поток — одна крутилка», простые ментальные эксперименты.

**Минусы:** ручной lifecycle, легко перегрузить систему потоками, нет встроенного **DAG задач** и **структурированной отмены**; гонки на общих данных остаются на совести разработчика.

```swift
import Foundation

func runOnOwnThread() {
    let worker = Thread {
        let result = (1...1_000_000).reduce(0, +)
        DispatchQueue.main.async {
            print("sum", result)
        }
    }
    worker.name = "cpu-worker"
    worker.start()
}
```

---

</details>

## 3. [RunLoop](../../../glossary/README.md#glossary-runloop) and one thread

_English summary — expand «По-русски» for full text (3. [RunLoop](../../../XI. Резюме/Глоссарий/Glossary.md#glossary-runloop) и один поток)._

<details class="lang-ru">
<summary>По-русски</summary>

**[RunLoop](../../../XI. Резюме/Глоссарий/Glossary.md#glossary-runloop)** — цикл обработки **источников** (таймеры, сокеты, custom sources) на **конкретном** потоке. **Main thread** крутит main [RunLoop](../../../XI. Резюме/Глоссарий/Glossary.md#glossary-runloop) и UI-события.

Если запустить таймер на фоновом потоке **без** прокрутки [RunLoop](../../../XI. Резюме/Глоссарий/Glossary.md#glossary-runloop), колбэк может **никогда** не сработать: поток завершил блок и умер, либо [RunLoop](../../../XI. Резюме/Глоссарий/Glossary.md#glossary-runloop) не запущен.

```swift
import Foundation

func timerNeedsRunLoopPump() {
    Thread {
        RunLoop.current.add(
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                print("fired")
            },
            forMode: .common
        )
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1.0))
    }.start()
}
```

Практический вывод: **«поток» ≠ «фоновая работа из коробки»** — для событийного кода на потоке нужен [RunLoop](../../../XI. Резюме/Глоссарий/Glossary.md#glossary-runloop) (или ты используешь очередь GCD / async runtime, где это уже не твоя забота).

---

</details>

## 4. GCD: queues and blocks

_English summary — expand «По-русски» for full text (4. GCD: очереди и блоки)._

<details class="lang-ru">
<summary>По-русски</summary>

**Идея:** не бронировать поток навсегда, а класть **блоки** на **serial** или **concurrent** `DispatchQueue`; система сопоставляет блоки потокам из пула.

**Плюсы:** дёшево, привычно, хорошо для «сделай на фоне, верни на main».

**Минусы:** компилятор не знает **модель данных**; цепочки `async { ... async { ... } }`, гонки и дедлоки — ручная дисциплина.

```swift
import Dispatch

func gcdBackgroundThenMain() {
    DispatchQueue.global(qos: .userInitiated).async {
        let computed = "payload".uppercased()
        DispatchQueue.main.async {
            print(computed)
        }
    }
}
```

**Группы** (`DispatchGroup`) — дождаться нескольких асинхронных стартов без объектной обёртки `Operation`.

```swift
import Dispatch

func gcdGroup() {
    let group = DispatchGroup()
    let q = DispatchQueue.global(qos: .utility)
    group.enter()
    q.async {
        Thread.sleep(forTimeInterval: 0.05)
        group.leave()
    }
    group.notify(queue: .main) {
        print("all done")
    }
}
```

---

</details>

## 5. `Operation` and `OperationQueue`

_English summary — expand «По-русски» for full text (5. `Operation` и `OperationQueue`)._

<details class="lang-ru">
<summary>По-русски</summary>

**Идея:** **объект** «единица работы» с состоянием, приоритетом, **`dependencies`** (граф), **`cancel()`** (кооперативно), `completionBlock`. Очередь похожа на надстройку над планированием с политикой QoS и лимитом параллелизма (`maxConcurrentOperationCount`).

**Плюсы:** выразительный **DAG**, массовая отмена очереди, переиспользование подклассов.

**Минусы:** больше оверхеда, чем у сырого GCD; **асинхронная** работа внутри `Operation` требует ручного управления `isExecuting` / `isFinished` (или [KVO](../../../XI. Резюме/Глоссарий/Glossary.md#glossary-kvo)), иначе очередь «думает», что операция уже закончилась.

```swift
import Foundation

func operationDependencyChain() {
    let queue = OperationQueue()
    let fetch = BlockOperation {
        Thread.sleep(forTimeInterval: 0.05)
    }
    let parse = BlockOperation {
        Thread.sleep(forTimeInterval: 0.02)
    }
    parse.addDependency(fetch)
    queue.addOperations([fetch, parse], waitUntilFinished: false)
}
```

Развёрнутый разбор (в т.ч. Habr): [`Operating-Systems-and-Networks-for-iOS.md`](../../../I. Фундамент/02 Операционные системы и сети для iOS/Operating-Systems-and-Networks-for-iOS.md) — секция «Многопоточность: Operation и OperationQueue».

---

</details>

## 6. Callbacks and delegates (without `async`)

_English summary — expand «По-русски» for full text (6. Callbacks и делегаты (без `async`))._

<details class="lang-ru">
<summary>По-русски</summary>

**Идея:** асинхронность выражена **инверсией управления** — «позови меня, когда будет готово».

**Плюсы:** работает везде, с любым API.

**Минусы:** вложенные closures, размазанная отмена, легко ошибиться с потоком вызова completion (не всегда main).

```swift
import Foundation

func callbackStyle(completion: @escaping (String) -> Void) {
    DispatchQueue.global(qos: .utility).async {
        let value = "ok"
        DispatchQueue.main.async {
            completion(value)
        }
    }
}
```

**Swift Concurrency** заменяет типичную цепочку на линейный `async`/`await` и точки отмены в одном стиле.

---

</details>

## 7. Combine as a layer over GCD

_English summary — expand «По-русски» for full text (7. Combine как слой поверх GCD)._

<details class="lang-ru">
<summary>По-русски</summary>

**Идея:** поток событий (**Publisher**), операторы, подписка; планировщики (`receive(on:)`, `subscribe(on:)`) снова опираются на **очереди** / [RunLoop](../../../XI. Резюме/Глоссарий/Glossary.md#glossary-runloop).

**Плюсы:** декларативные пайплайны, отмена через `AnyCancellable`.

**Минусы:** другая модель мышления; для нового кода Apple и экосистема всё чаще дают **`AsyncSequence`** / **`async`** API вместо Combine.

```swift
import Combine
import Foundation

func combineReceiveOnMain() -> AnyCancellable {
    Just(42)
        .subscribe(on: DispatchQueue.global(qos: .userInitiated))
        .receive(on: DispatchQueue.main)
        .sink { print($0) }
}
```

---

</details>

## 8. Swift Concurrency

_English summary — expand «По-русски» for full text (8. Swift Concurrency)._

<details class="lang-ru">
<summary>По-русски</summary>

**Идея:** **`async`/`await`** для приостановки без обязательной привязки к «ручному» потоку; **`Task`** — единица работы с **structured concurrency** и отменой по дереву; **`actor`** и **`@MainActor`** — **изоляция**; **`Sendable`** — допустимость пересечения границ.

**Плюсы:** компилятор участвует в безопасности; линейный код; нативные `async` API платформы.

**Минусы:** нужно понимать **reentrancy** актора, строгий режим, мост к легаси через continuations.

```swift
import Foundation

actor Counter {
    private var value = 0
    func increment() {
        value += 1
    }
    func snapshot() -> Int {
        value
    }
}

func modernLoad() async -> String {
    try? await Task.sleep(for: .milliseconds(50))
    return "ready"
}

@MainActor
func modernUIUpdate() async {
    let text = await modernLoad()
    print(text)
}
```

Официально: [Concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/) в Swift Language Guide.

---

</details>

## 9. Same task: four eras

_English summary — expand «По-русски» for full text (9. Одна и та же задача: четыре эпохи)._

<details class="lang-ru">
<summary>По-русски</summary>

Задача: **посчитать строку на фоне, показать на main**.

| Слой | Суть вызова |
|------|-------------|
| **Thread** | свой поток + `DispatchQueue.main.async` с результатом |
| **GCD** | `global().async` + `main.async` |
| **Operation** | `BlockOperation` на фоновой `OperationQueue`, `completionBlock` с `OperationQueue.main.addOperation` или GCD на main |
| **Swift Concurrency** | `await` фоновой `async`-функции из контекста, который потом обновляет UI на `@MainActor` |

---

</details>

## 10. Summary table

_English summary — expand «По-русски» for full text (10. Сводная таблица)._

<details class="lang-ru">
<summary>По-русски</summary>

| Слой | Что абстрагирует | Кто гарантирует порядок доступа к state | Отмена | Компилятор про гонки |
|------|------------------|----------------------------------------|---------|----------------------|
| Поток ОС | планирование ядром | никто | вручную | нет |
| `Thread` | явный поток | никто | вручную | нет |
| [RunLoop](../../../XI. Резюме/Глоссарий/Glossary.md#glossary-runloop) | события на потоке | никто (ты проектируешь) | вручную | нет |
| GCD | очередь блоков | ты (serial queue / барьеры) | частично (`DispatchWorkItem`) | нет |
| Operation | объект задачи + DAG | ты + serial side-queue | `cancel` / кооперация | нет |
| Callbacks | контракт «позвони позже» | ты | договорённости | нет |
| Combine | поток значений | ты + операторы | `Cancellable` | нет |
| Swift Concurrency | приостановка и изоляция | `actor` / `MainActor` / дисциплина `Sendable` | `Task` cancellation | частично (строгий режим) |

**Практическое правило:** новый Swift-код — **Swift Concurrency**; легаси — читать по таблице «чем это было сделано» и мигрировать границами модулей.

---

</details>

## 11. Links

_English summary — expand «По-русски» for full text (11. Ссылки)._

<details class="lang-ru">
<summary>По-русски</summary>

- [Swift Language Guide — Concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/)
- [WWDC 2015: Advanced NSOperations](https://developer.apple.com/videos/play/wwdc2015/226/) (`Operation` в архитектуре)
- [Habr: Operation и OperationQueue](https://habr.com/en/articles/335756/) (Swift 3–4, идеи сохраняются)
- Конспект Operation в фундаменте: [`Operating-Systems-and-Networks-for-iOS.md`](../../../I. Фундамент/02 Операционные системы и сети для iOS/Operating-Systems-and-Networks-for-iOS.md)
- Подробнее про изоляцию и очереди в одном интервью-блоке: [Actors vs Queues vs Locks](https://livsycode.com/best-practices/actors-vs-queues-vs-locks-in-swift/)

</details>

