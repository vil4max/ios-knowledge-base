# Foundation & Lifecycle

## Topic structure

- `notes/` — Q&A + links to Apple docs
- `exercises/` — exercises with expected outcome

---

## 🎯 Focus vs Defer

### Defer

## 🏋️ Exercises (8) — expected outcomes

    Docs: `https://developer.apple.com/documentation/uikit/uiscene`

    Docs: `https://developer.apple.com/documentation/uikit/uiscenedelegate`

    Docs: `https://developer.apple.com/documentation/foundation/jsondecoder`

4) `FormatStyle`: 1234.5 -> `1 234,50 ₽`.

    Docs: `https://developer.apple.com/documentation/foundation/formatstyle`

    Docs: `https://developer.apple.com/documentation/foundation/calendar`

    Docs: `https://developer.apple.com/documentation/foundation/filemanager`

    Docs: `https://developer.apple.com/documentation/foundation/filemanager/1412643-containerurl`

8) Notification -> AsyncSequence: `UIApplication.didBecomeActiveNotification`.

    Docs: `https://developer.apple.com/documentation/foundation/notificationcenter/3767189-notifications`

---

## Interview Q&A (roadmap / drill)

<!-- knowledge-cards-canonical:start -->

### Q11
- **Question:** Application lifecycle: states and callbacks; why `UISceneDelegate` vs `UIApplicationDelegate`?

- **Answer:** `UIApplication.State` is only `.active`, `.inactive`, `.background`. Scene-based apps split process hooks (`UIApplicationDelegate`) from per-window session hooks (`UISceneDelegate`) so each `UIScene` can move independently.

- **Playground:** [open](09_foundation_app_lifecycle.playground/Contents.swift)

- **Notes:** [Foundation-App-Lifecycle-Scenes.md](Foundation-App-Lifecycle-Scenes.md)
### Q12
- **Question:** Junior interview “app states” narrative vs `UIApplication.State`?

- **Answer:** Interview “five states” includes not running and suspended; `UIApplication.State` only exposes `.active`, `.inactive`, `.background`. Per-UI session transitions belong with `UISceneDelegate` / `scenePhase`—see **Q11**.

- **Playground:** [open](09_foundation_app_lifecycle.playground/Contents.swift)

- **Notes:** [Foundation-App-Lifecycle-Scenes.md](Foundation-App-Lifecycle-Scenes.md)

<!-- knowledge-cards-canonical:end -->

---
