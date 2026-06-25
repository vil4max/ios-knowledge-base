# Caching & Offline-First

## In 30 seconds


**Caching** reduces latency and bandwidth: HTTP cache (`URLCache`), in-memory (`NSCache`), disk files, and image pipelines (decode + resize + memory/disk tiers). **Offline-first** means the UI reads a **local source of truth** and syncs in the background—network is an optimization, not a hard dependency. Interviewers ask about cache invalidation, memory pressure, stale data, and conflict resolution.


<details class="lang-ru">
<summary>По-русски</summary>

**Кэширование** снижает latency и трафик: HTTP cache (`URLCache`), in-memory, disk, image cache. **Offline-first** ставит локальные данные в центр UX с синхронизацией и конфликтами.

</details>

## Apple docs


- [URLCache](https://developer.apple.com/documentation/foundation/urlcache) — HTTP response cache for `URLSession`.
- [NSCache](https://developer.apple.com/documentation/foundation/nscache) — in-memory cache with system eviction on memory pressure.
- [NSURLRequest.CachePolicy](https://developer.apple.com/documentation/foundation/nsurlrequest/cachepolicy) — reload, return cache, else load.
- [Using background sessions](https://developer.apple.com/documentation/foundation/url_loading_system/downloading_files_in_the_background) — large downloads while suspended.
- [Reducing memory footprint](https://developer.apple.com/documentation/xcode/reducing-your-app-s-memory-use) — Jetsam, cache sizing.

## Materials


<details class="lang-ru">
<summary>По-русски</summary>

- [Image Caching in UIKit and SwiftUI](notes/Image-Caching-UIKit-SwiftUI.md) — decode cost, memory pressure, production pipelines, `AsyncImage`; карточка **Q35**

</details>
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
- **Question (EN):** Offline-first sync basics?

- **Answer (EN):** Offline-first means the UI reads authoritative local state—network sync reconciles local vs remote rather than gatekeeping every screen.

    Keep a durable outbound mutation queue; require idempotent APIs or keys; apply inbound merges with explicit versioning/rules.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up:** last-write-wins vs custom merge (кастомное слияние) — как выбирать?

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer:** LWW — когда допустимо перезатереть поле целиком и нет сложных инвариантов; custom merge — когда разные поля от разных источников, нужны частичные слияния или доменные правила (например суммы, статусы). Часто комбинируют: серверный timestamp для простых сущностей, ручной разбор для «конфликтных» записей.

</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** offline-first sync (офлайн-синхронизация): базовая стратегия?

- **Answer (RU):** Зацепка: **офлайн-first** — UI и бизнес-логика живут без обязательной сети в момент показа данных; сеть — синхронизация состояний, а не единственный источник истины.

    Локальный источник истины (БД/файл): читаем только из него. Исходящие мутации — в durable **outbox** на диске до подтверждения сервером; API идемпотентны или защищены ключами. Входящие изменения — с явной политикой слияния и версионированием.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (RU):** локально читаем; очередь мутаций на диске; идемпотентность; политика конфликтов.

</details>
</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Доп. информация:** outbox без диска → краш до отправки теряет мутацию; vector clocks — тема роадмапа.

</details>

### Q35
- **Question (EN):** How does UIKit image caching work, and why was early `AsyncImage` insufficient?

<details class="lang-ru">
<summary>По-русски</summary>

    - Из `URLCache` всё равно нужен **decode** (CPU) → `UIImage`.

    - В `NSCache` кладёт **разработчик** (`setObject`) — UIKit не делает это автоматически.

    - JPEG 2 MB → decoded `UIImage` в RAM часто **20–40 MB**; лента картинок = сотни MB RAM.

    - **`NSCache`** vs `[URL: UIImage]`: eviction при **memory pressure**; иначе Jetsam убивает процесс.

    **`AsyncImage` (до WWDC26):** скачал + placeholder + показал; без контроля memory/disk cache, prefetch, invalidation → перезагрузки при scroll / recreate view → в prod часто Kingfisher / Nuke / SDWebImage.

</details>
- **Answer (EN):** `UIImageView` does not cache. Production stacks layer memory (`NSCache` of decoded `UIImage`), optional disk, `URLCache` (HTTP bytes—not `UIImage`), then network. Developers must populate `NSCache`; decode from URLCache still costs CPU. Decoded images dominate RAM; `NSCache` evicts under memory pressure before Jetsam. Early `AsyncImage` lacked real cache policy—third-party loaders remained standard.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (EN):**

</details>
</details>
</details>
    1. UIImageView doesn't cache—you build or use a loader.
    2. URLCache holds bytes; NSCache holds decoded UIImages.
    3. Memory pressure evicts NSCache; Jetsam kills if RAM exhausted.
    4. Early AsyncImage was download-and-show; lists need layered caches.

- **Playground:** [open](caching_offline_first.playground/Contents.swift)


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Как устроено **кэширование изображений** в UIKit и почему **`AsyncImage`** долго не хватало для production?

- **Answer (RU):** Зацепка: **`UIImageView` сам не кэширует** — Apple даёт кирпичи, pipeline собирает разработчик или библиотека.

    **Слои (сверху вниз при lookup):**

    1. **Memory cache (`NSCache<NSURL, UIImage>`)** — готовый декодированный `UIImage`; hit → сразу на экран, без сети/диска/decode.
    2. **Disk cache** (опционально, в Kingfisher/Nuke/SDWebImage) — байты на диске приложения.
    3. **`URLCache`** — HTTP-ответы и **JPEG/PNG bytes** по `Cache-Control` / `ETag` / `304`; это **не** `UIImage`.
    4. **Network** — полная загрузка.

    **Ключевые различия:**

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (RU):**

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

    1. UIKit не кэширует сам — memory (`NSCache`) + disk + `URLCache` + network.

</details>
    2. `URLCache` = bytes; `NSCache` = decoded `UIImage`; decode — CPU.
<details class="lang-ru">
<summary>По-русски</summary>

    3. Memory pressure → `NSCache` чистится; иначе Jetsam.
    4. `AsyncImage` без слоёв → флаки в списках; prod — библиотеки или свой pipeline.

</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up (RU):** зачем **`NSCache`**, а не обычный `[URL: UIImage]`?

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer (RU):** `NSCache` **сам выкидывает** объекты при нехватке RAM и лучше интегрирован с системой; словарь держит всё, пока ты сам не удалишь — риск memory warning / Jetsam на image feed.

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up (RU):** как **`UICollectionView` reuse** стыкуется с кэшем?

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer (RU):** cell ушла с экрана, но **UIImage по URL остаётся в cache**; новая cell с тем же URL берёт из memory без повторного download/decode.

</details>
</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Доп. информация:** [Image Caching in UIKit and SwiftUI](notes/Image-Caching-UIKit-SwiftUI.md); iosiq exercise «NSCache 50 MB» — `Iosiq-Roadmap-Snapshot.md`; HTTP cache — Networking Q&A.

</details>
- **Notes:** [notes/Image-Caching-UIKit-SwiftUI.md](notes/Image-Caching-UIKit-SwiftUI.md)

<!-- knowledge-cards-canonical:end -->
