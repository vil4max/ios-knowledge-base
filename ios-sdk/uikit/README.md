# UIKit

## In 30 seconds


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

## 🎯 Focus vs Defer


<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- `UIView` vs `UIViewController` vs `UIWindow` lifecycle (`viewDidLoad`, `viewWillAppear`, `viewIsAppearing`).
  - **Answer:**  
    - `UIView` отвечает за отображение/лейаут/обработку касаний.  
    - `UIViewController` управляет жизненным циклом экрана и связывает view с данными/навигацией.  
    - `UIWindow` — корень, который принимает события и держит root VC.  
    Практика: тяжелые инициализации — в `viewDidLoad`, обновление UI перед показом — `viewWillAppear`, анимации/аналитика “после показа” — `viewDidAppear`.  
    Docs: `https://developer.apple.com/documentation/uikit/uiviewcontroller`


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- Responder chain, hit-testing.
<details class="lang-ru">
<summary>По-русски</summary>

  - **Answer:** responder chain — цепочка, по которой событие “поднимается” (view → superview → VC → window → app). Hit-testing определяет, какая view получит touch. Понимание этого снимает “магические” баги жестов/тачей.  
    Docs: `https://developer.apple.com/documentation/uikit/uiresponder`

</details>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- Layer vs View, `setNeedsLayout` vs `layoutIfNeeded`.
<details class="lang-ru">
<summary>По-русски</summary>

  - **Answer:** `UIView` — объект UIKit с поведением и иерархией; `CALayer` — низкоуровневый рендер-слой (анимации/композиция). `setNeedsLayout` помечает layout как устаревший (выполнится позже), `layoutIfNeeded` принудительно запускает layout сейчас (часто нужно перед анимацией).  
    Docs: `https://developer.apple.com/documentation/uikit/uiview`

</details>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- Адаптивность: trait collections, Dynamic Type, Dark Mode.
<details class="lang-ru">
<summary>По-русски</summary>

  - **Answer:** `UITraitCollection` меняется на лету (size class, interface style, content size category). Корректный UI реагирует на изменения traits и поддерживает Dynamic Type и dark mode без перезапуска приложения.  
    Docs: `https://developer.apple.com/documentation/uikit/uitraitcollection`

</details>


</details>


</details>


</details>

### Defer

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- Storyboards/XIB: уметь читать, но в новых проектах часто programmatic UI.

</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- Низкоуровневый tab bar customization, если хватает `UITabBarController`.


</details>


</details>


</details>

## 📚 What to learn by level


### TRAINEE

<details class="lang-ru">
<summary>По-русски</summary>

- Что такое `UIView`/`UIViewController`, кнопка и обработка тапа.

</details>

### JUNIOR

<details class="lang-ru">
<summary>По-русски</summary>

- Lifecycle: `viewDidLoad`, `viewWillAppear`, `viewIsAppearing`.
- `UIScrollView`, `UITableView`, базовый `UICollectionView`.
- Programmatic UI для одного экрана.
- Dark Mode + Dynamic Type.

</details>

### MIDDLE

<details class="lang-ru">
<summary>По-русски</summary>

- Hit-testing/responder chain, кастомные жесты.

</details>
- Custom transitions (`UIViewControllerAnimatedTransitioning`).
- Adaptive layout: trait collections, size classes.

### SENIOR

<details class="lang-ru">
<summary>По-русски</summary>

- UIKit + SwiftUI гибрид (`UIHostingController`) с динамическим sizing.
- Миграция legacy MVC в современную архитектуру без переписывания всего.
- Профилирование скролла (60–120fps), async image decoding.

</details>

### TECH LEAD

<details class="lang-ru">
<summary>По-русски</summary>

- Стратегия UIKit ↔ SwiftUI: где что использовать.
- Дизайн-система поверх UIKit (компоненты + токены).

</details>

## 📚 Key terms (question → answer)


<details class="lang-ru">
<summary>По-русски</summary>

- Responder chain
  - **Answer:** цепочка объектов, которые могут обработать событие: view → superview → view controller → window → application. Помогает дебажить тапы/жесты/`sendAction`.  
    Docs: `https://developer.apple.com/documentation/uikit/uiresponder`

