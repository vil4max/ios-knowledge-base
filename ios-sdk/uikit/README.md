# UIKit

## За 30 секунд


UIKit is the **imperative** iOS UI framework: **UIView** hierarchy, **UIViewController** lifecycle, **Auto Layout**, tables/collections, and touch handling via **responder chain**. Still essential for interviews, legacy codebases, and SwiftUI bridges. Know lifecycle callbacks, when layout runs, memory (retain cycles in closures), and adaptive traits (size class, Dynamic Type).


<details class="lang-ru">
<summary>По-русски</summary>

UIKit — **императивный** UI: иерархия **UIView**, **UIViewController**, lifecycle, delegates, Auto Layout. Всё ещё основа многих приложений и bridge для SwiftUI.

</details>



## Apple docs

- [UIKit](https://developer.apple.com/documentation/uikit) — views, view controllers, controls.
- [UIViewController](https://developer.apple.com/documentation/uikit/uiviewcontroller) — lifecycle, containment, transitions.
- [UIView](https://developer.apple.com/documentation/uikit/uiview) — layout, drawing, gestures.
- [UITableView](https://developer.apple.com/documentation/uikit/uitableview) / [UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview) — reuse, data source.
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines) — patterns and platform conventions.

## 🎯 Фокус vs можно отложить (вопрос → ответ)

- `UIView` vs `UIViewController` vs `UIWindow` lifecycle (`viewDidLoad`, `viewWillAppear`, `viewIsAppearing`).
  - **Ответ**:  
    - `UIView` отвечает за отображение/лейаут/обработку касаний.  
    - `UIViewController` управляет жизненным циклом экрана и связывает view с данными/навигацией.  
    - `UIWindow` — корень, который принимает события и держит root VC.  
    Практика: тяжелые инициализации — в `viewDidLoad`, обновление UI перед показом — `viewWillAppear`, анимации/аналитика “после показа” — `viewDidAppear`.  
    Docs: `https://developer.apple.com/documentation/uikit/uiviewcontroller`

- Responder chain, hit-testing.
  - **Ответ**: responder chain — цепочка, по которой событие “поднимается” (view → superview → VC → window → app). Hit-testing определяет, какая view получит touch. Понимание этого снимает “магические” баги жестов/тачей.  
    Docs: `https://developer.apple.com/documentation/uikit/uiresponder`

- Layer vs View, `setNeedsLayout` vs `layoutIfNeeded`.
  - **Ответ**: `UIView` — объект UIKit с поведением и иерархией; `CALayer` — низкоуровневый рендер-слой (анимации/композиция). `setNeedsLayout` помечает layout как устаревший (выполнится позже), `layoutIfNeeded` принудительно запускает layout сейчас (часто нужно перед анимацией).  
    Docs: `https://developer.apple.com/documentation/uikit/uiview`

- Адаптивность: trait collections, Dynamic Type, Dark Mode.
  - **Ответ**: `UITraitCollection` меняется на лету (size class, interface style, content size category). Корректный UI реагирует на изменения traits и поддерживает Dynamic Type и dark mode без перезапуска приложения.  
    Docs: `https://developer.apple.com/documentation/uikit/uitraitcollection`

### Отложить

- Storyboards/XIB: уметь читать, но в новых проектах часто programmatic UI.
- Низкоуровневый tab bar customization, если хватает `UITabBarController`.

## 📚 Что учить по уровням

### TRAINEE

- Что такое `UIView`/`UIViewController`, кнопка и обработка тапа.

### JUNIOR

- Lifecycle: `viewDidLoad`, `viewWillAppear`, `viewIsAppearing`.
- `UIScrollView`, `UITableView`, базовый `UICollectionView`.
- Programmatic UI для одного экрана.
- Dark Mode + Dynamic Type.

### MIDDLE

- Hit-testing/responder chain, кастомные жесты.
- Custom transitions (`UIViewControllerAnimatedTransitioning`).
- Adaptive layout: trait collections, size classes.

### SENIOR

- UIKit + SwiftUI гибрид (`UIHostingController`) с динамическим sizing.
- Миграция legacy MVC в современную архитектуру без переписывания всего.
- Профилирование скролла (60–120fps), async image decoding.

### TECH LEAD

- Стратегия UIKit ↔ SwiftUI: где что использовать.
- Дизайн-система поверх UIKit (компоненты + токены).

## 📚 Ключевые термины (вопрос → ответ)

- Responder chain
  - **Ответ**: цепочка объектов, которые могут обработать событие: view → superview → view controller → window → application. Помогает дебажить тапы/жесты/`sendAction`.  
    Docs: `https://developer.apple.com/documentation/uikit/uiresponder`

- Hit-testing
  - **Ответ**: поиск view под точкой касания (`hitTest(_:with:)`, `point(inside:with:)`). Переопределение позволяет делать “прозрачные” зоны или перенаправлять тач.  
    Docs: `https://developer.apple.com/documentation/uikit/uiview/1622469-hittest`

- `setNeedsLayout`
  - **Ответ**: помечает layout как устаревший; реальный `layoutSubviews` выполнится позже в цикле runloop.  
    Docs: `https://developer.apple.com/documentation/uikit/uiview`

- Trait collection
  - **Ответ**: контекст окружения (size class, dark mode, content size category, accessibility). Может меняться без перезапуска, UI обязан реагировать.  
    Docs: `https://developer.apple.com/documentation/uikit/uitraitcollection`

## 🏋️ Упражнения (10)

Ниже — практические задания в формате “что сделать и что проверить”.

1) Lifecycle trace  
Сделайте экран с логированием `viewDidLoad`, `viewWillAppear`, `viewDidAppear`, `viewWillDisappear`, `viewDidDisappear`.  
Проверка: объяснить порядок вызовов при push/pop и modal present/dismiss.

2) Responder chain  
Переопределите `next`/обработку действия и проследите путь события от кнопки до VC.  
Проверка: объяснить, почему action пришёл именно туда.

3) Hit-testing  
Сделайте overlay-view, которая визуально сверху, но пропускает тапы на нижний контрол.  
Проверка: корректная работа `point(inside:with:)` или `hitTest(_:with:)`.

