# SwiftUI

## За 30 секунд

SwiftUI is **declarative UI**: views are values, state drives body recomputation, modifiers build a render tree. **ARC still applies** — pick the right ownership wrapper (`@State` / `@Bindable` / `@Environment` on iOS 17+; `@StateObject` / `@ObservedObject` / `@EnvironmentObject` for legacy). Interview depth: view identity (`id`, `ForEach`), navigation (`NavigationStack`), async tied to lifetime (`.task`), performance (unnecessary body work), and **UIKit interop** (`UIViewRepresentable`). Know when SwiftUI is wrong tool (complex gestures, legacy UIKit investment).

## Apple docs

- [SwiftUI](https://developer.apple.com/documentation/swiftui) — views, modifiers, previews.
- [Model data](https://developer.apple.com/documentation/swiftui/model-data) — `@State`, `@Binding`, `@Observable`, `@Environment`.
- [NavigationStack](https://developer.apple.com/documentation/swiftui/navigationstack) — typed routes, `NavigationPath`.
- [UIViewRepresentable](https://developer.apple.com/documentation/swiftui/uiviewrepresentable) — UIKit bridge.
- [Image](https://developer.apple.com/documentation/swiftui/image) — `AsyncImage`; caching — [Image Caching note](../../data-and-network/caching-offline-first/notes/Image-Caching-UIKit-SwiftUI.md) (**Q35**)
- [Accessibility](https://developer.apple.com/documentation/swiftui/view-accessibility) — labels, traits, VoiceOver.
- [List](https://developer.apple.com/documentation/swiftui/list) — dynamic rows, sections, edit mode; note [swiftui-list-dynamic-data.md](notes/swiftui-list-dynamic-data.md)
- [View.task](https://developer.apple.com/documentation/swiftui/view/task(priority:_:)) — async load tied to view lifetime; note [swiftui-data-loading-task.md](notes/swiftui-data-loading-task.md)
- [TimelineView](https://developer.apple.com/documentation/swiftui/timelineview) — time-driven UI refresh; note [timeline-view-swiftui.md](notes/timeline-view-swiftui.md)

## SwiftUI components — quick map

**Инфографика:** [`assets/swiftui-components-overview.png`](assets/swiftui-components-overview.png) — пять блоков: Layout, Navigation, Lists, Text/Media, Input.

Каталог для **ориентации**; на собесе и в проде важнее state, identity, владение навигацией и профилирование — см. Q-cards и **Focus vs Defer** ниже.

| Area | Building blocks | Go deeper in this repo |
|------|-----------------|------------------------|
| **Layout & structure** | `VStack` / `HStack` / `ZStack`, `Spacer`, `Divider`, `ScrollView`, `ScrollViewReader`, `LazyVStack` / `LazyHStack` / `LazyVGrid` / `LazyHGrid`, `Grid` / `GridRow`, `Group`, `Section`, `Form`, `GeometryReader`, alignment guides | **Defer** ниже (`GeometryReader`, custom `Layout`); [Auto Layout](../auto-layout/README.md) |
| **Navigation & app structure** | `NavigationStack`, `NavigationSplitView`, `NavigationLink`, `navigationDestination`, `TabView`, `PageTabViewStyle`, `toolbar`, `searchable`, `refreshable` | [Navigation & Deep Links](../../architecture/navigation/README.md); Q9 (multilevel dismiss) |
| **Lists & collections** | `List`, `ForEach`, `OutlineGroup`, `swipeActions`, `listStyle`, row insets / separators | [List & dynamic data](notes/swiftui-list-dynamic-data.md); [Performance](../../quality/performance/README.md); Q11 (view identity) |
| **Text & media** | `Text`, `TextEditor`, `AttributedString`, `Image`, `AsyncImage`, SF Symbols, `ProgressView`, `Gauge`, Swift Charts, `Map`, `VideoPlayer` | Map TL;DR ниже; [Image Caching](../../data-and-network/caching-offline-first/notes/Image-Caching-UIKit-SwiftUI.md) |
| **Input controls** | `Button`, `Link`, `Toggle`, `Slider`, `Stepper`, `Picker` (segmented / wheel / menu), `ColorPicker`, `DatePicker`, `TextField`, `SecureField`, `Menu`, `ContextMenu`, `ControlGroup`, `Label`, `GroupBox`, `DisclosureGroup` | Form + state — Q-cards **Observation** / `@Bindable` |

## 🎯 Focus vs Defer

### Focus

- Безопасная миграция состояния на Observation (`@Observable`) в реальных проектах.
- Снижение риска регрессий при переходе с `ObservableObject`.
- Переиспользуемые немодальные UI-паттерны обратной связи (toast) в SwiftUI.
- Практические паттерны MapKit в SwiftUI: состояние карты, поиск и аннотации.
- **View identity:** стабильные `id` в `ForEach`; избегать лишних пересозданий stateful child views.
- **Memory & ownership:** ARC + правильный wrapper; не создавать VM в `body`; async через `.task` — Q-card *Memory & ownership*.
- **Data loading:** `.task` / `.task(id:)` + FSM в `@Observable` VM; не API в `.onAppear` + неструктурированный `Task`.
- **Time-driven UI:** `TimelineView` + schedule (`everyMinute`, `periodic`, `animation`) и `context.cadence`; не `Timer` + `@State` tick для часов на экране.

### Defer

- Custom **Layout** protocol until default `HStack`/`VStack`/`Grid` limits are hit.
- Rewriting entire UIKit app in one release without feature flags / screen-by-screen migration.
- **GeometryReader** everywhere instead of `safeAreaInset`, `alignmentGuide`, or `containerRelativeFrame`.
- Deep **Metal** shaders in SwiftUI before mastering draw cycle and Instruments SwiftUI template.

## 🏋️ Exercises

1. **Observation migration:** Convert one `ObservableObject` screen to `@Observable`; verify fewer `objectWillChange` fan-outs. **Expected:** same UX, simpler dependency injection.
2. **NavigationStack:** Push three destinations with typed `Hashable` route enum. **Expected:** programmatic pop to root via `path`.
3. **Identity bug:** `ForEach` without stable `id` on mutable list; fix flicker. **Expected:** explain identity vs data identity.
4. **Representable:** Embed `MKMapView` with coordinator for delegate callbacks. **Expected:** lifecycle `makeUIView` / `updateUIView` / `dismantle`.
5. **Performance:** Instruments SwiftUI template on scrolling list; remove one heavy `body` computation. **Expected:** measurable frame time improvement.

## Артефакты

- Notes: `notes/`
- Exercises: `exercises/`
- Assets: `assets/`
- Playgrounds: `playgrounds/`

### Последние заметки

- `notes/timeline-view-swiftui.md` — `TimelineView`, schedules, `cadence`, vs `Timer`; playground [TimelineViewDemo.playground](TimelineViewDemo.playground)
- `notes/swiftui-data-loading-task.md` — `.task` vs `.onAppear`, `LoadState`, cooperative cancel, `.refreshable`
- `notes/swiftui-list-dynamic-data.md` — `List`, sections, swipe, edit mode, empty state, stable `id`
- `notes/migrating-to-observable-without-breaking-your-app.md`
- `notes/swiftui-toast-in-5-steps.md`
- `notes/creating-maps-in-swiftui-with-mapkit.md`
- `notes/codakuma-floating-safe-area-bar.md` — [floating safeAreaBar](https://codakuma.com/floating-safe-area-bar/), playground [FloatingSafeAreaBar.playground](FloatingSafeAreaBar.playground)

---

## TL;DR

- MapKit в SwiftUI уже покрывает не только “показать карту”, но и полноценные пользовательские сценарии с поиском, метками и навигацией состояния.
- Ключ к качественной интеграции — правильно управлять `Map` состоянием (позиция/камера), а не только визуальными модификаторами.
- Для production-кейсов важны кластеры задач: поиск мест, геокодирование, работа с аннотациями и производительность рендера.
- WWDC 2025 расширил экосистему MapKit новыми API геокодирования и фреймворком GeoToolbox.

## Источник

- Статья: [Creating maps in SwiftUI apps with MapKit](https://www.createwithswift.com/creating-maps-in-swiftui-apps-with-mapkit/)
- Apple WWDC: [Go further with MapKit (WWDC25)](https://developer.apple.com/videos/play/wwdc2025/204/)
- Apple docs:
  - [GeoToolbox](https://developer.apple.com/documentation/GeoToolbox)
  - [MKGeocodingRequest](https://developer.apple.com/documentation/mapkit/mkgeocodingrequest)

## Зачем `Map` в SwiftUI

`Map` закрывает главный UX-кейс: интерактивная география прямо в декларативном UI, без ручной сборки UIKit-слоя в базовых сценариях.

Типовые задачи:

- показать регион/позицию пользователя;
- отобразить точки интереса;
- управлять выбором/фокусом на локации;
- встроить карту в поток экрана, а не в отдельный “сложный” модуль.

## Основные строительные блоки

### 1) Состояние карты

Самое важное — хранение и обновление map state:

- текущая позиция/камера;
- источник изменений (пользовательский жест vs программный фокус);
- синхронизация с остальным состоянием экрана.

### 2) Контент карты

- маркеры/аннотации;
- визуальные модификаторы карты;
- реакция на выбор конкретной точки.

### 3) Поиск и геокодирование

Для “живых” фич нужны:

- поиск мест;
- прямое/обратное геокодирование;
- преобразование пользовательского ввода в координаты и обратно.

## Что изменилось в новой волне API (WWDC 2025)

- усилены сценарии поиска и представления мест;
- появились новые интерфейсы геокодирования;
- добавлен GeoToolbox для более удобной работы с place-oriented данными и интеграциями.

Практический смысл: меньше инфраструктурного кода вокруг “описания места”, больше стандартизированных API-путей.

## Частая ошибка в SwiftUI-картах

Фокус только на “как красиво нарисовать карту” без архитектуры состояния:

- карта есть, но взаимодействие неустойчивое;
- сложно управлять обновлениями при поиске/фильтрации;
- появляются гонки между пользовательским и программным перемещением камеры.

## Практические выводы / что брать в работу

- Проектировать map-screen как state machine: источник события → изменение состояния → обновление карты.
- Разделять доменную модель места и presentation-слой аннотаций.
- Сразу закладывать сценарии поиска/геокодирования как часть фичи, а не “добавим потом”.
- Проверять UX на реальных сценариях скролла/зумов/быстрой смены фильтров.

## Мини-чеклист

- Map state хранится централизованно и предсказуемо обновляется.
- Программные обновления камеры не конфликтуют с жестами пользователя.
- Поиск/геокодирование не блокируют UI и корректно обрабатывают ошибки.
- Аннотации и оверлеи масштабируются при росте числа точек.

---

## TL;DR

- `@Observable` делает state-management в SwiftUI проще и точнее по обновлениям UI.
- Миграция не должна быть “большим взрывом”: лучше идти поэтапно, начиная с изолированных фич.
- Главный подводный камень — совместимость, если в проекте минимальная версия iOS ниже 17.
- Для безопасного перехода нужен migration plan, а не только замена `ObservableObject` на макрос.

## Источник

- Пример с UIKit от Apple (WWDC): [Discover Observation in SwiftUI](https://developer.apple.com/videos/play/wwdc2023/10149/)
- Apple docs: [Migrating from the ObservableObject protocol to the Observable macro](https://developer.apple.com/documentation/swiftui/migrating-from-the-observable-object-protocol-to-the-observable-macro)

## Что такое `@Observable` и зачем он нужен

`@Observable` — часть Observation framework (Apple платформы iOS 17+), которая позволяет объявить наблюдаемую модель без `ObservableObject` + `@Published` в прежнем виде.

Основная ценность:

- меньше шаблонного кода;
- более точечное отслеживание изменений;
- более предсказуемые обновления view при чтении конкретных свойств.

## Какие проблемы он реально решает

- Избыточная связка `ObservableObject` + много `@Published`.
- Лишние перерисовки при грубом уровне подписки.
- Рост когнитивной сложности в больших view-model слоях.

В результате `@Observable` помогает сделать модель состояния ближе к декларативному стилю SwiftUI.

## Подводные камни миграции

### 1) Поддержка iOS ниже 17

Observation framework доступен с iOS 17+, поэтому при более низком deployment target требуется стратегия совместимости:

- либо поэтапно оставлять часть модулей на `ObservableObject`;
- либо держать адаптеры/прослойки на границе старого и нового подхода.

### 2) Неоднородная архитектура во время перехода

Некоторое время в проекте будут сосуществовать оба подхода (`ObservableObject` и `@Observable`).  
Это нормально, если заранее зафиксированы правила “где какой подход допустим”.

### 3) Механическая миграция без ревью

Простая авто-замена без проверки жизненного цикла состояния и сценариев навигации легко приводит к регрессиям.

## Безопасный план миграции (по шагам)

1. Выделить 1–2 изолированные фичи как пилот.
2. Перевести их модели на `@Observable` и проверить сценарии ввода/навигации/синхронизации состояния.
3. Зафиксировать внутренний guide по паттернам использования.
4. Расширять миграцию волнами по модульным границам.
5. На каждом шаге проверять совместимость со старым кодом и поведение на целевых версиях iOS.

## Практические выводы / что брать в работу

- Рассматривать миграцию как архитектурное изменение, а не как “только синтаксис”.
- Начинать с небольшого пилота и переносить подход по мере стабилизации.
- Для mixed-version проектов заранее определить политику coexistence.
- Добавить чек в PR review: “новый state-код соответствует выбранной модели (`@Observable` или legacy) и не смешивает их хаотично”.

## Мини-чеклист перед merge

- Фича протестирована в ключевых пользовательских сценариях.
- Нет случайных циклов обновления состояния.
- Ясно задокументировано, почему в модуле выбран `@Observable` или `ObservableObject`.
- Для iOS < 17 есть корректный fallback-путь (если модуль это требует).

---

## TL;DR

- `alert` и `sheet` модальны и останавливают пользовательский поток, а toast даёт короткую обратную связь без прерывания.
- В SwiftUI тост обычно делают как переиспользуемый overlay-компонент.
- Ключевые части: модель сообщения, view для тоста, модификатор, управление показом/таймером, аккуратная анимация.
- Подход из статьи лёгкий, масштабируемый и подходит как базовый шаблон для app-wide уведомлений.

## Источник

- [Создание тоста в SwiftUI за 5 шагов](https://apptractor.ru/info/articles/sozdanie-tosta-v-swiftui-za-5-shagov.html?amp=1)

## Почему нужен toast, если уже есть alert и sheet

- `alert`/`sheet` решают задачи подтверждения и модальных действий.
- Toast решает другой UX-кейс: показать краткий результат действия (успех/ошибка/инфо), не блокируя экран.
- Это особенно важно для частых операций: copy, save, like, background refresh.

## Базовая архитектура toast в SwiftUI

### 1) Модель уведомления

Обычно выделяют структуру с минимумом данных:

- текст сообщения;
- тип (`success`, `error`, `info`);
- длительность показа (если нужно гибко).

### 2) Отдельный ToastView

Компонент отвечает только за визуал:

- фон, скругления, тень;
- иконка/цвет по типу;
- ограничение ширины и адаптация к safe area.

### 3) ViewModifier или extension

Чтобы не встраивать логику в каждый экран, тост заворачивают в модификатор:

- единая точка подключения;
- переиспользование по всему приложению;
- удобный API на уровне `.toast(...)`.

### 4) Управление временем жизни

Паттерн показа:

- изменить состояние `isPresented = true`;
- через задержку скрыть тост;
- при повторном показе сбрасывать предыдущий таймер/задачу.

### 5) Анимация и позиционирование

Обычно используют:

- `transition(.move + .opacity)` или аналог;
- размещение сверху/снизу через overlay + alignment;
- небольшую длительность анимации, чтобы не мешать сценариям.

## На что обратить внимание в реальном проекте

- Не конфликтовать с системными overlay-слоями (loading, fullScreenCover, навигационные переходы).
- Предусмотреть очередь уведомлений, если сообщения могут приходить пачкой.
- Избегать “вечных” тостов: автоскрытие по умолчанию обычно безопаснее.
- Проверить доступность: контраст, размер текста, VoiceOver-объявления при необходимости.

## Практические выводы / что брать в работу

- Делать toast как инфраструктурный UI-компонент, а не “локальный хак” в отдельном экране.
- Вынести API показа в единый слой (modifier/service), чтобы сохранить консистентность UX.
- Для сложных приложений заранее определить политику очереди и приоритетов уведомлений.
- Добавить preview/тестовые сценарии для success/error/info состояний.

## Мини-чеклист

- Toast не блокирует взаимодействие с основным контентом.
- Есть единый reusable API показа на уровне приложения.
- Настроено авто-скрытие и корректная обработка повторных показов.
- Анимации и позиция не конфликтуют с safe area и навигацией.

---

## Карточки знаний (Q&A)

### Обратная передача данных (аналог unwind segue)

**Вопрос (MCQ):** Как в SwiftUI передать данные при обратном переходе (аналог unwind segue)?

1. Использовать `@Binding`, `@EnvironmentObject` или Combine/closure во ViewModel, которые дочерний экран изменяет до `dismiss`
2. Через `NotificationCenter` — единственный способ в SwiftUI
3. Через `UIViewControllerRepresentable` и unwind segue
4. Передать callback в модификатор `navigationDestination`

**Правильный ответ:** **1**

**Почему:** В SwiftUI нет отдельного механизма «unwind segue» с возвращаемым значением. Родитель держит источник правды; дочерний экран до закрытия обновляет общее состояние — `@Binding`, объект из окружения (`@EnvironmentObject` / `@Observable`), замыкание с результатом, при необходимости Combine. Это явный поток данных, без обязательной глобальной шины.

**Почему остальные неверны:**

- **2** — `NotificationCenter` возможен, но не единственный способ и не типичный выбор для экранного флоу.
- **3** — через UIKit и representable можно пробросить legacy, но это не идиоматичный SwiftUI-ответ на вопрос «как в SwiftUI».
- **4** — у `navigationDestination` нет отдельного параметра «callback назад»; результат передают через состояние или замыкание в **инициализаторе** дочернего view внутри builder — это частный случай варианта **1**, а не отдельный API модификатора.

---

### Observation framework (`@Observable`) — что это и зачем

**Что это.** **Observation** — новая система Swift для отслеживания изменений состояния, добавленная Apple в iOS 17 / Swift 5.9. Работает через макрос `@Observable` и заменяет связку `ObservableObject` + `@Published` для большинства задач state-management в SwiftUI.

**Минимум кода.** Вместо:

```swift
final class Counter: ObservableObject {
    @Published var value = 0
}
```

пишем:

```swift
@Observable
final class Counter {
    var value = 0
}
```

Внутри SwiftUI больше не нужны ни `ObservableObject`, ни `@Published`, ни `@StateObject`/`@ObservedObject` для самой модели. View хранит модель через `@State` (для владения) или `@Bindable` (для биндингов внутрь дочерних view):

```swift
struct CounterView: View {
    @State private var counter = Counter()

    var body: some View {
        Stepper("\(counter.value)", value: $counter.value)
    }
}

struct DetailView: View {
    @Bindable var counter: Counter   // даёт `$counter.value` для биндингов
    var body: some View {
        TextField("Value", value: $counter.value, format: .number)
    }
}
```

**Главное отличие от `ObservableObject`.** Observation работает на уровне **доступа к свойствам**, а не «весь объект изменился». Swift через макрос вшивает в getter/setter код, который сообщает SwiftUI, **какие поля действительно прочитала** конкретная View. Когда меняется только это поле — обновится только эта View. Это **granular observation**: меньше лишних перерисовок, чем у `@Published`-модели, где любая публикация инвалидировала всех подписчиков.

**Чем Observation НЕ является.** Это **не замена Combine целиком**. Combine — это полноценная реактивная библиотека (publishers/subscribers, операторы `debounce`/`merge`/`combineLatest`). Observation — система **трекинга состояния**, заточенная под SwiftUI. Соответственно:

- **state management в SwiftUI** → Observation (`@Observable`);
- **сложные реактивные пайплайны над событиями** → Combine (или `AsyncStream` + `swift-async-algorithms`);
- **request/response async-логика** → Swift Concurrency (`async/await`).


---

### Q-card: Observation (`@Observable`) vs `ObservableObject` + `@Published`

**Вопрос (RU):** В чём суть **Observation framework** и чем `@Observable` отличается от `ObservableObject` + `@Published` на уровне поведения SwiftUI?

**Ответ (RU):** Зацепка: **Observation отслеживает доступ к конкретным свойствам, а не «объект целиком»**.

- `ObservableObject` + `@Published` — **грубая** модель: любое изменение `@Published` посылает событие в `objectWillChange`, и SwiftUI инвалидирует **все** view, подписавшиеся на этот объект, даже если они читают другое поле.
- `@Observable` — **гранулярная** модель: компилятор/макрос обвешивает `get`/`set` свойств кодом, который сообщает SwiftUI «эта view прочитала поле X». При изменении X SwiftUI переобновит **только** view, читавшие X. Поля, которые view не трогает, её перезапуск не вызывают.

Технические следствия:

- меньше шаблонного кода (нет `ObservableObject`, нет `@Published`, нет `@StateObject`/`@ObservedObject` для самой модели — достаточно `@State` / `@Bindable`);
- меньше лишних `body` recompute на больших экранах;
- удобнее структурировать модель — нескольким view проще делить один `@Observable` объект без боязни массовых перерисовок;
- работает только на iOS 17+/Swift 5.9+, потому что под капотом — **Swift macros**.

**Ответ (EN):** Observation is Apple’s state-tracking system replacing `ObservableObject` + `@Published`. The `@Observable` macro instruments property accessors so SwiftUI knows **which fields each view actually read**. When a field changes, only views that read that field re-render — granular observation, instead of `@Published`’s coarse «whole object changed». Less boilerplate (no `ObservableObject`, no `@Published`, just `@State`/`@Bindable`), fewer redundant body invalidations, but requires iOS 17+ and Swift 5.9+ because it’s built on macros.

**Устная заготовка (RU):**

1. `@Observable` — **гранулярное** наблюдение по факту чтения свойства.
2. `ObservableObject` + `@Published` — грубее: любое `@Published` бьёт по всем подписчикам.
3. Меньше boilerplate, меньше лишних перерисовок; нужен iOS 17+/Swift 5.9+.

**Устная заготовка (EN):**

1. `@Observable` tracks per-property reads, not whole-object events.
2. `ObservableObject` + `@Published` invalidates every subscriber on any change.
3. Less boilerplate, fewer redundant updates; iOS 17+/Swift 5.9+.

**Follow-up:** Заменяет ли Observation **Combine**?

**Доп. информация:** Внутри `@Observable` нужный SwiftUI-ховер на чтение реализован через `withObservationTracking { read } onChange: { … }` — этот же API можно использовать вручную вне SwiftUI (например, в логировании/аналитике), но в обычной View им пользоваться не приходится. `@Bindable` нужен только когда дочерней View нужны **биндинги** (`$counter.value`); иначе достаточно передать `let counter: Counter`.

---

### Q-card: Memory & ownership — ARC in SwiftUI

**Вопрос (RU):** SwiftUI «сам управляет памятью»? Какой property wrapper выбрать и где типичные утечки?

**Ответ (RU):** Зацепка: **SwiftUI не заменяет ARC** — ViewModel и сервисы остаются reference types; wrapper задаёт **кто владеет** объектом и **когда** он пересоздаётся.

```mermaid
flowchart LR
    V["View (struct)"] --> W["Ownership wrapper"]
    W --> M["ViewModel / model (class)"]
    M --> ARC["ARC retain/release"]
    ARC --> D["deinit when no strong refs"]
```

| Кто владеет | iOS 17+ (`@Observable`) | Legacy (`ObservableObject`) |
|-------------|-------------------------|-----------------------------|
| View создаёт и держит VM | `@State private var vm = VM()` | `@StateObject private var vm = VM()` |
| VM пришёл снаружи (родитель владеет) | `@Bindable var vm` или `let vm: VM` | `@ObservedObject var vm` |
| Общий на поддерево | `@Environment(Type.self)` | `@EnvironmentObject` |

**Три правила (interview hook):**

- View **владеет** объектом → `@State` / `@StateObject`
- Объект **владеет кто-то ещё** → `@Bindable` / `@ObservedObject`
- **App-wide** shared state → `@Environment` / `@EnvironmentObject`

**Типичные баги:**

1. **`ViewModel()` в `body`** или `ObservedObject(wrappedValue: VM())` — новый экземпляр на каждый recompute → потеря state, дубли запросов. Фикс: владение через `@State` / `@StateObject`.
2. **`Task { await load() }` в `.onAppear`** — задача не привязана к lifetime view; VM может жить дольше экрана. Фикс: [`.task`](notes/swiftui-data-loading-task.md) + cooperative cancel.
3. **Retain cycle в VM** — closure / `sink` / вложенный `Task` с strong `self`. Фикс: `[weak self]`; отмена подписок в `deinit`.
4. **«View исчез» ≠ «объект освободился»** — navigation stack, parent VM или cache всё ещё держат class. Проверка: `deinit` на **модели**, Memory Graph, Instruments Leaks.

**Ответ (EN):** SwiftUI does not replace ARC. Wrappers express **ownership**, not automatic memory management. View-owned models use `@State` (Observation) or `@StateObject` (legacy); externally owned models use `@Bindable`/`@ObservedObject`; shared hierarchy state uses `@Environment`/`@EnvironmentObject`. Common pitfalls: creating VMs inside `body`, unstructured `Task` in `.onAppear`, strong-self cycles in closures, confusing view disappearance with model deallocation.

**Устная заготовка (RU):**

1. ARC на месте; wrapper = владение.
2. View владеет → `@State` / `@StateObject`.
3. Не создавать VM в `body`.
4. Async → `.task`; циклы → `[weak self]`.

**Устная заготовка (EN):**

1. SwiftUI works with ARC; wrappers express ownership.
2. View-owned → `@State` / `@StateObject`.
3. Never instantiate VMs in `body`.
4. Bind async to view lifetime; break cycles with weak captures.

**Follow-up (RU):** ViewModel не вызывает `deinit` после pop — что проверять?

**Follow-up answer (RU):** Memory Graph → цепочка strong refs (parent coordinator, singleton, неотменённый `Task`, `Set<AnyCancellable>`). Не путать struct `View` с class VM.

**Глубже:** [Memory & ARC](../../swift/memory-arc/README.md) · playground [ARCAdvanced.playground](../../swift/memory-arc/ARCAdvanced.playground) · MVVM ownership — [architecture/patterns](../../architecture/patterns/README.md)

---

### Q-card: Data loading — `.task` vs `.onAppear`

**Вопрос (RU):** Почему не стоит грузить данные с API в `.onAppear`? Что использовать вместо этого?

**Ответ (RU):** Зацепка: **`.onAppear` — lifecycle, не контракт на загрузку**.

- `View` пересоздаётся часто; `.onAppear` срабатывает при **каждом** появлении → повторные запросы без guard/кэша.
- `Task { await load() }` внутри `.onAppear` — **неструктурированная** задача; SwiftUI **не отменяет** её при disappear (нужен ручной wiring → утечки трафика и гонки с UI).
- Вместо разрозненных `isLoading` / `error` / `data` — **`enum LoadState`** в **`@MainActor` `@Observable` ViewModel** (ровно одно состояние экрана).
- В view — **`.task`** или **`.task(id:)`** ([Apple](https://developer.apple.com/documentation/swiftui/view/task(priority:_:))): async из коробки, **cooperative cancel** при исчезновении view. Повторный fetch при возврате на экран блокируют **`guard case .idle`** / уже `.loaded` / VM выше по навигации — **не сам `.task`**.
- Pull-to-refresh — **`.refreshable`**, отдельный путь `retry()`.

**Ответ (EN):** Don't use `.onAppear` for primary async API loads: it fires on every appearance and `Task { }` inside it isn't tied to view lifetime. Use a screen-state `enum` in an `@Observable` ViewModel plus `.task` or `.task(id:)` for structured async with automatic cancellation. Prevent duplicate fetches with guards or cached `.loaded`, not by switching modifiers alone.

**Устная заготовка (RU):**

1. `.onAppear` — «экран виден», не «загрузи данные».
2. `.task` — structured async + отмена с view.
3. FSM в VM — один state, без loader+error одновременно.
4. Дубли запросов — guard/кэш, не магия `.task`.

**Устная заготовка (EN):**

1. `.onAppear` is lifecycle, not a data-loading API.
2. `.task` binds async work to view lifetime.
3. One `enum` state in the ViewModel.
4. Dedupe with guards/cache, not modifier choice alone.

**Follow-up (RU):** Когда `.onAppear` допустим?

**Follow-up answer (RU):** Синхронные side effects: аналитика, scroll, geometry — без async fetch.

**Notes:** [swiftui-data-loading-task.md](notes/swiftui-data-loading-task.md)

---

### Q-card: Time-driven UI — `TimelineView` vs `Timer`

**Вопрос (RU):** Зачем `TimelineView`, если есть `Timer`?

**Ответ (RU):** Зацепка: **`TimelineView` — отрисовка от времени, `Timer` — работа во времени**.

- `TimelineView` пересчитывает content по **расписанию**, пока view в дереве; исчез — тики останавливаются без `invalidate`.
- `context.date` + **`cadence`** — формат UI под реальную частоту обновлений (например дробные секунды только при `.live`).
- Расписания: `.everyMinute`, `.periodic(from:by:)`, `.animation(minimumInterval:paused:)`.
- `Timer` / периодический `Task` — fetch, таймауты, доменная логика; не для секундомера в `body` через лишний `@State`.

**Ответ (EN):** Use `TimelineView` when UI content is a function of time (clocks, shimmer, animation phase via `context.date`). Ticks are tied to view lifetime and expose `cadence` for adaptive detail. Use `Timer` or async tasks for data refresh and non-rendering timers.

**Устная заготовка (RU):**

1. UI от времени → `TimelineView`.
2. Данные / side effects → `Task` или `Timer` вне render loop.
3. `cadence` — не обещай 60 FPS везде.

**Устная заготовка (EN):**

1. Time-based *display* → `TimelineView`.
2. Time-based *work* → `Task` / `Timer`.
3. Branch on `cadence` for detail level.

**Follow-up (RU):** Где ещё встречается в базе?

**Follow-up answer (RU):** [Graphics / shaders](../graphics/README.md) — uniform времени через `TimelineView(.animation)`.

**Notes:** [timeline-view-swiftui.md](notes/timeline-view-swiftui.md) · **Playground:** [TimelineViewDemo.playground](TimelineViewDemo.playground)

---

### Q9
- **Question (RU):** **multilevel dismiss** в SwiftUI: несколько уровней **sheet** / **fullScreenCover** / **навигация** — как задать состояние и **кто** закрывает какой уровень?
- **Question (EN):** Multilevel dismiss in SwiftUI—stacked sheets, fullScreenCover, navigation; state patterns and who dismisses which level?
- **Answer (RU):** Зацепка: презентации в SwiftUI **декларативны** — показывается то, что следует из **`@State` / биндингов / маршрута**; закрытие — это **сброс того же состояния** или вызов **`dismiss()`** из **правильного** `Environment`.

    **Кто закрывает уровень:** **`@Environment(\.dismiss)`** ([`DismissAction`](https://developer.apple.com/documentation/swiftui/dismissaction)) закрывает **текущую** презентацию **относительно того места, где environment прочитан**. Apple прямо предупреждает: **`dismiss` нужно брать внутри контента sheet**, а не в родителе — иначе действие относится к **родительскому** окружению (лист не закроется, на macOS/iPadOS может закрыться **окно**). Для **навигации** (`NavigationStack` + `path`) «закрыть уровень» = **`path.removeLast()`** или очистить **`NavigationPath`**; `dismiss()` в контексте push — **pop** текущего экрана ([документация](https://developer.apple.com/documentation/swiftui/dismissaction)).

    **Паттерны состояния:** (1) **Один источник правды на ветку презентаций** — `enum` с `Identifiable` + **один** `.sheet(item:)` / `.fullScreenCover(item:)` вместо нескольких `.sheet(isPresented:)` на одном view (иначе порядок/какой сработает — хрупко). (2) **Вложенные флаги** `showA`, `showB` — работает, но «свалить всё» = выставить **оба** в `false` (часто через **`onDismiss`** внешнего листа или колбэк «готово»). (3) **Координатор / замыкание** с родителя: дочерний экран перед закрытием вызывает `onComplete()` → родитель **атомарно** меняет enum в `.none` — снимает **весь стек**, если это один `item`. (4) **Навигация внутри листа** — отдельный `NavigationStack` + `path` внутри модалки: внешнее `dismiss()` закрывает **всю модалку**, внутренний pop — только **шаг** внутри.

    **fullScreenCover** — по смыслу как sheet для dismiss/state; отличие в **UX и жестах**, не в модели «сбросить binding».

- **Answer (EN):** Presentations follow state. Use `Environment(\.dismiss)` **inside** presented content to pop a sheet or a navigation level; read it in the wrong scope and dismissal targets the wrong presentation (per Apple). Prefer a single `sheet(item:)` driven by an `Identifiable` enum rather than stacking multiple `sheet(isPresented:)`. Collapsing the whole stack = reset shared presentation state or clear `NavigationPath`.

- **Устный канон (опросник п.22 / H22, drill):** «**Состояние** решает, что показано; **закрыть** — **сбросить state** или **`dismiss()` из контента презентации**. Несколько уровней — **enum + один sheet** или **вложенный NavigationStack**; **свалить всё** — **родитель** в **один** переход состояния.»

- **Follow-up (RU):** как закрыть **два листа** одной кнопкой?
- **Follow-up answer (RU):** один **`enum`** презентации в `.none`; либо сброс **двух** `@State` подряд (может мигать — лучше одна модель); либо **dismiss** на самом внешнем контейнере, если архитектура это допускает.

- **Доп. информация:** [Habr H22](https://habr.com/en/articles/726388/); [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.22; [DismissAction](https://developer.apple.com/documentation/swiftui/dismissaction); блок выше «обратная передача данных» (unwind-аналог); **II/05 Q51** (если отвлёкся на функции — там таблицы).

- **Playground:** [open](swiftui_state_management.playground/Contents.swift)
- **Notes:** [III/11 SwiftUI — декларативный UI и state management/SwiftUI-Declarative-UI-State.md](III.%20iOS%20SDK/11%20SwiftUI%20—%20декларативный%20UI%20и%20state%20management/SwiftUI-Declarative-UI-State.md)

---

### Q10
- **Question (RU):** что такое протокол **`View`** в SwiftUI и зачем **`Body`** / **`@ViewBuilder`**?
- **Question (EN):** What is the `View` protocol—`Body`, `@ViewBuilder`?
- **Answer (RU):** Зацепка: по [документации Apple](https://developer.apple.com/documentation/swiftui/view), **`View`** — тип, который **представляет часть UI** и даёт **модификаторы** для настройки; обязательное — вычисляемое свойство **`body`** с типом **`some View`** (opaque), собирающее иерархию из примитивов и других `View`.

    **`associatedtype Body`:** конкретный тип дерева, которое возвращает `body` (часто **opaque** `some View`). **`@ViewBuilder`** — атрибут результата `body` (и похожих замыканий): позволяет писать **несколько** дочерних view / `if` / `switch` **без явного `Group`** — DSL для дерева.

    **Модификаторы** по модели SwiftUI **оборачивают** экземпляр в новый тип view с нужными параметрами (цепочка `Text().padding().foregroundStyle(...)`).

- **Answer (EN):** `View` describes a piece of UI via `body`; modifiers wrap the view. `Body` is the concrete tree type; `@ViewBuilder` builds conditional/multi-statement view DSL.

- **Устный канон (опросник п.23 / H23, drill):** «**`View`** — **описание** куска UI через **`body`**; **`@ViewBuilder`** — **DSL** для дерева; **модификаторы** — **обёртки** вокруг типа.»

- **Follow-up (RU):** почему `body` — **`some View`**, а не конкретный тип?
- **Follow-up answer (RU):** тип дерева **сложный и меняется** от модификаторов; **opaque** скрывает конкретику, сохраняя **статическую** типизацию у компилятора.

- **Доп. информация:** [Habr H23](https://habr.com/en/articles/726388/); [View](https://developer.apple.com/documentation/swiftui/view); [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.23; см. **Q11** (почему `struct`).

- **Playground:** [open](swiftui_state_management.playground/Contents.swift)
- **Notes:** [III/11 SwiftUI — декларативный UI и state management/SwiftUI-Declarative-UI-State.md](III.%20iOS%20SDK/11%20SwiftUI%20—%20декларативный%20UI%20и%20state%20management/SwiftUI-Declarative-UI-State.md)

### Q11
- **Question (RU):** почему во SwiftUI **`View`** обычно — **`struct`**?
- **Question (EN):** Why is SwiftUI `View` typically a `struct`?
- **Answer (RU):** Зацепка: **`View`** в SwiftUI — это не «живой виджет на экране», а **значение-описание** (`value`): *какой* UI нужен при *текущих* входных данных. Рендер и долговечность — у **рантайма и графа**; `struct` хорошо ложится на эту модель.

    **1) Value semantics вместо «одного объекта на экран».** В UIKit **`UIView`** — **reference type** с **идентичностью** (`===`): один экземпляр, много указателей, общая мутабельность. В SwiftUI **каждый раз** можно получить **новое значение** `ContentView(...)` — это **новая версия рецепта**, а не «тот же объект перерисовали». Мутабельность **не размазывается** по алиасам самого `View`-значения.

    **2) Пересборка `body`.** При изменении зависимостей SwiftUI **вызывает `body` снова** и сравнивает результат с прошлым описанием. **`struct`** здесь уместен: **immutable-ish** слой «что хотим», а не накопление побочных эффектов внутри самого типа `View`. Тяжёлое **сохранённое** состояние не обязано жить в stored properties `View` — его держат **`@State` / `@StateObject` / `@Observable` / окружение**: у структуры есть **стабильное хранилище**, не совпадающее с «копией значения в стеке» буквально.

    **3) `@State` и «где на самом деле память».** То, что `View` — `struct`, **не значит**, что вся память на стеке: **`@State`** (и аналоги) связывают поле с **внешним буфером**, привязанным к **месту в дереве**. Поэтому формула для собеса: «**`View` — лёгкое описание; долгоживущее — в state / модели**».

    **4) Модификаторы = новые типы.** Цепочка `.padding().background()` строит **цепочку обёрток** — удобнее, когда базовый тип **`struct`**: композиция **значений** без обязательной «один класс-обёртка на всё».

    **5) Производительность — осторожно.** «**struct быстрее**» — **не аксиома**: если раздувать stored properties или злоупотреблять type-erasure (`AnyView`), можно потерять. Выигрыш обычно в том, что **описание маленькое**, копии **дешёвые**, а **ARC/циклы** концентрируются в **классах модели** и **замыканиях**, где их проще рассуждать.

    **6) Идентичность в дереве.** У значения `View` **нет** стабильного `===` как у виджета. SwiftUI отличает узлы по **структуре**, **`id`**, `.tag`, позиции в `ForEach` и т.д. Это отдельная тема (identity), но она **дополняет**, а не отменяет выбор `struct`.

    **7) Почему не `class` по умолчанию.** Класс тянет **разделяемую ссылку**, **наследование**, **деинициализацию** — для «одноразового описания кадра» это чаще **лишняя семантика** и риск **разделяемой мутабельности** описания. Классы остаются для **сервисов, VM, legacy UIKit**.

- **Answer (EN):** A SwiftUI `View` is primarily a **lightweight value-typed description** of UI, not a long-lived widget instance. `body` can be re-evaluated frequently; real persistence lives in `@State`/environment/models (often classes). Structs match modifier chains (wrapping values), reduce accidental shared mutation of the description, and keep ARC/retain-cycle concerns centered in models/closures. Identity in the tree is handled separately (`id`, `ForEach` keys, structure), not by `===` on the struct description itself.

- **Устный канон (опросник п.24 / H24, drill):** «**`View` — struct**, потому что это **описание** UI: **value semantics**, **дешёвые копии**, состояние **вне** в `State`/модели; **меньше shared mutable** на уровне дерева.»

- **Follow-up (RU):** когда **`View` всё же `class`**?
- **Follow-up answer (RU):** редко и осознанно; чаще **класс** — **модель** (`ObservableObject`, сервис), а не сам `View`.

- **Доп. информация:** [Habr H24](https://habr.com/en/articles/726388/); [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.24; [View](https://developer.apple.com/documentation/swiftui/view); см. **Q10**.

- **Playground:** [open](swiftui_state_management.playground/Contents.swift)
- **Notes:** [III/11 SwiftUI — декларативный UI и state management/SwiftUI-Declarative-UI-State.md](III.%20iOS%20SDK/11%20SwiftUI%20—%20декларативный%20UI%20и%20state%20management/SwiftUI-Declarative-UI-State.md)

### Q12
- **Question (RU):** **UIKit внутри SwiftUI** — **`UIViewRepresentable`** и **`UIViewControllerRepresentable`**: зачем, **какие методы**, **`Coordinator`**, как **прокинуть state**?
- **Question (EN):** Embedding UIKit in SwiftUI—`UIViewRepresentable` vs `UIViewControllerRepresentable`, lifecycle hooks, coordinator, state?
- **Answer (RU):** Зацепка: по [Apple](https://developer.apple.com/documentation/swiftui/uiviewrepresentable), **`UIViewRepresentable`** — обёртка **`UIView`** для встраивания в SwiftUI; **`UIViewControllerRepresentable`** — то же для [`UIViewController`](https://developer.apple.com/documentation/swiftui/uiviewcontrollerrepresentable). Оба — **`View`**, но с `Body == Never`: реального `body` нет — рендерит **UIKit**.

    **Жизненный цикл (UIView):** **`makeUIView(context:)`** — создать view и базовую настройку; **`updateUIView(_:context:)`** — при изменении **SwiftUI state** снова вызывается — синхронизируй **props** в UIKit (`text`, `isHidden`, …); **`dismantleUIView(_:coordinator:)`** — убрать подписки / освободить ресурсы. Для VC: **`makeUIViewController`**, **`updateUIViewController`**, **`dismantleUIViewController`**.

    **Координатор:** **документация:** система **не пробрасывает** события из UIKit в SwiftUI автоматически — для **delegate / target-action** делают **`Coordinator`** (через **`makeCoordinator()`**), держат **слабую** ссылку на родителя/`Binding` и вызывают **колбэки** / пишут в **`Binding`**.

    **State SwiftUI → UIKit:** храни нужное в **`@Binding` / `@State` / модели`** representable-структуры; в **`updateUIView(*)`** копируй в свойства UIKit. **UIKit → SwiftUI:** delegate/coordinator → **`binding.wrappedValue = ...`** или `@Observable`.

    **Предупреждение Apple:** SwiftUI **полностью контролирует** layout-поля (`frame`, `bounds`, `center`, `transform`) вью у representable — **не выставляй их вручную** из своего кода к управляемой SwiftUI вью — **undefined behavior**.

- **Answer (EN):** Representables wrap UIKit views or view controllers into SwiftUI. Implement make/update/dismantle; use a `Coordinator` to bridge delegates/target-actions to SwiftUI state via bindings. Don’t fight SwiftUI for layout of the managed view—Apple documents UB if you set frame/bounds/center/transform yourself.

- **Устный канон (опросник п.25 / H25, drill):** «**Representable** встраивает **UIKit**: **`make` / `update` / `dismantle`**, **`Coordinator`** для **delegate**, **`Binding`** для данных; **layout** не ломать — контролирует **SwiftUI**.»

- **Follow-up (RU):** когда нужен **VC**, а не **View**?
- **Follow-up answer (RU):** нужен **`UINavigationController`**, **системные VC**, **child VC**-композиция — тогда **`UIViewControllerRepresentable`**.

- **Доп. информация:** [Habr H25](https://habr.com/en/articles/726388/); [UIViewRepresentable](https://developer.apple.com/documentation/swiftui/uiviewrepresentable); [UIViewControllerRepresentable](https://developer.apple.com/documentation/swiftui/uiviewcontrollerrepresentable); [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.25; **III/10 UIKit** (жизненный цикл VC).

- **Playground:** [open](swiftui_state_management.playground/Contents.swift)
- **Notes:** [III/11 SwiftUI — декларативный UI и state management/SwiftUI-Declarative-UI-State.md](III.%20iOS%20SDK/11%20SwiftUI%20—%20декларативный%20UI%20и%20state%20management/SwiftUI-Declarative-UI-State.md)

### Q13
- **Question (RU):** **п.33 / H33** — плюсы и минусы **SwiftUI** vs **UIKit** (в одном заходе)?
- **Question (EN):** SwiftUI vs UIKit tradeoffs in one interview pass?
- **Answer (RU):** Зацепка: **SwiftUI** — **декларативное** описание UI (**`View`** чаще как **`struct`**, «рецепт кадра»); **UIKit** — **императивная** работа с **живым** графом **`UIView`** (**reference type**, идентичность `===`, ручные `addSubview` / constraints / `setNeedsLayout`).

    **Плюсы SwiftUI:** меньше шаблонного кода, быстрее типичные экраны, **состояние** рядом с UI (`@State`, `@Binding`, `@Observable`), превью, проще адаптив и списки в стандартных кейсах.

    **Минусы / риски SwiftUI:** отладка «почему лишний `body`», производительность на сложных списках без дисциплины, требования к **версии ОС**, часть API всё ещё через **bridge** (**Q12**).

    **Плюсы UIKit:** полный контроль, предсказуемый жизненный цикл **`UIView`/`UIViewController`**, зрелая экосистема сложных контролов и интеграций.

    **Минусы UIKit:** больше ручной работы (constraints, datasource), больше шанс размазать состояние.

    **Уточнение к короткой формуле «SwiftUI = struct, UIKit = class»:** у SwiftUI **модель и окружение** часто **`class`** (`@Observable`, `ObservableObject`); **описание** экрана — значения **`struct`**. UIKit тоже использует **structs** (`CGRect`, `NSDirectionalEdgeInsets`) — речь про **узел UI**, не про «всё приложение только классы».

- **Answer (EN):** SwiftUI is declarative: lightweight `View` values (usually structs) describe UI; the runtime diff/updates the graph. UIKit is imperative: you mutate a persistent `UIView` hierarchy (reference semantics). SwiftUI trades boilerplate and speed of development for occasional complexity in state/diff debugging; UIKit trades verbosity for fine control. Models in SwiftUI are often still classes.

- **Устный канон (опросник п.33 / H33, drill):** «**SwiftUI** — **декларативно**, **`View`**-**`struct`**, состояние отдельно; **UIKit** — **императивно**, **`UIView`**-**class**, ручная иерархия; **SwiftUI** быстрее стандартные экраны, **UIKit** — тонкий контроль и легаси; сложное — **Representable** / **HostingController**.»

- **Формулировка с drill (п.33):** «**SwiftUI** — **декларативный** UI на **структурах**; **UIKit** — **императивный** на **референс-типах**.»

- **Follow-up (RU):** как встроить SwiftUI в UIKit и наоборот?
- **Follow-up answer (RU):** **`UIHostingController`** (SwiftUI внутри UIKit); **`UIViewRepresentable` / `UIViewControllerRepresentable`** (**Q12**) — UIKit внутри SwiftUI.

- **Доп. информация:** [Habr H33](https://habr.com/en/articles/726388/); [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.33; **Q11** (почему `struct`), **Q12** (bridge); **III/10 UIKit**.

- **Playground:** [open](swiftui_state_management.playground/Contents.swift)
- **Notes:** [III/11 SwiftUI — декларативный UI и state management/SwiftUI-Declarative-UI-State.md](III.%20iOS%20SDK/11%20SwiftUI%20—%20декларативный%20UI%20и%20state%20management/SwiftUI-Declarative-UI-State.md)

---

## Ресурсы

### TimelineView — time-driven UI (Nil Coalescing)
- **Type:** article + playground
- **URL:** https://nilcoalescing.com/blog/TimelineViewInSwiftUI/
- **Author:** Natalia Panferova (Nil Coalescing)
- **Why:** Schedules, `context.cadence`, animation without state; vs `Timer`
- **When:** Clocks, countdown, shimmer, shader time uniform
- **Tags:** `swiftui`, `timelineview`, `animation`, `pattern`
- **Note:** [timeline-view-swiftui.md](notes/timeline-view-swiftui.md)
- **Playground:** [TimelineViewDemo.playground](TimelineViewDemo.playground)
- **Added:** 2026-06-19

### Floating card using safeAreaBar (Codakuma)
- **Type:** article + code
- **URL:** https://codakuma.com/floating-safe-area-bar/
- **Author:** Codakuma
- **Why:** CTA-карточка внизу: safeAreaInset → floating card → safeAreaBar (26) / material fallback (18)
- **When:** Checkout bar, summary + Save, bottom CTA over ScrollView/List
- **Tags:** `swiftui`, `safe-area`, `ios-26`, `layout`, `pattern`
- **Playground:** [FloatingSafeAreaBar.playground](FloatingSafeAreaBar.playground)
- **Added:** 2026-06-19
