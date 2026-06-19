# Auto Layout

## За 30 секунд

Auto Layout is a **constraint-based layout engine**: you declare relationships between views (edges, centers, sizes), and the solver computes frames for a given size. On iOS you express constraints with **NSLayoutConstraint** / **anchor API**, often grouped in **UIStackView**. Each view contributes an **intrinsic content size**; **content hugging** and **compression resistance** priorities resolve conflicts when space is tight. **Ambiguous** or **unsatisfiable** layouts produce warnings or crashes at runtime — senior interviews expect you to diagnose them with Xcode's constraint debugger. **UILayoutGuide** (safe area, layout margins, custom spacers) replaces “padding views.” In SwiftUI, the **`Layout`** protocol and built-in stacks solve a similar problem declaratively; UIKit remains the reference for understanding priorities, ambiguity, and UIKit ↔ SwiftUI sizing bridges.

## Apple docs

- [Auto Layout Guide](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/) — concepts, anatomy of a constraint, debugging.
- [NSLayoutConstraint](https://developer.apple.com/documentation/uikit/nslayoutconstraint) — programmatic constraints, priorities, identifiers.
- [UILayoutGuide](https://developer.apple.com/documentation/uikit/uilayoutguide) — safe area, margins, spacer guides without dummy views.
- [UIStackView](https://developer.apple.com/documentation/uikit/uistackview) — axis, distribution, alignment, arranged subviews.
- [UIView.layoutMarginsGuide](https://developer.apple.com/documentation/uikit/uiview/1622657-layoutmarginsguide) — readable margins independent of safe area.
- [UIView.safeAreaLayoutGuide](https://developer.apple.com/documentation/uikit/uiview/2891103-safearealayoutguide) — notches, home indicator, bars.
- [Intrinsic content size](https://developer.apple.com/documentation/uikit/uiview/1622600-intrinsiccontentsize) — natural size from content.
- [Updating constraints](https://developer.apple.com/documentation/uikit/uiview/1622513-updateconstraints) — `updateConstraints`, `needsUpdateConstraints`.
- [Layout protocol (SwiftUI)](https://developer.apple.com/documentation/swiftui/layout) — custom layout in SwiftUI.

## 🎯 Focus vs Defer

### Focus

- **Constraint model:** first attribute, second attribute, relation (`equal`, `greaterThanOrEqual`, `lessThanOrEqual`), multiplier, constant, **priority** (default 1000 = required).
- **Intrinsic size + priorities:** when label meets fixed width, hugging/compression decide whether text truncates or the container grows.
- **Stack views:** distribution (`.fill`, `.fillEqually`, `.fillProportionally`, `.equalSpacing`, `.equalCentering`) and alignment — know when stacks hide complexity vs when they fight nested scroll views.
- **Safe area vs layout margins:** pin content to `safeAreaLayoutGuide`; use `layoutMarginsGuide` for consistent inset from readable width.
- **Debugging:** “Unable to simultaneously satisfy constraints”, ambiguous layout, `_UILayoutGuide` in logs — read the conflict graph, add identifiers, use **Debug View Hierarchy**.
- **SwiftUI bridge:** `UIHostingController` sizing, `intrinsicContentSize`, `systemLayoutSizeFitting` — why SwiftUI-in-UIKit needs explicit height sometimes.

### Defer

- **Visual Format Language** for new code — prefer anchor API; still read VFL in legacy codebases.
- **Manual frame layout** everywhere — only for performance-critical hot paths or `CALayer`-only subtrees with measured trade-offs.
- **Third-party DSL wrappers** until the team standard is clear — understand native constraints first.
- **Every custom `Layout` in SwiftUI** — built-in `HStack`/`VStack`/`Grid` cover most product UI; custom layout for novel measurement (badges, flow rows).

## Ключевые понятия

| Term | Meaning |
|------|---------|
| **Constraint** | Linear equation linking two layout attributes (e.g. `viewA.leading = viewB.trailing + 16`). |
| **Layout attribute** | Edge, dimension, or center (`leading`, `width`, `centerX`, …). |
| **Priority** | Required (1000) vs optional (1–999); lower priority breaks first under pressure. |
| **Intrinsic content size** | Size a view “wants” from its content (`UILabel`, `UIImageView`, `UIStackView`). |
| **Content hugging** | Resistance to growing beyond intrinsic size (default 250). |
| **Compression resistance** | Resistance to shrinking below intrinsic size (default 750). |
| **Ambiguous layout** | Under-constrained — multiple valid solutions; Auto Layout picks one arbitrarily. |
| **Unsatisfiable layout** | Over-constrained — no solution; runtime breaks lowest-priority constraints or traps in debug. |
| **UILayoutGuide** | Non-drawing layout rectangle; safe area, margins, custom guides. |
| **UIStackView** | Manages arranged subviews along an axis; generates constraints internally. |
| **Layout pass** | `updateConstraints` → `layoutSubviews`; call `layoutIfNeeded()` before animating constraint changes. |

### UIKit vs SwiftUI Layout

| UIKit | SwiftUI analogue |
|-------|------------------|
| NSLayoutConstraint / anchors | `frame`, `padding`, stacks, `Spacer` |
| UIStackView | `HStack` / `VStack` |
| UILayoutGuide | `safeAreaInset`, `GeometryReader`, custom `Layout` |
| intrinsicContentSize | ideal size from `sizeThatFits` / `Layout` proposal |
| hugging / compression | less explicit; `fixedSize`, `layoutPriority`, `lineLimit` |
| `updateConstraints()` | view invalidation via state; body re-evaluation |

SwiftUI's **`Layout`** protocol (iOS 16+) is the closest analogue to writing a custom layout engine: you implement `sizeThatFits(proposal:subviews:cache:)` and `placeSubviews(in:proposal:subviews:cache:)`. UIKit's solver is global across the hierarchy; SwiftUI layout is **propose → measure → place** per container, which explains different debugging workflows.

### Typical interview traps

1. **Scroll view + stack:** pinning a vertical `UIStackView` to scroll view **edges** without also tying to **contentLayoutGuide** → zero or ambiguous height.
2. **Equal widths in stack:** `.fillEqually` on views with different intrinsic widths — understand distribution, not just “make them equal.”
3. **Animating constraints:** change constant, then `layoutIfNeeded()` inside `UIView.animate` — not `setNeedsLayout` alone.
4. **`translatesAutoresizingMaskIntoConstraints = false`** forgotten on programmatic views — conflicts with autoresizing mask constraints.

## 🏋️ Exercises

1. **Ambiguity lab:** Build a label centered horizontally with **no width constraint**. Run, open Debug View Hierarchy, explain the ambiguity warning. Fix with leading/trailing **or** width **or** superview width chain. **Expected:** can articulate under- vs over-constrained.

2. **Priority fight:** Two labels in an `HStack`-like row (UIKit: horizontal `UIStackView` or manual constraints) with both `compressionResistance = 1000`. Narrow the container; observe conflict log. Lower one label's resistance; confirm truncation behavior. **Expected:** hugging/compression in plain language.

3. **Safe area vs margins:** Full-bleed background pinned to superview edges; readable text pinned to `safeAreaLayoutGuide` and `layoutMarginsGuide`. Rotate, Dynamic Type, home indicator device. **Expected:** background edge-to-edge, text never under notch/home bar.

4. **Custom UILayoutGuide:** Replace a 16 pt “spacer view” with a `UILayoutGuide` between two buttons. **Expected:** no extra subview, same spacing, guide participates in constraints.

5. **Animate height:** Expand/collapse a panel by changing one height constraint constant inside `UIView.animate { layoutIfNeeded() }`. **Expected:** smooth animation tied to constraint solver, not frame hacks.

6. **SwiftUI Layout mini:** Implement a simple horizontal flow `Layout` that wraps subviews to the next row when width exceeds proposal. Compare mental model to `UIStackView` + nested stacks. **Expected:** propose/measure/place vs constraint equations.

7. **HostingController sizing:** Embed a SwiftUI view in `UIHostingController` inside a UITableView/UICollectionView cell. Make height correct with `systemLayoutSizeFitting` or self-sizing cell pattern. **Expected:** explain why intrinsic height is not automatic.

8. **Debug unsatisfiable:** Deliberately create conflicting required constraints; read Xcode's symbolic breakdown, add `identifier` to constraints, fix. **Expected:** methodical conflict resolution, not random constraint deletion.

## Ссылки

- [WWDC 2015 — Mysteries of Auto Layout, Part 1](https://developer.apple.com/videos/play/wwdc2015/218/)
- [WWDC 2015 — Mysteries of Auto Layout, Part 2](https://developer.apple.com/videos/play/wwdc2015/219/)
- [WWDC 2018 — High Performance Auto Layout](https://developer.apple.com/videos/play/wwdc2018/220/)
- [WWDC 2022 — Compose custom layouts with SwiftUI](https://developer.apple.com/videos/play/wwdc2022/10056/)
- [TN2154 — Auto Layout Guide (archive)](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/)

## Code patterns

### Anchors (modern UIKit)

```swift
label.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
    label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
    label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
])
```

### Scroll view + content guide

```swift
scrollView.translatesAutoresizingMaskIntoConstraints = false
contentView.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
    contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
    contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
    contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
    contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
])
```

### Constraint animation

```swift
heightConstraint.constant = isExpanded ? 200 : 0
UIView.animate(withDuration: 0.3) {
    view.layoutIfNeeded()
}
```

---

## Карточки знаний (Q&A)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question (RU):** Что такое **intrinsic content size** и как **content hugging** / **compression resistance** влияют на layout?
- **Question (EN):** What is intrinsic content size, and how do hugging and compression resistance affect layout?
- **Answer (RU):** **Intrinsic content size** — естественный размер view по контенту (`UILabel`, `UIImageView`, `UIStackView`). Когда места мало или много, движок не “угадывает” — **compression resistance** (сопротивление сжатию, default 750) и **content hugging** (не растягиваться, default 250) с **priority** решают, кто сожмётся, обрежется или растянется. На собесе: конфликт двух label с resistance 1000 в узком `HStack` → unsatisfiable или truncation после понижения priority.

- **Answer (EN):** Intrinsic content size is a view's natural size from its content. Hugging resists growing; compression resistance resists shrinking. Priorities break ties when space is tight — interview classic: two labels both demanding full width in a narrow row.

- **Устная заготовка (RU):** intrinsic — “хочу такой размер”; hugging — не растягивай; compression — не сжимай; priority решает спор.

- **Устная заготовка (EN):** Intrinsic = natural size; hugging vs compression + priorities resolve fights.

- **Follow-up:** что если intrinsic size `(UIView.noIntrinsicMetric, …)`?
- **Follow-up answer:** view не задаёт размер по одной оси — нужны явные constraints или размер от superview/stack.

- **Доп. информация:** [intrinsicContentSize](https://developer.apple.com/documentation/uikit/uiview/1622600-intrinsiccontentsize), [setContentHuggingPriority](https://developer.apple.com/documentation/uikit/uiview/1622480-setcontenthuggingpriority).

### Q2
- **Question (RU):** **Ambiguous** vs **unsatisfiable** constraints — в чём разница и как дебажить?
- **Question (EN):** Ambiguous vs unsatisfiable Auto Layout — difference and debugging?
- **Answer (RU):** **Ambiguous** — недоопределено, несколько решений; Auto Layout выберет одно, возможны “прыгающие” frame. **Unsatisfiable** — противоречие required constraints; в debug — trap/log, система ломает constraint с lowest priority. Дебаг: symbolic log, **identifiers** на constraints, Debug View Hierarchy, `_UILayoutGuide` в сообщениях. Типичная ошибка — scroll view без связи content height с subviews.

- **Answer (EN):** Ambiguous = under-constrained; unsatisfiable = impossible required set. Debug with conflict logs, constraint identifiers, and view hierarchy — scroll views missing contentLayoutGuide height are a classic.

- **Устная заготовка (RU):** ambiguous — мало уравнений; unsatisfiable — слишком много required; читай log, не удаляй constraints наугад.

- **Устная заготовка (EN):** Under vs over constrained; read the conflict graph; fix the root cause.

- **Follow-up:** зачем `identifier` на `NSLayoutConstraint`?
- **Follow-up answer:** в symbolic breakdown видно человекочитаемое имя вместо только адресов объектов.

### Q3
- **Question (RU):** Зачем **UILayoutGuide** и чем отличается от **safeAreaLayoutGuide** / **layoutMarginsGuide**?
- **Question (EN):** Why UILayoutGuide, and how does it differ from safe area and layout margins guides?
- **Answer (RU):** **UILayoutGuide** — прямоугольник для constraints **без subview** (spacer, колонка, выравнивание). **safeAreaLayoutGuide** — inset под notch, status bar, home indicator. **layoutMarginsGuide** — readable margins (можно `directionalLayoutMargins`, `preservesSuperviewLayoutMargins`). Раньше ставили invisible padding views — guides чище и дешевле.

- **Answer (EN):** Layout guides are non-rendering layout anchors. Safe area avoids system chrome; layout margins define readable inset. Prefer guides over dummy spacer views.

- **Устная заготовка (RU):** guide = layout-only rect; safe area — системные inset; margins — дизайн-система отступов.

- **Устная заготовка (EN):** Guides replace spacer views; safe area vs margins serve different inset purposes.

- **Follow-up:** когда custom guide вместо stack?
- **Follow-up answer:** выравнивание групп, процентная ширина колонки, привязка к “виртуальному” краю без лишних view в иерархии.

### Q4
- **Question (RU):** Auto Layout (UIKit) vs **`Layout`** protocol (SwiftUI) — что сравнивать на собесе?
- **Question (EN):** UIKit Auto Layout vs SwiftUI Layout protocol — what to compare in interviews?
- **Answer (RU):** UIKit — **глобальный constraint solver**, priorities, intrinsic size, imperative `layoutIfNeeded`. SwiftUI — **propose → measure → place** на контейнер, state-driven invalidation, `layoutPriority` реже explicit hugging. **`Layout`** — кастомный контейнер как свой mini-engine. Мост: `UIHostingController`, `UIViewRepresentable`, self-sizing cells — sizing часто ломается на границе. Senior: знать обе модели, не “SwiftUI заменил Auto Layout” буквально в гибриде.

- **Answer (EN):** UIKit = constraint solver with priorities; SwiftUI = per-container measurement protocol. Custom `Layout` mirrors writing a stack algorithm. Hybrid apps need explicit sizing at UIKit boundaries.

- **Устная заготовка (RU):** UIKit — уравнения и solver; SwiftUI — proposal и placeSubviews; на границе — явный размер.

- **Устная заготовка (EN):** Solver vs propose/measure/place; hybrid needs explicit bridge sizing.

- **Follow-up:** `setNeedsLayout` vs `layoutIfNeeded` перед анимацией?
- **Follow-up answer:** `layoutIfNeeded()` форсирует pass **сейчас** — нужно внутри animation block для constraint-driven motion.

<!-- knowledge-cards-canonical:end -->
