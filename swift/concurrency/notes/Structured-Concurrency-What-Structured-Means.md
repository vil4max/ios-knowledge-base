# Что значит «structured» в Structured Concurrency

**Источник:** [What's that "structured" in Structured Concurrency?](https://macguru.dev/whats-that-structured-in-structured-concurrency/) — macguru.dev. Связанные темы: [StructuredConcurrencyLab.playground](../StructuredConcurrencyLab.playground), [SwiftConcurrencyPrimer.playground](../SwiftConcurrencyPrimer.playground).

---

## Главный вопрос

`Task` кажется «структурированным»: есть handle, cancellation, async/await. Но в документации Swift написано:

> Runs the given (non-)throwing operation asynchronously as part of a new **unstructured top-level task**.

**Structured** относится не к «современности» API, а к **иерархии жизненного цикла**: родитель **не может завершиться**, пока дочерняя concurrent-работа не закончится (или не будет отменена вместе с ним).

---

## Три способа запустить concurrent-работу

| Способ | Structured? | Суть |
|--------|---------------|------|
| `Task { }` | **Нет** | top-level task — можно запустить и забыть |
| `async let` | **Да** | implicit subtask; scope функции владеет жизненным циклом |
| `withTaskGroup` / `withThrowingTaskGroup` | **Да** | closure обязан дождаться всех `group.addTask` |

**Structured** = прямая, неизбежная зависимость: вызывающий код **ждёт** дочернюю работу или **отменяет** её при своём завершении.

---

## Граф зависимостей

### Unstructured — плоский список

```swift
let a = Task {
    let b = Task { /* ... */ }
}
a.cancel()
// b НЕ отменён
```

```
→ Task a
→ Task b
```

### Structured — дерево

```swift
func load() async { /* ... */ }

let a = Task {
    async let b = load()
    async let c = load()
    _ = await (b, c)
}
a.cancel()
// async let b и c отменены
```

```
→ Task a
  ↳ async let b
  ↳ async let c
```

### TaskGroup — structured, несмотря на имя «Task»

```swift
let a = Task {
    await withTaskGroup(of: Void.self) { group in
        group.addTask { /* b */ }
        group.addTask { /* c */ }
    }
}
a.cancel()
// group, b и c отменены
```

```
→ Task a
  ↳ TaskGroup
    ↳ Task b
    ↳ Task c
```

Внешний `Task` здесь unstructured относительно своего родителя, но **группа structured** относительно задач внутри `withTaskGroup`.

---

## Cancellation как практическое следствие

При отмене structured-родителя дочерние операции отменяются **автоматически**.

При unstructured `Task` внутри другого `Task` — **нет**, пока не прокинешь отмену вручную:

```swift
let a = Task {
    let b = Task { /* ... */ }

    await withTaskCancellationHandler {
        await b.value
    } onCancel: {
        b.cancel() // onCancel вызывается синхронно при a.cancel()
    }
}
a.cancel()
// b гарантированно отменён после a.cancel()
```

---

## `async let` с отброшенным результатом

Даже если результат не нужен, зависимость остаётся:

```swift
let a = Task {
    async let _ = load() // функция вызвана, subtask создан
}
// при завершении a subtask отменяется
```

`await` не обязателен, но **scope владеет** subtask — как у вызова с `_ =`.

---

## `Task` vs async-closure

Часто вместо передачи `Task` достаточно **async-closure** — работа выполняется в контексте вызывающего, отмена наследуется, тестировать проще.

**Было** — `Task` + ручной cancellation handler:

```swift
func subtaskUpdate() async {
    let subtask: Task<Void, Never> = /* ... */

    await withTaskCancellationHandler {
        await subtask.value
    } onCancel: {
        subtask.cancel()
    }

    if !Task.isCancelled {
        update()
    }
}
```

**Стало** — closure:

```swift
func subtaskUpdate() async {
    let subtask: () async -> Void = /* ... */

    await subtask()

    if !Task.isCancelled {
        update()
    }
}
```

| | `Task` | `() async -> Void` |
|---|--------|---------------------|
| Старт | сразу при создании | когда вызывающий вызовет |
| Cancellation | нужен ручной wiring | наследуется от вызывающего |
| Тесты | сложнее (живёт отдельно) | проще (вызов как обычная функция) |

---

## Правило большого пальца

1. **Избегай** top-level `Task`, где можно.
2. **Предпочитай** `async let`, `TaskGroup`, обычные `async` функции.
3. Если `Task` неизбежен — auto-cancelling wrapper или проверенный helper.
4. Для изоляции между компонентами — **closure**, не `Task`-handle.

---

## Как отвечать на интервью

**Q: Что «structured» в Structured Concurrency?**

**A:** Иерархия владения жизненным циклом. `async let` и `TaskGroup` создают subtask, который **не переживёт** родительский scope: родитель ждёт результат или отменяет детей при своей отмене. `Task { }` — unstructured top-level task без такой связи; cancellation и cleanup нужно проектировать вручную.

**Q: `Task` внутри `Task` — structured?**

**A:** Нет. Внутренний `Task` — отдельный top-level task. Отмена внешнего не отменяет внутренний автоматически.

**Q: Когда `Task` всё же уместен?**

**A:** Future-подобный контракт (один producer, много consumers через `.value`), deduplication in-flight запросов, async boundary из sync callback (UIKit delegate и т.п.). Structured vs unstructured — [StructuredConcurrencyLab.playground](../StructuredConcurrencyLab.playground).

---

## Ссылки

- [StructuredConcurrencyLab.playground](../StructuredConcurrencyLab.playground) — runnable demos (cancellation propagation)
- [What's that "structured" in Structured Concurrency?](https://macguru.dev/whats-that-structured-in-structured-concurrency/) — macguru.dev
- [The Versatility of Tasks](https://macguru.dev/the-versatility-of-tasks/) — серия macguru.dev про Task и cancellation
- [Swift Concurrency — Tasks](https://developer.apple.com/documentation/swift/concurrency#Tasks) — Apple Documentation