4) setNeedsLayout vs layoutIfNeeded  
Соберите пример, где изменение constraints сначала “не видно”, а после `layoutIfNeeded` видно сразу.  
Проверка: понимать deferred vs immediate layout pass.

5) Trait changes  
Добавьте реакцию на смену `traitCollection` (dark/light, content size category).  
Проверка: UI корректно перестраивается без перезапуска.

6) Gesture conflicts  
На одном экране объедините `UIPanGestureRecognizer` и `UIScrollView`.  
Проверка: настроить приоритеты/совместимость (`gestureRecognizer(_:shouldRecognizeSimultaneouslyWith:)`).

7) Custom transition  
Реализуйте простую кастомную анимацию push/present через `UIViewControllerAnimatedTransitioning`.  
Проверка: корректный интерактивный и неинтерактивный сценарий.

8) Collection performance  
Соберите `UICollectionView` с diffable data source + prefetch.  
Проверка: плавный скролл без просадок при обновлении данных.

9) UIKit + SwiftUI bridge  
Встроить SwiftUI-вью через `UIHostingController` в UIKit-экран и обратно (`UIViewRepresentable`).  
Проверка: корректные размеры и lifecycle-интеграция.

10) Scene-based migration  
Смоделировать переход с AppDelegate-only на scene-based конфигурацию.  
Проверка: приложение корректно обрабатывает `UISceneSession` и жизненный цикл окна.

---

## Карточки знаний (Q&A)

Ниже — Q&A по теме.

<!-- knowledge-cards-canonical:start -->

### Q21
- **Question (EN):** Lifecycle order for first VC appearance?

- **Вводные данные:** вопрос про первый показ экрана — цепочка «появился». Ты перечислил почти все имена, но важно не смешать её с уходом с экрана: после **layout** (**layout pass**) идёт именно `viewDidAppear` (уже показали), а `viewWillDisappear` / `viewDidDisappear` — когда экран уходит. **`deinit`** у контроллера — ещё позже, при **deallocation** (деаллокации; не обязательно сразу после **`viewDidDisappear`**).

- **Answer (EN):** First show: `loadView` (when programmatic) → `viewDidLoad` → `viewWillAppear` → layout pass (`willLayout` / `layoutSubviews` / `didLayout`) → `viewDidAppear`. Teardown is `willDisappear` → `didDisappear`; `deinit` is deallocation timing—not the same milestone as appearance.