- Hit-testing
  - **Answer:** поиск view под точкой касания (`hitTest(_:with:)`, `point(inside:with:)`). Переопределение позволяет делать “прозрачные” зоны или перенаправлять тач.  
    Docs: `https://developer.apple.com/documentation/uikit/uiview/1622469-hittest`

- `setNeedsLayout`
  - **Answer:** помечает layout как устаревший; реальный `layoutSubviews` выполнится позже в цикле runloop.  
    Docs: `https://developer.apple.com/documentation/uikit/uiview`

- Trait collection
  - **Answer:** контекст окружения (size class, dark mode, content size category, accessibility). Может меняться без перезапуска, UI обязан реагировать.  
    Docs: `https://developer.apple.com/documentation/uikit/uitraitcollection`

</details>

## 🏋️ Exercises (10)


<details class="lang-ru">
<summary>По-русски</summary>

Ниже — практические задания в формате “что сделать и что проверить”.

</details>
1) Lifecycle trace  
<details class="lang-ru">
<summary>По-русски</summary>

Сделайте экран с логированием `viewDidLoad`, `viewWillAppear`, `viewDidAppear`, `viewWillDisappear`, `viewDidDisappear`.  
Проверка: объяснить порядок вызовов при push/pop и modal present/dismiss.

</details>
2) Responder chain  
<details class="lang-ru">
<summary>По-русски</summary>

Переопределите `next`/обработку действия и проследите путь события от кнопки до VC.  
Проверка: объяснить, почему action пришёл именно туда.

</details>
3) Hit-testing  
<details class="lang-ru">
<summary>По-русски</summary>

Сделайте overlay-view, которая визуально сверху, но пропускает тапы на нижний контрол.  
Проверка: корректная работа `point(inside:with:)` или `hitTest(_:with:)`.

</details>
4) setNeedsLayout vs layoutIfNeeded  
<details class="lang-ru">
<summary>По-русски</summary>

Соберите пример, где изменение constraints сначала “не видно”, а после `layoutIfNeeded` видно сразу.  
Проверка: понимать deferred vs immediate layout pass.

</details>
5) Trait changes  
<details class="lang-ru">
<summary>По-русски</summary>

Добавьте реакцию на смену `traitCollection` (dark/light, content size category).  
Проверка: UI корректно перестраивается без перезапуска.

</details>
6) Gesture conflicts  
<details class="lang-ru">
<summary>По-русски</summary>

На одном экране объедините `UIPanGestureRecognizer` и `UIScrollView`.  
Проверка: настроить приоритеты/совместимость (`gestureRecognizer(_:shouldRecognizeSimultaneouslyWith:)`).

</details>
7) Custom transition  
<details class="lang-ru">
<summary>По-русски</summary>

Реализуйте простую кастомную анимацию push/present через `UIViewControllerAnimatedTransitioning`.  
Проверка: корректный интерактивный и неинтерактивный сценарий.

</details>
8) Collection performance  
<details class="lang-ru">
<summary>По-русски</summary>

Соберите `UICollectionView` с diffable data source + prefetch.  
Проверка: плавный скролл без просадок при обновлении данных.

</details>
9) UIKit + SwiftUI bridge  
<details class="lang-ru">
<summary>По-русски</summary>

Встроить SwiftUI-вью через `UIHostingController` в UIKit-экран и обратно (`UIViewRepresentable`).  
Проверка: корректные размеры и lifecycle-интеграция.

</details>
10) Scene-based migration  
<details class="lang-ru">
<summary>По-русски</summary>

Смоделировать переход с AppDelegate-only на scene-based конфигурацию.  
Проверка: приложение корректно обрабатывает `UISceneSession` и жизненный цикл окна.

</details>

---

## Interview Q&A (Knowledge cards)


Interview Q&A below.

<!-- knowledge-cards-canonical:start -->

### Q21
- **Question (EN):** Lifecycle order for first VC appearance?

<details class="lang-ru">
<summary>По-русски</summary>

- **Вводные данные:** вопрос про первый показ экрана — цепочка «появился». Ты перечислил почти все имена, но важно не смешать её с уходом с экрана: после **layout** (**layout pass**) идёт именно `viewDidAppear` (уже показали), а `viewWillDisappear` / `viewDidDisappear` — когда экран уходит. **`deinit`** у контроллера — ещё позже, при **deallocation** (деаллокации; не обязательно сразу после **`viewDidDisappear`**).

