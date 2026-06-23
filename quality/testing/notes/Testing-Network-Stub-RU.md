# Unit-тесты сети без HTTP

**Назначение:** шлюз из темы Testing в networking — fake client vs `URLProtocol`. Полная Q-карточка: [Networking Q (H30)](../../../data-and-network/networking/README.md).

**Topic README:** [Testing](../README.md)

---

## TL;DR

В **unit** не ходим в интернет. Два пути: **fake `HTTPClient`** (быстрее, чище) или **`URLProtocol`** в `protocolClasses` (прогоняет реальный `URLSession`). Не трогать `URLSession.shared`. Проверяем запрос, статус, декодинг, ошибки, retry, отмену.

---

## Выбор подхода

```mermaid
flowchart TD
    Q{Нужен реальный URLSession stack?}
    Q -->|Нет — только логика клиента| FAKE[Fake HTTPClient protocol]
    Q -->|Да — middleware, redirect, metrics| PROTO[URLProtocol stub + ephemeral session]
    FAKE --> UNIT[Unit test]
    PROTO --> UNIT
    UNIT --> INT[Integration — real TLS / staging]
```

| Подход | Плюсы | Минусы |
|--------|-------|--------|
| **Fake client** | Быстро, нет глобального состояния | Не ловит баги в URLSession-обвязке |
| **URLProtocol** | Реальный путь `data(for:)` | Больше кода stub protocol |

---

## Fake client (предпочтительно)

```swift
protocol HTTPClient {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

struct HTTPClientStub: HTTPClient {
    var result: Result<(Data, URLResponse), Error>

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try result.get()
    }
}
```

SUT получает `any HTTPClient` в `init` — тест подставляет stub.

---

## URLProtocol stub (кратко)

1. Подкласс `URLProtocol`: в `canInit(with:)` — свой URL scheme или host prefix.
2. В `startLoading()` — отдать `HTTPURLResponse` + `Data` клиенту.
3. `URLSessionConfiguration.ephemeral.protocolClasses = [StubProtocol.self]` — **своя** сессия на тест.
4. `tearDown`: `URLProtocol.unregisterClass` если использовали `registerClass`.

**Не делать:** подмена `URLSession.shared` — гонки между параллельными тестами.

---

## JSON fixtures

Integration-friendly паттерн для mapper + decoder:

```swift
func loadFixture<T: Decodable>(_ name: String, as type: T.Type) throws -> T {
    let url = Bundle(for: BundleToken.self).url(forResource: name, withExtension: "json")!
    let data = try Data(contentsOf: url)
    return try JSONDecoder().decode(T.self, from: data)
}

private final class BundleToken {}
```

Файл `user_ok.json` в test bundle — unit/integration без сети.

---

## Что проверять в unit

- Сборка `URLRequest` (method, path, headers, body).
- 2xx + `Decodable`.
- 4xx/5xx → доменная ошибка.
- `URLError` + политика retry.
- Отмена `Task` / не вызывать retry на 401.

**Не unit:** реальный TLS, pinning end-to-end, latency.

---

## Вопросы–ответы (собес)

**Q. Fake vs URLProtocol?**  
**A.** Fake — для логики поверх абстракции; URLProtocol — когда тестируешь код, жёстко завязанный на `URLSession`.

**Q. Почему не реальная сеть в CI?**  
**A.** Флейки, таймауты, внешние простои — ломает FIRST.

---

## Дальше

- [Contract-Tests-OpenAPI-RU](Contract-Tests-OpenAPI-RU.md) — фикстуры из спеки, OpenAPI codegen
- [Networking README — Q H30](../../../data-and-network/networking/README.md)
- [URLSession lifecycle note](../../../data-and-network/networking/notes/URLSession-Lifecycle-iOS-IQ.md)
- [URLProtocol](https://developer.apple.com/documentation/foundation/urlprotocol)
- **Playground:** [URLProtocol demo](../testing.playground/Contents.swift)

---

**Версия:** 1.0 · **Язык:** RU
