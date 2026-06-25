# Feature Flags

## За 30 секунд


**Feature flags** and **remote config** decouple release from exposure: ship code dark, enable per user/segment, run **gradual rollout**, and flip a **kill switch** without App Store delay. Client-side evaluation reads cached config at launch; server-side gates sensitive or paid features. Interview answers cover flag lifecycle, consistency, analytics linkage, and avoiding flag spaghetti.


<details class="lang-ru">
<summary>По-русски</summary>

**Feature flags** и **remote config** отделяют релиз от включения фичи. Kill switch, gradual rollout, type-safe resolver на клиенте.

</details>



## Материалы

- **Implementation (Swift):** [notes/swift-type-safe-resolver.md](notes/swift-type-safe-resolver.md) — type-safe resolver, priority sources, environment composition ([Livsy Code](https://livsycode.com/best-practices/a-feature-flags-system-in-swift/), [FeatureFlagsKit](https://github.com/Livsy90/FeatureFlagsKit))
- **Playground:** [feature_flags_resolver.playground](feature_flags_resolver.playground/Contents.swift) — runnable `Feature`, sources, `FeatureFlagsConfigurator`, override demo

## Apple docs

- No first-party feature-flag SDK — integrate Firebase Remote Config, LaunchDarkly, custom CDN JSON, or backend-driven config via your API.
- [BackgroundTasks](https://developer.apple.com/documentation/backgroundtasks) — optional periodic config refresh (not real-time guarantee).
- [App Store review guidelines](https://developer.apple.com/app-store/review/guidelines/) — hidden switches for review vs production must comply with guideline 2.3.1 (no undisclosed toggles for reviewers).

## 🎯 Focus vs Defer

### Focus

- **Remote config vs feature flag:** config values (thresholds, copy) vs on/off gates.
- **Kill switch:** disable broken feature instantly; graceful degradation UI.
- **Gradual rollout:** percentage, allowlist, geo, app version, platform.
- **Client evaluation:** cached snapshot, stale-while-revalidate, default safe values.
- **Targeting:** user id hash bucket for stable assignment.
- **Observability:** log exposure events for experiment analysis.
- **Cleanup:** remove dead flags to avoid combinatorial complexity.
- **Type-safe client layer:** `Feature` enum + priority sources + sync resolver — see [implementation note](notes/swift-type-safe-resolver.md).

### Defer

- Full experimentation statistics (Bayesian vs frequentist) unless data science round.
- Multi-layer flag inheritance across 50 teams — keep example scoped.
- Server-side rendering of flags for static sites — mobile focus stays client cache + API.

## Ключевые понятия

| Pattern | Use |
|---------|-----|
| **Boolean flag** | Feature on/off |
| **Multivariate config** | JSON parameters (timeout, variant id) |
| **Allowlist** | Internal/beta users |
| **Percentage rollout** | `hash(userId) % 100 < N` |
| **Kill switch** | Force off regardless of other rules |
| **Sticky assignment** | Same user stays in variant |
| **Default off** | Safe when fetch fails |

**Architecture:**

```text
Launch → fetch config (CDN/API)
      → persist cache + etag
      → evaluate flags locally (sync, fast)
      → UI reads FlagProvider protocol
      → analytics: exposure + conversion
```

**Client-side vs server-side:**

| | Client-side | Server-side |
|---|-------------|-------------|
| Latency | Instant after cache | Network per request |
| Security | Can be tampered | Authoritative for paid/gated |
| Offline | Uses last cache | May block |

**Anti-patterns:** nested `if flagA { if flagB {` without defaults; no TTL; flags without owners; permanent flags named `temp_*`.

## 🏋️ Exercises

1. **New checkout flow** — Roll out to 5% iOS 18+ users; kill switch if crash rate spikes. *Expected:* hash bucketing, crash telemetry tie-in, revert without release.

2. **Remote config** — API timeout default 30s → change to 15s without app update. *Expected:* config key + client read at request layer.

3. **Offline launch** — Config fetch fails. *Expected:* bundled defaults, last cached values, feature off if unknown.

4. **A/B naming** — Define exposure event and primary metric for search UI experiment. *Expected:* `search_ui_variant_assigned`, metric `search_result_tap`.

5. **Flag cleanup RFC** — Process to remove flag after 100% rollout. *Expected:* default true in code, delete branch, remove remote key.

## Ссылки

- [LaunchDarkly architecture concepts](https://docs.launchdarkly.com/home/about/architecture) — vendor-neutral patterns
- [Firebase Remote Config](https://firebase.google.com/docs/remote-config) — common mobile choice
- [Type-safe resolver (note)](notes/swift-type-safe-resolver.md) · [Playground](feature_flags_resolver.playground/Contents.swift)
- [Livsy Code — A Feature Flags System in Swift](https://livsycode.com/best-practices/a-feature-flags-system-in-swift/)
- [FeatureFlagsKit](https://github.com/Livsy90/FeatureFlagsKit)
- Related: [analytics](../analytics/README.md), [scaling-teams](../scaling-teams/README.md)

## Карточки знаний (Q&A)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question (EN):** Remote config vs feature flag?

- **Answer (EN):** Remote config tunes parameters (strings, numbers, JSON). Feature flags gate behavior on/off or variants. One service often provides both; separate kill switches from experiments operationally.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Remote config vs feature flag?

- **Answer (RU):** **Remote config** — параметры (строки, числа, JSON): тексты, лимиты, URLs. **Feature flag** — gate поведения (вкл/выкл, variant). На практике один сервис часто делает и то и другое; важно разделить **kill switch** (безопасность) и **experiments** (продукт).

</details>
### Q2
- **Question (EN):** How do you implement gradual rollout on the client?

- **Answer (EN):** Use stable bucketing (e.g. hash userId mod 100) plus filters for app version/OS. Server can send percent or per-user booleans; sticky assignment and exposure logging matter most.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Как делать gradual rollout на клиенте?

- **Answer (RU):** Стабильный **bucket**: `hash(userId) % 100 < rolloutPercent`. Пользователь остаётся в группе между запусками. Добавить фильтры: версия app, OS, locale. Сервер отдаёт процент или готовый boolean per user — оба valid; главное — **sticky** assignment и логирование exposure.

</details>
### Q3
- **Question (EN):** What should happen in the UI when a kill switch fires?

- **Answer (EN):** Hide or degrade gracefully — legacy flow, disabled sub-step, no crashes or blank screens. Refresh config on launch; for high-risk features default safe (off) when config is unavailable.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Kill switch — что должно произойти в UI?

- **Answer (RU):** Feature **исчезает или degrades gracefully**: скрыть entry point, показать legacy flow, disable только risky sub-step. Не crash и не пустой экран. Config refresh на launch + периодически; при off — локальный cache обновляется. Критичные флаги — **default safe** (off) если config недоступен, если риск высокий.

</details>
### Q4
- **Question (EN):** What are the risks of client-side evaluation?

- **Answer (EN):** Client cache can be tampered with on jailbroken devices — fine for UX rollouts, not for authorization or paid gates (verify server-side). Remove stale flags to limit complexity.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Client-side evaluation — риски?

- **Answer (RU):** Пользователь может подменить cached config на jailbreak (редко критично для UI experiments). **Платные/безопасные** gates — проверять на **server**. Клиентские флаги — для UX rollout и performance; не для авторизации. Минимизировать вложенность флагов и удалять мёртвые.

</details>
### Q5
- **Question (EN):** How do you structure type-safe feature flags on the client?

- **Answer (EN):** String-backed enum conforming to `Feature`; merge prioritized sources (business, testing, overrides); first non-nil wins, else default. Remote config maps into a source — no string keys in views. See playground link above.

<!-- knowledge-cards-canonical:end -->


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Как устроить type-safe feature flags на клиенте?

- **Answer (RU):** Enum + `Feature` protocol (`key`, `defaultValue`). Значения из **источников с приоритетом** (`business` → `testing` → overrides); resolver возвращает первое non-`nil`, иначе default. Remote config — отдельный source, не строки в UI. Playground: [feature_flags_resolver.playground](feature_flags_resolver.playground/Contents.swift).

</details>
