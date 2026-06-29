# Caching & Offline-First

## In 30 seconds

**Caching** reduces latency and bandwidth: HTTP cache (`URLCache`), in-memory (`NSCache`), disk files, and image pipelines (decode + resize + memory/disk tiers). **Offline-first** means the UI reads a **local source of truth** and syncs in the background—network is an optimization, not a hard dependency. Interviewers ask about cache invalidation, memory pressure, stale data, and conflict resolution.

## Apple docs

- [URLCache](https://developer.apple.com/documentation/foundation/urlcache) — HTTP response cache for `URLSession`.
- [NSCache](https://developer.apple.com/documentation/foundation/nscache) — in-memory cache with system eviction on memory pressure.
- [NSURLRequest.CachePolicy](https://developer.apple.com/documentation/foundation/nsurlrequest/cachepolicy) — reload, return cache, else load.
- [Using background sessions](https://developer.apple.com/documentation/foundation/url_loading_system/downloading_files_in_the_background) — large downloads while suspended.
- [Reducing memory footprint](https://developer.apple.com/documentation/xcode/reducing-your-app-s-memory-use) — Jetsam, cache sizing.

## Materials

- HTTP cache policies — [Networking & URLSession](../networking/README.md) (Q31, Q47)
- Parallel image loading — [Swift Concurrency](../../swift/concurrency/README.md)

## 🎯 Focus vs Defer

### Focus

- **HTTP cache:** `Cache-Control`, ETag, `URLCache` limits; when to use `.reloadIgnoringLocalCacheData`.
- **Image pipeline:** download → decode off main → downscale → memory + disk cache; cost of decoding on main thread.
- **NSCache vs Dictionary:** `NSCache` evicts under pressure; no strong guarantee of retention.
- **Offline-first UX:** optimistic UI, outbox queue, show stale with timestamp, retry with backoff.
- **Invalidation:** TTL, version keys, push silent refresh, pull-to-refresh as explicit user intent.

### Defer

- Building a full **CDN** strategy before app-level cache headers are correct.
- **Multi-tier L1/L2** custom cache frameworks without measuring hit rate.
- Perfect **conflict-free replicated data types** (CRDTs) unless role requires distributed systems depth.

## 🏋️ Exercises

1. **URLCache:** Two identical GETs; second with default policy. **Expected:** second may hit cache; log `URLSessionTaskMetrics` if available.
2. **NSCache pressure:** Fill cache with large images; simulate memory warning. **Expected:** entries evicted without crash.
3. **Stale-while-revalidate:** Show cached feed immediately; refresh in background; update UI on success. **Expected:** no blank screen on launch offline.
4. **Image downscale:** Decode 4000px image to cell size off main. **Expected:** lower peak memory vs full decode.
5. **Cache key design:** Same URL, different auth headers. **Expected:** explain why URL alone is insufficient for authenticated resources.

## Artifacts

- Notes: `notes/`
- Exercises: `exercises/`
- Assets: `assets/`
- Playgrounds: `playgrounds/`

---

## Interview Q&A (Knowledge cards)

Interview Q&A below.

<!-- knowledge-cards-canonical:start -->

### Q34
- **Question:** Offline-first sync basics?

- **Answer:** Offline-first means the UI reads authoritative local state—network sync reconciles local vs remote rather than gatekeeping every screen.

    Keep a durable outbound mutation queue; require idempotent APIs or keys; apply inbound merges with explicit versioning/rules.

### Q35
- **Question:** How does UIKit image caching work, and why was early `AsyncImage` insufficient?

- **Answer:** `UIImageView` does not cache. Production stacks layer memory (`NSCache` of decoded `UIImage`), optional disk, `URLCache` (HTTP bytes—not `UIImage`), then network. Developers must populate `NSCache`; decode from URLCache still costs CPU. Decoded images dominate RAM; `NSCache` evicts under memory pressure before Jetsam. Early `AsyncImage` lacked real cache policy—third-party loaders remained standard.

    1. UIImageView doesn't cache—you build or use a loader.
    2. URLCache holds bytes; NSCache holds decoded UIImages.
    3. Memory pressure evicts NSCache; Jetsam kills if RAM exhausted.
    4. Early AsyncImage was download-and-show; lists need layered caches.

- **Playground:** [open](caching_offline_first.playground/Contents.swift)

- **Notes:** [notes/Image-Caching-UIKit-SwiftUI.md](notes/Image-Caching-UIKit-SwiftUI.md)

<!-- knowledge-cards-canonical:end -->
