# Stateless Actors (Matt Massicotte)

**Источник:** [Stateless Actors](https://www.massicotte.org/stateless-actors/) — [Matt Massicotte](https://www.massicotte.org/), май 2026. Связанные темы: [Approachable Swift Concurrency](notes/Approachable-Swift-Concurrency-Site-RU.md), `@concurrent`, custom executors.

---

## Главный вопрос

Если **actor** защищает **mutable state**, имеет ли смысл **actor без свойств**?

**Короткий ответ:** да, но редко и **осознанно**. Часто это запах (непонимание модели или лишняя сложность). **First rule of actors:** уметь чётко объяснить, **зачем** нужна синхронизация.

---

## 1. «Stateless» NetworkClient-style actor

```swift
actor NetworkClient {
    func loadCart() async throws -> [Product] {
        let (data, _) = try await URLSession.shared.data(for: cartRequest)
        return try JSONDecoder().decode([Product].self, from: data)
    }
}
```

**Зачем actor без полей:**

| Плюс | Суть |
|------|------|
| `Sendable` «бесплатно» | reference type можно передавать между доменами изоляции |
| Синхронная работа не на main | JSON decode и т.п. идут на shared thread pool актора, не на `@MainActor` |
| Задел на будущее | позже появятся cache, auth token — уже есть домен изоляции |

**Минусы:**

- плохо стыкуется с **protocols** (isolation mismatch);
- входы/выходы должны быть **`Sendable`** → давление на типы;
- **сериализация**: все синхронные блоки на одном executor — **один decode за раз**, даже при N параллельных `Task`.

**Альтернатива (Swift 6.2+):**

```swift
struct NetworkClient: Sendable {
    @concurrent
    func loadCart() async throws -> [Product] { ... }
}
```

- проще с протоколами;
- `@concurrent` — **параллельные** тяжёлые вызовы без очереди актора;
- struct + `Sendable` вместо actor как «костыля» для Sendable.

**Вывод:** actor без state — не «всегда плохо», но сравни с **`Sendable struct` + `@concurrent`**.

---

## 2. `@globalActor` BackgroundActor — антипаттерн

```swift
@globalActor
actor BackgroundActor {
    static let shared = BackgroundActor()
}

Task { @BackgroundActor in ... }
```

**Проблемы:**

1. **Сериализация** — как у обычного актора: один background-task за раз на shared executor.
2. **Viral typing** — global actor «размазывается» по типам (как `@MainActor`, но в обратную сторону); снять потом больно.

**Лучше:** знать **`nonisolated async`**, **`@concurrent`**, явный `Task` / domain actors — не подменять язык вторым глобальным актором «для всего фона».

---

## 3. Custom executor actor (легитимный «stateless»)

Actor как **мост** к чужой системе очередей — основной use case **custom serial executors**:

```swift
actor LandingSite {
    private let queue = DispatchSerialQueue(label: "something")

    nonisolated var unownedExecutor: UnownedSerialExecutor {
        queue.asUnownedSerialExecutor()
    }

    func acceptTransport(_ transport: PersonalTransportation) {
        // выполняется на queue
    }
}
```

- интеграция с **AVFoundation**, legacy GCD, queue-based API;
- **`MainActor`** — тот же класс идей: почти нет «своих» properties, но управляет **UI state** всего процесса.

---

## 4. Файловая система = внешнее state

On-disk cache / файлы — **state вне процесса**, невидимое компилятору. Actor сериализует доступ → меньше порчи файлов при concurrent writes.

**Нюансы:**

- компилятор **не проверяет** корректность — нужна дисциплина инкапсуляции;
- sync read/write **блокирует поток** cooperative pool (≈ число ядер на QoS), не бесконечный GCD thread explosion;
- при риске starvation blocking I/O — **снять с pool** (GCD / dedicated queue) осознанно.

---

## 5. First rule of actors (для собеса)

> Actors over-used. Как любой примитив синхронизации — **объясни, зачем он нужен**.

**Устная заготовка (RU):**

1. Actor без полей — странно по умолчанию; часто лучше **`Sendable struct` + `@concurrent`**.
2. Исключения: **custom executor**, **внешнее state** (FS), **скоро будет state**, осознанный **Sendable reference type**.
3. **`@globalActor` для «всего фона»** — сериализация + viral isolation; избегать.
4. Помни **serial sync work** на actor — bottleneck при параллельных вызовах.

**Устная заготовка (EN):**

1. Stateless actors are odd by default; often `Sendable struct` + `@concurrent` wins.
2. Valid cases: custom executors, external state (filesystem), imminent mutable state, intentional Sendable service type.
3. Avoid a global `@BackgroundActor`—serialization and viral typing.
4. Actor serializes synchronous sections—parallel callers queue up.

---

## Связь с roadmap

- Q12–Q13 — actor isolation, reentrancy
- Q49 в `Swift-Concurrency.md` — карточка по этой статье
- Senior: custom executors (Iosiq snapshot — «экзотика», но на собесе senior+ спрашивают сценарии)