</details>
- **Answer (EN):** First show: `loadView` (when programmatic) → `viewDidLoad` → `viewWillAppear` → layout pass (`willLayout` / `layoutSubviews` / `didLayout`) → `viewDidAppear`. Teardown is `willDisappear` → `didDisappear`; `deinit` is deallocation timing—not the same milestone as appearance.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (EN):**

</details>
</details>
</details>
    1. First appearance: loadView → viewDidLoad → viewWillAppear → layout pass → viewDidAppear.
    2. Leaving: viewWillDisappear → viewDidDisappear.
    3. `deinit` is separate—deallocation, not “last appearance hook”.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Итог одной фразой (EN):** First show ends at `viewDidAppear` after layout pass; `viewDidDisappear`/`deinit` are teardown/deallocation.

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up:** когда `viewWillAppear` может быть без `viewDidAppear`?

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer:** если переход оборвали до конца (отмена интерактивного pop, контейнер снял VC, координатор transition отменил анимацию) — пара appear/disappear может не завершиться «полным» циклом; тогда `viewWillAppear` мог быть без последующего `viewDidAppear` для этого показа.

</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** порядок **lifecycle** (жизненный цикл) первого показа VC?

- **Answer (RU):** первый показ (упрощённо): **`loadView`** (если **`view`** создаёшь кодом; при **storyboard** / **xib** цепочка может начинаться с уже готового **`view`**) → **`viewDidLoad`** (**`view`** загружен один раз) → **`viewWillAppear`** (скоро на экране) → **layout pass** (`viewWillLayoutSubviews` → **`layoutSubviews`** / **constraint pass** → `viewDidLayoutSubviews`) → **`viewDidAppear`** (уже на экране).

    Полный «оборот» экрана отдельно: при уходе — **`viewWillDisappear`** → **`viewDidDisappear`**; память — **`deinit`**, когда объект действительно **deallocated** (освобождён).

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (RU):**

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

    1. Первый показ: `loadView` → `viewDidLoad` → `viewWillAppear` → layout pass → `viewDidAppear`.
    2. Уход: `viewWillDisappear` → `viewDidDisappear`.
    3. `deinit` — deallocation контроллера; не путать с `viewDidDisappear`.

</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Итог одной фразой (RU):** первый показ: до `viewDidAppear` через load → didLoad → willAppear → layout pass; уход (`viewDidDisappear`) и `deinit` — другая фаза.

</details>
</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Доп. информация:** связать с `isMovingToParent` / `isBeingPresented`; обрывы — `interactivePopGesture`, `willMove(toParent:)` до завершения transition, `UIViewControllerTransitionCoordinator` cancellation.

</details>

### Q22
- **Question (EN):** `setNeedsLayout` vs `layoutIfNeeded`?

- **Answer (EN):** `setNeedsLayout` marks the view dirty and schedules a future layout pass. `layoutIfNeeded` lays out immediately if needed—synchronous flush of pending layout on that subtree.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (EN):**

</details>
</details>
</details>
    1. `setNeedsLayout` schedules layout.
    2. `layoutIfNeeded` forces layout now if dirty.
    3. Drawing is `setNeedsDisplay`, not layout.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Итог одной фразой (EN):** Schedule vs synchronous layout flush.

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up:** как применять в constraint animation (анимации constraints)?

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer:** меняешь constraints / constants, затем внутри блока анимации вызываешь `layoutIfNeeded` на нужном контейнере (ветке иерархии) — начальный и конечный кадры layout попадают в анимацию; один только `setNeedsLayout` без forced layout pass может не дать нужный синхронный эффект к началу анимации.

</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** `setNeedsLayout` vs `layoutIfNeeded`?

- **Answer (RU):** `setNeedsLayout` — пометить иерархию как layout dirty (нужен будущий layout pass), запланировать layout pass позже, когда run loop доходит до фазы layout / обновления geometry (геометрии); не обязательно сразу пересчитывает constraints.

    `layoutIfNeeded` — если эта ветка layout dirty, синхронно выполнить layout pass; если пометки не было, делать почти нечего.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (RU):**

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

    1. `setNeedsLayout` — помечает layout dirty, отложенный layout pass.
    2. `layoutIfNeeded` — если layout dirty, синхронно выполнить layout pass.
    3. Не путать с `setNeedsDisplay` — это drawing.

