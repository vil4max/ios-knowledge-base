# URLSession Lifecycle — iOS IQ

Конспект для темы **20 — Networking**. Полный текст статьи — offline-архив в [`_import/urlsession-lifecycle-iosiq-full.md`](../../../../_import/urlsession-lifecycle-iosiq-full.md). Оригинал: [iosiq.ru/urlsession-lifecycle.html](https://iosiq.ru/urlsession-lifecycle.html).


---

## Зачем знать жизненный цикл

`URLSession.shared.data(from:)` — одна строка; за ней: конфигурация, задача, DNS, TLS, I/O, кэш, делегаты, завершение. Alamofire/Moya стоят поверх этого API — отладка всегда возвращается к `URLSession`, `URLSessionDelegate`, `URLError`, `URLSessionTaskMetrics`.

Жизненный цикл — **граф**, не лента: на любом этапе возможны cancel, retry, background resume.

---

## Семь стадий

| # | Стадия | Суть |
|---|--------|------|
| 1 | **Configuration** | `URLSessionConfiguration` — таймауты, кэш, cellular/Low Data, `waitsForConnectivity` |
| 2 | **URLRequest** | URL (`URLComponents`), method, headers, body, per-request cache/cellular |
| 3 | **Create Task** | `data` / `download` / `upload` / `WebSocket` — рождается в `.suspended` |
| 4 | **`resume()`** | `.suspended` → `.running` |
| 5 | **Network I/O** | DNS → TCP → TLS → HTTP; метрики в `URLSessionTaskMetrics` |
| 6 | **Response** | `HTTPURLResponse`, кэш, редиректы; **валидация status code — на клиенте** |
| 7 | **Complete** | success / error / cancel; cleanup, retry, новая задача |

**Правило:** конфигурация сессии задаётся **один раз** при создании — у живой сессии не меняется (Apple docs).

---

## Configuration: три типа

| | `.default` | `.ephemeral` | `.background(identifier:)` |
|---|------------|--------------|----------------------------|
| Кэш | диск + память | только память | диск |
| Cookies | системные | in-memory | системные |
| Credentials | Keychain | сессия | Keychain |
| Фон | нет | нет | **да** |
| Completion handler | да | да | **нет, только delegate** |
| Тело upload | Data / file | Data / file | **только fromFile** |

Ключевые флаги:

- `timeoutIntervalForRequest` — idle между сетевыми событиями (сбрасывается, пока идут байты).
- `timeoutIntervalForResource` — бюджет на всю задачу; для больших файлов — часы/дни.
- `waitsForConnectivity = true` — не падать сразу без сети; ждать (метро, туннель).
- `allowsExpensiveNetworkAccess` / `allowsConstrainedNetworkAccess` — Hotspot / Low Data Mode.
- `httpMaximumConnectionsPerHost` — по умолчанию ~4; HTTP/2 мультиплексирует.

**Антипаттерн:** новая `URLSession` на каждый запрос — теряется пул соединений. Один клиент → одна сессия (`lazy var`).

`URLSession.shared` — для разовых вызовов; центральный API-клиент — своя конфигурация.

---

## URLRequest

- URL через `URLComponents` / `appending(queryItems:)`, не склейка строк.
- `RequestBuilder` / `Endpoint` enum — auth, User-Agent, correlation ID в одном месте.
- `cachePolicy` на запросе переопределяет конфигурацию сессии.
- `allowsCellularAccess` на запросе — точечный контроль (тяжёлые preload только Wi‑Fi).

---

## Тип задачи

| Task | Когда |
|------|-------|
| `DataTask` | JSON, малые/средние ответы in-memory |
| `DownloadTask` | файлы, медиа; фон; resume data |
| `UploadTask` | multipart, backup; фон — `fromFile` |
| `WebSocketTask` | двусторонний обмен (iOS 13+) |
| `StreamTask` | редко; чаще `Network.framework` |

Три стиля вызова: completion handler, delegate, async/await (`data(for:)`, `download(for:)`, `bytes(for:)`).

**Частая ошибка:** забыть `resume()` — задача навсегда в `.suspended`.

---

## State machine задачи

```
.suspended ──resume()──► .running ──cancel()──► .canceling ──► .completed
     ▲                        │
     └── suspend() ───────────┘
```

- После `.canceling` / `.completed` — **новая задача**, не `resume()` на старой.
- `suspend()` ≠ `cancel()` — пауза с сохранением соединения.
- Download resume: `cancel(byProducingResumeData:)` → `downloadTask(withResumeData:)`.

---

## Network I/O и метрики

Внутри: DNS → TCP → TLS → request → response stream.

`URLSessionTaskMetrics` / `transactionMetrics`: DNS, TLS, TTFB, `networkProtocolName` (`h2`, `h3`, `http/1.1`).

**Streaming:**

- Completion handler — тело целиком в памяти.
- Delegate — `didReceive data:` по чанкам.
- async — `session.bytes(for:)` + `bytes.lines` для SSE / NDJSON.

---

## Response и кэш

URLSession считает «успехом» любой ответ с заголовками, **включая 500**. Ошибка — только transport (нет сети, TLS, timeout).

```swift
guard let http = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
switch http.statusCode {
case 200...299: break
case 401: throw AuthError.expired
default: throw HTTPError(status: http.statusCode, data: data)
}
```

**Порядок:** status → body → `Decodable`. Не наоборот.

`URLCache`: GET + `Cache-Control` / ETag; POST — свой слой. При офлайне может отдать stale cache — осознанная политика.

Редиректы 30x — автоматически; кастом — `willPerformHTTPRedirection`.

---

## Complete: URLError и retry

Полезные коды: `.notConnectedToInternet`, `.timedOut`, `.cancelled`, `.networkConnectionLost`, `.dataNotAllowed`.

Retry с **exponential backoff + jitter**. Не retry: POST без idempotency, 401, 4xx (кроме 408/429), user cancel.

429 — уважать `Retry-After`. POST — `Idempotency-Key` где API поддерживает.

---

## Delegates (каскад)

`URLSessionDelegate` → `URLSessionTaskDelegate` → `Data` / `Download` / `WebSocket` / `Stream`.

Важные колбэки:

- `didReceive challenge` — TLS, pinning, mTLS, basic auth.
- `taskIsWaitingForConnectivity` — UX «ждём сеть».
- `didFinishCollecting metrics` — прод-логирование.
- `didCompleteWithError` — финал (в т.ч. cancel → `.cancelled`, без алерта).

Сессия **strong-retain** делегата → `invalidateAndCancel()` для освобождения.

Background: один `identifier` → одна сессия (singleton). `handleEventsForBackgroundURLSession` + вызов completion handler обязателен.

---

## async/await (iOS 15+)

- `Task.cancel()` отменяет сетевой запрос по дереву задач.
- Параллель: `async let` / `TaskGroup`.
- Delegate + `data(for:)` — совместимы (метрики/прогресс через delegate, данные через async).

---

## WebSocket

- Отдельная сессия; свой ping (`sendPing`) каждые 20–30 с.
- Reconnect с backoff; состояние — idempotent subscribe после reconnect.
- Нет resume-data как у download — новое соединение.

---

## Прогресс

- `task.progress` + KVO на `fractionCompleted`.
- Delegate: `didWriteData` / `didSendBodyData`.
- `AsyncStream` + `.task` в SwiftUI — автоотмена с view.

---

## Production checklist (сжатый)

- [ ] Одна `URLSession` на клиент, явная конфигурация.
- [ ] Endpoint/builder, не сырые `URLRequest` по коду.
- [ ] Валидация `HTTPURLResponse` до парсинга.
- [ ] Один настроенный `JSONDecoder`.
- [ ] `URLSessionTaskMetrics` в проде.
- [ ] Тесты через `URLProtocol`, не `URLSession.shared`.
- [ ] Cancel на уходе с экрана / `.task`.
- [ ] Retry с jitter; idempotency для POST.
- [ ] Background: delegate, file upload, один identifier, completion handler.
- [ ] Logout: `invalidateAndCancel()`, очистка cache/cookies/Keychain.
- [ ] NLC / метро для проверки `waitsForConnectivity`.

---

## Дерево решений (из статьи)

| Данные | Инструмент |
|--------|------------|
| JSON / малый ответ | `session.data(for:)` |
| Файл / крупная выгрузка | `download(for:)` / `upload(fromFile:)` + `.background` для долгих |
| Двусторонний обмен | `webSocketTask(with:)` |
| SSE / NDJSON stream | `bytes(for:)` + `.lines` |

---

## Подводные камни (top)

1. Completion handler не на main — UI нужно `@MainActor`.
2. Background upload только из файла, не `httpBody`.
3. `JSONDecoder` — snake_case через `.convertFromSnakeCase`.
4. Debugger может искажать background-поведение — проверять на устройстве без LLDB.
5. Не trust-all в Release для «dev» pinning.

---

## Apple docs (первичный источник)

- [URLSession](https://developer.apple.com/documentation/foundation/urlsession)
- [URLSessionConfiguration](https://developer.apple.com/documentation/foundation/urlsessionconfiguration)
- [Loading and parsing data](https://developer.apple.com/documentation/foundation/url_loading_system)
- [Background URLSession](https://developer.apple.com/documentation/foundation/urlsessionconfiguration/1411552-backgroundsessionconfiguration)
- [URLProtocol](https://developer.apple.com/documentation/foundation/urlprotocol)

---

## Interview hooks

- Объясни 7 стадий и где URLSession **не** считает HTTP 404 ошибкой.
- Разница `timeoutIntervalForRequest` vs `timeoutIntervalForResource`.
- Когда `.background`, когда `.ephemeral`.
- Как unit-тестировать без сети (`URLProtocol`).
- State machine: почему нельзя `resume()` после `cancel()`.
- `waitsForConnectivity` + delegate `taskIsWaitingForConnectivity`.
