# Floating card using safeAreaBar (Codakuma)

- **Source:** https://codakuma.com/floating-safe-area-bar/
- **Author:** Codakuma
- **Migrated:** 2026-06-19
- **Status:** digest
- **Playground:** [FloatingSafeAreaBar.playground](../FloatingSafeAreaBar.playground)

---

## TL;DR

Bottom CTA card (summary + button) pinned above scrolling content. Start with `safeAreaInset`; add card chrome (padding, radius, shadow). On iOS 26 use `safeAreaBar` for scroll-edge blur; on iOS 18 fall back to `ultraThinMaterial` + gradient mask.

---

## Baseline — safeAreaInset

```swift
List(0..<100) { i in
    Text("Row \(i)")
}
.safeAreaInset(edge: .bottom) {
    VStack {
        Text("Some summary content")
        Button("Save") { }
            .buttonStyle(.borderedProminent)
    }
    .frame(maxWidth: .infinity)
    .padding()
    .background(.background)
}
```

---

## Floating card chrome

Add to inset content:

```swift
.cornerRadius(20)
.overlay(RoundedRectangle(cornerRadius: 20).stroke(.gray.opacity(0.25), lineWidth: 1))
.shadow(color: .black.opacity(0.1), radius: 5)
.padding()
```

Without scroll-edge treatment, card blends into list content.

---

## iOS 26 — safeAreaBar

`safeAreaBar` behaves like `safeAreaInset` but applies the scroll edge effect (content blurs under the bar).

Requires iOS 26+.

---

## iOS 18 fallback

Material background with gradient mask: top 30pt fade from clear → opaque, then solid under the bar. `.ignoresSafeArea()` on background extends under home indicator.

---

## Reusable API

`floatingSafeAreaBar { }` — `#available(iOS 26, *)` → `safeAreaBar`; else `safeAreaInset` + material fallback. `CardStyle` modifier for shared padding, radius, border, shadow.

When min OS is 26, remove fallback branch.

---

## Link to parent topic

- [SwiftUI README](../README.md)
- [FloatingSafeAreaBar.playground](../FloatingSafeAreaBar.playground)
