# Notes on Approachable Swift Concurrency (RU site)

**Источник:** [fuckingapproachableswiftconcurrency.com/ru](https://fuckingapproachableswiftconcurrency.com/ru/) — адаптация идей [Matt Massicotte](https://www.massicotte.org/), оформление [Pedro Piñera](https://pepicrft.me/) ([Tuist](../../../XI. Резюме/Глоссарий/Glossary.md#glossary-tuist)). Здесь — сжатая выжимка для темы **08**; примеры кода и полный текст смотри на сайте и в [Swift Language Guide — Concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/).

---

## 1. Why `async`/`await`

_English summary — expand «По-русски» for full text (1. Зачем `async`/`await`)._

<details class="lang-ru">
<summary>По-русски</summary>

Приложение много **ждёт**: сеть, диск, БД. Раньше — callbacks, делегаты, Combine. **`async`/`await`** даёт код, который **выглядит последовательным**, но **приостанавливается** на `await` и **возобновляется** после готовности; пока ждёшь, runtime может занять поток другой работой. Это не отменяет вопрос **где** исполняется тяжёлая CPU-работа (см. ниже).

- **`await` только внутри `async`**-контекста.
- **Несколько независимых ожиданий:** подряд `await` — медленно; **`async let`** стартует параллельно, `await` собирает результаты.

---

</details>

## 2. `Task` and work structure

_English summary — expand «По-русски» for full text (2. `Task` и структура работы)._

<details class="lang-ru">
<summary>По-русски</summary>

**[Task](https://developer.apple.com/documentation/swift/task)** — единица асинхронной работы: запуск `async` из синхронного кода, ожидание результата (`.value`), отмена, фон.

- **SwiftUI `.task` / `.task(id:)`** — привязка к жизненному циклу view, отмена при уходе с экрана / смене `id`.
- **`Button { Task { await … } }`** — ручной запуск по событию.
- **`TaskGroup` / `withThrowingTaskGroup`** — динамическое число дочерних задач; **structured concurrency**: дерево задач, отмена и ошибки связаны с родителем (детали потребления результатов — на сайте и в доках Apple).

---

</details>

## 3. From threads to isolation

_English summary — expand «По-русски» for full text (3. От потоков к изоляции)._

<details class="lang-ru">
<summary>По-русски</summary>

Старый стек: **Thread**, **GCD**, **OperationQueue**, **Combine** — работало, но **безопасность конкурентного доступа к памяти** была на разработчике.

**[Data race](https://developer.apple.com/documentation/xcode/data-races)** — два обращения к одной памяти, хотя бы одно запись → UB (краш, порча данных, «флаки» тесты).

Модель Swift: вместо «**на каком потоке**?» — «**кому разрешено трогать эти данные**?» → **[isolation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/#Isolation)**. Границы декларируешь ты, **компилятор** проверяет на этапе сборки.

**Под капотом:** Swift Concurrency опирается на **libdispatch**; планирование — **кооперативный пул потоков** (ограничен числом ядер и т.д., см. WWDC про планировщик). Отличие — **слой компилятора** (акторы, изоляция, `Sendable`).

---

</details>

## 4. Three isolation domains (as on site)

_English summary — expand «По-русски» for full text (4. Три домена изоляции (как на сайте))._

<details class="lang-ru">
<summary>По-русски</summary>

1. **`@MainActor`** — глобальный актор **главного потока** для UI (UIKit / AppKit / SwiftUI). Не синоним «просто `dispatch` на main»: это **домен изоляции**; чужой код должен пересекать границу через `await`, где нужно.
2. **`actor`** — **свой** домен для изменяемого состояния; снаружи доступ через `await`; актор ≠ «отдельный поток навсегда» — поток выбирает runtime.
3. **`nonisolated`** — метод **вне** защищённого состояния актора; к полям актора из него нельзя без дисциплины.

**Офисная метафора (с сайта):** `MainActor` — ресепшен (всё, что видит пользователь); `actor` — отделы с закрытыми документами; `nonisolated` — коридор без секретов; в чужой офис — только через «стук» (`await`).

---

</details>

## 5. Approachable Concurrency and `@concurrent` (Swift 6.2+)

_English summary — expand «По-русски» for full text (5. Approachable Concurrency и `@concurrent` (Swift 6.2+))._

<details class="lang-ru">
<summary>По-русски</summary>

По материалу сайта (см. [Swift 6.2 — Approachable Concurrency](https://www.swift.org/blog/swift-6.2-released/#approachable-concurrency)):

- **`SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`** — по умолчанию изоляция главного актора, если не указано иное.
- **`SWIFT_APPROACHABLE_CONCURRENCY = YES`** — **`nonisolated async`** чаще остаётся на **акторе вызывающего**, без лишнего прыжка на фон.
- Для **CPU-heavy** вне main — **`@concurrent`** (явный opt-in к фону; точное поведение сверяй с версией Xcode / SE).

Новые шаблоны Xcode на момент текста сайта могли включать эти флаги по умолчанию — **проверяй Build Settings** своего проекта.

---

</details>

## 6. `Sendable`

_English summary — expand «По-русски» for full text (6. `Sendable`)._

<details class="lang-ru">
<summary>По-русски</summary>

**[[Sendable](../../../XI. Резюме/Глоссарий/Glossary.md#glossary-sendable)](https://developer.apple.com/documentation/swift/sendable)** — маркер «тип можно **безопасно передавать** между доменами изоляции». Value-типы с `Sendable`-полями, акторы, иммутабельные `final class` — типичные случаи; **`@unchecked Sendable`** — обещание разработчика, ошибка → снова data race.

**Метафора с сайта:** ксерокопии vs один оригинал контракта — пересылать безопасно то, что **не даёт двум сторонам мутировать одно и то же** без правил.

---

</details>

## 7. How isolation “leaks”

_English summary — expand «По-русски» for full text (7. Как «течёт» изоляция)._

<details class="lang-ru">
<summary>По-русски</summary>

- Вызов функции — изоляция **вызываемой** сущности (`@MainActor`, `actor`, наследование от вызывающего при Approachable defaults).
- **Замыкания** наследуют изоляцию **места определения** (почему `Button` в SwiftUI может трогать `@State` без лишнего танца).
- **`Task { }`** наследует изоляцию **места создания** (часто то, что нужно для UI-моделей).
- **`Task.detached`** — **без наследования**; на сайте — **крайняя мера** ([форум Swift](https://forums.swift.org/t/revisiting-when-to-use-task-detached/57929)); для фона предпочтительнее **`@concurrent`**, чем размазывать `detached`.

**Утилиты `async`:** если `nonisolated` обобщённая функция принимает замыкание с захватом `MainActor`, компилятор ругается на non-`Sendable` closure. Варианты с сайта: **`nonisolated(nonsending)`** (остаться на executor вызывающего) или параметр **`isolation: isolated (any Actor)? = #isolation`** ([#isolation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/expressions/#Isolation-Expression)) для явной передачи контекста.

---

</details>

## 8. Summary model (central idea of site)

_English summary — expand «По-русски» for full text (8. Сводная модель (центральная мысль сайта))._

<details class="lang-ru">
<summary>По-русски</summary>

С **Approachable Concurrency** стартовая точка — **`MainActor`**, дальше изоляция **распространяется** (функции, замыкания, `Task { }`), пока ты **явно** не выберешь:

- **`@concurrent`** — фоновая CPU-работа;
- **`actor`** — отдельный изолированный тип состояния;
- **`Task.detached`** — «чистый лист» без наследования.

Между доменами данные проверяются на **`Sendable`**. Жалобы компилятора — почти всегда нарушение одного из этих трёх правил; ищи цепочку наследования и пересечения границ.

---

</details>

## 9. Typical mistakes (checklist from site)

_English summary — expand «По-русски» for full text (9. Типичные ошибки (чеклист с сайта))._

<details class="lang-ru">
<summary>По-русски</summary>

| Ошибка | Суть |
|--------|------|
| **`async` = фон** | `async` на `@MainActor` с синхронным тяжёлым телом **блокирует main**; фон — `@concurrent` / вынести работу в изолированный контекст. |
| **Слишком много акторов** | Правило Massicotte: актор только если (1) non-`Sendable` state, (2) операции должны быть атомарны в смысле актора, (3) нельзя уложиться в существующий актор; иначе чаще **`@MainActor`**. |
| **Всё `Sendable` / везде `@unchecked`** | Если данные не пересекают домены — маркеры не нужны; `@unchecked` без причины = маскировка гонок. |
| **`MainActor.run` без нужды** | Лучше **`@MainActor`** на функции/типе — яснее для компилятора ([заметки Massicotte](https://www.massicotte.org/problematic-patterns/)). |
| **Блокировать кооперативный пул** | `DispatchSemaphore.wait()` и т.п. **внутри** async-цепочки на пуле → риск **deadlock**; оставаться в async-модели. |
| **«Невидимые» `Task { }`** | Нет отмены, нет `.value`, нет связи с structured group — для UI предпочтительны **`.task` / `task(id:)`** и паттерны с управляемым жизненным циклом; группы — когда контекст уже `async`. |

---

</details>

## 10. Keyword cheat sheet (as on site)

_English summary — expand «По-русски» for full text (10. Шпаргалка ключевых слов (как на сайте))._

<details class="lang-ru">
<summary>По-русски</summary>

| Ключевое слово | Смысл |
|----------------|--------|
| `async` | Функция может приостанавливаться |
| `await` | Ждать завершения другой async-операции |
| `Task { }` | Запуск async, **наследует** контекст |
| `Task.detached { }` | Запуск **без** наследования |
| `@MainActor` | Домен главного потока для UI |
| `actor` | Изолированное изменяемое состояние |
| `nonisolated` | Код вне защищённого состояния актора |
| `nonisolated(nonsending)` | Не уходить с executor вызывающего |
| `Sendable` | Безопасно пересекать изоляцию |
| `@concurrent` | Явный фон (Swift 6.2+, сверяй доку) |
| `#isolation` | Параметр «текущая изоляция вызывающего» |
| `async let` | Параллель на фиксированном наборе |
| `TaskGroup` | Параллель на динамическом наборе |

---

</details>

## 11. Where next (links from site)

_English summary — expand «По-русски» for full text (11. Куда дальше (ссылки с сайта))._

<details class="lang-ru">
<summary>По-русски</summary>

- Matt Massicotte: [Concurrency Glossary](https://www.massicotte.org/concurrency-glossary), [Intro to isolation](https://www.massicotte.org/intro-to-isolation/), [When should you use an actor?](https://www.massicotte.org/actors/), [Non-Sendable types are cool too](https://www.massicotte.org/non-sendable/)
- Apple: [Meet async/await (WWDC21)](https://developer.apple.com/videos/play/wwdc2021/10132/), [Actors (WWDC21)](https://developer.apple.com/videos/play/wwdc2021/10133/)
- Навык для агентов: [SKILL.md на сайте](https://fuckingapproachableswiftconcurrency.com/SKILL.md) — при работе с Claude Code / др. можно подключить как контекст.

---

</details>

## Link to this repository

_English summary — expand «По-русски» for full text (Связь с этим репозиторием)._

<details class="lang-ru">
<summary>По-русски</summary>

- Развёрнутый вводный каркас и Q&A: [Swift-Concurrency.md](../Swift-Concurrency.md) (**Вводный конспект**, **Q11–Q20**).
- Плейграунды: `TaskVersatility.playground`, `ActorsQueuesLocksInterview.playground`.

</details>