- **Устная заготовка (EN):**

    1. First appearance: loadView → viewDidLoad → viewWillAppear → layout pass → viewDidAppear.
    2. Leaving: viewWillDisappear → viewDidDisappear.
    3. `deinit` is separate—deallocation, not “last appearance hook”.

- **Итог одной фразой (EN):** First show ends at `viewDidAppear` after layout pass; `viewDidDisappear`/`deinit` are teardown/deallocation.

- **Follow-up:** когда `viewWillAppear` может быть без `viewDidAppear`?

- **Follow-up answer:** если переход оборвали до конца (отмена интерактивного pop, контейнер снял VC, координатор transition отменил анимацию) — пара appear/disappear может не завершиться «полным» циклом; тогда `viewWillAppear` мог быть без последующего `viewDidAppear` для этого показа.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** порядок **lifecycle** (жизненный цикл) первого показа VC?

- **Answer (RU):** первый показ (упрощённо): **`loadView`** (если **`view`** создаёшь кодом; при **storyboard** / **xib** цепочка может начинаться с уже готового **`view`**) → **`viewDidLoad`** (**`view`** загружен один раз) → **`viewWillAppear`** (скоро на экране) → **layout pass** (`viewWillLayoutSubviews` → **`layoutSubviews`** / **constraint pass** → `viewDidLayoutSubviews`) → **`viewDidAppear`** (уже на экране).

    Полный «оборот» экрана отдельно: при уходе — **`viewWillDisappear`** → **`viewDidDisappear`**; память — **`deinit`**, когда объект действительно **deallocated** (освобождён).

- **Устная заготовка (RU):**

    1. Первый показ: `loadView` → `viewDidLoad` → `viewWillAppear` → layout pass → `viewDidAppear`.
    2. Уход: `viewWillDisappear` → `viewDidDisappear`.
    3. `deinit` — deallocation контроллера; не путать с `viewDidDisappear`.

- **Итог одной фразой (RU):** первый показ: до `viewDidAppear` через load → didLoad → willAppear → layout pass; уход (`viewDidDisappear`) и `deinit` — другая фаза.

</details>

- **Доп. информация:** связать с `isMovingToParent` / `isBeingPresented`; обрывы — `interactivePopGesture`, `willMove(toParent:)` до завершения transition, `UIViewControllerTransitionCoordinator` cancellation.
### Q22
- **Question (EN):** `setNeedsLayout` vs `layoutIfNeeded`?

- **Answer (EN):** `setNeedsLayout` marks the view dirty and schedules a future layout pass. `layoutIfNeeded` lays out immediately if needed—synchronous flush of pending layout on that subtree.

- **Устная заготовка (EN):**

    1. `setNeedsLayout` schedules layout.
    2. `layoutIfNeeded` forces layout now if dirty.
    3. Drawing is `setNeedsDisplay`, not layout.

- **Итог одной фразой (EN):** Schedule vs synchronous layout flush.

- **Follow-up:** как применять в constraint animation (анимации constraints)?

- **Follow-up answer:** меняешь constraints / constants, затем внутри блока анимации вызываешь `layoutIfNeeded` на нужном контейнере (ветке иерархии) — начальный и конечный кадры layout попадают в анимацию; один только `setNeedsLayout` без forced layout pass может не дать нужный синхронный эффект к началу анимации.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** `setNeedsLayout` vs `layoutIfNeeded`?

- **Answer (RU):** `setNeedsLayout` — пометить иерархию как layout dirty (нужен будущий layout pass), запланировать layout pass позже, когда run loop доходит до фазы layout / обновления geometry (геометрии); не обязательно сразу пересчитывает constraints.

    `layoutIfNeeded` — если эта ветка layout dirty, синхронно выполнить layout pass; если пометки не было, делать почти нечего.

- **Устная заготовка (RU):**

    1. `setNeedsLayout` — помечает layout dirty, отложенный layout pass.
    2. `layoutIfNeeded` — если layout dirty, синхронно выполнить layout pass.
    3. Не путать с `setNeedsDisplay` — это drawing.

