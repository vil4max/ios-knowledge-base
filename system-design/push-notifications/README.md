# Push Notifications

## In 30 seconds


iOS push flows through **APNs**: your server sends to Apple, Apple delivers to device. The app registers for a **device token**, handles permission via **UNUserNotificationCenter**, and may use **Notification Service Extension** for rich media and **silent push** (`content-available`) to wake the app for background fetch — within strict budgets. Design covers token lifecycle, payload size limits, categories/actions, and never assuming guaranteed delivery.


<details class="lang-ru">
<summary>По-русски</summary>

Push через **APNs**: сервер → Apple → устройство. Payload, silent push, notification service extension, permission, delivery guarantees (нет 100%).

</details>

## Apple docs


- [User Notifications framework](https://developer.apple.com/documentation/usernotifications) — `UNUserNotificationCenter`, permissions, categories.
- [Registering your app with APNs](https://developer.apple.com/documentation/usernotifications/registering_your_app_with_apns) — device token, entitlements.
- [Sending notification requests to APNs](https://developer.apple.com/documentation/usernotifications/sending_notification_requests_to_apns) — server-side HTTP/2 API.
- [Modifying content in new notifications](https://developer.apple.com/documentation/usernotifications/modifying_content_in_newly_delivered_notifications) — Notification Service Extension.
- [Pushing background updates](https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/pushing_background_updates_to_your_app) — silent push constraints.

## 🎯 Focus vs Defer


### Focus

- **Permission UX:** when to ask, provisional vs full authorization.
- **Device token:** per app install, changes on reinstall/OS update — send to backend, handle invalidation.
- **Payload anatomy:** `aps` alert/badge/sound, custom data, size ~4 KB.
- **Silent push:** `content-available: 1`, no guaranteed delivery, budget, not for marketing.
- **NSE:** download attachments, decrypt, mutate content before display.
- **Deep link:** tap → `userInfo` → route coordinator.
- **Topics & collapse id:** replace stale notifications.

### Defer

- FCM as primary explanation unless backend is Firebase — still ends at APNs on iOS.
- VoIP push legacy patterns — mention PushKit only if prompt is call-related.
- Custom APNs certificate management minutiae unless ops-focused interview.

## Key concepts


| Term | Detail |
|------|--------|
| **APNs** | Apple Push Notification service — last mile to device |
| **Device token** | Opaque bytes; map user ↔ device on your server |
| **p8 / JWT auth** | Modern server auth to APNs (preferred over legacy certs) |
| **UNAuthorizationOptions** | badge, sound, alert, critical, provisional |
| **Foreground presentation** | `willPresent` — show banner while app active |
| **Notification Service Extension** | Mutate payload; ~30s wall time; memory limit |
| **Silent push** | Background wake for sync; throttled by system |
| **Category + UNNotificationAction** | Buttons, text input, deep actions |
| **Thread identifier** | Group notifications in UI |

**Architecture:**

```text
Backend → APNs (HTTP/2) → Device
                ↓
     UNUserNotificationCenter
                ↓
   App delegate / UNUserNotificationCenterDelegate
                ↓
        Routing / sync trigger
```

**Token lifecycle:** register on launch → send token + user id to backend → on `didFailToRegister` handle simulator/no entitlement → on token refresh update backend → on logout unlink token.

## 🏋️ Exercises


1. **Onboarding permission** — When to show pre-permission screen vs system dialog. *Expected:* value prop first; handle denied → settings deep link.

2. **Chat message push** — Payload design + collapse id for same thread. *Expected:* `thread-id`, minimal body, fetch message on tap/open.

3. **Silent sync** — New data on server; update badge without alert. *Expected:* `content-available`, background fetch delta, respect budget; fallback on next foreground.

4. **Rich image push** — URL in payload, NSE downloads image. *Expected:* Service Extension, failure fallback to text-only.

5. **Token rotation** — User reinstalls app. *Expected:* new token, invalidate old mapping, avoid duplicate devices per user.

## Links


- [User Notifications](https://developer.apple.com/documentation/usernotifications)
- [APNs overview](https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server)
- Related: [deep-links](../deep-links/README.md), [offline-first](../offline-first/README.md)

## Interview Q&A (Knowledge cards)


<!-- knowledge-cards-canonical:start -->

### Q1
- **Question (EN):** How does a push travel from server to UI?

- **Answer (EN):** Your server POSTs to APNs with the device token and payload. APNs delivers to the device. UNUserNotificationCenter presents the notification or wakes the app for silent pushes. The app handles taps via delegates and routes deep links, often fetching fresh data from your API.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Как устроен путь push от сервера до UI?

- **Answer (RU):** Backend шлёт HTTP/2 запрос в **APNs** с device token и payload. APNs доставляет на устройство. **UNUserNotificationCenter** показывает alert или будит app (silent). App обрабатывает tap через delegate / scene, маршрутизирует deep link и при необходимости тянет данные с API.

</details>

### Q2
- **Question (EN):** Silent push — what is allowed and what is not?

- **Answer (EN):** `content-available` wakes the app briefly for work like sync. Delivery is not guaranteed and the OS throttles usage. Do not use for ads or to bypass limits; enable the remote-notification background mode and keep work minimal.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Silent push — что можно и нельзя?

- **Answer (RU):** Payload с `content-available: 1` без alert — **background wake** для короткой работы (sync). Доставка **не guaranteed**, система **throttle** по battery/usage. Нельзя использовать для рекламы или обхода background limits; нужен `remote-notification` background mode и бережное использование.

</details>

### Q3
- **Question (EN):** Why use a Notification Service Extension?

- **Answer (EN):** Runs before display to download media, decrypt, or mutate content. Time- and memory-limited; on timeout the original payload shows. Use it because APNs payload size is small (~4 KB).


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Зачем Notification Service Extension?

- **Answer (RU):** Выполняется **до показа** уведомления: скачать медиа, расшифровать, изменить title/body. Ограничения по времени и памяти; при timeout — показ исходного payload. Нужен для rich notifications без огромного payload в APNs (лимит ~4 KB).

</details>

### Q4
- **Question (EN):** How should the backend manage device tokens?

- **Answer (EN):** Store userId ↔ token mappings; refresh on registration callbacks; remove on logout and when APNs reports invalid tokens. Users may have multiple tokens; tokens change — they are not stable device identifiers.

<!-- knowledge-cards-canonical:end -->


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Что делать с device token на backend?

- **Answer (RU):** Хранить связку **userId ↔ token ↔ app version**; обновлять при каждом `didRegister`; удалять при logout и при **410/invalid** от APNs. Один пользователь — несколько токенов (iPhone + iPad). Не использовать token как stable device id — он меняется.

</details>
