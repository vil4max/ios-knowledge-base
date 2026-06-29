# Value types, actors, concurrency — quiz breakdown

> **Status:** draft — moved from a practice quiz; question breakdown and interview follow-ups.

Cheat sheet and deep dive: struct vs class, copy-on-write, actor reentrancy, `@MainActor`, array performance.

See cards **Q12–Q13** (actor isolation, reentrancy) in the [Concurrency README](../README.md).

---

## 1. Mutation via array copy (class vs struct)

### Question

```swift
class Entity {
    var id: String

    init(_ id: String) {
        self.id = id
    }
}

class EntityContainer {
    var entities = [
        Entity("a"),
        Entity("b"),
        Entity("c"),
    ]
}

let container = EntityContainer()
var entities = container.entities

entities[0].id = "d"
var entity = entities.removeLast()
entity.id = "e"

print(container.entities.map(\.id))
print(entities.map(\.id))
```

Options:

- `["a", "b"]` / `["d", "b"]`
- `["a", "b", "c"]` / `["d", "b"]`
- `["d", "b", "e"]` / `["d", "b", "e"]`
- **`["d", "b", "e"]` / `["d", "b"]`** ✅
- `["d", "b", "e"]` / `["d", "b"]` (duplicate of the correct option in the original list)

### Answer

```
["d", "b", "e"]
["d", "b"]
```

### Mental model

Three levels of copying:

| Level | Type | What is copied |
|-------|------|----------------|
| `container` | `class` | One reference to `EntityContainer` |
| `container.entities` vs `entities` | `Array` (struct) | Two **different** arrays after `var entities = container.entities` |
| Array elements | `Entity` (class) | **The same** heap objects |

`Array` is a value type, but an array of classes is an array of **pointers**. Copying the array copies pointers, not the objects.

### Step by step

```
Before mutations:
container.entities → [ptr₀→"a", ptr₁→"b", ptr₂→"c"]
entities           → [ptr₀→"a", ptr₁→"b", ptr₂→"c"]

entities[0].id = "d"
→ object ptr₀ changes → both arrays see "d"

entities.removeLast()
→ entities: [ptr₀→"d", ptr₁→"b"]                    // length 2
→ container.entities: [ptr₀→"d", ptr₁→"b", ptr₂→"c"]  // length 3

entity = ptr₂, entity.id = "e"
→ container.entities[2] is also "e"
```

| Step | What happens |
|------|----------------|
| `var entities = container.entities` | The **array** is copied; elements are **references** to the same `Entity` instances. |
| `entities[0].id = "d"` | Shared object → `container.entities[0]` is also `"d"`. |
| `entities.removeLast()` | Removal only from local `entities`; the container still has 3 elements. |
| `entity.id = "e"` | Mutation of shared object → `container.entities[2]` becomes `"e"`. |

**Result:** two different arrays (different lengths), three shared heap objects.

### Typical mistakes

| Wrong answer | Why it is wrong |
|--------------|-----------------|
| `["a","b","c"]` / `["d","b"]` | Forgetting that `entities[0].id = "d"` mutates a **shared** object |
| `["d","b","e"]` / `["d","b","e"]` | Assuming `removeLast()` affected the container |
| `["a","b"]` / `["d","b"]` | Confusing shallow array copy with deep copy of objects |

### If `Entity` were a struct

Copying the array would copy the values too; mutations through `entities` would not affect `container.entities` (array buffer COW is a separate topic; struct elements are independent after the array copy).

### Interview follow-up

- **Shallow vs deep copy** — copying `[Class]` is always shallow for elements.
- **`===` vs `==`** — object identity matters here.
- UIKit: copy `view.subviews`, mutate a view → the superview sees the change too.

**One-liner:** the container (array) is copied, not the contents (class objects).

---

## 2. Actor reentrancy and `async let`

### Question

```swift
actor Counter {
    var value = 0

    func increment() async {
        let current = value
        await Task.yield()
        value = current + 1
    }
}

let counter = Counter()
async let a = counter.increment()
async let b = counter.increment()
_ = await (a, b)
print(await counter.value)
```

Options:

1. **Actor reentrancy: both read 0 before writing → `value == 1`** ✅
2. Actor serializes access → `value == 2`
3. Compile error — `async let` with actor methods
4. Runtime crash — data race

### Answer

**Prints `1`.** Correct option — **1**.

### Two claims — do not mix them

| Claim | True? |
|-------|-------|
| Actor **serializes** access | ✅ Two calls do not mutate `value` at the same time |
| Actor **prevents** lost updates with `await` between read and write | ❌ Reentrancy |

An actor is not a mutex held for the entire method. At a **suspension point** (`await`) the current call **releases** the actor and another isolated call can enter.

### Timeline

```
Task A: read value=0 → await yield → [suspend]
Task B: read value=0 → await yield → [suspend]
Task A: value = 0+1 = 1
Task B: value = 0+1 = 1   // stale current
```

