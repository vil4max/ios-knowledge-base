# Storage & Persistence

## In 30 seconds

iOS apps persist data in **UserDefaults**, **Keychain**, **files** (Documents / Caches / Application Support), **Core Data**, **SwiftData**, and **SQLite** (direct or via wrappers). Interview focus: **where** to store what, **threading** rules for Core Data, **migration** strategy, and **encryption** for secrets. Wrong layer (e.g. large blobs in UserDefaults) causes performance and backup issues.

## Apple docs

- [Preserving your app's data across launches](https://developer.apple.com/documentation/uikit/app_and_environment/scenes/preparing_your_ui_to_run_in_the_background/preserving_your_app_s_data_across_launches) — state restoration vs durable storage.
- [Using Core Data in your app](https://developer.apple.com/documentation/coredata/using_core_data_in_your_app) — stack, contexts, fetch requests.
- [Core Data concurrency](https://developer.apple.com/documentation/coredata/using_core_data_in_the_background) — background contexts, `perform`.
- [Migrating your data model automatically](https://developer.apple.com/documentation/coredata/using_a_lightweight_migration) — lightweight vs heavyweight migration.
- [SwiftData](https://developer.apple.com/documentation/swiftdata) — model macros, `@Query`, CloudKit sync path.
- [Observation](https://developer.apple.com/documentation/observation) — property-level reactivity for SwiftUI (iOS 17+).
- [Keychain Services](https://developer.apple.com/documentation/security/keychain_services) — secrets, access groups.
- [FileManager](https://developer.apple.com/documentation/foundation/filemanager) — sandbox directories, App Groups.
- [UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults) — small preferences only.
- [SQLite](https://www.sqlite.org/docs.html) — embedded SQL engine (Core Data / SwiftData default store).

## 🎯 Focus vs Defer

### Focus

- **Layer choice:** UserDefaults — flags/small prefs; Keychain — tokens/passwords; Files — user content & caches; Core Data/SwiftData — relational object graphs.
- **Core Data threading:** `NSManagedObject` is **not** thread-safe; pass **`NSManagedObjectID`**; use `perform` / `performAndWait` on the context's queue.
- **Context hierarchy:** main (UI) + private background child; `save` child → merge to parent; set **`mergePolicy`** explicitly.

### Defer

- **NSKeyedArchiver** for new features — prefer `Codable` + files or Core Data.
- Custom **encryption at rest** for entire DB before Keychain + Data Protection classes are understood.

## Key concepts

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

## Links

- [WWDC19 — Using Core Data With CloudKit](https://developer.apple.com/videos/play/wwdc2019/202/)
- [WWDC20 — Sync a Core Data store with CloudKit](https://developer.apple.com/videos/play/wwdc2020/10650/)
- [WWDC23 — Meet SwiftData](https://developer.apple.com/videos/play/wwdc2023/10187/)
- [WWDC24 — Track model data with SwiftData](https://developer.apple.com/videos/play/wwdc2024/10137/)

## Artifacts

- Notes: `notes/`
- Exercises: `exercises/`
- Assets: `assets/`
- Playgrounds: `playgrounds/`

### Recent notes

---

## Interview Q&A (Knowledge cards)

<!-- knowledge-cards-canonical:start -->

### Q33
- **Question:** Core Data concurrency basics?

- **Answer:** Contexts are queue-bound; never pass `NSManagedObject` across threads—use `NSManagedObjectID` and `perform`. Parent/child contexts with explicit merge policies; CloudKit adds sync-specific merging.

### Q48
- **Question:** UserDefaults vs Keychain vs files—when to use each?

- **Answer:** UserDefaults for small non-secret prefs; Keychain for secrets; Files for content and caches with correct directory semantics.

### Q49
- **Question:** SwiftData vs Core Data in interviews?

- **Answer:** SwiftData for new SwiftUI apps; Core Data for complex migrations and existing stacks. Know concurrency and migration either way.

### Q50
- **Question:** Core Data + SwiftUI: how to get property-level updates without splitting views?

- **Answer:** SwiftData integrates Observation natively. Core Data needs `@ObservedObject` per MO or a bridge like CDE: subscribe on read, publish after save; `saveObservedChanges()` for background field snapshots; honest degradation when metadata is objectID-only.

### Q51
- **Question:** Are SQLite and NoSQL competitors or different categories?

- **Answer:** Different categories. SQLite is embedded relational SQL for local files; NoSQL is server-side families optimized for scale and flexible schemas. iOS uses SQLite on device; NoSQL lives behind the API.

### Q52
- **Question:** Is Core Data a database? Where does SwiftData fit?

- **Answer:** Core Data is an object-graph persistence framework, not a database. SwiftData is the modern Swift layer on Core Data concepts. Both typically persist to SQLite—you use objects and fetch APIs.

### Q53
- **Question:** When direct SQLite, Core Data, SwiftData, or backend NoSQL?

- **Answer:** Direct SQLite for SQL control; Core Data for complex graphs and legacy; SwiftData for new iOS 17+ SwiftUI; backend NoSQL for cloud scale—the app talks over the network.

- **Follow-up:** 30-second interview answer?

- **Follow-up answer:** Copy-paste EN/RU blocks in [`notes/SQLite-NoSQL-Core-Data-SwiftData.md`](notes/SQLite-NoSQL-Core-Data-SwiftData.md#copy-paste-30-second-interview-answer).

<!-- knowledge-cards-canonical:end -->
