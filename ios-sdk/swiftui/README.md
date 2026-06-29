# SwiftUI

## In 30 seconds

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

**Infographic:** [`assets/swiftui-components-overview.png`](assets/swiftui-components-overview.png) — five blocks: Layout, Navigation, Lists, Text/Media, Input.

| Area | Building blocks | Go deeper in this repo |
|------|-----------------|------------------------|
| **Layout & structure** | `VStack` / `HStack` / `ZStack`, `Spacer`, `Divider`, `ScrollView`, `ScrollViewReader`, `LazyVStack` / `LazyHStack` / `LazyVGrid` / `LazyHGrid`, `Grid` / `GridRow`, `Group`, `Section`, `Form`, `GeometryReader`, alignment guides | **Defer** below (`GeometryReader`, custom `Layout`); [Auto Layout](../auto-layout/README.md) |
| **Navigation & app structure** | `NavigationStack`, `NavigationSplitView`, `NavigationLink`, `navigationDestination`, `TabView`, `PageTabViewStyle`, `toolbar`, `searchable`, `refreshable` | [Navigation & Deep Links](../../architecture/navigation/README.md); Q9 (multilevel dismiss) |
| **Lists & collections** | `List`, `ForEach`, `OutlineGroup`, `swipeActions`, `listStyle`, row insets / separators | [List & dynamic data](notes/swiftui-list-dynamic-data.md); [Performance](../../quality/performance/README.md); Q11 (view identity) |

| **Input controls** | `Button`, `Link`, `Toggle`, `Slider`, `Stepper`, `Picker` (segmented / wheel / menu), `ColorPicker`, `DatePicker`, `TextField`, `SecureField`, `Menu`, `ContextMenu`, `ControlGroup`, `Label`, `GroupBox`, `DisclosureGroup` | Form + state — Q-cards **Observation** / `@Bindable` |

## 🎯 Focus vs Defer

### Focus

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

## Artifacts

- Notes: `notes/`
- Exercises: `exercises/`
- Assets: `assets/`
- Playgrounds: `playgrounds/`

### Recent notes

