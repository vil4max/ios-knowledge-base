# Concurrency evolution on Apple platforms: threads to Swift Concurrency

**Purpose:** one timeline of abstractions — **what came after what**, why, and a **minimal example**. For interviews and legacy migration. Linked to topic **08:** [intro notes `Swift-Concurrency.md`](../Swift-Concurrency.md) (anchor [`#concurrency-primer-s0`](../Swift-Concurrency.md#concurrency-primer-s0)).

**Playground** (all approaches in sequence, with comments in code): [`ConcurrencyEvolutionFromThreads.playground/Contents.swift`](../ConcurrencyEvolutionFromThreads.playground/Contents.swift).

---

## Table of contents

## 1. OS process and thread

## 2. Explicit thread: `Thread`

## 3. [RunLoop](../../../glossary/README.md#glossary-runloop) and one thread

## 4. GCD: queues and blocks

## 5. `Operation` and `OperationQueue`

## 6. Callbacks and delegates (without `async`)

## 7. Combine as a layer over GCD

## 8. Swift Concurrency

## 9. Same task: four eras

## 10. Summary table

## 11. Links