</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Итог одной фразой (RU):** `setNeedsLayout` — в очередь на layout pass; `layoutIfNeeded` — синхронный layout pass сейчас.

</details>
</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Доп. информация:** вызывать `layoutIfNeeded` на том контейнере, чьи subviews реально едут; не злоупотреблять на всём окне без нужды.

</details>

### Q24
- **Question (EN):** `frame` vs `bounds`?

- **Answer (EN):** `frame` is in the superview’s space; `bounds` is the view’s own coordinate space.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (EN):**

</details>
</details>
</details>
    1. `frame` — position and size in the `superview`’s coordinate space.
    2. `bounds` — the `view`’s own local coordinate space.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up:** как `bounds.origin` связан с scroll behavior (поведением скролла)?

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer:** у `UIScrollView` при скролле двигают `contentOffset`, что эквивалентно смене `bounds.origin`: смещается видимое «окно» по `contentSize`, а `frame` (положение скролла в `superview`) часто не меняется. Для обычного `UIView` `bounds.origin` чаще `(0, 0)`, пока явно не задают иное.

</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** `frame` vs `bounds`?

- **Answer (RU):** `frame` — geometry (геометрия) в координатном пространстве `superview`; `bounds` — локальная система координат `view`.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (RU):**

</details>
</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

    1. `frame` — в координатах `superview` (позиция и размер «как нас видят снаружи»).
    2. `bounds` — свои локальные координаты (разметка и `draw` внутри `view`).


- **Доп. информация:** `transform` меняет `frame`, но не `bounds`; при обсуждении hit-testing иногда уводят в `convert(_:to:)` / `hitTest(_:with:)` — смежная тема к двум системам координат.

</details>

### Q26
- **Question (EN):** Why know the responder chain?

- **Answer (EN):** It routes events and actions from the UIKit layer along linked `UIResponder` instances until someone handles them.

    Responders form a chain via `next` (roughly view → view controller → window → application → app delegate). `UIView` subclasses `UIResponder`, but `UIResponder` is the shared base for every chain participant, not “the root of all UI” alone.

    Unhandled touches propagate `next`. `first responder` is who owns keyboard/text input. For `UIControl`, a nil `target` searches the action selector up the responder chain.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (EN):**

</details>
</details>
</details>
    1. Responder chain routes events/actions until handled.
    2. Linked `UIResponder` instances via `next`.
    3. `first responder` — keyboard-focused input.
    4. `UIControl` + nil `target` walks the chain for the selector.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up:** пример нестандартной маршрутизации event / action.

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer:** `UIControl` с `target == nil` — `action` бежит вверх по цепочке (типичный приём в nib / `UIStoryboard`). Кастомный `hitTest(_:with:)` / `point(inside:with:)` меняет, кто получает касание и кто может стать `first responder`. `becomeFirstResponder` / `resignFirstResponder` у кастомного поля ввода — явное управление фокусом. Перехват клавиш (`UIKeyCommand`) у `UIViewController` — событие обрабатывается на уровне контроллера, минуя конкретный `UIView`.

</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** зачем знать responder chain (цепочку responder)?

- **Answer (RU):** нужна для маршрутизации событий (events) и действий (actions) от UIKit-слоя к тому `UIResponder`, кто их примет или передаст дальше.

    Участники цепочки — объекты `UIResponder`, связанные через `next` (упрощённо вверх: `UIView` → `UIViewController` → `UIWindow` → `UIApplication` → делегат приложения). `UIView` наследует `UIResponder`, но базовый класс `UIResponder` — не «основа любого view», а общий предок всего, что входит в цепочку (в т.ч. контроллеры, окно, приложение).

    События (touch и др.), которые текущий объект не обработал, уходят по `next`, пока кто-то не обработает или цепочка не закончится. `first responder` — текущий получатель ввода с клавиатуры и части системных действий (`UITextField`, `UITextView` и т.п.). У `UIControl` при `target == nil` поиск обработчика `action` идёт вверх по responder chain.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (RU):**

