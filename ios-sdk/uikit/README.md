# UIKit

## In 30 seconds

UIKit is the **imperative** iOS UI framework: **UIView** hierarchy, **UIViewController** lifecycle, **Auto Layout**, tables/collections, and touch handling via **responder chain**. Still essential for interviews, legacy codebases, and SwiftUI bridges. Know lifecycle callbacks, when layout runs, memory (retain cycles in closures), and adaptive traits (size class, Dynamic Type).

## Apple docs

- [UIKit](https://developer.apple.com/documentation/uikit) — views, view controllers, controls.
- [UIViewController](https://developer.apple.com/documentation/uikit/uiviewcontroller) — lifecycle, containment, transitions.
- [UIView](https://developer.apple.com/documentation/uikit/uiview) — layout, drawing, gestures.
- [UITableView](https://developer.apple.com/documentation/uikit/uitableview) / [UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview) — reuse, data source.
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines) — patterns and platform conventions.

## 🎯 Focus vs Defer

### Defer

## 📚 What to learn by level

### TRAINEE

### JUNIOR

### MIDDLE

- Custom transitions (`UIViewControllerAnimatedTransitioning`).
- Adaptive layout: trait collections, size classes.

### SENIOR

### TECH LEAD

## 📚 Key terms (question → answer)

## 🏋️ Exercises (10)

1) Lifecycle trace

2) Responder chain

3) Hit-testing

4) setNeedsLayout vs layoutIfNeeded

5) Trait changes

6) Gesture conflicts

7) Custom transition

8) Collection performance

9) UIKit + SwiftUI bridge

10) Scene-based migration

---

## Interview Q&A (Knowledge cards)

Interview Q&A below.

<!-- knowledge-cards-canonical:start -->

### Q21
- **Question:** Lifecycle order for first VC appearance?

- **Answer:** First show: `loadView` (when programmatic) → `viewDidLoad` → `viewWillAppear` → layout pass (`willLayout` / `layoutSubviews` / `didLayout`) → `viewDidAppear`. Teardown is `willDisappear` → `didDisappear`; `deinit` is deallocation timing—not the same milestone as appearance.

    1. First appearance: loadView → viewDidLoad → viewWillAppear → layout pass → viewDidAppear.
    2. Leaving: viewWillDisappear → viewDidDisappear.
    3. `deinit` is separate—deallocation, not “last appearance hook”.

### Q22
- **Question:** `setNeedsLayout` vs `layoutIfNeeded`?

- **Answer:** `setNeedsLayout` marks the view dirty and schedules a future layout pass. `layoutIfNeeded` lays out immediately if needed—synchronous flush of pending layout on that subtree.

    1. `setNeedsLayout` schedules layout.
    2. `layoutIfNeeded` forces layout now if dirty.
    3. Drawing is `setNeedsDisplay`, not layout.

### Q24
- **Question:** `frame` vs `bounds`?

- **Answer:** `frame` is in the superview’s space; `bounds` is the view’s own coordinate space.

    1. `frame` — position and size in the `superview`’s coordinate space.
    2. `bounds` — the `view`’s own local coordinate space.

### Q26
- **Question:** Why know the responder chain?

- **Answer:** It routes events and actions from the UIKit layer along linked `UIResponder` instances until someone handles them.

    Responders form a chain via `next` (roughly view → view controller → window → application → app delegate). `UIView` subclasses `UIResponder`, but `UIResponder` is the shared base for every chain participant, not “the root of all UI” alone.

    Unhandled touches propagate `next`. `first responder` is who owns keyboard/text input. For `UIControl`, a nil `target` searches the action selector up the responder chain.

    1. Responder chain routes events/actions until handled.
    2. Linked `UIResponder` instances via `next`.
    3. `first responder` — keyboard-focused input.
    4. `UIControl` + nil `target` walks the chain for the selector.

### Q27
- **Question:** `UIView` vs `CALayer`?

    1. UIView wraps a backing CALayer.
    2. Views handle interaction/layout; layers handle rendering/compositing.
    3. Many animations ultimately animate layer properties.

### Q28
- **Question:** Safe area and child view controllers?

- **Answer:** Safe area is the layout region avoiding system chrome (notch, status bar, home indicator, rounded corners)—exposed as `safeAreaInsets` / `safeAreaLayoutGuide`, not just raw screen bounds.

    Embedded child view controllers inherit the container’s safe-area context; the parent can push insets with `additionalSafeAreaInsets`. Correct embedding (`addChild`, view setup, `didMove(toParent:)`, appearance transitions) keeps children aligned with the parent’s safe area.

    1. Safe area avoids system obstructions—insets/layout guide.
    2. Children inherit the parent’s safe-area story; watch `additionalSafeAreaInsets`.
    3. Embed with proper child lifecycle and appearance transitions.

---
### Q44
- **Question:** Must-know UIKit lifecycle hooks?

- **Answer:** `viewDidLoad` once; appear/disappear pairs per presentation cycle; layout hooks when frames matter; `deinit` is object lifetime, not visibility.

### Q45
- **Question:** `UIViewController` lifecycle: why split across phases; ordering; incomplete segue **A→B**?

- **Answer:** Split setup (`viewDidLoad` once) vs layout vs per-appearance (`will`/`did` appear) vs teardown on disappear. Cancelled transitions can deliver asymmetric `will`/`did` pairs—avoid irreversible work only in `didDisappear`/`didAppear` when transitions are interactive/cancellable.

<!-- knowledge-cards-canonical:end -->