- `notes/timeline-view-swiftui.md` — `TimelineView`, schedules, `cadence`, vs `Timer`; playground [TimelineViewDemo.playground](TimelineViewDemo.playground)
- `notes/swiftui-data-loading-task.md` — `.task` vs `.onAppear`, `LoadState`, cooperative cancel, `.refreshable`
- `notes/swiftui-list-dynamic-data.md` — `List`, sections, swipe, edit mode, empty state, stable `id`
- `notes/migrating-to-observable-without-breaking-your-app.md`
- `notes/swiftui-toast-in-5-steps.md`
- `notes/creating-maps-in-swiftui-with-mapkit.md`
- `notes/codakuma-floating-safe-area-bar.md` — [floating safeAreaBar](https://codakuma.com/floating-safe-area-bar/), playground [FloatingSafeAreaBar.playground](FloatingSafeAreaBar.playground)

---

## TL;DR

## Source

- Apple WWDC: [Go further with MapKit (WWDC25)](https://developer.apple.com/videos/play/wwdc2025/204/)
- Apple docs:
  - [GeoToolbox](https://developer.apple.com/documentation/GeoToolbox)
  - [MKGeocodingRequest](https://developer.apple.com/documentation/mapkit/mkgeocodingrequest)

## Why `Map` in SwiftUI

## Main building blocks

### 1) Map state

### 2) Map content

### 3) Search and geocoding

## What changed in the new API wave (WWDC 2025)

## Common SwiftUI Maps mistake

## Practical takeaways

## Mini checklist

---## TL;DR

## Source

- Apple docs: [Migrating from the ObservableObject protocol to the Observable macro](https://developer.apple.com/documentation/swiftui/migrating-from-the-observable-object-protocol-to-the-observable-macro)

## What `@Observable` is and why it matters

## Problems it actually solves

## Migration pitfalls

### 1) iOS below 17 support

### 2) Mixed architecture during transition

### 3) Mechanical migration without review

## Safe migration plan (step by step)

## Practical takeaways

## Mini checklist before merge

---## TL;DR

## Source

## Why toast when alert and sheet exist

## Basic toast architecture in SwiftUI

### 1) Notification model

### 2) Dedicated ToastView

### 3) ViewModifier or extension

### 4) Lifetime management

### 5) Animation and positioning

## What to watch in a real project

## Practical takeaways

## Mini checklist

---## Interview Q&A (Knowledge cards)

### Passing data back (unwind segue analogue)

---

### Observation framework (`@Observable`) — what and why

```swift
final class Counter: ObservableObject {
    @Published var value = 0
}
```

```swift
@Observable
final class Counter {
    var value = 0
}
```

```swift
struct CounterView: View {
    @State private var counter = Counter()

    var body: some View {
        Stepper("\(counter.value)", value: $counter.value)
    }
}

struct DetailView: View {
    @Bindable var counter: Counter   // provides `$counter.value` for bindings
    var body: some View {
        TextField("Value", value: $counter.value, format: .number)
    }
}
```

---

### Q-card: Observation (`@Observable`) vs `ObservableObject` + `@Published`

1. `@Observable` tracks per-property reads, not whole-object events.
2. `ObservableObject` + `@Published` invalidates every subscriber on any change.
3. Less boilerplate, fewer redundant updates; iOS 17+/Swift 5.9+.

---

### Q-card: Memory & ownership — ARC in SwiftUI

```mermaid
flowchart LR
    V["View (struct)"] --> W["Ownership wrapper"]
    W --> M["ViewModel / model (class)"]
    M --> ARC["ARC retain/release"]
    ARC --> D["deinit when no strong refs"]
```

|-------------|-------------------------|-----------------------------|

- **App-wide** shared state → `@Environment` / `@EnvironmentObject`

1. SwiftUI works with ARC; wrappers express ownership.
2. View-owned → `@State` / `@StateObject`.
3. Never instantiate VMs in `body`.
4. Bind async to view lifetime; break cycles with weak captures.

---

### Q-card: Data loading — `.task` vs `.onAppear`

1. `.onAppear` is lifecycle, not a data-loading API.
2. `.task` binds async work to view lifetime.
3. One `enum` state in the ViewModel.
4. Dedupe with guards/cache, not modifier choice alone.

**Notes:** [swiftui-data-loading-task.md](notes/swiftui-data-loading-task.md)

---

### Q-card: Time-driven UI — `TimelineView` vs `Timer`

1. Time-based *display* → `TimelineView`.
2. Time-based *work* → `Task` / `Timer`.
3. Branch on `cadence` for detail level.

**Notes:** [timeline-view-swiftui.md](notes/timeline-view-swiftui.md) · **Playground:** [TimelineViewDemo.playground](TimelineViewDemo.playground)

---

### Q9
- **Question:** Multilevel dismiss in SwiftUI—stacked sheets, fullScreenCover, navigation; state patterns and who dismisses which level?

- **Answer:** Presentations follow state. Use `Environment(\.dismiss)` **inside** presented content to pop a sheet or a navigation level; read it in the wrong scope and dismissal targets the wrong presentation (per Apple). Prefer a single `sheet(item:)` driven by an `Identifiable` enum rather than stacking multiple `sheet(isPresented:)`. Collapsing the whole stack = reset shared presentation state or clear `NavigationPath`.

- **Playground:** [open](swiftui_state_management.playground/Contents.swift)

---
### Q10
- **Question:** What is the `View` protocol—`Body`, `@ViewBuilder`?

- **Answer:** `View` describes a piece of UI via `body`; modifiers wrap the view. `Body` is the concrete tree type; `@ViewBuilder` builds conditional/multi-statement view DSL.

- **Playground:** [open](swiftui_state_management.playground/Contents.swift)

### Q11
- **Question:** Why is SwiftUI `View` typically a `struct`?

- **Answer:** A SwiftUI `View` is primarily a **lightweight value-typed description** of UI, not a long-lived widget instance. `body` can be re-evaluated frequently; real persistence lives in `@State`/environment/models (often classes). Structs match modifier chains (wrapping values), reduce accidental shared mutation of the description, and keep ARC/retain-cycle concerns centered in models/closures. Identity in the tree is handled separately (`id`, `ForEach` keys, structure), not by `===` on the struct description itself.

- **Playground:** [open](swiftui_state_management.playground/Contents.swift)

### Q12
- **Question:** Embedding UIKit in SwiftUI—`UIViewRepresentable` vs `UIViewControllerRepresentable`, lifecycle hooks, coordinator, state?

- **Answer:** Representables wrap UIKit views or view controllers into SwiftUI. Implement make/update/dismantle; use a `Coordinator` to bridge delegates/target-actions to SwiftUI state via bindings. Don’t fight SwiftUI for layout of the managed view—Apple documents UB if you set frame/bounds/center/transform yourself.

- **Playground:** [open](swiftui_state_management.playground/Contents.swift)

### Q13
- **Question:** SwiftUI vs UIKit tradeoffs in one interview pass?

- **Answer:** SwiftUI is declarative: lightweight `View` values (usually structs) describe UI; the runtime diff/updates the graph. UIKit is imperative: you mutate a persistent `UIView` hierarchy (reference semantics). SwiftUI trades boilerplate and speed of development for occasional complexity in state/diff debugging; UIKit trades verbosity for fine control. Models in SwiftUI are often still classes.

- **Playground:** [open](swiftui_state_management.playground/Contents.swift)

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

- **When:** Checkout bar, summary + Save, bottom CTA over ScrollView/List

- **Tags:** `swiftui`, `safe-area`, `ios-26`, `layout`, `pattern`

- **Playground:** [FloatingSafeAreaBar.playground](FloatingSafeAreaBar.playground)

- **Added:** 2026-06-19

---

## Resources
