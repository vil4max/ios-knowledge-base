# Caching & Offline-First

## Apple docs

- [NSURLCache](https://developer.apple.com/documentation/foundation/nsurlcache) — HTTP-кэш (`URLCache`).
- [NSCache](https://developer.apple.com/documentation/foundation/nscache) — in-memory cache с eviction при memory pressure.

## Материалы

- Конспект: [Image Caching in UIKit and SwiftUI](notes/Image-Caching-UIKit-SwiftUI.md) — `URLCache` vs `NSCache`, decode cost, memory pressure / Jetsam, production pipeline (Kingfisher / Nuke / SDWebImage), `AsyncImage` до WWDC26; карточка **Q35**
- HTTP-кэш и заголовки — [Networking — URLSession](../../20%20Networking%20—%20URLSession,%20REST,%20WebSocket,%20GraphQL,%20gRPC/Networking-URLSession-REST-WebSocket.md)
- Параллельная загрузка N картинок — [ImageLoadingConcurrencyLab](../../../II.%20Swift/08%20Swift%20Concurrency%20—%20async-await,%20actor,%20isolation/ImageLoadingConcurrencyLab.playground/Contents.swift)

## 🎯 Focus vs Defer

### Focus


### Defer


## 🏋️ Exercises

- Каждое упражнение: **задача** → **ожидаемый результат** → при необходимости **ссылка** на документацию.

## Артефакты

- Notes: `notes/`
- Exercises: `exercises/`
- Assets: `assets/`
- Playgrounds: `playgrounds/`

---

## Карточки знаний (Q&A)

Ниже — Q&A по теме.

<!-- knowledge-cards-canonical:start -->

### Q34
- **Question (RU):** offline-first sync (офлайн-синхронизация): базовая стратегия?
- **Question (EN):** Offline-first sync basics?
- **Answer (RU):** Зацепка: **офлайн-first** — UI и бизнес-логика живут без обязательной сети в момент показа данных; сеть — синхронизация состояний, а не единственный источник истины.

    Локальный источник истины (БД/файл): читаем только из него. Исходящие мутации — в durable **outbox** на диске до подтверждения сервером; API идемпотентны или защищены ключами. Входящие изменения — с явной политикой слияния и версионированием.

- **Answer (EN):** Offline-first means the UI reads authoritative local state—network sync reconciles local vs remote rather than gatekeeping every screen.

    Keep a durable outbound mutation queue; require idempotent APIs or keys; apply inbound merges with explicit versioning/rules.

- **Устная заготовка (RU):** локально читаем; очередь мутаций на диске; идемпотентность; политика конфликтов.

- **Follow-up:** last-write-wins vs custom merge (кастомное слияние) — как выбирать?
- **Follow-up answer:** LWW — когда допустимо перезатереть поле целиком и нет сложных инвариантов; custom merge — когда разные поля от разных источников, нужны частичные слияния или доменные правила (например суммы, статусы). Часто комбинируют: серверный timestamp для простых сущностей, ручной разбор для «конфликтных» записей.

- **Доп. информация:** outbox без диска → краш до отправки теряет мутацию; vector clocks — тема роадмапа.


### Q35
- **Question (RU):** Как устроено **кэширование изображений** в UIKit и почему **`AsyncImage`** долго не хватало для production?
- **Question (EN):** How does UIKit image caching work, and why was early `AsyncImage` insufficient?
- **Answer (RU):** Зацепка: **`UIImageView` сам не кэширует** — Apple даёт кирпичи, pipeline собирает разработчик или библиотека.

    **Слои (сверху вниз при lookup):**

    1. **Memory cache (`NSCache<NSURL, UIImage>`)** — готовый декодированный `UIImage`; hit → сразу на экран, без сети/диска/decode.
    2. **Disk cache** (опционально, в Kingfisher/Nuke/SDWebImage) — байты на диске приложения.
    3. **`URLCache`** — HTTP-ответы и **JPEG/PNG bytes** по `Cache-Control` / `ETag` / `304`; это **не** `UIImage`.
    4. **Network** — полная загрузка.

    **Ключевые различия:**

    - Из `URLCache` всё равно нужен **decode** (CPU) → `UIImage`.
    - В `NSCache` кладёт **разработчик** (`setObject`) — UIKit не делает это автоматически.
    - JPEG 2 MB → decoded `UIImage` в RAM часто **20–40 MB**; лента картинок = сотни MB RAM.
    - **`NSCache`** vs `[URL: UIImage]`: eviction при **memory pressure**; иначе Jetsam убивает процесс.

    **`AsyncImage` (до WWDC26):** скачал + placeholder + показал; без контроля memory/disk cache, prefetch, invalidation → перезагрузки при scroll / recreate view → в prod часто Kingfisher / Nuke / SDWebImage.

- **Answer (EN):** `UIImageView` does not cache. Production stacks layer memory (`NSCache` of decoded `UIImage`), optional disk, `URLCache` (HTTP bytes—not `UIImage`), then network. Developers must populate `NSCache`; decode from URLCache still costs CPU. Decoded images dominate RAM; `NSCache` evicts under memory pressure before Jetsam. Early `AsyncImage` lacked real cache policy—third-party loaders remained standard.

- **Устная заготовка (RU):**

    1. UIKit не кэширует сам — memory (`NSCache`) + disk + `URLCache` + network.
    2. `URLCache` = bytes; `NSCache` = decoded `UIImage`; decode — CPU.
    3. Memory pressure → `NSCache` чистится; иначе Jetsam.
    4. `AsyncImage` без слоёв → флаки в списках; prod — библиотеки или свой pipeline.

- **Устная заготовка (EN):**

    1. UIImageView doesn't cache—you build or use a loader.
    2. URLCache holds bytes; NSCache holds decoded UIImages.
    3. Memory pressure evicts NSCache; Jetsam kills if RAM exhausted.
    4. Early AsyncImage was download-and-show; lists need layered caches.

- **Follow-up (RU):** зачем **`NSCache`**, а не обычный `[URL: UIImage]`?
- **Follow-up answer (RU):** `NSCache` **сам выкидывает** объекты при нехватке RAM и лучше интегрирован с системой; словарь держит всё, пока ты сам не удалишь — риск memory warning / Jetsam на image feed.

- **Follow-up (RU):** как **`UICollectionView` reuse** стыкуется с кэшем?
- **Follow-up answer (RU):** cell ушла с экрана, но **UIImage по URL остаётся в cache**; новая cell с тем же URL берёт из memory без повторного download/decode.

- **Доп. информация:** [Image Caching in UIKit and SwiftUI](notes/Image-Caching-UIKit-SwiftUI.md); iosiq exercise «NSCache 50 MB» — `Iosiq-Roadmap-Snapshot.md`; HTTP cache — Networking Q&A.

- **Playground:** [open](caching_offline_first.playground/Contents.swift)
- **Notes:** [notes/Image-Caching-UIKit-SwiftUI.md](notes/Image-Caching-UIKit-SwiftUI.md)

<!-- knowledge-cards-canonical:end -->
