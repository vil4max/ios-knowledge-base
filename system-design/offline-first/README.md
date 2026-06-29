# Offline First

## In 30 seconds

**Offline-first** means the app treats **local storage as the source of truth** for what the user sees. Reads never block on network; writes are recorded locally first, then synced. Network is reconciliation, not a gate for every screen. Interview answers cover outbox queues, idempotent APIs, conflict policies, and UX for pending/failed states.

## Apple docs

- [Using background tasks](https://developer.apple.com/documentation/backgroundtasks) — `BGAppRefreshTask`, deferred sync windows.
- [NWPathMonitor](https://developer.apple.com/documentation/network/nwpathmonitor) — reachability without polling.
- [Core Data](https://developer.apple.com/documentation/coredata) — persistent local store; [NSPersistentCloudKitContainer](https://developer.apple.com/documentation/coredata/nspersistentcloudkitcontainer) for Apple-managed sync (know limits vs custom backend).
- [URLSession background configuration](https://developer.apple.com/documentation/foundation/urlsessionconfiguration/1407496-background) — large uploads/downloads while suspended.

## 🎯 Focus vs Defer

### Focus

- **Local source of truth:** UI binds to local DB/cache, not raw network responses.
- **Outbound mutation queue (outbox):** durable on disk until server ack.
- **Idempotency:** client-generated IDs or `Idempotency-Key` header.
- **Conflict resolution:** LWW, field-level merge, server wins, or user prompt.
- **Sync triggers:** app launch, foreground, connectivity restored, push silent refresh.
- **UX:** pending, synced, failed, retry — visible states.

### Defer

- Full CRDT/OT unless collaborative editing is in scope.
- CloudKit as default answer for every custom backend — mention when it fits vs when it does not.
- Perfect real-time consistency across devices in v1.

## Key concepts

| Term | Meaning |
|------|---------|
| **Read model** | Denormalized local view optimized for screens |
| **Outbox** | Table/queue of pending mutations with retry metadata |
| **Cursor / watermark** | Last synced server version or timestamp |
| **Tombstone** | Deleted flag synced so deletes propagate |
| **Optimistic write** | Apply locally before server confirms |
| **Reconciliation** | Merge server delta into local store |
| **Idempotent API** | Same request twice → same server state |
| **Last-write-wins (LWW)** | Higher timestamp wins whole record |
| **Field-level merge** | Merge non-conflicting fields independently |

**Anti-patterns:** network-only reads; in-memory-only outbox (lost on crash); blocking UI on `URLSession` without local cache.

**Sync trigger matrix:**

| Event | Typical action |
|-------|----------------|
| App foreground | Pull delta, flush outbox |
| Network restored | Flush outbox, backoff pull |
| User pull-to-refresh | Force pull + retry failed |
| Silent push | Wake app, fetch delta (budget-aware) |

## 🏋️ Exercises

1. **Notes app** — Design local schema + outbox for create/edit/delete. *Expected:* `Note` table, `PendingMutation` table, LWW on `updatedAt`.

2. **Shopping cart offline** — User adds items offline, prices change on server. *Expected:* local cart authoritative for UX; reconcile price conflicts on sync with user message.

3. **Failure UX** — Message stuck in “sending” for 24h. *Expected:* retry with exponential backoff, manual retry, delete draft, analytics on failure reason.

4. **Reachability** — Replace timer-based polling with `NWPathMonitor` + foreground sync. *Expected:* no background poll loop; sync on path satisfied.

5. **Idempotency** — POST /messages twice with same client UUID. *Expected:* server returns same resource id both times.

## Links

- [Using Background Tasks](https://developer.apple.com/documentation/backgroundtasks)
- Related: [sync-engine](../sync-engine/README.md), [caching-offline-first](../../data-and-network/caching-offline-first/README.md)
- [Offline First (offlinefirst.org)](https://offlinefirst.org/) — principles and patterns

## Interview Q&A (Knowledge cards)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question:** What does “local source of truth” mean?

- **Answer:** Screens read from local storage; the network updates that store but does not gate every read. The user sees the last known state immediately, including offline.

### Q2
- **Question:** Why a durable outbox on disk?

- **Answer:** Mutations persist in a disk queue until the server acknowledges them. Survives crashes and offline periods; retries with backoff when online. In-memory queues lose work on process death.

### Q3
- **Question:** Last-write-wins vs custom merge — when to use which?

- **Answer:** LWW fits simple records with a single version timestamp. Custom merge fits multi-field edits, domain rules, or user-visible conflicts. Often combine both strategies by entity type.

### Q4
- **Question:** How does offline-first work with push notifications?

- **Answer:** Push triggers sync, it is not the data transport: silent push wakes the app, fetches a delta, merges locally, UI updates via observation. Do not rely on push payload alone for large payloads.

<!-- knowledge-cards-canonical:end -->
