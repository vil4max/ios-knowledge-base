# Deep Links

## За 30 секунд


**Deep links** route users into a specific screen from outside the app: **Universal Links** (HTTPS, verified), **custom URL schemes** (`myapp://`), and **deferred deep links** (attribution after install). iOS validates Universal Links via **Associated Domains** (`apple-app-site-association`). Design covers routing layer, cold vs warm start, auth gates, and fallback when the app is not installed.


<details class="lang-ru">
<summary>По-русски</summary>

**Deep links** ведут на конкретный экран: **Universal Links**, custom URL schemes, deferred deep links. Cold start, state restoration, attribution.

</details>



## Apple docs

- [Supporting universal links in your app](https://developer.apple.com/documentation/xcode/supporting-universal-links-in-your-app) — Associated Domains, AASA file.
- [Allowing apps and websites to link to your content](https://developer.apple.com/documentation/xcode/allowing-apps-and-websites-to-link-to-your-content) — entitlements, paths.
- [UIApplicationDelegate continuation methods](https://developer.apple.com/documentation/uikit/uiapplicationdelegate) — `continue userActivity`, `open url`.
- [Scene-based lifecycle](https://developer.apple.com/documentation/uikit/app_and_environment/scenes) — `scene(_:openURLContexts:)`, `continue userActivity`.

## 🎯 Focus vs Defer

### Focus

- **Universal Links vs custom scheme:** HTTPS verified (no disambiguation sheet) vs easy but hijackable schemes.
- **AASA file:** `applinks` paths, team id + bundle id, CDN/hosting requirements.
- **Routing architecture:** single `DeepLinkRouter` / coordinator parses URL → route enum → auth check → navigate.
- **Cold start:** link arrives before UI ready — queue route until root ready.
- **Fallback:** web page or App Store when app missing; Smart App Banner optional.
- **Push + links:** notification `userInfo` shares same routing code path.

### Defer

- Full Branch/AppsFlyer SDK internals — mention as deferred attribution providers.
- Android App Links parity unless cross-platform interview.
- Every edge case of Facebook/Instagram in-app browsers — mention wrapped WebView limitations briefly.

## Ключевые понятия

| Mechanism | Pros | Cons |
|-----------|------|------|
| **Universal Link** | Secure, seamless open, SEO | AASA setup, CDN cache |
| **Custom URL scheme** | Simple, works everywhere | No ownership proof; conflicts |
| **Deferred deep link** | Post-install destination | Needs attribution SDK or fingerprinting |
| **Handoff / userActivity** | Continuity across devices | Narrow use cases |

**AASA essentials:** hosted at `https://domain/.well-known/apple-app-site-association` (no extension); JSON with `appIDs` and `paths` or `components`.

**Routing flow:**

```text
URL / NSUserActivity
    → parse path + query
    → DeepLinkRoute enum
    → if !authenticated → login then resume
    → Coordinator pushes/presents screen
```

**Common bugs:** duplicate handling (Scene + AppDelegate); opening Safari instead of app (missing AASA); fragment `#` not sent to app; query param encoding.

## 🏋️ Exercises

1. **Product page link** — `https://example.com/product/42` opens ProductDetail. *Expected:* AASA path `/product/*`, router extracts id, handles missing product.

2. **Auth gate** — Deep link to settings while logged out. *Expected:* store pending route, login, replay navigation.

3. **Cold start** — App killed; user taps Universal Link. *Expected:* queue in AppDelegate/Scene until tab bar ready.

4. **Custom scheme fallback** — Email uses `myapp://promo`. *Expected:* register scheme, document that Universal Link is preferred for production marketing.

5. **Notification parity** — Push tap and Universal Link share router. *Expected:* one `OpenRoute` type fed from both entry points.

## Ссылки

- [Universal Links](https://developer.apple.com/ios/universal-links/)
- [Associated Domains entitlement](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_associated-domains)
- Related: [push-notifications](../push-notifications/README.md), [mobile](../mobile/README.md)

## Карточки знаний (Q&A)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question (EN):** Universal Link vs custom URL scheme?

- **Answer (EN):** Universal Links use verified HTTPS and AASA for seamless, secure opening. Custom schemes are easy but not ownership-proof. Prefer Universal Links in production; schemes for dev or legacy.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Universal Link vs custom URL scheme?

- **Answer (RU):** **Universal Link** — HTTPS URL, Apple проверяет **AASA** и открывает app без лишнего диалога; безопаснее для marketing. **Custom scheme** (`app://`) — проще, но любой app может зарегистировать похожую схему; часто fallback или legacy. Production: Universal Links + scheme для dev/tests.

</details>
### Q2
- **Question (EN):** What are Associated Domains and AASA?

- **Answer (EN):** The `applinks:` entitlement links your app to a domain. Host the apple-app-site-association file listing app IDs and paths. Without a valid AASA, links stay in Safari.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Что такое Associated Domains и AASA?

- **Answer (RU):** Entitlement **`applinks:your.domain`** связывает app с доменом. На сервере файл **apple-app-site-association** перечисляет teamID.bundleID и **paths**, которые app может обрабатывать. Без корректного AASA ссылка откроется в Safari.

</details>
### Q3
- **Question (EN):** How do you explain deferred deep links?

- **Answer (EN):** User clicks a link before install; after first launch the app restores the intended destination via attribution (SDK or custom backend). Trade-offs include privacy, match accuracy, and vendor dependency.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Deferred deep link — как объяснить на интервью?

- **Answer (RU):** Пользователь кликает ссылку **до установки** → Store → первый запуск. **Deferred** attribution (Branch, Firebase Dynamic Links, custom) сохраняет intent и при первом open восстанавливает маршрут (promo, invite). Компромисс: privacy, accuracy, зависимость от SDK/сервера.

</details>
### Q4
- **Question (EN):** Where do you handle deep links with scenes / SwiftUI?

- **Answer (EN):** Use `onOpenURL`, `onContinueUserActivity`, or scene delegate methods — but route everything through one router/coordinator shared with push and shortcuts to avoid duplicate navigation.

<!-- knowledge-cards-canonical:end -->


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Где обрабатывать deep link в SwiftUI / scenes?

- **Answer (RU):** **Scene phase:** `onOpenURL`, `onContinueUserActivity`, или `scene(_:openURLContexts:)` / `continue userActivity`. Один **router** на все entry points (push, link, shortcut). Избегать двойной навигации — centralize в coordinator.

</details>
