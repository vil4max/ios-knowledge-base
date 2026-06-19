# Foundation & Lifecycle

## Структура топика

- `notes/` — Q&A + ссылки на Apple docs
- `exercises/` — упражнения с expected outcome

---

## 🎯 Фокус vs можно отложить (вопрос → ответ)

- App lifecycle: `didFinishLaunching`, `UIScene`, состояния foreground/background.
  - **Ответ**: в сценах жизненный цикл “делится”: часть событий в `UIApplicationDelegate`, часть в `UISceneDelegate` (особенно foreground/background для конкретной сцены). Важно понимать state transitions, чтобы корректно сохранять состояние, отменять задачи и обновлять UI.  
    Docs: `https://developer.apple.com/documentation/uikit/uiscene`

- Время и даты: `Date`, `Calendar`, `DateFormatter`, `FormatStyle`.
  - **Ответ**: `Date` = момент времени (UTC-ish), `Calendar` + `TimeZone` дают “человеческую” арифметику, форматирование лучше делать `FormatStyle` (современнее) или `DateFormatter` (кешировать, он дорогой).  
    Docs: `https://developer.apple.com/documentation/foundation/date`

- `FileManager`: где что лежит (Documents, Caches, tmp, App Group).
  - **Ответ**: выбирай директорию по назначению: Documents (пользовательские данные), Caches (можно удалить системой), tmp (временное). Для шаринга между app/extension — App Group container.  
    Docs: `https://developer.apple.com/documentation/foundation/filemanager`

    Docs: `https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types`

    Docs: `https://developer.apple.com/documentation/foundation/notificationcenter`

### Отложить

- Глубокая работа с `NSPredicate` вне CoreData.
- `NSRegularExpression` (если доступен нативный Regex iOS 16+).

## 🏋️ Упражнения (8) — что должно получиться

1) Lifecycle логирование: залогировать переходы состояний приложения.
  - **Ожидаемый результат**: видеть, какие колбэки вызываются при home swipe/lock/kill; понимать отличие app-level и scene-level событий.  
    Docs: `https://developer.apple.com/documentation/uikit/uiscene`

2) Scene-based миграция: перенести UIKit app на Scene Delegate.
  - **Ожидаемый результат**: появится `SceneDelegate`, управление `UIWindow` переедет в `scene(_:willConnectTo:options:)`, появится возможность multi-window (iPadOS).  
    Docs: `https://developer.apple.com/documentation/uikit/uiscenedelegate`

  - **Ожидаемый результат**: старые payload’ы декодятся (через optional/дефолт), новые тоже; тестами закрепить.  
    Docs: `https://developer.apple.com/documentation/foundation/jsondecoder`

4) `FormatStyle`: 1234.5 -> `1 234,50 ₽`.
  - **Ожидаемый результат**: корректное форматирование под locale через `.formatted(.currency(code: \"RUB\"))`.  
    Docs: `https://developer.apple.com/documentation/foundation/formatstyle`
  - **Подробнее:** [FormatStyle & Parsing](/ios-sdk/format-style/)

5) Date arithmetic: сколько дней до конца месяца (с учётом timezone).
  - **Ожидаемый результат**: использовать `Calendar` и `dateInterval(of:for:)`/`range(of:in:for:)`, не вычитать секунды “в лоб”.  
    Docs: `https://developer.apple.com/documentation/foundation/calendar`

6) FileManager: сохранить файл в Caches, что будет при low storage.
  - **Ожидаемый результат**: кеш может быть удалён системой; для критичных данных — Documents/Application Support. Обработать ошибки записи (`NSFileWriteOutOfSpaceError`).  
    Docs: `https://developer.apple.com/documentation/foundation/filemanager`

7) App Group: поделиться данными между app и виджетом.
  - **Ожидаемый результат**: настроить App Group entitlement, читать/писать в `containerURL(forSecurityApplicationGroupIdentifier:)`.  
    Docs: `https://developer.apple.com/documentation/foundation/filemanager/1412643-containerurl`

8) Notification -> AsyncSequence: `UIApplication.didBecomeActiveNotification`.
  - **Ожидаемый результат**: подписка через `NotificationCenter.default.notifications(named:)` и обработка в `for await`.  
    Docs: `https://developer.apple.com/documentation/foundation/notificationcenter/3767189-notifications`

---

## Карточки знаний (роадмап / drill)

<!-- knowledge-cards-canonical:start -->