`async let a` and `async let b` start in parallel — both reach `await` almost immediately.

Lost update is a reentrancy trap, **not a data race**: state is protected by the actor, but the logic is wrong.

### Why not the other options

- **“Serializes → 2”** — true only without suspension between read and write (`value += 1` with no `await`).
- **Compile error** — `async let` with actor methods compiles fine.
- **Data race** — no race on a single actor’s storage; this is a **logic bug**.

### How to write safely

```swift
func increment() {
    value += 1
}

func increment() {
    value = value + 1
}

// ❌ read → await → write with a stale local
func increment() async {
    let current = value
    await something()
    value = current + 1
}
```

After `await`, re-check invariants or work from a snapshot.

### Link to GCD

A serial queue without `await` inside the block holds the queue for the whole body. An actor with `await` releases the “lock” while waiting → reentrancy.

**One-liner:** an actor removes data races but does not protect against lost updates across `await`.

---

## 3. Performance: 10,000 small models — struct vs class in array

### Question

Which statement is most accurate for a performance-sensitive path with 10,000 small objects in an array?

Options:

1. struct is slower — COW copies the entire array on every mutation
2. Same performance — ARC makes class arrays indistinguishable
3. **struct array stores elements contiguously, cache-friendly, no per-element heap; class array — pointers, heap per object + dereference** ✅
4. class is faster — O(1) dereference; struct is copied on every read

### Answer

**Option 3.**

### Memory layout

```
[SmallStruct]  →  |s₀|s₁|s₂|...|s₉₉₉₉|   one buffer, dense packing

[SmallClass]   →  |→obj₀|→obj₁|→obj₂|...|   pointer buffer
                    ↓     ↓     ↓
                   heap  heap  heap
```

| | `[SmallModel]` struct | `[SmallModel]` class |
|--|-------------------------|----------------------|
| Array buffer | Densely packed values | Contiguous array of **pointers** |
| Per element | In buffer, no separate alloc | Separate heap allocation |
| 10k iteration | Sequential memory access | 10k pointer chase, cache misses |
| Array mutation | COW — buffer copy only on shared + write | ARC retain/release when passing references |

### Why not the others

- **COW** does not run on **every** mutation — only on shared buffer + write.
- Contiguous storage for a class array applies to the **pointer array**, not the object payloads.
- Reading a struct from an array copies a small value — cheaper than scattered heap objects.

### Caveats

- A very **large** struct — pass-by-value copy costs more.
- Need **identity** (`===`) or shared mutation — use a class.
- Frequent shared copies of the array + mutations — COW buffer copies; sometimes `ContiguousArray`.

**One-liner:** for 10k small value models, a dense struct array is cache-friendly; a class array is heap + pointer chase.

---

## 4. `@MainActor` and call from non-isolated `async`

### Question

```swift
@MainActor
class ViewModel {
    var title = "Hello"

    func updateTitle(_ newTitle: String) {
        title = newTitle
    }
}

class DataService {
    let viewModel = ViewModel()

    func fetchData() async {
        let result = await someAPICall()
        viewModel.updateTitle(result) // ← this line
    }
}
```

Options:

1. Runtime crash — `MainActorViolation`
2. Compiles, automatic hop to main without `await`
3. Runs on the current thread — `@MainActor` is only advisory
4. **Compile error — cannot call from non-isolated async without `await`** ✅

### Answer

**Compile error** (Swift 6 strict concurrency; warning in Swift 5). Correct option — **4**.

### Isolation crossing

`ViewModel` is isolated on `@MainActor`. `fetchData()` is nonisolated async. Calling `updateTitle` is an **isolation crossing** → requires a hop:

```swift
await viewModel.updateTitle(result)
```

Here `await` is not “waiting for the network” — it **switches the isolation domain** to the main actor.

### Why not the other options

| Option | Reality |
|--------|---------|
| Runtime crash | Primarily compile-time; debug runtime checks are a separate topic (see [Swift-6-Runtime-Concurrency-Crashes](Swift-6-Runtime-Concurrency-Crashes.md)) |
| Automatic hop without `await` | No |
| Advisory | No — enforcement, not a hint |

### Typical fix

```swift
func fetchData() async {
    let result = await someAPICall()
    await viewModel.updateTitle(result)
}
```

### Follow-up

- `@MainActor` on class vs method.
- `nonisolated` on a ViewModel method.
- `Sendable` when passing data across isolation domains.

**One-liner:** cross-actor call = `await`, otherwise compile error in strict concurrency.

---

## 5. What an actor is and what problem it solves

### Short answer (1–2 sentences)

An **actor** is a reference type where only one task mutates state at a time; the compiler requires `await` for external access — protection against **data races** on shared mutable state. Before actors: **serial queues and locks**; main caveat — **reentrancy at `await`**: another call can interleave between read and write; logic breaks without a data race.