- **Итог одной фразой (RU):** `setNeedsLayout` — в очередь на layout pass; `layoutIfNeeded` — синхронный layout pass сейчас.

</details>

- **Доп. информация:** вызывать `layoutIfNeeded` на том контейнере, чьи subviews реально едут; не злоупотреблять на всём окне без нужды.
### Q24
- **Question (EN):** `frame` vs `bounds`?

- **Answer (EN):** `frame` is in the superview’s space; `bounds` is the view’s own coordinate space.

- **Устная заготовка (EN):**

    1. `frame` — position and size in the `superview`’s coordinate space.
    2. `bounds` — the `view`’s own local coordinate space.

- **Follow-up:** как `bounds.origin` связан с scroll behavior (поведением скролла)?

- **Follow-up answer:** у `UIScrollView` при скролле двигают `contentOffset`, что эквивалентно смене `bounds.origin`: смещается видимое «окно» по `contentSize`, а `frame` (положение скролла в `superview`) часто не меняется. Для обычного `UIView` `bounds.origin` чаще `(0, 0)`, пока явно не задают иное.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** `frame` vs `bounds`?

- **Answer (RU):** `frame` — geometry (геометрия) в координатном пространстве `superview`; `bounds` — локальная система координат `view`.

- **Устная заготовка (RU):**

    1. `frame` — в координатах `superview` (позиция и размер «как нас видят снаружи»).
    2. `bounds` — свои локальные координаты (разметка и `draw` внутри `view`).

</details>

- **Доп. информация:** `transform` меняет `frame`, но не `bounds`; при обсуждении hit-testing иногда уводят в `convert(_:to:)` / `hitTest(_:with:)` — смежная тема к двум системам координат.
### Q26
- **Question (EN):** Why know the responder chain?

- **Answer (EN):** It routes events and actions from the UIKit layer along linked `UIResponder` instances until someone handles them.

    Responders form a chain via `next` (roughly view → view controller → window → application → app delegate). `UIView` subclasses `UIResponder`, but `UIResponder` is the shared base for every chain participant, not “the root of all UI” alone.

    Unhandled touches propagate `next`. `first responder` is who owns keyboard/text input. For `UIControl`, a nil `target` searches the action selector up the responder chain.

- **Устная заготовка (EN):**

    1. Responder chain routes events/actions until handled.
    2. Linked `UIResponder` instances via `next`.
    3. `first responder` — keyboard-focused input.
    4. `UIControl` + nil `target` walks the chain for the selector.

- **Follow-up:** пример нестандартной маршрутизации event / action.

- **Follow-up answer:** `UIControl` с `target == nil` — `action` бежит вверх по цепочке (типичный приём в nib / `UIStoryboard`). Кастомный `hitTest(_:with:)` / `point(inside:with:)` меняет, кто получает касание и кто может стать `first responder`. `becomeFirstResponder` / `resignFirstResponder` у кастомного поля ввода — явное управление фокусом. Перехват клавиш (`UIKeyCommand`) у `UIViewController` — событие обрабатывается на уровне контроллера, минуя конкретный `UIView`.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** зачем знать responder chain (цепочку responder)?

- **Answer (RU):** нужна для маршрутизации событий (events) и действий (actions) от UIKit-слоя к тому `UIResponder`, кто их примет или передаст дальше.

    Участники цепочки — объекты `UIResponder`, связанные через `next` (упрощённо вверх: `UIView` → `UIViewController` → `UIWindow` → `UIApplication` → делегат приложения). `UIView` наследует `UIResponder`, но базовый класс `UIResponder` — не «основа любого view», а общий предок всего, что входит в цепочку (в т.ч. контроллеры, окно, приложение).

    События (touch и др.), которые текущий объект не обработал, уходят по `next`, пока кто-то не обработает или цепочка не закончится. `first responder` — текущий получатель ввода с клавиатуры и части системных действий (`UITextField`, `UITextView` и т.п.). У `UIControl` при `target == nil` поиск обработчика `action` идёт вверх по responder chain.

- **Устная заготовка (RU):**

    1. Цепочка — маршрутизация events / actions от UI к получателю.
    2. Связь `UIResponder` через `next` вверх по иерархии.
    3. `first responder` — клавиатура / ввод текста.
    4. `UIControl`, `target == nil` — `action` ищется по цепочке.

