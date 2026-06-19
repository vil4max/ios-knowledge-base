# Animations

## За 30 секунд

iOS animation spans **UIKit view animations**, **UIViewPropertyAnimator** (interruptible, scrubbable, gesture-driven), and **Core Animation** on **`CALayer`** (transform, opacity, `CAAnimation` family). **`withAnimation`** in SwiftUI drives state-driven implicit animations on view properties. **Spring** curves (UIKit `usingSpringWithDamping`, property animator `UISpringTimingParameters`, SwiftUI `.spring`) model natural motion with damping and velocity. **Interruptible** animations let user gestures take over mid-flight without visual jumps — property animators + `fractionComplete` are the UIKit tool. **`CADisplayLink`** fires aligned to display refresh (~60/120 Hz) for frame-synced updates — custom physics, progress scrubbing, or game loops; distinct from `Timer`. Senior interviews expect you to pick the layer (view vs layer vs SwiftUI), explain runloop timing, and avoid animating layout-heavy properties on the main thread without `layoutIfNeeded`.

## Apple docs

- [UIViewPropertyAnimator](https://developer.apple.com/documentation/uikit/uiviewpropertyanimator) — interruptible, pausable, custom timing.
- [Animating views and constraints](https://developer.apple.com/documentation/uikit/uiview/1622419-animate) — block-based `UIView.animate`.
- [Core Animation Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/Introduction/Introduction.html) — layer tree, implicit vs explicit animations.
- [CALayer](https://developer.apple.com/documentation/quartzcore/calayer) — transforms, opacity, masks, sublayers.
- [CABasicAnimation](https://developer.apple.com/documentation/quartzcore/cabasicanimation) — from/to key paths.
- [CAAnimationGroup](https://developer.apple.com/documentation/quartzcore/caanimationgroup) — synchronized animations.
- [CADisplayLink](https://developer.apple.com/documentation/quartzcore/cadisplaylink) — vsync-aligned callbacks.
- [withAnimation (SwiftUI)](https://developer.apple.com/documentation/swiftui/withanimation(_:_:)) — state-driven animation.
- [Animation (SwiftUI)](https://developer.apple.com/documentation/swiftui/animation) — spring, timing curves.
- [UIViewAnimating](https://developer.apple.com/documentation/uikit/uiviewanimating) — protocol for animators.

## 🎯 Focus vs Defer

### Focus

- **View vs layer:** UIKit block animates **presentation** on layer backing; some properties (`backgroundColor` on view) animate; layout changes need constraint + `layoutIfNeeded`.
- **Property animator lifecycle:** create → `startAnimation` / pause → `continueAnimation` with `CGFloat` velocity → `fractionComplete` for scrubbing → `isInterruptible`.
- **Springs:** damping ratio, response, initial velocity — match design system; avoid one magic duration for all motion.
- **Interruptible transitions:** interactive dismiss, drag-to-reveal — hand off from animator to gesture without resetting model state.
- **Core Animation explicit:** `CABasicAnimation` + `fillMode`, `isRemovedOnCompletion` — know model vs presentation layer split.
- **SwiftUI:** animation tied to **value change** in `withAnimation`; `.animation(_:value:)` on specific state; springs via `.spring(response:dampingFraction:)`.
- **CADisplayLink:** target-selector or block on common run loop mode; invalidate on teardown; prefer for frame-synced custom drawing.

### Defer

- **`CAKeyframeAnimation` path art** for standard UI — property animator or SwiftUI springs cover product motion.
- **Animating `frame` directly** in new Auto Layout code — animate constraints instead.
- **CADisplayLink for simple delays** — use `async`/`Task.sleep` or animators; display link is for per-frame work.
- **Implicit animation on every SwiftUI state** — over-specifying `.animation` causes unintended cascades; animate at the source.

## Ключевые понятия

| Term | Meaning |
|------|---------|
| **Model vs presentation layer** | During animation, `layer.presentation()` shows in-flight values; model layer jumps at end unless configured otherwise. |
| **Implicit animation** | Core Animation auto-animates animatable property changes inside `CATransaction`. |
| **Explicit animation** | `CAAnimation` attached to layer; does not change model until completion unless configured. |
| **UIViewPropertyAnimator** | Reference-type animator; supports pause, scrub, continuation, custom curves. |
| **Interruptible animation** | New animation replaces in-flight without snapping from stale presentation. |
| **Spring timing** | `UISpringTimingParameters(dampingRatio:initialVelocity:)` — physical feel. |
| **Display link** | Callback once per frame (or paused); `timestamp`, `duration` for delta time. |
| **withAnimation** | SwiftUI: wraps state mutations to animate resulting view changes. |
| **Animation curve** | easeInOut, linear, spring — maps time → progress. |
| **layoutIfNeeded in animate block** | Commits constraint layout changes over animation duration. |

### UIKit vs Core Animation vs SwiftUI

| Layer | Best for |
|-------|----------|
| `UIView.animate` | Simple property transitions, alpha, transform on views |
| `UIViewPropertyAnimator` | Interactive, pausable, gesture handoff, custom timing |
| `CALayer` / `CAAnimation` | Transform/opacity on layers, rotation, path morph, additive animations |
| SwiftUI `withAnimation` | Declarative UI state transitions, matched geometry effect |
| `CADisplayLink` | Per-frame simulation, custom progress, sync with refresh rate |

**Runloop note:** UIKit animations and display link callbacks run on the **main run loop**. Heavy work in `displayLink` callback drops frames — offload computation, keep callback thin.

### Interruptible animations (pattern)

1. Start `UIViewPropertyAnimator` for transition.
2. On pan gesture, `pauseAnimation()`, map translation to `fractionComplete`.
3. On release, `continueAnimation(withTimingParameters:durationFactor:)` toward finish or reverse.
4. SwiftUI: `.gesture` + `Animatable`/`Animation` or UIKit bridge for same UX.

## 🏋️ Exercises

1. **Constraint fade-slide:** Animate view alpha and vertical position via constraint constant + `layoutIfNeeded()` in `UIView.animate`. **Expected:** smooth motion without setting `frame` directly.

2. **Property animator scrub:** Build expand/collapse panel; pause animator and scrub with slider bound to `fractionComplete`. **Expected:** explain pause vs stop.

3. **Interactive spring:** Dismiss sheet with vertical pan; on release, continue animator with velocity from gesture. **Expected:** interruptible handoff vocabulary.

4. **Layer vs view:** Animate `transform.rotation` on `view.layer` with `CABasicAnimation`; compare to `UIView.animate` transform. **Expected:** presentation layer inspection in Instruments / debug.

5. **SwiftUI spring comparison:** Same toggle in SwiftUI with `.spring(response:0.4,dampingFraction:0.8)` and UIKit spring parameters; tune to match visually. **Expected:** cross-framework motion vocabulary.

6. **CADisplayLink clock:** Draw progress ring updated each display link tick; compute delta from `targetTimestamp`. **Expected:** invalidate link on dismiss; no retain cycle.

7. **Implicit animation trap:** Change `cornerRadius` on layer inside `UIView.performWithoutAnimation` vs without — observe difference. **Expected:** `CATransaction.setDisableActions(true)`.

8. **Hero transition sketch:** Two VCs, animate shared element with property animator + snapshot or `UIView.animate`. **Expected:** z-order, snapshot cleanup, cancellation.

## Ссылки

- [WWDC 2016 — Advanced UIViewPropertyAnimator](https://developer.apple.com/videos/play/wwdc2016/230/)
- [WWDC 2018 — Designing Fluid Interfaces](https://developer.apple.com/videos/play/wwdc2018/803/)
- [WWDC 2021 — Explore advanced animation in SwiftUI](https://developer.apple.com/videos/play/wwdc2021/10258/)
- [WWDC 2023 — Animate with springs](https://developer.apple.com/videos/play/wwdc2023/10158/)
- [Core Animation Essentials (archive)](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/CoreAnimationEssentials/CoreAnimationEssentials.html)

## Code patterns

### UIViewPropertyAnimator spring

```swift
let animator = UIViewPropertyAnimator(
    duration: 0,
    timingParameters: UISpringTimingParameters(damping: 0.8, response: 0.35)
)
animator.addAnimations {
    view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
}
animator.startAnimation()
```

### Constraint animation

```swift
UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut]) {
    constraint.constant = expanded ? 200 : 0
    view.layoutIfNeeded()
}
```

### CADisplayLink (block API)

```swift
displayLink = CADisplayLink(target: DisplayLinkTarget { [weak self] link in
    self?.tick(delta: link.targetTimestamp)
}, selector: #selector(DisplayLinkTarget.invoke))
displayLink?.add(to: .main, forMode: .common)
```

### SwiftUI spring

```swift
withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
    isExpanded.toggle()
}
```

---

## Карточки знаний (Q&A)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question (RU):** **`UIViewPropertyAnimator`** vs **`UIView.animate`** — когда property animator?
- **Question (EN):** UIViewPropertyAnimator vs UIView.animate — when property animator?
- **Answer (RU):** **`UIView.animate`** — простые one-shot transitions. **`UIViewPropertyAnimator`** — **pause/scrub** (`fractionComplete`), **продолжение с velocity**, **interruptible** handoff с gesture, кастомные **`UITimingCurveProvider`**. Interactive dismiss, drag-to-reveal, scrubbing progress — property animator; простой fade — block API достаточно.

- **Answer (EN):** Block API for simple transitions; property animators for pausing, scrubbing, spring continuation, and gesture-driven interruptible motion.

- **Устная заготовка (RU):** block — просто; property animator — pause, scrub, жест, spring continue.

- **Устная заготовка (EN):** Simple → animate; interactive → property animator.

- **Follow-up:** что такое `fractionComplete`?
- **Follow-up answer:** 0…1 прогресс анимации; можно выставить вручную при pause для scrubbing.

### Q2
- **Question (RU):** **Core Animation:** model layer vs **presentation layer** — зачем знать?
- **Question (EN):** Core Animation model vs presentation layer — why it matters?
- **Answer (RU):** Во время анимации **presentation** показывает промежуточные значения на экране; **model** может уже быть финальным. Hit-testing и reading `layer.position` без presentation дадут “прыжок”. **`isRemovedOnCompletion`**, **`fillMode`**, **`CATransaction.setDisableActions`** управляют implicit animation. Explicit `CABasicAnimation` не меняет model до completion, если так настроено.

- **Answer (EN):** Presentation layer shows in-flight values; model may already be final. Matters for hit-testing, sampling animated position, and implicit vs explicit animation control.

- **Устная заготовка (RU):** на экране presentation; model — истина после commit; hit-test осторожно mid-flight.

- **Устная заготовка (EN):** Presentation = on-screen; model = committed state; know both during animation.

- **Follow-up:** как отключить implicit animation?
- **Follow-up answer:** `UIView.performWithoutAnimation`, `CATransaction.setDisableActions(true)`.

### Q3
- **Question (RU):** **Spring animations** — damping, response, velocity в UIKit и SwiftUI?
- **Question (EN):** Spring animations — damping, response, velocity in UIKit and SwiftUI?
- **Answer (RU):** **UIKit:** `usingSpringWithDamping:initialSpringVelocity:` (legacy block) или **`UISpringTimingParameters`** / **`UICubicTimingParameters`** у property animator. **SwiftUI:** `.spring(response:dampingFraction:blendDuration:)` — response ≈ duration scale, dampingFraction 0…1 (1 = no oscillation). **Initial velocity** из gesture передаётся в `continueAnimation` / `UISpringTimingParameters(initialVelocity:)`. Один `duration: 0.3` linear на всё — анти-паттерн для natural UI.

- **Answer (EN):** UIKit springs via timing parameters on property animators; SwiftUI via `.spring(response:dampingFraction:)`. Feed gesture velocity on continuation for physical handoff.

- **Устная заготовка (RU):** spring = damping + response; velocity с жеста; не linear 0.3 везде.

- **Устная заготовка (EN):** Tune damping/response; pass gesture velocity; avoid one linear duration.

- **Follow-up:** interruptible spring — что ломается без property animator?
- **Follow-up answer:** новый block animate с zero delay может snap; нужен continue/scrub API.

### Q4
- **Question (RU):** **`CADisplayLink`** vs **`Timer`** vs **`withAnimation`** — когда display link?
- **Question (EN):** CADisplayLink vs Timer vs withAnimation — when display link?
- **Answer (RU):** **`withAnimation`** — декларативные изменения SwiftUI view state. **`Timer`** — периодические события, **не** привязаны к refresh (drift, jitter). **`CADisplayLink`** — **vsync-aligned**, один callback на кадр: custom physics, manual progress ring, game loop, sampling animation. Инвалидировать при deinit; тяжёлую работу не в callback. Для стандартного UI motion — animators/SwiftUI, не display link.

- **Answer (EN):** Display link for per-frame, vsync-synced work; timers for coarse periodic tasks; withAnimation for SwiftUI state transitions. Don't use display link for ordinary button fades.

- **Устная заготовка (RU):** display link = каждый кадр; timer — не vsync; SwiftUI — state animation.

- **Устная заготовка (EN):** Display link = frame sync; not a replacement for standard UI animators.

- **Follow-up:** main run loop mode `.common`?
- **Follow-up answer:** display link fires during tracking/UI interaction, not only default mode — важно для scrubbing во время scroll.

<!-- knowledge-cards-canonical:end -->
