# Storage & Persistence

## За 30 секунд

iOS apps persist data in **UserDefaults**, **Keychain**, **files** (Documents / Caches / Application Support), **Core Data**, **SwiftData**, and **SQLite** (direct or via wrappers). Interview focus: **where** to store what, **threading** rules for Core Data, **migration** strategy, and **encryption** for secrets. Wrong layer (e.g. large blobs in UserDefaults) causes performance and backup issues.

## Apple docs

- [Preserving your app's data across launches](https://developer.apple.com/documentation/uikit/app_and_environment/scenes/preparing_your_ui_to_run_in_the_background/preserving_your_app_s_data_across_launches) — state restoration vs durable storage.
- [Using Core Data in your app](https://developer.apple.com/documentation/coredata/using_core_data_in_your_app) — stack, contexts, fetch requests.
- [Core Data concurrency](https://developer.apple.com/documentation/coredata/using_core_data_in_the_background) — background contexts, `perform`.
- [Migrating your data model automatically](https://developer.apple.com/documentation/coredata/using_a_lightweight_migration) — lightweight vs heavyweight migration.
- [SwiftData](https://developer.apple.com/documentation/swiftdata) — model macros, `@Query`, CloudKit sync path.
- [Keychain Services](https://developer.apple.com/documentation/security/keychain_services) — secrets, access groups.
- [FileManager](https://developer.apple.com/documentation/foundation/filemanager) — sandbox directories, App Groups.
- [UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults) — small preferences only.

## 🎯 Focus vs Defer

### Focus

- **Layer choice:** UserDefaults — flags/small prefs; Keychain — tokens/passwords; Files — user content & caches; Core Data/SwiftData — relational object graphs.
- **Core Data threading:** `NSManagedObject` is **not** thread-safe; pass **`NSManagedObjectID`**; use `perform` / `performAndWait` on the context's queue.
- **Context hierarchy:** main (UI) + private background child; `save` child → merge to parent; set **`mergePolicy`** explicitly.
- **Migration:** lightweight (additive) vs mapping model; versioned `.xcdatamodeld`; test migrations in CI with fixture stores.
- **SwiftData vs Core Data:** SwiftData for greenfield SwiftUI; Core Data for mature stacks, complex migrations, existing ObjC bridges.

### Defer

- Full **CloudKit** conflict matrix until basic local stack is solid.
- Raw **SQLite** API unless debugging a wrapper or interview asks specifically.
- **NSKeyedArchiver** for new features — prefer `Codable` + files or Core Data.
- Custom **encryption at rest** for entire DB before Keychain + Data Protection classes are understood.

## Ключевые понятия

- **Persistent store** — SQLite file (or in-memory) behind Core Data stack.
- **NSManagedObjectContext** — unit of work; queue-confined (`main` or `private`).
- **NSManagedObjectID** — stable token to re-fetch object on another context/thread.
- **Fetch request** — query with predicates, sort descriptors, batching (`fetchBatchSize`).
- **Fault** — lazy placeholder; firing fault loads data; batch faults reduce round-trips.
- **Merge policy** — how parent resolves child saves (`NSErrorMergePolicy`, property-level).
- **Lightweight migration** — inferred mapping for additive schema changes.
- **Data Protection** — file encryption classes (`complete`, `untilFirstUserAuthentication`).
- **App Group container** — shared sandbox URL for app + extensions/widgets.
- **WAL mode** — SQLite write-ahead log; Core Data uses it by default on iOS.

## 🏋️ Exercises

1. **Directory pick:** Classify 5 data types (auth token, feed JSON cache, user avatar file, onboarding flag, order graph) → storage layer. **Expected:** Keychain / Caches / Documents / UserDefaults / Core Data.
2. **Cross-thread ID:** Fetch on background context; pass `objectID` to main; materialize with `existingObject(with:)`. **Expected:** no cross-thread `NSManagedObject` usage.
3. **Migration test:** Add optional attribute; run lightweight migration on old store fixture. **Expected:** launch without crash; new field defaults correctly.
4. **Keychain round-trip:** Save and read token with `kSecAttrAccessibleAfterFirstUnlock`. **Expected:** survives relaunch; not in UserDefaults plist.
5. **Batch delete:** Delete 10k rows with `NSBatchDeleteRequest` vs loop delete. **Expected:** measure time; discuss context merge / UI refresh.

## Ссылки

- [WWDC19 — Using Core Data With CloudKit](https://developer.apple.com/videos/play/wwdc2019/202/)
- [WWDC20 — Sync a Core Data store with CloudKit](https://developer.apple.com/videos/play/wwdc2020/10650/)
- [WWDC23 — Meet SwiftData](https://developer.apple.com/videos/play/wwdc2023/10187/)
- [WWDC24 — Track model data with SwiftData](https://developer.apple.com/videos/play/wwdc2024/10137/)

## Артефакты

- Notes: `notes/`
- Exercises: `exercises/`
- Assets: `assets/`
- Playgrounds: `playgrounds/`

---

## Карточки знаний (Q&A)

<!-- knowledge-cards-canonical:start -->

### Q33
- **Question (RU):** Core Data concurrency basics (база многопоточности Core Data)?
- **Question (EN):** Core Data concurrency basics?
- **Answer (RU):** **`NSManagedObject` не передаём между потоками** — он живёт внутри конкретного **`NSManagedObjectContext`**. Контекст сериализует доступ на своей очереди (`main` или `private`). Между контекстами передают **`NSManagedObjectID`**, на целевом контексте — `object(with:)` / `existingObject(with:)` внутри `perform`. Иерархия: `main` для UI + child `private` для записи; `save` ребёнка → merge в родителя; **`mergePolicy`** задавать явно.
- **Answer (EN):** Contexts are queue-bound; never pass `NSManagedObject` across threads—use `NSManagedObjectID` and `perform`. Parent/child contexts with explicit merge policies; CloudKit adds sync-specific merging.

- **Follow-up:** merge conflict strategy в offline flow?
- **Follow-up answer:** server-wins / client-wins / field-level merge; версия записи + UI для конфликта; merge при save parent или отдельная сущность «conflict» до push.

- **Доп. информация:** [Using Core Data in the background](https://developer.apple.com/documentation/coredata/using_core_data_in_the_background); `performAndWait` с main из фона — риск deadlock.

### Q48
- **Question (RU):** UserDefaults vs Keychain vs файл — когда что?
- **Question (EN):** UserDefaults vs Keychain vs files—when to use each?
- **Answer (RU):** **UserDefaults** — мелкие настройки, не секреты, не большие данные (plist, backup). **Keychain** — токены, пароли, ключи; шифрование и политики доступа. **Файлы** — пользовательский контент, кэши (`Caches` можно снести системой), большие blob; **Documents** — то, что пользователь «владеет». Секреты не в UserDefaults.
- **Answer (EN):** UserDefaults for small non-secret prefs; Keychain for secrets; Files for content and caches with correct directory semantics.

- **Follow-up:** App Group зачем?
- **Follow-up answer:** общий контейнер для app + extension/widget; `containerURL(forSecurityApplicationGroupIdentifier:)`.

- **Доп. информация:** [FileManager](https://developer.apple.com/documentation/foundation/filemanager); [Keychain Services](https://developer.apple.com/documentation/security/keychain_services).

### Q49
- **Question (RU):** SwiftData vs Core Data на собесе?
- **Question (EN):** SwiftData vs Core Data in interviews?
- **Answer (RU):** **SwiftData** — Swift-native, макросы `@Model`, `@Query`, тесная SwiftUI; меньше boilerplate на новых проектах. **Core Data** — зрелый стек, сложные миграции, ObjC, NSPredicate, большие legacy кодовые базы. Оба могут использовать SQLite под капотом; SwiftData не отменяет понимание контекстов и миграций.
- **Answer (EN):** SwiftData for new SwiftUI apps; Core Data for complex migrations and existing stacks. Know concurrency and migration either way.

- **Доп. информация:** [SwiftData](https://developer.apple.com/documentation/swiftdata); WWDC23 Meet SwiftData.

<!-- knowledge-cards-canonical:end -->
