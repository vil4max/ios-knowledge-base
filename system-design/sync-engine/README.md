# Sync Engine

## In 30 seconds

A **sync engine** moves data between client and server with **versioning**, **delta updates**, **tombstones**, a **durable queue**, and **idempotent** operations. Interview answers explain how the client knows what changed (cursor, vector clock, or revision), how deletes propagate, how retries avoid duplicates, and how the UI stays consistent while sync runs in the background.

## Apple docs

- [BackgroundTasks](https://developer.apple.com/documentation/backgroundtasks) — scheduling sync work within OS limits.
- [URLSession](https://developer.apple.com/documentation/foundation/urlsession) — batch requests, background transfers.
- [NSPersistentCloudKitContainer](https://developer.apple.com/documentation/coredata/nspersistentcloudkitcontainer) — reference for Apple-managed sync semantics (compare vs custom engine).

## 🎯 Focus vs Defer

### Focus

- **Delta sync:** fetch changes since cursor/watermark, not full snapshots every time.
- **Versioning:** monotonic revision, `updatedAt`, or vector clock per entity.
- **Tombstones:** soft-delete records replicated so clients remove local copies.
- **Outbound queue:** ordered mutations, retry, deduplication.
- **Idempotency keys:** safe retries after timeout.
- **Conflict policy:** explicit per entity type.
- **Observability:** sync status, last error, pending count for support/debug.

### Defer

- Building a general-purpose CRDT library in an interview.
- Multi-master global ordering unless the product requires it.
- Sub-second sync SLAs on mobile without stating battery/network trade-offs.

## Key concepts

| Component | Role |
|-----------|------|
| **Sync cursor** | Opaque token: “give me changes after this point” |
| **Change feed** | Server endpoint returning creates/updates/deletes |
| **Tombstone** | `{ id, deletedAt, revision }` — delete propagates |
| **Outbox entry** | `{ op, entityId, payload, idempotencyKey, attempts }` |
| **Backoff** | Exponential delay on 5xx / network errors |
| **Compaction** | Purge old tombstones after all clients past revision |
| **Full sync fallback** | Reset cursor after corruption or schema migration |

**Typical flow:**

```text
1. Flush outbox (POST/PATCH with idempotency key)
2. Pull delta GET /changes?since=cursor
3. Apply inbound in transaction (local DB)
4. Advance cursor atomically with applied revision
5. Notify UI (diff or FRC)
```

**Idempotency:** client UUID as primary key, or header `Idempotency-Key: <uuid>` — server stores result of first attempt, returns same on duplicate.

**Ordering:** per-entity serialization (message thread) vs global queue (risk: head-of-line blocking).

## 🏋️ Exercises

1. **Design change feed API** — Request/response for `GET /sync?since=cursor` including tombstones. *Expected:* JSON with `changes[]`, `nextCursor`, `hasMore`.

2. **Delete propagation** — User deletes item on device A offline; device B online. *Expected:* tombstone in delta; B removes locally; outbox on A sends delete with idempotency.

3. **Retry storm** — 503 from server; 10 pending mutations. *Expected:* exponential backoff, jitter, max attempts, dead-letter state visible in UI.

4. **Schema migration** — App v2 adds field; old cursor invalid. *Expected:* bump sync protocol version, force full sync or migration step.

5. **Conflict** — Two devices edit same note offline. *Expected:* state names chosen policy (LWW or merge UI) and server role as arbiter.

## Links

- Related: [offline-first](../offline-first/README.md), [push-notifications](../push-notifications/README.md)
- [Stripe idempotency](https://stripe.com/docs/api/idempotent_requests) — classic idempotency pattern (concept applies beyond payments)

## Interview Q&A (Knowledge cards)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question:** Why are tombstones needed in a sync engine?

- **Answer:** Deletes must replicate like updates. Without tombstones, clients that miss a delete event keep stale records forever. Tombstones in the change feed tell every client to remove the entity locally.

### Q2
- **Question:** Delta sync vs full sync?

- **Answer:** Delta sync fetches only changes since a cursor — fast and bandwidth-friendly. Full sync reloads everything — used for first login, schema changes, or recovery after corruption.

### Q3
- **Question:** How do you ensure idempotency on retry?

- **Answer:** Assign a stable idempotency key per mutation; the server stores the first successful result and returns it on duplicates. Client timeouts do not mean the operation failed — design safe retries.

### Q4
- **Question:** How should the UI learn about sync completion?

- **Answer:** The UI observes local DB changes after transactional applies. Expose sync state (idle/syncing/error) and pending counts for status surfaces — do not block every screen on network.

<!-- knowledge-cards-canonical:end -->
