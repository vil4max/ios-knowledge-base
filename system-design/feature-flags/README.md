# Feature Flags

## In 30 seconds

**Feature flags** and **remote config** decouple release from exposure: ship code dark, enable per user/segment, run **gradual rollout**, and flip a **kill switch** without App Store delay. Client-side evaluation reads cached config at launch; server-side gates sensitive or paid features. Interview answers cover flag lifecycle, consistency, analytics linkage, and avoiding flag spaghetti.

## Materials

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

## Key concepts

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

## Links

- [LaunchDarkly architecture concepts](https://docs.launchdarkly.com/home/about/architecture) — vendor-neutral patterns
- [Firebase Remote Config](https://firebase.google.com/docs/remote-config) — common mobile choice
- [Type-safe resolver (note)](notes/swift-type-safe-resolver.md) · [Playground](feature_flags_resolver.playground/Contents.swift)
- [Livsy Code — A Feature Flags System in Swift](https://livsycode.com/best-practices/a-feature-flags-system-in-swift/)
- [FeatureFlagsKit](https://github.com/Livsy90/FeatureFlagsKit)
- Related: [analytics](../analytics/README.md), [scaling-teams](../scaling-teams/README.md)

## Interview Q&A (Knowledge cards)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question:** Remote config vs feature flag?

- **Answer:** Remote config tunes parameters (strings, numbers, JSON). Feature flags gate behavior on/off or variants. One service often provides both; separate kill switches from experiments operationally.

### Q2
- **Question:** How do you implement gradual rollout on the client?

- **Answer:** Use stable bucketing (e.g. hash userId mod 100) plus filters for app version/OS. Server can send percent or per-user booleans; sticky assignment and exposure logging matter most.

### Q3
- **Question:** What should happen in the UI when a kill switch fires?

- **Answer:** Hide or degrade gracefully — legacy flow, disabled sub-step, no crashes or blank screens. Refresh config on launch; for high-risk features default safe (off) when config is unavailable.

### Q4
- **Question:** What are the risks of client-side evaluation?

- **Answer:** Client cache can be tampered with on jailbroken devices — fine for UX rollouts, not for authorization or paid gates (verify server-side). Remove stale flags to limit complexity.

### Q5
- **Question:** How do you structure type-safe feature flags on the client?

- **Answer:** String-backed enum conforming to `Feature`; merge prioritized sources (business, testing, overrides); first non-nil wins, else default. Remote config maps into a source — no string keys in views. See playground link above.

<!-- knowledge-cards-canonical:end -->