</details>

- **Доп. информация:** target-action и цепочка — смежные механизмы; знание одного не отменяет второе. Для текста дополнительно `UITextInput` и уведомления клавиатуры.
### Q27
- **Question (EN):** `UIView` vs `CALayer`?

- **Устная заготовка (EN):**

    1. UIView wraps a backing CALayer.
    2. Views handle interaction/layout; layers handle rendering/compositing.
    3. Many animations ultimately animate layer properties.

- **Follow-up:** где layer-first подход даёт выигрыш?

- **Follow-up answer:** когда нужно часто менять геометрию/путь без полной перерисовки всего `draw(_:)` view: `CAShapeLayer`, `CAGradientLayer`, группа слоёв с отдельными `contents`; тяжёлый кастомный `draw(_:)` проще заменить или дополнить слоями. Явные анимации через `CABasicAnimation` / keyframes на `layer` без лишних проходов layout. Осторожно: лишние подслои, маски и `cornerRadius` + `masksToBounds` могут давать offscreen passes — тема производительности рядом с этим ответом.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** `UIView` vs `CALayer`?

- **Устная заготовка (RU):**

    1. View — API над backing `layer`.
    2. View — touch, responder, layout; layer — рисование и compositing.
    3. Анимации часто бьют в `layer` (`transform`, `opacity`).

</details>

- **Доп. информация:** анимации `UIView` часто проксируют в `layer` (`position`, `transform`); `draw(_:)` vs `CALayerDelegate` / `CAShapeLayer` — когда дорого перерисовывать всё view. `cornerRadius` + `masksToBounds` — классический разговор про offscreen passes рядом с этим вопросом.
### Q28
- **Question (EN):** Safe area and child view controllers?

- **Answer (EN):** Safe area is the layout region avoiding system chrome (notch, status bar, home indicator, rounded corners)—exposed as `safeAreaInsets` / `safeAreaLayoutGuide`, not just raw screen bounds.

    Embedded child view controllers inherit the container’s safe-area context; the parent can push insets with `additionalSafeAreaInsets`. Correct embedding (`addChild`, view setup, `didMove(toParent:)`, appearance transitions) keeps children aligned with the parent’s safe area.

- **Устная заготовка (EN):**

    1. Safe area avoids system obstructions—insets/layout guide.
    2. Children inherit the parent’s safe-area story; watch `additionalSafeAreaInsets`.
    3. Embed with proper child lifecycle and appearance transitions.

- **Follow-up:** частая ошибка с `beginAppearanceTransition` / `endAppearanceTransition`.

- **Follow-up answer:** вызывают только один конец пары, вызывают в неправильном порядке относительно `addChild`/`removeFromParent`, или забывают `endAppearanceTransition` при отмене transition — у ребёнка ломаются счётчики appearance (`isViewLoaded`/`view.window` и логика «на экране»), из‑за чего едут insets, подписки и анимации. Нужна симметрия begin/end и согласование с реальным добавлением/снятием view с иерархии.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** safe area (безопасная область) и child view controllers (дочерние контроллеры)?

- **Answer (RU):** safe area — область контента с учётом системных выступов (notch, статус-бар, home indicator, скругления), не «голые края экрана». На практике это `safeAreaInsets` и `safeAreaLayoutGuide` у корневого `view` контроллера.

    Встроенный child view controller живёт в иерархии родителя: дочерний VC должен получать согласованные safe area и корректный appearance lifecycle. Родитель может расширить «опасную» зону через `additionalSafeAreaInsets` (свои панели/бары) — это участвует в расчёте safe area у детей. При embed важны `addChild`, размещение `view`, `didMove(toParent:)` и парные appearance transitions.

- **Устная заготовка (RU):**

    1. Safe area — не край экрана, а зона без системных помех; `safeAreaInsets`.
    2. Child VC — учитывать safe area иерархии родителя; `additionalSafeAreaInsets` у родителя влияет на детей.
    3. Embed: `addChild` → layout → `didMove` + согласованные appearance callbacks.

</details>

- **Доп. информация:** при кастомных контейнерах проверять `edgesForExtendedLayout`, прозрачные бар-items и то, как родитель сам получает insets от своего parent/window scene.