### In depth

**What it is:** a type with mutual exclusion for mutable state plus compile-time isolation checks. `@MainActor` is the same idea for the UI thread.

**Problem it solves:** safe **shared mutable state** under concurrency (data races, “which thread may touch this”).

**What came before:**

- Serial `DispatchQueue`
- Locks (`NSLock`, `os_unfair_lock`, …)
- “Main thread only” for UI
- Immutability / value types where possible

**What an actor does not give you:**

| Myth | Reality |
|------|---------|
| “Whole app is thread-safe” | Races between actors, `nonisolated`, non-Sendable references |
| “Parallelizes CPU inside” | One actor = one queue of work |
| “Like a mutex for the whole method” | `await` releases the actor |
| “Replaces DB transactions” | Network/disk are separate contracts |

### Comparison with predecessors

| | Serial queue + lock | Actor |
|--|---------------------|-------|
| Data race on one state | ✅ with discipline | ✅ by design |
| Reentrancy at await | N/A (sync block) | ⚠️ yes |
| Compile-time | ❌ | ✅ Swift 6 |
| Deadlock | queue A ↔ B | actor A ↔ B via `await` |

### Caveats

| Risk | Essence |
|------|---------|
| Reentrancy | `await` inside an actor method — window for another call |
| Deadlock | Mutual `await` between two actors |
| Overhead | Cross-actor call — suspend + scheduling |
| No CPU speedup | Work inside one actor does not parallelize |
| `nonisolated` / non-`Sendable` | Guarantees can be bypassed |
| Debugging | Suspension order is harder to reproduce |

**One-liner:** actor = anti data race, not anti logic bugs.

---

## One-line cheat sheet

| Topic | Remember |
|-------|----------|
| Class in a copied array | Array of references is copied; objects are shared |
| Actor + `await` inside | Reentrancy → lost updates possible |
| 10k small models | Struct array — dense memory; class — heap + dereference |
| `@MainActor` from background | Need `await`, else compile error |
| Actor | Anti data race, not anti logic bugs |
| Value type vs stack | Value type ≠ stack; copy semantics, not storage location (§6) |

---

## 6. Value type vs stack vs heap (interview)

### Question

Can **value types** live on the **heap**?

### Answer

**Yes.** A **value type** defines **copy semantics** (value semantics), not storage location.

| Context | Where the value usually lives |
|---------|--------------------------------|
| Local variable | Often **stack** (or registers / inline in the frame) |
| Stored property of a **`class`** | **Embedded** in the class object’s heap allocation |
| **Escaping closure** capture | May end up in the closure’s **heap** context |
| `Array` / `String` / … buffer | **CoW** buffer on **heap**, even though the type is a `struct` |

### Main idea

**Value type ≠ stack. Reference type ≠ heap.**

In an interview, lead with **semantics** (`struct` / `enum` / **tuple** — independent copies; `class` — shared **identity**), then clarify **where** the bytes live.

### Interview follow-up

- **Tuple** — value type? → **Yes** (like a `struct` without a named type).
- **Tuple** on the heap? → **Yes**, if it has a `class` field or escaping capture — same rules as any value type.
- **Reference type** always on heap? → Practically always for `class`/`actor`; what matters is that **value/reference** is about **semantics**, not “stack only / heap only”.

### Links

- [syntax Q45–Q47](../../syntax/README.md) — value vs reference, `struct` layout inside `class`
- [memory-arc README](../../memory-arc/README.md) — memory regions, CoW
- **§1** in this file — copying `[Class]` = shallow for elements

**One-liner:** value type describes **how copying works**; heap/stack is **where bytes ended up** in a given context.

---

## 7. Quick answers (flashcards)

| Question | Short answer | More detail |
|----------|--------------|-------------|
| Value type always on stack? | **No.** | [§6](#6-value-type-vs-stack-vs-heap-interview) |
| Reference type always on heap? | Practically yes for `class`, but the axis is **semantics**, not address. | [§6](#6-value-type-vs-stack-vs-heap-interview), [syntax Q45](../../syntax/README.md) |
| What does **`weak`** do? | Does not retain; after dealloc → **`nil`** (zeroing). | [memory-arc Q47](../../memory-arc/README.md) |
| **Tuple** — value type? | **Yes.** | [syntax Q59](../../syntax/README.md) |
| Tuple on heap? | **Yes** — `class` field or escaping capture. | [§6](#6-value-type-vs-stack-vs-heap-interview), [syntax Q59](../../syntax/README.md) |

---

## TODO (draft)

- [ ] Add playground with runnable examples (Q1 array copy, Q2 counter)
- [ ] Link to Q&A cards in the main README (new ids or section refs)
- [ ] Extra questions: `Sendable`, `nonisolated`, two-actor deadlock, bank transfer reentrancy