</details>
</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

    1. Цепочка — маршрутизация events / actions от UI к получателю.
    2. Связь `UIResponder` через `next` вверх по иерархии.
    3. `first responder` — клавиатура / ввод текста.
    4. `UIControl`, `target == nil` — `action` ищется по цепочке.


- **Доп. информация:** target-action и цепочка — смежные механизмы; знание одного не отменяет второе. Для текста дополнительно `UITextInput` и уведомления клавиатуры.

</details>

### Q27
- **Question (EN):** `UIView` vs `CALayer`?

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (EN):**

</details>
</details>
</details>
    1. UIView wraps a backing CALayer.
    2. Views handle interaction/layout; layers handle rendering/compositing.
    3. Many animations ultimately animate layer properties.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up:** где layer-first подход даёт выигрыш?

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer:** когда нужно часто менять геометрию/путь без полной перерисовки всего `draw(_:)` view: `CAShapeLayer`, `CAGradientLayer`, группа слоёв с отдельными `contents`; тяжёлый кастомный `draw(_:)` проще заменить или дополнить слоями. Явные анимации через `CABasicAnimation` / keyframes на `layer` без лишних проходов layout. Осторожно: лишние подслои, маски и `cornerRadius` + `masksToBounds` могут давать offscreen passes — тема производительности рядом с этим ответом.

</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** `UIView` vs `CALayer`?

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (RU):**

</details>
</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

    1. View — API над backing `layer`.
    2. View — touch, responder, layout; layer — рисование и compositing.
    3. Анимации часто бьют в `layer` (`transform`, `opacity`).


- **Доп. информация:** анимации `UIView` часто проксируют в `layer` (`position`, `transform`); `draw(_:)` vs `CALayerDelegate` / `CAShapeLayer` — когда дорого перерисовывать всё view. `cornerRadius` + `masksToBounds` — классический разговор про offscreen passes рядом с этим вопросом.

</details>

### Q28
- **Question (EN):** Safe area and child view controllers?

- **Answer (EN):** Safe area is the layout region avoiding system chrome (notch, status bar, home indicator, rounded corners)—exposed as `safeAreaInsets` / `safeAreaLayoutGuide`, not just raw screen bounds.

    Embedded child view controllers inherit the container’s safe-area context; the parent can push insets with `additionalSafeAreaInsets`. Correct embedding (`addChild`, view setup, `didMove(toParent:)`, appearance transitions) keeps children aligned with the parent’s safe area.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (EN):**

</details>
</details>
</details>
    1. Safe area avoids system obstructions—insets/layout guide.
    2. Children inherit the parent’s safe-area story; watch `additionalSafeAreaInsets`.
    3. Embed with proper child lifecycle and appearance transitions.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up:** частая ошибка с `beginAppearanceTransition` / `endAppearanceTransition`.

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer:** вызывают только один конец пары, вызывают в неправильном порядке относительно `addChild`/`removeFromParent`, или забывают `endAppearanceTransition` при отмене transition — у ребёнка ломаются счётчики appearance (`isViewLoaded`/`view.window` и логика «на экране»), из‑за чего едут insets, подписки и анимации. Нужна симметрия begin/end и согласование с реальным добавлением/снятием view с иерархии.

</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** safe area (безопасная область) и child view controllers (дочерние контроллеры)?

- **Answer (RU):** safe area — область контента с учётом системных выступов (notch, статус-бар, home indicator, скругления), не «голые края экрана». На практике это `safeAreaInsets` и `safeAreaLayoutGuide` у корневого `view` контроллера.

    Встроенный child view controller живёт в иерархии родителя: дочерний VC должен получать согласованные safe area и корректный appearance lifecycle. Родитель может расширить «опасную» зону через `additionalSafeAreaInsets` (свои панели/бары) — это участвует в расчёте safe area у детей. При embed важны `addChild`, размещение `view`, `didMove(toParent:)` и парные appearance transitions.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (RU):**

</details>
</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

    1. Safe area — не край экрана, а зона без системных помех; `safeAreaInsets`.
    2. Child VC — учитывать safe area иерархии родителя; `additionalSafeAreaInsets` у родителя влияет на детей.
    3. Embed: `addChild` → layout → `didMove` + согласованные appearance callbacks.


- **Доп. информация:** при кастомных контейнерах проверять `edgesForExtendedLayout`, прозрачные бар-items и то, как родитель сам получает insets от своего parent/window scene.

