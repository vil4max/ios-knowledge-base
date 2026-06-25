# Analytics

## За 30 секунд


Mobile **analytics** turns product questions into an **event taxonomy**: what to measure, which properties attach to each event, how data batches and uploads respect battery, and how **privacy** (consent, ATT, minimal PII) shapes the pipeline. Senior answers link events to decisions, define session/user identity carefully, and know when **SKAdNetwork** replaces user-level attribution on iOS.


<details class="lang-ru">
<summary>По-русски</summary>

Мобильная **аналитика** — **таксономия событий**: что логировать, sampling, privacy, связь с remote config и A/B. Client schema vs server pipeline.

</details>



## Apple docs

- [App Tracking Transparency](https://developer.apple.com/documentation/apptrackingtransparency) — `ATTrackingManager`, permission before IDFA access.
- [SKAdNetwork](https://developer.apple.com/documentation/storekit/skadnetwork) — privacy-preserving ad attribution.
- [Privacy manifest](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files) — declared data collection (required reason APIs).
- [User privacy and data use](https://developer.apple.com/app-store/user-privacy-and-data-use/) — App Store privacy nutrition labels.

## 🎯 Focus vs Defer

### Focus

- **Event taxonomy:** names, required properties, naming convention (`snake_case` / `object_action`).
- **Identity:** anonymous id → logged-in id merge; device id not equal user id.
- **Session model:** foreground session, timeout, background gaps.
- **Batching & upload:** queue on disk, flush on timer/background/ size threshold.
- **Privacy:** no PII in free-text; hash where needed; regional consent (GDPR).
- **ATT impact:** IDFA unavailable unless authorized — use SKAdNetwork for ads.
- **Quality:** schema versioning, debug vs production endpoints, duplicate suppression.

### Defer

- Full data warehouse ETL design — stay client pipeline + contract with backend.
- Marketing mix modeling — mention as ATT-era alternative briefly.
- Every vendor SDK API (Amplitude, Firebase) — patterns over vendor specifics.

## Ключевые понятия

| Layer | Responsibility |
|-------|----------------|
| **Instrumentation** | Call sites in UI / use cases |
| **Client queue** | Persist events, backoff on failure |
| **Ingestion API** | Auth, rate limits, schema validation |
| **Identity graph** | Merge anon + account |
| **Dashboards** | Funnels, retention, experiments |

**Event shape example:**

```json
{
  "name": "checkout_completed",
  "timestamp": "2026-06-19T12:00:00Z",
  "user_id": "u_123",
  "session_id": "s_456",
  "properties": {
    "order_id": "o_789",
    "currency": "USD",
    "item_count": 3,
    "experiment_variant": "B"
  }
}
```

**ATT flow:** show pre-prompt if needed → `requestTrackingAuthorization` → if denied, no IDFA; rely on first-party ids + SKAdNetwork for ads.

**SKAdNetwork (overview):** ad network registers; post-install conversion postback to Apple → advertiser; coarse conversion values; no user-level cross-app tracking.

**Batching trade-offs:** frequent upload = fresh data + battery cost; batch 20–50 events or 30–60s idle; flush critical events (purchase) immediately.

## 🏋️ Exercises

1. **Define taxonomy for onboarding** — 5–8 events from app open to first success. *Expected:* `onboarding_started`, `step_viewed`, `step_completed`, `onboarding_completed` with `step_id`.

2. **ATT-aware attribution** — Campaign drives install; measure conversion without IDFA. *Expected:* SKAdNetwork + first-party deep link params for organic; no illegal fingerprinting.

3. **Offline events** — User completes action offline; upload later. *Expected:* disk queue, monotonic client sequence, idempotent server ingest.

4. **PII audit** — List forbidden properties in checkout events. *Expected:* no email, full card, raw address — use ids only.

5. **Experiment exposure** — Log flag assignment once per session. *Expected:* `experiment_exposure` with `variant`, tied to feature flag topic.

## Ссылки

- [App Tracking Transparency](https://developer.apple.com/documentation/apptrackingtransparency)
- [SKAdNetwork](https://developer.apple.com/documentation/storekit/skadnetwork)
- [Privacy manifest files](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files)
- Related: [feature-flags](../feature-flags/README.md), [mobile](../mobile/README.md)

## Карточки знаний (Q&A)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question (EN):** How do you design an event taxonomy?

- **Answer (EN):** Start from product questions. Use consistent names like `object_action`. Require timestamp, session id, and entity ids. Document schemas, version changes, one action per event.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Как спроектировать event taxonomy?

- **Answer (RU):** Начать с **product questions** (где отваливаются, что drives retention). Имена: **`object_action`** (`checkout_completed`). Обязательные поля: `timestamp`, `session_id`, ids сущностей. Документ schema; версионировать breaking changes; один event — одно действие, не god-event.

</details>
### Q2
- **Question (EN):** How do you batch analytics without draining battery?

- **Answer (EN):** Persist a disk queue; flush on size threshold, background transition, or timer — not constant polling. Send critical events immediately; backoff on network errors.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Batching на iOS — как не убить battery?

- **Answer (RU):** **Persist queue on disk**; flush по порогу (N events / KB) или при **background** / app backgrounding. Critical events — immediate. Exponential backoff при ошибках сети. Не wake каждые 5 секунд.

</details>
### Q3
- **Question (EN):** What changes for analytics after ATT?

- **Answer (EN):** IDFA requires authorization. Without it use first-party identifiers, aggregated metrics, and SKAdNetwork for ads. No fingerprinting to bypass ATT; disclose collection in privacy labels and manifests.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** ATT — что меняется для analytics?

- **Answer (RU):** **IDFA** доступен только после authorize. Без ATT — first-party ids (install id, account id), aggregated analytics, **SKAdNetwork** для ad attribution. Нельзя обходить ATT fingerprinting. Privacy Nutrition Label и privacy manifest должны отражать сбор.

</details>
### Q4
- **Question (EN):** Explain SKAdNetwork in two sentences.

- **Answer (EN):** Apple mediates install attribution from ad networks without cross-app user identifiers. Advertisers receive postbacks with campaign and coarse conversion values — useful for ads optimization, not user-level analytics.

<!-- knowledge-cards-canonical:end -->


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** SKAdNetwork в двух предложениях?

- **Answer (RU):** Apple посредничает **атрибуцию установок** от рекламных сетей без передачи user-level ID между app. Advertiser получает **postback** с campaign и coarse conversion value — достаточно для оптимизации ads, недостаточно для user-level analytics.

</details>