---
### Q44
- **Question (EN):** Must-know UIKit lifecycle hooks?

- **Answer (EN):** `viewDidLoad` once; appear/disappear pairs per presentation cycle; layout hooks when frames matter; `deinit` is object lifetime, not visibility.

- **Устная заготовка (EN):** Setup once on load; refresh on appear; teardown risks on disappear.

- **Follow-up:** что обычно инициализировать в `viewDidLoad`, а что обновлять в `viewWillAppear`?

- **Follow-up answer:** в `viewDidLoad` — статическая иерархия и констрейнты; в `viewWillAppear` — то, что зависит от модели при каждом показе (обновление данных, аналитика экрана), без тяжёлой работы блокирующей переход.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** UIKit view controller lifecycle: какие методы must-know (обязательные)?

- **Answer (RU):** Зацепка: **`viewDidLoad` — один раз** настроить UI; **appear/disappear — каждый показ и уход**; layout-хуки — когда важны финальные фреймы.

    `viewDidLoad` — один раз после загрузки view; пара появления `viewWillAppear`/`viewDidAppear`; пара ухода `viewWillDisappear`/`viewDidDisappear`; при необходимости layout-хуки. Не путать с `deinit` контроллера.

- **Устная заготовка (RU):** didLoad — каркас; willAppear — при каждом возврате на экран; disappear — убрать шум (таймеры).

</details>

- **Доп. информация:** из storyboard — ещё `awakeFromNib`/constructor калибровка.
### Q45
- **Question (EN):** `UIViewController` lifecycle: why split across phases; ordering; incomplete segue **A→B**?

- **Answer (EN):** Split setup (`viewDidLoad` once) vs layout vs per-appearance (`will`/`did` appear) vs teardown on disappear. Cancelled transitions can deliver asymmetric `will`/`did` pairs—avoid irreversible work only in `didDisappear`/`didAppear` when transitions are interactive/cancellable.

- **Устный канон (опросник п.12 / H12, drill):** «Разные хуки — разные этапы: **`loadView`** (если кодом) → **`viewDidLoad`** один раз → **layout** → **`will/did` appear** каждый показ → **`will/did` disappear**. Отмена перехода — **`will` без `did`**, не доверять `did` для одноразовых необратимых действий.»


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** `UIViewController` lifecycle (Habr **H12**): зачем **разные методы на разные этапы**; порядок; что если **segue A→B** не завершили?

- **Answer (RU):** Зацепка: **разделение ответственности** — «создать/собрать UI» ≠ «финальный лейаут» ≠ «видимость на экране» ≠ «уход с экрана».

    **Порядок (типично):** при необходимости программной сборки корня — **`loadView`** (назначить `view`; из storyboard чаще не трогают). Первый доступ к `view` → **`viewDidLoad`** (**один раз** на экземпляр VC): каркас UI, биндинги; геометрия ещё может быть не финальной. Далее проходы лейаута — **`viewWillLayoutSubviews`** / **`viewDidLayoutSubviews`**. При показе на экране — **`viewWillAppear`** / **`viewDidAppear`** (**каждый раз** при возврате на экран). При уходе — **`viewWillDisappear`** / **`viewDidDisappear`**.

    **Segue A→B не завершён** (отменили интерактивный pop, смахнули модалку и т.п.): возможна ситуация **`will…` без пары `did…`** (например, у **A** был **`viewWillDisappear`**, но **`viewDidDisappear`** не наступил; у **B** — **`viewWillAppear`** без **`viewDidAppear`**). Нельзя опираться на «необратимые» side effects только в `did…`, если переход может **отмениться**; критичное — по завершённому переходу / `transitionCoordinator` при необходимости.

- **Follow-up (RU):** что класть в `viewWillAppear` vs `viewDidLoad`?

- **Follow-up answer (RU):** в **`viewDidLoad`** — статическая иерархия и то, что не зависит от «каждого показа»; в **`viewWillAppear`** — обновление при каждом возврате (данные, аналитика экрана), без тяжёлой блокировки анимации перехода.

</details>

- **Доп. информация:** [Habr H12](https://habr.com/en/articles/726388/); [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.12; см. также **Q44** (must-know хуки) в этом файле.


<!-- knowledge-cards-canonical:end -->