</details>

---
### Q44
- **Question (EN):** Must-know UIKit lifecycle hooks?

- **Answer (EN):** `viewDidLoad` once; appear/disappear pairs per presentation cycle; layout hooks when frames matter; `deinit` is object lifetime, not visibility.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (EN):** Setup once on load; refresh on appear; teardown risks on disappear.

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up:** что обычно инициализировать в `viewDidLoad`, а что обновлять в `viewWillAppear`?

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer:** в `viewDidLoad` — статическая иерархия и констрейнты; в `viewWillAppear` — то, что зависит от модели при каждом показе (обновление данных, аналитика экрана), без тяжёлой работы блокирующей переход.

</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** UIKit view controller lifecycle: какие методы must-know (обязательные)?

- **Answer (RU):** Зацепка: **`viewDidLoad` — один раз** настроить UI; **appear/disappear — каждый показ и уход**; layout-хуки — когда важны финальные фреймы.

    `viewDidLoad` — один раз после загрузки view; пара появления `viewWillAppear`/`viewDidAppear`; пара ухода `viewWillDisappear`/`viewDidDisappear`; при необходимости layout-хуки. Не путать с `deinit` контроллера.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (RU):** didLoad — каркас; willAppear — при каждом возврате на экран; disappear — убрать шум (таймеры).

</details>
</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Доп. информация:** из storyboard — ещё `awakeFromNib`/constructor калибровка.

</details>

### Q45
- **Question (EN):** `UIViewController` lifecycle: why split across phases; ordering; incomplete segue **A→B**?

- **Answer (EN):** Split setup (`viewDidLoad` once) vs layout vs per-appearance (`will`/`did` appear) vs teardown on disappear. Cancelled transitions can deliver asymmetric `will`/`did` pairs—avoid irreversible work only in `didDisappear`/`didAppear` when transitions are interactive/cancellable.

<details class="lang-ru">
<summary>По-русски</summary>

- **Устный канон (опросник п.12 / H12, drill):** «Разные хуки — разные этапы: **`loadView`** (если кодом) → **`viewDidLoad`** один раз → **layout** → **`will/did` appear** каждый показ → **`will/did` disappear**. Отмена перехода — **`will` без `did`**, не доверять `did` для одноразовых необратимых действий.»

</details>
<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** `UIViewController` lifecycle (Habr **H12**): зачем **разные методы на разные этапы**; порядок; что если **segue A→B** не завершили?

- **Answer (RU):** Зацепка: **разделение ответственности** — «создать/собрать UI» ≠ «финальный лейаут» ≠ «видимость на экране» ≠ «уход с экрана».

    **Порядок (типично):** при необходимости программной сборки корня — **`loadView`** (назначить `view`; из storyboard чаще не трогают). Первый доступ к `view` → **`viewDidLoad`** (**один раз** на экземпляр VC): каркас UI, биндинги; геометрия ещё может быть не финальной. Далее проходы лейаута — **`viewWillLayoutSubviews`** / **`viewDidLayoutSubviews`**. При показе на экране — **`viewWillAppear`** / **`viewDidAppear`** (**каждый раз** при возврате на экран). При уходе — **`viewWillDisappear`** / **`viewDidDisappear`**.

    **Segue A→B не завершён** (отменили интерактивный pop, смахнули модалку и т.п.): возможна ситуация **`will…` без пары `did…`** (например, у **A** был **`viewWillDisappear`**, но **`viewDidDisappear`** не наступил; у **B** — **`viewWillAppear`** без **`viewDidAppear`**). Нельзя опираться на «необратимые» side effects только в `did…`, если переход может **отмениться**; критичное — по завершённому переходу / `transitionCoordinator` при необходимости.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up (RU):** что класть в `viewWillAppear` vs `viewDidLoad`?

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer (RU):** в **`viewDidLoad`** — статическая иерархия и то, что не зависит от «каждого показа»; в **`viewWillAppear`** — обновление при каждом возврате (данные, аналитика экрана), без тяжёлой блокировки анимации перехода.

</details>
</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Доп. информация:** [Habr H12](https://habr.com/en/articles/726388/); [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.12; см. также **Q44** (must-know хуки) в этом файле.

</details>
<!-- knowledge-cards-canonical:end -->
