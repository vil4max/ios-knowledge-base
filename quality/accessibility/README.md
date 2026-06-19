# Accessibility & Localization

## Apple docs

- [Accessibility for UIKit](https://developer.apple.com/documentation/uikit/accessibility-for-uikit) — labels, traits, notifications.
- [Accessibility for SwiftUI](https://developer.apple.com/documentation/swiftui/accessibility) — modifiers, `@AccessibilityFocusState`.
- [VoiceOver](https://developer.apple.com/accessibility/voiceover/) — user guide; rotor, gestures.
- [Supporting Dynamic Type](https://developer.apple.com/documentation/uikit/uifont/scaling_fonts_automatically) — text scaling, layout adaptation.
- [Localization](https://developer.apple.com/documentation/xcode/localization) — strings, locales, export/import.
- [String Catalogs](https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog) — `.xcstrings`, pluralization, variants.
- [Human Interface Guidelines — Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility)

## In 30 seconds

**Accessibility** makes UI usable with VoiceOver, Dynamic Type, Reduce Motion, and other settings—via **labels**, **traits**, **hints**, and logical **focus order**. SwiftUI: `.accessibilityLabel`, `.accessibilityAddTraits`, `accessibilityElement(children:)`; UIKit: `accessibilityLabel` / `accessibilityTraits`. **Localization** externalizes copy; **String Catalogs** (`.xcstrings`) centralize strings, plurals, and device variations with Xcode review tools. Test with Accessibility Inspector and VoiceOver on device—not only after release.

## 🎯 Focus vs Defer

### Focus

- **VoiceOver flow:** meaningful labels, grouping related elements, hide decorative images, custom actions.
- **Dynamic Type:** scalable fonts (`Font.body`, `UIFontMetrics`), multiline labels, layout that grows—not clipped.
- **Traits & hints:** button vs header vs link; hint only when label insufficient.
- **Localization:** `LocalizedStringKey`, String Catalogs, pseudo-localization pass, RTL sanity.
- **String Catalogs:** plural rules (`%lld items`), platform/device variants, export for translators.

### Defer

- Full WCAG audit checklist before basic VoiceOver pass on primary flows.
- Supporting every locale on day one—start with String Catalog pipeline + English base.
- Custom accessibility rotors until standard navigation fails UX review.
- Snapshot-testing every language before copy freeze process exists.

## Key concepts

| Term | Meaning |
|------|---------|
| **Accessibility label** | Short name VoiceOver speaks; replaces visible text if needed. |
| **Traits** | Role: button, header, selected, adjustable, etc. |
| **Hint** | Optional extra instruction; avoid redundancy with label. |
| **Accessibility element** | Group children (`children: .combine`/`.ignore`) for sane traversal. |
| **Dynamic Type** | User text size; requires flexible layouts and minimum touch targets (44pt). |
| **VoiceOver rotor** | Context actions (headings, links); custom rotors for complex views. |
| **String Catalog** | `.xcstrings` JSON in Xcode; pluralization and variant metadata. |
| **Pseudo-localization** | Long accents strings to expose truncation before translation. |

**SwiftUI vs UIKit**

- SwiftUI: prefer modifiers; use `@AccessibilityFocusState` for programmatic focus.
- UIKit: set on `UIView`/`UIAccessibilityElement`; post `UIAccessibilityLayoutChangedNotification` on screen changes.

**Localization pipeline**

```text
Developer adds key in String Catalog
  → Export XLIFF / translate
  → Import → test pseudo + RTL + long strings
  → VoiceOver in target language on critical paths
```

## 🏋️ Exercises

1. **Unlabeled icon button:** Fix toolbar icon-only button with label “Close” and `.isButton` trait. **Expected:** VoiceOver reads purpose, not “image”.
2. **Dynamic Type:** Screen with fixed-height label; switch to scalable font + `minimumScaleFactor` or multiline. **Expected:** largest accessibility size without clipping.
3. **Group fields:** Combine “Email” label + text field for VoiceOver as one element or logical order. **Expected:** rotor navigates label then field sensibly.
4. **String Catalog plural:** Key `items_count` with `%lld item(s)` plural rules. **Expected:** correct string for 1, 2, 5 in preview.
5. **Pseudo-localization:** Enable scheme double-length strings; find truncated button on checkout. **Expected:** layout fix before translators deliver.

## WWDC & resources

- [Build an accessible SwiftUI app (WWDC19)](https://developer.apple.com/videos/play/wwdc2019/238/)
- [Create accessible experiences for watchOS (WWDC20)](https://developer.apple.com/videos/play/wwdc2020/10120/) — focus/state patterns
- [What's new in SwiftUI accessibility (WWDC23)](https://developer.apple.com/videos/play/wwdc2023/10036/)
- [Discover String Catalogs (WWDC23)](https://developer.apple.com/videos/play/wwdc2023/10155/)

## Artifacts

- Notes: `notes/`
- Exercises: `exercises/`
- Assets: `assets/`
- Playgrounds: `playgrounds/`

---

## Interview Q&A (Knowledge cards)

### Q1
- **Question (RU):** Чем отличаются accessibility label, hint и trait?
- **Question (EN):** What is the difference between accessibility label, hint, and trait?
- **Answer (RU):** **Label** — что это (имя элемента). **Trait** — роль/состояние (кнопка, заголовок, selected). **Hint** — что произойдёт при действии; используй редко, если label неочевиден. Плохой паттерн: дублировать visible text в hint. Декоративные картинки — `accessibilityHidden(true)`.
- **Answer (EN):** Label names the element; traits describe role/state; hints explain action outcomes sparingly. Hide decorative elements from VoiceOver.

### Q2
- **Question (RU):** Как поддержать Dynamic Type без поломки layout?
- **Question (EN):** How do you support Dynamic Type without breaking layout?
- **Answer (RU):** Системные text styles / `UIFontMetrics`, multiline labels, **Auto Layout** или SwiftUI stacks с приоритетами, избегать фиксированных высот для текста. Проверять **largest content size** в Simulator и на device. Touch targets ≥ 44pt; при необходимости scroll. Snapshot только как дополнение — живой VoiceOver важнее.
- **Answer (EN):** Use scalable styles, flexible constraints, test at largest sizes, keep hit areas ≥44pt, allow scrolling when content grows.

### Q3
- **Question (RU):** String Catalog vs legacy `Localizable.strings`?
- **Question (EN):** String Catalog vs legacy `Localizable.strings`?
- **Answer (RU):** **String Catalog** (`.xcstrings`) — единый файл в Xcode: plurals, variants, comments для переводчиков, validation, sync с code. Legacy strings работают, но хуже для plural rules и review. Новые проекты — catalog-first; миграция постепенная через Xcode import.
- **Answer (EN):** String Catalogs centralize plurals, variants, and translator comments with Xcode tooling—preferred for new work over scattered `.strings` files.

### Q4
- **Question (RU):** Как тестировать accessibility в CI?
- **Question (EN):** How do you test accessibility in CI?
- **Answer (RU):** **Accessibility Inspector** audits (some rules automatable), UI tests asserting `accessibilityLabel`/identifiers on critical controls, snapshot of accessibility tree via `XCUIElement` attributes. VoiceOver — ручной/regression checklist на release. В SwiftUI проверять grouped elements не ломают focus order после рефакторинга.
- **Answer (EN):** Combine Inspector audits, XCUITest assertions on labels/identifiers, and manual VoiceOver passes on key flows; automate stable checks in CI, not full spoken UX.
