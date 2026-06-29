# Computer Science

## In 30 seconds

Computer science fundamentals explain *why* Swift and iOS behave the way they do: stack vs heap, algorithmic cost, concurrency primitives, caching, and common data structures. Interviewers use these topics to test whether you can reason about performance, memory, and correctness—not just API names. On iOS you rarely implement a red-black tree from scratch, but you must connect Big-O to scrolling lists, explain why a closure may escape to the heap, and choose the right structure for a cache or queue. Solid CS basics make answers about ARC, GCD, and networking sound grounded instead of memorized.

## Apple docs

- [MemoryLayout](https://developer.apple.com/documentation/swift/memorylayout) — size, stride, alignment of Swift types; ties stack/heap reasoning to real APIs.
- [ContiguousArray](https://developer.apple.com/documentation/swift/contiguousarray) — dense storage when cache locality matters vs `Array` flexibility.
- [Automatic Reference Counting (Swift Book)](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/) — reference types, heap lifetime, cycles.
- [Copy-on-Write collections](https://developer.apple.com/documentation/swift/array) — value semantics with heap-backed buffers.
- [Concurrency (Swift Book)](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/) — tasks, actors, structured concurrency vs threads.
- [Operation and OperationQueue](https://developer.apple.com/documentation/foundation/operation) — higher-level scheduling on top of GCD.
- [Measurement](https://developer.apple.com/documentation/foundation/measurement) — typed units; useful when discussing numeric precision and conversions in domain models.
- [JSONEncoder / JSONDecoder performance patterns](https://developer.apple.com/documentation/foundation/jsondecoder) — decoding cost on large payloads (CPU + memory).

## 🎯 Focus vs Defer

### Focus

- **Stack vs heap for Swift types** — when values live on the stack, when buffers or reference types go to the heap, and why `@escaping` closures often allocate.
  - **Answer:** Stack = LIFO frames for locals and call chains; fast, scoped lifetime. Heap = dynamic allocation for reference types, large/copy-on-write buffers, escaping captures. A `struct` with only small value fields is usually stack-friendly; adding a `class` property or existential pushes work to the heap. Interview hook: “ARC counts heap objects; stack frames disappear when the function returns.”

- **Big-O for mobile work** — O(1), O(log n), O(n), O(n log n), O(n²); tie to scrolling, search, and network batching.
  - **Answer:** UITableView/UICollectionView reuse avoids O(n) view creation. Linear scan of 10k items on main thread is O(n) UI risk. Sorting for display is often O(n log n). Nested loops over users × permissions is O(n²)—red flag in code review. You do not need to derive master theorem; you need to spot bottlenecks.

- **Process vs thread vs task** — OS units vs Swift Concurrency.
  - **Answer:** Process = isolated address space (iOS app sandbox is one app process). Thread = OS-scheduled execution within a process; preemption and shared memory. GCD/OperationQueue map work to thread pools. Swift `Task` is structured concurrency—lighter scheduling model, still runs on threads under the hood. Main thread = one serial queue tied to UI and RunLoop.

- **Caching trade-offs** — CPU vs memory vs staleness; NSCache, URLCache, in-memory dictionaries.
  - **Answer:** Cache when recomputation or network is expensive and stale data is acceptable within TTL. Key risks: unbounded memory (use cost/limit like `NSCache`), stale UI after invalidation, thread safety. Always define eviction and invalidation policy in the answer.

- **Core data structures for app code** — array, dictionary/hash map, set, queue, stack, linked list concepts.
  - **Answer:** Swift `Array` + `Dictionary` cover most cases. Queue = FIFO (pending uploads); stack = LIFO (undo, DFS). Hash map gives average O(1) lookup for indexes. Linked lists rarely appear directly in Swift; understanding them explains pointer-chasing cost vs array index access.

- **Amortized complexity** — why `Array.append` is usually cheap but sometimes expensive.
  - **Answer:** Dynamic arrays over-allocate; most appends O(1) amortized, occasional O(n) copy when capacity grows. Mention when batching inserts or pre-allocating `reserveCapacity` helps.

### Defer

- Implementing balanced trees, skip lists, or custom allocators from scratch—unless the role is systems/algorithm heavy.
- Formal proofs of correctness for sorting algorithms—know properties (stable vs unstable) at a high level instead.
- Deep CPU cache line optimization without Instruments evidence—defer until profiling shows a hotspot.
- Competitive-programming math tricks unrelated to UI, networking, or persistence on device.

## Key concepts

- **Stack:** LIFO memory for activation records; locals and call frames; automatic reclamation on return.
- **Heap:** Dynamic region for objects with unknown or shared lifetime; managed by ARC in Swift for reference types.
- **Big-O notation:** Upper-bound growth rate of time or space vs input size; used to compare algorithms asymptotically.
- **Amortized analysis:** Average cost over a sequence of operations (e.g. dynamic array append).
- **Process:** OS-level program instance with private virtual memory; iOS apps run in a sandboxed process.
- **Thread:** Unit of execution within a process; shares address space; requires synchronization for mutable shared state.
- **Race condition:** Outcome depends on interleaving of concurrent access without proper synchronization.
- **Hash table (`Dictionary`):** Key → value with average O(1) lookup; hash collisions handled by the runtime.
- **Queue (FIFO):** First-in-first-out; work queues, BFS, async job ordering.
- **Stack (ADT):** Last-in-first-out; undo stacks, parsing, DFS.
- **Cache locality:** Using contiguous memory (arrays) so CPU caches hit more often; matters for hot loops.
- **Copy-on-Write (CoW):** Value types share storage until mutation; Swift `Array`/`String`/`Dictionary` use CoW buffers on the heap.

## 🏋️ Exercises

1. **Stack vs heap:** For `struct Point { var x, y: Int }`, `class Node { var next: Node? }`, and `{ [self] in ... }` escaping closure capturing `self`, classify stack vs heap components. **Expected:** Point likely stack; Node and closure context on heap; explain ARC on `Node`.
2. **Big-O spot check:** Given nested `for user in users { for order in user.orders { ... } }`, state complexity and one refactor to improve worst case. **Expected:** O(n×m); index orders by `userId` in a `[ID: [Order]]` dictionary first.
3. **Structure pick:** Design an in-memory LRU cache for 100 image thumbnails with max 20 MB. **Expected:** hash map + doubly-linked list or use `NSCache` with `totalCostLimit`; define eviction on memory warning.
4. **Thread vs Task:** Rewrite a callback-based retry loop as `async/await` and explain what still runs on threads. **Expected:** structured tasks; underlying thread pool unchanged; cancellation propagates.
5. **Amortized cost:** Append 1…10_000 to `[Int]()` with and without `reserveCapacity(10_000)`; reason about allocations without benchmarking. **Expected:** fewer reallocations with reserve; tie to CoW if copies exist.

## Links

- WWDC 2021 — [Explore structured concurrency in Swift](https://developer.apple.com/videos/play/wwdc2021/10132/)
- WWDC 2020 — [Data Essentials in SwiftUI](https://developer.apple.com/videos/play/wwdc2020/10040/) — value types, identity, performance mindset
- [Swift Memory Layout (Swift Book)](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/memorylayout/)
- [Energy Efficiency Guide for iOS Apps](https://developer.apple.com/library/archive/documentation/Performance/Conceptual/EnergyGuide-iOS/) — algorithmic work and wakeups
- External: [Big-O Cheat Sheet](https://www.bigocheatsheet.com/) — quick complexity reference for interviews

---

## Interview Q&A (Knowledge cards)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question:** Stack vs heap—what is the difference and how does it relate to Swift?

- **Answer:** Stack holds call frames and locals with scoped lifetime; heap holds dynamically allocated objects. Swift reference types and escaping closures live on the heap under ARC; value types are often stack-allocated but may use heap-backed CoW storage for collections.

### Q2
- **Question:** Explain Big-O using a list in an iOS app.

- **Answer:** Big-O describes growth with input size n. Index access is O(1); full array transforms on the main thread are O(n); sorting is O(n log n); nested scans are O(n²). Table/collection reuse keeps UI work proportional to visible items, not total n.

### Q3
- **Question:** Process vs thread—what matters for iOS developers?

- **Answer:** A process is an isolated memory space (iOS app sandbox). Threads share memory within a process; the main thread drives UI. GCD schedules blocks on thread pools; Swift tasks add structured concurrency but still require synchronization for shared mutable state.

### Q4
- **Question:** When and how should you cache on iOS?

- **Answer:** Cache when recomputation or network is costly and staleness is acceptable. Use URLCache for HTTP, NSCache for memory-sensitive objects, or layered memory+disk with explicit TTL and invalidation. Always cap size and respond to memory pressure.

<!-- knowledge-cards-canonical:end -->