### Q11
- **Question (RU):** `Application lifecycle` — какие состояния и колбэки; зачем отдельно **`UISceneDelegate`** от **`UIApplicationDelegate`**?
- **Question (EN):** Application lifecycle: states and callbacks; why `UISceneDelegate` vs `UIApplicationDelegate`?
- **Answer (RU):** Зацепка: у **`UIApplication`** публичное **`UIApplication.State`** — только **три** значения: **`.active`**, **`.inactive`**, **`.background`**. **`notRunning`** в этом enum не лежит — это «процесса нет». После ухода в **`.background`** система может **приостановить выполнение** (**suspended** в терминологии документации про последовательность в фоне); у **`applicationState`** при этом по-прежнему фиксируют именно **`.background`**, пока приложение не выгрузят.

    **Колбэки процесса (`UIApplicationDelegate`):** ранний старт — `application(_:willFinishLaunchingWithOptions:)`, `application(_:didFinishLaunchingWithOptions:)`; для scene-based ещё **`application(_:configurationForConnecting:options:)`** — отдаёт **`UISceneConfiguration`** и класс **`UISceneDelegate`** для новой сцены.

    **Сцены (с iOS 13):** **`UIScene`** — одна «сессия UI» (окно / сцена). У неё свой **`UISceneDelegate`**: `scene(_:willConnectTo:options:)`, дальше **`sceneWillEnterForeground`**, **`sceneDidBecomeActive`**, **`sceneWillResignActive`**, **`sceneDidEnterBackground`**. Здесь обычно **`UIWindowScene`**, **`UIWindow`**, корень UI и pause/resume логики **для этой сцены**.

    **Зачем разделение:** несколько сцен (**multi-window iPadOS** и т.п.) → у разных **`UIScene`** разный foreground/background; это нельзя выразить одним глобальным делегатом. Итого: **`UIApplicationDelegate`** — **app-wide / process**, **`UISceneDelegate`** — **per-`UIScene`**.

- **Answer (EN):** `UIApplication.State` is only `.active`, `.inactive`, `.background`. Scene-based apps split process hooks (`UIApplicationDelegate`) from per-window session hooks (`UISceneDelegate`) so each `UIScene` can move independently.

- **Устный канон (опросник п.11 / H11, drill):** «`UIApplication.State`: **active, inactive, background**; not running / suspended — отдельно от тройки enum. **`AppDelegate`** — процесс и конфиг сцен; **`SceneDelegate`** — одна **`UIScene`**, окно и **scene** foreground/background.»

- **Follow-up (RU):** `scenePhase` в SwiftUI / `UIApplication.didBecomeActiveNotification` — к чему относится?
- **Follow-up answer (RU):** **`scenePhase`** привязан к **`Scene`** в SwiftUI и отражает жизненный цикл **этой** сцены. **`UIApplication.didBecomeActiveNotification`** — **app-level** уведомление; в scene-based приложении для UI логики предпочтительнее привязка к **сцене** или **`scenePhase`**, чтобы не путать глобальное и per-scene.

- **Доп. информация:** [Habr H11](https://habr.com/en/articles/726388/); [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.11; Apple — [Managing your app’s life cycle](https://developer.apple.com/documentation/uikit/app_and_environment/managing_your_app_s_life_cycle), [`UIApplication.State`](https://developer.apple.com/documentation/uikit/uiapplication/state), [`UISceneDelegate`](https://developer.apple.com/documentation/uikit/uiscenedelegate).

- **Playground:** [open](09_foundation_app_lifecycle.playground/Contents.swift)
- **Notes:** [Foundation-App-Lifecycle-Scenes.md](Foundation-App-Lifecycle-Scenes.md)

### Q12
- **Question (RU):** **п.45 / J05 (drill)** — **состояния приложения** в формулировке джуниорского собеса: «not running → … → suspended» и как это стыкуется с **`UIApplication.State`**?
- **Question (EN):** Junior interview “app states” narrative vs `UIApplication.State`?
- **Answer (RU):** Зацепка: в учебниках часто перечисляют **пять** стадий процесса: **не запущено** → **inactive** → **active** → **inactive** → **background**, после чего система может **приостановить** процесс (**suspended** — выполнение остановлено, процесс ещё в памяти). У **`UIApplication.shared.applicationState`** в enum только **`.active` / `.inactive` / `.background`**: **«не запущено»** и **suspended** туда **не входят** — это состояние **процесса**, а не значения enum.

    **Сцены:** foreground/background для **UI** удобнее вязать к **`UISceneDelegate`** / **`scenePhase`** (см. **Q11**).

- **Answer (EN):** Interview “five states” includes not running and suspended; `UIApplication.State` only exposes `.active`, `.inactive`, `.background`. Per-UI session transitions belong with `UISceneDelegate` / `scenePhase`—see **Q11**.

- **Устный канон (опросник п.45 / J05, drill):** «**Пять стадий** — про **процесс**; **`applicationState`** — только **тройка**; **suspended** после фона — **не отдельный** case enum. Детали колбэков — **Q11**.»

- **Follow-up (RU):** чем **`sceneDidBecomeActive`** отличается от **`applicationDidBecomeActive`**?
- **Follow-up answer (RU):** первое — **конкретная `UIScene`**, второе — **процесс целиком**; при multi-window важна **per-scene** логика.

- **Доп. информация:** [ios-interview Junior](https://ios-interview.ru/top-20-junior-ios-interview-questions/) (типичный список состояний); [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.45; **Q11** (колбэки и `SceneDelegate`).

- **Playground:** [open](09_foundation_app_lifecycle.playground/Contents.swift)
- **Notes:** [Foundation-App-Lifecycle-Scenes.md](Foundation-App-Lifecycle-Scenes.md)

<!-- knowledge-cards-canonical:end -->

---
