# Swift 6 Runtime Concurrency Crashes

**Источник:** [How to avoid Swift 6 concurrency crashes](https://onmyway133.com/posts/how-to-avoid-swift-6-concurrency-crashes/) — Swift Discovery (Khoa Pham / onmyway133), май 2026. Карточка **Q50** в `Swift-Concurrency.md`. Связь: Q12–Q13 (isolation, reentrancy), [Combine-Interview-Roadmap](Combine-Interview-Roadmap.md).

---

## Main idea

_English summary — expand «По-русски» for full text (Главная мысль)._

<details class="lang-ru">
<summary>По-русски</summary>

`SWIFT_STRICT_CONCURRENCY = complete` ловит **data races на compile time**, но **не закрывает runtime**. Компилятор вставляет **динамические проверки изоляции** на границах actor / GCD. Сборка может быть **без warnings**, crash — **в проде**.

**Swift 5:** нарушение потоков часто **молча** выполнялось «не там». **Swift 6:** runtime **trap** вместо продолжения в потенциально unsafe state.

---

</details>

## Crash symbols in report

_English summary — expand «По-русски» for full text (Crash symbols в отчёте)._

<details class="lang-ru">
<summary>По-русски</summary>

| Symbol | Смысл |
|--------|--------|
| `_swift_task_checkIsolatedSwift` | Ожидали **actor isolation** (`@MainActor` и т.д.), выполнили **вне** него |
| `_dispatch_assert_queue_fail` | Ожидали **конкретную GCD-очередь**, выполнили на **другой** |

**Общая причина:** код **унаследовал isolation** из контекста определения, **вызвали с другого потока**.

Это **не compile-time diagnostic** — compiler не всегда статически знает, на каком потоке выполнится closure, и вставляет runtime check.

---

</details>

## 1. Closures inherit actor isolation

_English summary — expand «По-русски» for full text (1. Closures наследуют actor isolation)._

<details class="lang-ru">
<summary>По-русски</summary>

Closure внутри `@MainActor`-метода **наследует `@MainActor`**. Компилятор помечает его main-actor-isolated и вставляет assertion.

### Core Data `perform`

```swift
@MainActor
class ContactsViewModel {
    func deleteAll(context: NSManagedObjectContext) {
        context.perform {
            // inherits @MainActor; Core Data runs on private background queue
            // → _dispatch_assert_queue_fail
            let request = NSFetchRequest<Contact>(entityName: "Contact")
            let contacts = try? context.fetch(request)
            contacts?.forEach { context.delete($0) }
        }
    }
}
```

**Fix:** `@Sendable` снимает наследование isolation — assertion не вставляется.

```swift
context.perform { @Sendable in
    let request = NSFetchRequest<Contact>(entityName: "Contact")
    let contacts = try? context.fetch(request)
    contacts?.forEach { context.delete($0) }
}
```

### Combine pipeline

```swift
@MainActor
class SearchViewModel {
    func subscribe() {
        searchPublisher
            .map { value in              // inherits @MainActor from subscribe()
                value.lowercased()
            }
            .receive(on: DispatchQueue.main)
            .sink { self.results = $0 }
            .store(in: &cancellables)
    }
}
```

Publisher может emit на **background** → `map` выполняется там → crash **до** `receive(on:)`.

**Fix A — hop first:**

```swift
searchPublisher
    .receive(on: DispatchQueue.main)
    .map { $0.lowercased() }
    .sink { self.results = $0 }
    .store(in: &cancellables)
```

**Fix B — off-main work:**

```swift
searchPublisher
    .map { @Sendable value in value.lowercased() }
    .receive(on: DispatchQueue.main)
    .sink { self.results = $0 }
    .store(in: &cancellables)
```

### NotificationCenter

Тот же паттерн: notification с **background** + `sink` в `@MainActor` классе → isolated closure → crash.

**Fix:** `.receive(on: DispatchQueue.main)` **перед** `sink`.

---

</details>

## 2. `@MainActor` delegate methods on wrong thread

_English summary — expand «По-русски» for full text (2. `@MainActor` delegate methods с wrong thread)._

<details class="lang-ru">
<summary>По-русски</summary>

Весь класс `@MainActor` → **все методы**, включая delegate overrides, наследуют main isolation. SDK часто зовёт их **не с main**.

### NSDocument

```swift
@MainActor
class MyDocument: NSDocument {
    override class var autosavesInPlace: Bool { true }
    // AppKit calls from background during autosave → _swift_task_checkIsolatedSwift
}
```

**Fix:**

```swift
override nonisolated class var autosavesInPlace: Bool { true }
```

### CLLocationManagerDelegate

```swift
@MainActor
class LocationManager: NSObject, CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateMap(with: locations)  // framework internal queue → crash
    }
}
```

**Fix:**

```swift
nonisolated func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    Task { @MainActor in
        self.updateMap(with: locations)
    }
}
```

Тот же паттерн: **`AVAudioPlayerDelegate`**, **`WKNavigationDelegate`**, любой SDK delegate без гарантии main thread.

---

</details>

## 3. Other scenarios

_English summary — expand «По-русски» for full text (3. Прочие сценарии)._

<details class="lang-ru">
<summary>По-русски</summary>

### `MainActor.assumeIsolated`

Crash **сразу**, если код **не на main**. Только legacy-bridge, где main **доказан** — не замена `await MainActor.run` в async-коде.

### Actor reentrancy

После `await` актор разблокирован — другие задачи могут менять state. Редко instant crash; чаще precondition failures / corrupted state. См. **Q13**.

---

</details>

## Oral summaries (interview)

_English summary — expand «По-русски» for full text (Устные заготовки (собес))._

<details class="lang-ru">
<summary>По-русски</summary>

**RU:**

1. Strict concurrency ≠ полная runtime-защита — injected checks на actor/GCD границах.
2. Closure в `@MainActor` **наследует** isolation → Core Data / Combine / NotificationCenter — типичные prod crash.
3. Fix: `@Sendable` closure, `receive(on:)` **раньше**, `nonisolated` delegate + `Task { @MainActor in }`.
4. `assumeIsolated` — только когда main **гарантирован** SDK/legacy.
5. Тестировать **реальные SDK callbacks** и background publishers — warnings не покрывают.

**EN:**

1. Strict mode still has runtime isolation traps at actor/GCD boundaries.
2. Closures inherit caller isolation—Core Data perform, Combine map, NotificationCenter sink are common crash sites.
3. Fixes: `@Sendable`, reorder `receive(on:)`, `nonisolated` delegates with explicit MainActor hop.
4. `assumeIsolated` only when main is proven—not a shortcut for `MainActor.run`.
5. Manual testing with real SDK threading beats compile-only confidence.

---

</details>

## Swift 5 vs Swift 6 (one line)

_English summary — expand «По-русски» for full text (Swift 5 vs Swift 6 (одной строкой))._

<details class="lang-ru">
<summary>По-русски</summary>

| Swift 5 | Swift 6 |
|---------|---------|
| Wrong thread → часто тихо | Wrong thread → **trap** (`_swift_task_checkIsolatedSwift` / `_dispatch_assert_queue_fail`) |

</details>

