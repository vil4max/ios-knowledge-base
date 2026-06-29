# Data Structures & Big-O

## In 30 seconds

Mobile interviews still test **arrays, hash maps, sets, stacks, queues, trees, and graphs** plus **Big-O** for time and space. You rarely implement a red-black tree on iOS, but you must reason about **lookup vs insert**, sorting cost, and **when Swift `Dictionary`/`Set`/`Array` fit**. Pair theory with 2–3 LeetCode-medium patterns: two pointers, BFS/DFS, sliding window.

## Apple docs & Swift

- [Swift Collections](https://developer.apple.com/documentation/swift/array) — `Array`, `Dictionary`, `Set` complexity expectations.
- [Sequence](https://developer.apple.com/documentation/swift/sequence) — `sorted()`, `filter`, lazy chains.
- [Choosing between structures and classes](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/classesandstructures/) — value semantics and CoW.

## 🎯 Focus vs Defer

### Focus

- **Big-O:** O(1), O(log n), O(n), O(n log n), O(n²)—recognize in loops and nested structures.
- **Hash map / set:** O(1) average lookup; counting frequencies; deduplication.
- **Stack / queue:** parsing, BFS (queue), DFS (stack/recursion), undo stacks.
- **Two pointers / sliding window:** sorted arrays, substring problems.
- **Trees & graphs:** BFS shortest path unweighted; DFS connectivity; don't mutate while iterating Swift collections.

### Defer

- Proving amortized analysis formally unless staff-level algorithms round.
- Implementing **custom balanced trees** in interview unless explicitly asked.
- Memorizing 200 LeetCode hard problems—prefer 30 representative patterns with explanations.

## 📚 Key terms (Q&A)

- Jeff Erickson track (RU + EN): `notes/jeff-erickson-track.md`

## 🏋️ Exercises

- Use `notes/jeff-erickson-track.md` + paired playgrounds as chapter exercises.

## Artifacts

- Notes: `notes/`
- Exercises: `exercises/`
- Assets: `assets/`
- Playgrounds: `playgrounds/`
- Practice: `practice/LeetCode/` (local algorithm track)

## Jeff Erickson Chapters (implemented)

- 13 chapter summaries in `notes/jeff_erickson_*.md`
- 13 paired playgrounds in `playgrounds/Jeff*.playground/Contents.swift`

---

## Universal

- [ ] Problem constraints are explicit (`n`, value ranges, time/memory limits).
- [ ] Complexity is stated before coding.
- [ ] At least one invariant is named.
- [ ] Edge cases are listed and tested.
- [ ] Alternative approach and trade-off are mentioned.

## Recursion / Backtracking

- [ ] Base case is reachable.
- [ ] Progress measure strictly decreases.
- [ ] No accidental shared mutable state leaks across branches.
- [ ] Rollback (`popLast`, unmark visited) is always symmetric.
- [ ] Pruning rule is justified as safe.

## Dynamic Programming

- [ ] State is minimal but sufficient.
- [ ] Transition uses only already-computed dependencies.
- [ ] Initialization/base row or column is correct.
- [ ] Index bounds and off-by-one are verified.
- [ ] Memory compression does not break dependencies.

## Greedy

- [ ] Greedy choice is proven (exchange/stay-ahead), not assumed.
- [ ] Counterexample search was done.
- [ ] Sorting key is correct and justified.
- [ ] Tie-breaking does not break correctness.

## Graphs / DFS / BFS

- [ ] Graph representation matches density and operations.
- [ ] Disconnected components are handled.
- [ ] `visited` lifecycle is correct.
- [ ] Directed vs undirected behavior is not mixed.
- [ ] Path reconstruction stores parent correctly.

## Shortest Paths

- [ ] Dijkstra used only for nonnegative weights.
- [ ] Infinity sentinel cannot overflow on addition.
- [ ] Relaxation condition is correct.
- [ ] Negative cycle logic present where needed.

## APSP

- [ ] Floyd-Warshall loop order is `k -> i -> j`.
- [ ] Diagonal initialized correctly (`dist[i][i] = 0` if appropriate).
- [ ] Negative cycle check via diagonal is performed.

## Flow / Cut

- [ ] Residual edges are updated both forward and reverse.
- [ ] BFS/DFS in residual graph checks positive residual capacity.
- [ ] Augmenting path bottleneck is computed correctly.
- [ ] Source/sink and capacities reflect original problem constraints.

## NP-Hardness

- [ ] Reduction direction is correct.
- [ ] Both yes/no directions are argued.
- [ ] Transformation is polynomial time.
- [ ] Practical strategy after classification is stated (exact/approx/FPT/heuristic).

---

## Day 1 — Foundations + Recursion

- Read: Chapter 1 + Chapter 2 notes.
- Run: `Jeff01_Introduction.playground`, `Jeff02_Recursion.playground`.
- Solve: 1 easy recursion task.
- Deliverable: explain recurrence and base case in 60 seconds.

## Day 2 — Backtracking + DP basics

- Read: Chapter 3 + Chapter 4 notes.
- Run: `Jeff03_Backtracking.playground`, `Jeff04_DynamicProgramming.playground`.
- Solve: 1 backtracking + 1 DP easy/medium.
- Deliverable: when to switch from recursion to DP.

## Day 3 — Greedy + Graph foundations

- Read: Chapter 5 + Chapter 6 notes.
- Run: `Jeff05_Greedy.playground`, `Jeff06_BasicGraphs.playground`.
- Solve: interval scheduling + BFS components.
- Deliverable: one valid greedy proof sketch.

## Day 4 — DFS + MST

- Read: Chapter 7 + Chapter 8 notes.
- Run: `Jeff07_DFS.playground`, `Jeff08_MST.playground`.
- Solve: cycle detection + Kruskal/Prim task.
- Deliverable: explain cut property in your own words.

## Day 5 — Shortest paths + APSP

- Read: Chapter 9 + Chapter 10 notes.
- Run: `Jeff09_ShortestPaths.playground`, `Jeff10_APSP.playground`.
- Solve: one Dijkstra task + one Floyd-Warshall task.
- Deliverable: decision rule BFS vs Dijkstra vs Bellman-Ford.

## Day 6 — Flow core + applications

- Read: Chapter 11 + Chapter 12 notes.
- Run: `Jeff11_MaxFlow.playground`, `Jeff12_FlowApplications.playground`.
- Solve: one max-flow and one matching reduction task.
- Deliverable: explain residual graph and min cut extraction.

## Day 7 — NP-hardness + consolidation

- Read: Chapter 13 + `jeff-erickson-interview-cram.md`.
- Run: `Jeff13_NPHardness.playground`.
- Solve: one reduction explanation (3-SAT -> VC or similar).
- Deliverable: 10-minute mock interview self-review across all topics.

## Final self-check

- Can I classify a new problem in under 2 minutes?
- Can I justify algorithm choice with complexity and invariant?
- Can I provide at least one alternative approach and trade-off?
- Can I explain where the approach fails (counterexample/limitations)?

---

## 1) Introduction

## 2) Recursion

## 3) Backtracking

## 4) Dynamic Programming

## 5) Greedy

## 6) Basic Graph Algorithms

## 7) DFS

## 8) MST

## 9) Shortest Paths

## 10) APSP

## 11) Max Flow / Min Cut

## 12) Flow Applications

## 13) NP-Hardness

## How to answer fast in interview

- Step 1: classify input (array/tree/graph, weighted/unweighted, constraints).
- Step 2: map to pattern (recursion/backtracking/DP/greedy/graph-flow).
- Step 3: state complexity before coding.
- Step 4: mention correctness invariant in one sentence.
- Step 5: code minimal clean version and test 2 edge cases.

---

## Chapters

1. `jeff_erickson_01_introduction.md` + `../playgrounds/Jeff01_Introduction.playground/Contents.swift`
2. `jeff_erickson_02_recursion.md` + `../playgrounds/Jeff02_Recursion.playground/Contents.swift`
3. `jeff_erickson_03_backtracking.md` + `../playgrounds/Jeff03_Backtracking.playground/Contents.swift`
4. `jeff_erickson_04_dynamic_programming.md` + `../playgrounds/Jeff04_DynamicProgramming.playground/Contents.swift`
5. `jeff_erickson_05_greedy_algorithms.md` + `../playgrounds/Jeff05_Greedy.playground/Contents.swift`
6. `jeff_erickson_06_basic_graph_algorithms.md` + `../playgrounds/Jeff06_BasicGraphs.playground/Contents.swift`
7. `jeff_erickson_07_depth_first_search.md` + `../playgrounds/Jeff07_DFS.playground/Contents.swift`
8. `jeff_erickson_08_minimum_spanning_trees.md` + `../playgrounds/Jeff08_MST.playground/Contents.swift`
9. `jeff_erickson_09_shortest_paths.md` + `../playgrounds/Jeff09_ShortestPaths.playground/Contents.swift`
10. `jeff_erickson_10_all_pairs_shortest_paths.md` + `../playgrounds/Jeff10_APSP.playground/Contents.swift`
11. `jeff_erickson_11_max_flows_min_cuts.md` + `../playgrounds/Jeff11_MaxFlow.playground/Contents.swift`
12. `jeff_erickson_12_flow_cut_applications.md` + `../playgrounds/Jeff12_FlowApplications.playground/Contents.swift`
13. `jeff_erickson_13_np_hardness.md` + `../playgrounds/Jeff13_NPHardness.playground/Contents.swift`

## How to study

- Read one chapter summary first.
- Run the paired playground.
- Solve at least one extra problem in `practice/LeetCode/` with the same pattern.
- Return and write a 3-line recap: idea, invariant, complexity.

---

## Core idea

## Chapter link

- Book chapter: [Introduction](https://jeffe.cs.illinois.edu/teaching/algorithms/book/00-intro.pdf)

## Mental model

## Complexity checklist

## Proof intuition

## Typical tasks

## Common mistakes

## Practice prompt

## Interview framing

## Key statements

## Must-know tasks

## Explain in 60 seconds

---## Core idea

## Chapter link

- Book chapter: [Recursion](https://jeffe.cs.illinois.edu/teaching/algorithms/book/01-recursion.pdf)

## Mental model

## Complexity checklist

## Proof intuition

## Typical tasks

## Common mistakes

## Practice prompt

## Interview framing

## Key statements

## Must-know tasks

## Explain in 60 seconds

---## Core idea

## Chapter link

- Book chapter: [Backtracking](https://jeffe.cs.illinois.edu/teaching/algorithms/book/02-backtracking.pdf)

## Mental model

## Complexity checklist

## Proof intuition

## Typical tasks

## Common mistakes

## Practice prompt

## Interview framing

## Key statements

## Must-know tasks

## Explain in 60 seconds

---## Core idea

## Chapter link

- Book chapter: [Dynamic Programming](https://jeffe.cs.illinois.edu/teaching/algorithms/book/03-dynprog.pdf)

## Mental model

## Complexity checklist

## Proof intuition

## Typical tasks

- Knapsack.
- Longest Common Subsequence.
- Edit Distance.

## Common mistakes

## Practice prompt

## Interview framing

## Key statements

## Must-know tasks

- Easy: Climbing Stairs / House Robber.

## Explain in 60 seconds

---## Core idea

## Chapter link

- Book chapter: [Greedy Algorithms](https://jeffe.cs.illinois.edu/teaching/algorithms/book/04-greedy.pdf)

## Mental model

## Complexity checklist

## Proof intuition

## Typical tasks

- Interval Scheduling.
- Huffman coding.
- Activity selection.

## Common mistakes

## Practice prompt

## Interview framing

## Key statements

## Must-know tasks

## Explain in 60 seconds

---## Core idea

## Chapter link

- Book chapter: [Basic Graph Algorithms](https://jeffe.cs.illinois.edu/teaching/algorithms/book/05-graphs.pdf)

## Mental model

## Complexity checklist

## Proof intuition

## Typical tasks

## Common mistakes

## Practice prompt

## Interview framing

## Key statements

## Must-know tasks

## Explain in 60 seconds

---## Core idea

## Chapter link

- Book chapter: [Depth-First Search](https://jeffe.cs.illinois.edu/teaching/algorithms/book/06-dfs.pdf)

## Mental model

## Complexity checklist

## Proof intuition

## Typical tasks

- Topological sort.
- Cycle detection.
- Strongly connected components.

## Common mistakes

## Practice prompt

## Interview framing

## Key statements

## Must-know tasks

- Medium: strongly connected components (Kosaraju/Tarjan conceptual level).

## Explain in 60 seconds

---## Core idea

## Chapter link

- Book chapter: [Minimum Spanning Trees](https://jeffe.cs.illinois.edu/teaching/algorithms/book/07-mst.pdf)

## Mental model

## Complexity checklist

## Proof intuition

## Typical tasks

## Common mistakes

## Practice prompt

## Interview framing

## Key statements

## Must-know tasks

## Explain in 60 seconds

---## Core idea

## Chapter link

- Book chapter: [Shortest Paths](https://jeffe.cs.illinois.edu/teaching/algorithms/book/08-sssp.pdf)

## Mental model

## Complexity checklist

- EN: Dijkstra with heap: `O((V + E) log V)`.
- RU: Bellman-Ford: `O(VE)`.
- EN: Bellman-Ford: `O(VE)`.

## Proof intuition

## Typical tasks

## Common mistakes

## Practice prompt

## Interview framing

## Key statements

## Must-know tasks

- Easy: shortest path in unweighted graph (BFS).
- Medium: network delay time / cheapest route with weighted edges.

## Explain in 60 seconds

---## Core idea

## Chapter link

- Book chapter: [All-Pairs Shortest Paths](https://jeffe.cs.illinois.edu/teaching/algorithms/book/09-apsp.pdf)

## Mental model

## Complexity checklist

## Proof intuition

## Typical tasks

## Common mistakes

## Practice prompt

## Interview framing

## Key statements

## Must-know tasks

## Explain in 60 seconds

---## Core idea

## Chapter link

- Book chapter: [Maximum Flows & Minimum Cuts](https://jeffe.cs.illinois.edu/teaching/algorithms/book/10-maxflow.pdf)

## Mental model

## Complexity checklist

## Proof intuition

## Typical tasks

## Common mistakes

## Practice prompt

## Interview framing

## Key statements

## Must-know tasks

## Explain in 60 seconds

---## Core idea

## Chapter link

- Book chapter: [Applications of Flows and Cuts](https://jeffe.cs.illinois.edu/teaching/algorithms/book/11-maxflowapps.pdf)

## Mental model

## Complexity checklist

## Proof intuition

## Typical tasks

- Bipartite matching.
- Project selection.
- Image segmentation (graph cut formulation).

## Common mistakes

## Practice prompt

## Interview framing

## Key statements

## Must-know tasks

## Explain in 60 seconds

---## Core idea

## Chapter link

- Book chapter: [NP-Hardness](https://jeffe.cs.illinois.edu/teaching/algorithms/book/12-nphard.pdf)

## Mental model

## Complexity checklist

## Proof intuition

## Typical tasks

- SAT/3-SAT reductions.
- Clique/Vertex Cover/Independent Set.
- Subset Sum variations.

## Common mistakes

## Practice prompt

## Interview framing

## Key statements

## Must-know tasks

## Explain in 60 seconds

---## How to answer

- Start with classification (array/tree/graph, weighted/unweighted, constraints).
- Name the candidate patterns (greedy/DP/graph/etc.).
- Pick one approach and state complexity.
- State one correctness invariant.
- Mention one alternative with trade-off.

## Questions

1) Explain why asymptotic complexity still matters when constants differ a lot.
2) When would you choose recursion over iteration in production Swift code?
3) Give a safe pruning rule for N-Queens and prove it does not remove valid solutions.
4) How do you detect that a recursion problem should become DP?
5) Define DP state for Coin Change (minimum coins).
6) Why does greedy fail for some coin systems?
7) Give an exchange argument for interval scheduling.
8) Adjacency list vs adjacency matrix: when and why?
9) How do you find all connected components in an undirected graph?
10) How do you detect cycle in a directed graph with DFS colors?
11) Why does reverse postorder produce topological sorting in DAG?
12) Kruskal vs Prim: which one for sparse graph and why?
13) Prove one MST property (cut or cycle) informally but clearly.
14) Why is Dijkstra invalid with negative edges?
15) How to detect negative cycle with Bellman-Ford?
16) How to reconstruct shortest path, not just distance?
17) When is Floyd-Warshall better than repeated Dijkstra?
18) How to detect negative cycles in APSP matrix?
19) Explain residual graph in your own words.
20) Why does "no augmenting path" imply max flow?
21) How to extract minimum cut after max flow completion?
22) Show reduction from bipartite matching to max flow.
23) What makes a reduction "correct" in NP-hard proofs?
24) NP-hard vs NP-complete: practical engineering implications.
25) Give one reason to choose approximation over exact algorithm.
26) Give one reason to choose heuristic over approximation.
27) For a new problem, how do you decide between greedy and DP quickly?
28) Which edge cases do you always test for graph algorithms?
29) Which edge cases do you always test for DP table solutions?
30) Explain one topic from this track in 60 seconds.
31) Whiteboard task: shortest path in unweighted graph + path restoration.
32) Whiteboard task: topological sort + cycle check.
33) Whiteboard task: DSU operations and Kruskal.
34) Whiteboard task: Bellman-Ford with negative cycle detection.
35) Whiteboard task: Edmonds-Karp on a 5-node network.

## Quick scoring rubric

- 0: no clear approach.
- 1: approach exists but no complexity/correctness.
- 2: approach + complexity.
- 3: approach + complexity + invariant + trade-off.

---

## Leveling (1–5)

1. Valid Anagram
   Pattern: hashing/sorting baseline.
   Why: fast complexity comparison practice.

2. Contains Duplicate
   Pattern: set vs sort trade-off.
   Why: immediate `O(n)` vs `O(n log n)` reasoning.

3. Binary Search
   Pattern: recursion/iteration invariant.
   Why: boundary management and correctness.

4. Maximum Subarray
   Pattern: DP/greedy (Kadane).
   Why: transition intuition with constant memory.

5. Climbing Stairs
   Pattern: DP basics.
   Why: state and base initialization.

## Core patterns (6–12)

6. Coin Change
   Pattern: DP (minimization).
   Why: state design and impossible states.

7. House Robber
   Pattern: DP on linear structure.
   Why: include/exclude thinking.

8. Combination Sum
   Pattern: backtracking.
   Why: branch control and pruning.

9. Permutations
   Pattern: backtracking with visited tracking.
   Why: rollback discipline.

10. Number of Islands
    Pattern: DFS/BFS components.
    Why: grid-as-graph conversion.

11. Course Schedule
    Pattern: directed cycle detection / topological sort.
    Why: DFS colors and DAG logic.

12. Clone Graph
    Pattern: graph traversal + mapping.
    Why: graph reconstruction correctness.

## Weighted graph and MST/paths (13–17)

13. Min Cost to Connect All Points
    Pattern: MST (Prim/Kruskal).
    Why: practical MST modeling.

14. Network Delay Time
    Pattern: Dijkstra.
    Why: single-source shortest paths.

15. Cheapest Flights Within K Stops
    Pattern: constrained shortest path (DP/Bellman-Ford style).
    Why: model constraints over edges/stops.

16. Path With Minimum Effort
    Pattern: graph shortest path with custom weight semantics.
    Why: adapting known algorithm to transformed metric.

17. Reconstruct Itinerary
    Pattern: graph traversal + ordering constraints (Eulerian-style reasoning).
    Why: advanced traversal correctness.

## Flow and complexity thinking (18–20)

18. Maximum Bipartite Matching (custom or platform-specific)
    Pattern: flow reduction.
    Why: flow modeling from constraints.

19. Word Ladder
    Pattern: BFS shortest transformation sequence.
    Why: implicit graph construction at scale.

20. NP-hard discussion task (non-coding): 3-SAT -> Vertex Cover sketch
    Pattern: reduction reasoning.
    Why: interview depth and theory-to-practice judgment.

## How to use this list

- Solve in order.
- For each problem, write:
  - chosen pattern,
  - complexity,
  - one invariant,
  - one alternative approach.
- Re-solve every medium task after 7 days without notes.

---

## Navigation

| Where | What |
|-------|------|
| **Learning plan** | Levels 0–9, theory → problems, with links |
| **Task checklist** | Flat list of all tasks (quick tick-off) |
| **Problem notes** | One note per problem: conditions, solution, thoughts, iOS tips |
| Theory: Big O | Complexity, O(n), O(log n), etc. |
| Theory: Arrays & Hashing | HashMap, collision, prefix sum |
| [LeetCode Explore](https://leetcode.com/explore/interview/) | Curated paths, quizzes, cheatsheets |

---

## Learning Rules

1. **Theory first** — read the topic doc before coding.
2. **Solve yourself** — implement before asking for help.
3. **Hints only** — if stuck, ask for hints, not full solutions.
4. **One problem per day** — steady pace over speed.

---

## Progress (by level)

| Level | Topic | Problems | Status |
|-------|-------|----------|--------|
| 0 | Foundation | Big O, Arrays & Hashing, 1 Two Sum | ⬜ |
| 1 | Arrays & Hashing | 49, 217, 238 | ⬜ |
| 2 | Two Pointers | 125, 167, 15, 11 | ⬜ |
| 3 | Sliding Window | 121, 3, 424 | ⬜ |
| 4 | Stack | 20, 155, 739 | ⬜ |
| 5 | Binary Search | 704, 74, 33, 153 | ⬜ |
| 6 | Linked List | 206, 21, 141, 23 | ⬜ |
| 7 | Trees | 104, 100, 226, 102 | ⬜ |
| 8 | Dynamic Programming | 70, 198, 62, 322 | ⬜ |

⬜ Not started | 🟡 In progress | ✅ Done

---

## Project Structure

```
LeetCode/
├── README.md                    # This file — navigation hub
├── TODO.md                      # Flat task checklist
├── docs/                        # Local-only (plan, theory, problem notes)
│   ├── LEARNING_PLAN.md
│   ├── 01-big-o.md, 02-arrays-hashing.md
│   └── problems/
├── LeetCode/                    # Xcode app — UI/sandbox
│   ├── LeetCodeApp.swift
│   ├── ContentView.swift
│   └── Assets.xcassets
├── LeetCodeTests/               # Xcode unit tests (scaffold; assertions live in Packages)
└── Packages/                    # One topic = one independent SPM
    ├── Arrays/                  # LeetCodeArrays
    ├── Stack/                   # LeetCodeStack
    ├── TwoPointers/             # LeetCodeTwoPointers
    ├── SlidingWindow/           # LeetCodeSlidingWindow
    ├── BinarySearch/            # LeetCodeBinarySearch
    ├── LinkedList/              # LeetCodeLinkedList
    ├── Trees/                   # LeetCodeTrees
    └── DynamicProgramming/      # LeetCodeDynamicProgramming
```

**Each package:** `Package.swift`, `Sources/`, `Tests/`, own README optional. Independent; link packages only if needed.

**Run tests:** `swift test --package-path Packages/Arrays` (or Stack, TwoPointers, etc.)

---

Project includes [@mcpfun/mcp-server-leetcode](https://www.npmjs.com/package/@mcpfun/mcp-server-leetcode) in `.cursor/mcp.json`. Requires Node.js.

**Tools:** `get-problem` (by titleSlug), `search-problems`, `get-daily-challenge`, `get-user-submissions` (progress sync).

**Title slugs for our problems:** `two-sum`, `group-anagrams`, `contains-duplicate`, `valid-parentheses`, `binary-search`, etc. — same as the LeetCode URL path.

---

## LeetCode Explore & Quizzes

- [Interview Crash Course](https://leetcode.com/explore/featured/card/leetcodes-interview-crash-course-data-structures-and-algorithms/) — 13 chapters
- [Cheatsheets](https://leetcode.com/explore/interview/card/cheatsheets) — Big O, templates
- [Beginner's Guide](https://leetcode.com/explore/featured/card/the-leetcode-beginners-guide/)
- [Explore Browse](https://leetcode.com/explore/) — topic quizzes (Array, Binary Search, etc.)

---

## Workflow

1. Open LEARNING_PLAN → pick the next level and problem.
2. Read theory in `docs/`, open the problem note and LeetCode.
3. Implement in `Packages/<Topic>/Sources/`, add tests in `Packages/<Topic>/Tests/`.
4. Run `swift test --package-path Packages/<Topic>`.
5. Add solution, thoughts, iOS notes to the problem file in `docs/problems/`.
6. Mark done in plan and TODO.

---

## Common Classes

| Notation | Name | Example | Growth |
|----------|------|---------|--------|
| O(1) | Constant | Array access by index | Independent of n |
| O(log n) | Logarithmic | Binary search | Halves work each step |
| O(n) | Linear | Single loop over array | Proportional to n |
| O(n log n) | Linearithmic | Merge sort, quicksort | Between linear and quadratic |
| O(n²) | Quadratic | Nested loops over array | Slow for large n |
| O(2ⁿ) | Exponential | Exhaustive combination search | Usually impractical |

---

## Examples

```
O(1):   arr[i]                    — index access
O(n):   for x in arr { ... }      — one pass
O(n²):  for i in arr { for j in arr } — all pairs
O(log n): while n > 0 { n /= 2 }  — halving
```

---

## Simplification Rules

- Drop constants: O(2n) → O(n), O(500) → O(1)
- Keep dominant term: O(n² + n) → O(n²)
- Nested loops often multiply: two loops over n → O(n²)

---

## Space Complexity

Same notation for memory:

- O(1) — fixed extra space (few variables)
- O(n) — array or hash map of size n
- O(n²) — 2D structure of size n×n

---

## Amortized Analysis

Some operations are sometimes expensive (e.g. Dynamic Array resize), but averaged over many calls they behave like O(1). We say **amortized O(1)**.

Example: `pushback` in Dynamic Array — O(1) amortized, even with occasional O(n) resize.

---

## Why It Matters

- Compare solutions before coding
- Understand editorials and solutions
- Know when to optimise and when to stop

---

## Key Structures

**Array** — contiguous storage, O(1) index access, O(n) search by value.

**HashMap (Dictionary)** — key→value, O(1) average get/set/contains.

**HashSet (Set)** — unique elements, O(1) average add/contains.

---

## Common Patterns

1. **Frequency map** — count occurrences: `[num: count]`
2. **Index map** — store value→index for O(1) lookups
3. **Set for uniqueness** — deduplication, "seen" checks

---

## Starter Problems

| # | Problem | Main idea |
|---|---------|-----------|
| 1 | Two Sum | HashMap: for each num, look for (target - num) |
| 49 | Group Anagrams | HashMap: sorted string → list of anagrams |
| 217 | Contains Duplicate | HashSet or compare lengths |
| 238 | Product of Array Except Self | Prefix/suffix products, O(n) without division |

---

Read this before solving Arrays & Hashing problems.

---

## Level 0: Foundation (1–2 weeks)

- [ ] Big O — docs/01-big-o.md
- [ ] Arrays & Hashing theory — docs/02-arrays-hashing.md
- [ ] LeetCode 1 — Two Sum · [LeetCode](https://leetcode.com/problems/two-sum/)
- [ ] (Optional) Dynamic Array — NeetCode

---

## Level 1: Arrays & Hashing

- [ ] 49 Group Anagrams · [LeetCode](https://leetcode.com/problems/group-anagrams/)
- [ ] 217 Contains Duplicate · [LeetCode](https://leetcode.com/problems/contains-duplicate/)
- [ ] 238 Product of Array Except Self · [LeetCode](https://leetcode.com/problems/product-of-array-except-self/)

---

## Level 2: Two Pointers

- [ ] 125 Valid Palindrome · [LeetCode](https://leetcode.com/problems/valid-palindrome/)
- [ ] 167 Two Sum II · [LeetCode](https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/)
- [ ] 15 3Sum · [LeetCode](https://leetcode.com/problems/3sum/)
- [ ] 11 Container With Most Water · [LeetCode](https://leetcode.com/problems/container-with-most-water/)

---

## Level 3: Sliding Window

- [ ] 121 Best Time to Buy and Sell Stock · [LeetCode](https://leetcode.com/problems/best-time-to-buy-and-sell-stock/)
- [ ] 3 Longest Substring Without Repeating · [LeetCode](https://leetcode.com/problems/longest-substring-without-repeating-characters/)
- [ ] 424 Longest Repeating Character Replacement · [LeetCode](https://leetcode.com/problems/longest-repeating-character-replacement/)

---

## Level 4: Stack

- [ ] 20 Valid Parentheses · [LeetCode](https://leetcode.com/problems/valid-parentheses/)
- [ ] 155 Min Stack · [LeetCode](https://leetcode.com/problems/min-stack/)
- [ ] 739 Daily Temperatures · [LeetCode](https://leetcode.com/problems/daily-temperatures/)

---

## Level 5: Binary Search

- [ ] 704 Binary Search · [LeetCode](https://leetcode.com/problems/binary-search/)
- [ ] 74 Search a 2D Matrix · [LeetCode](https://leetcode.com/problems/search-a-2d-matrix/)
- [ ] 33 Search in Rotated Sorted Array · [LeetCode](https://leetcode.com/problems/search-in-rotated-sorted-array/)
- [ ] 153 Find Minimum in Rotated Sorted Array · [LeetCode](https://leetcode.com/problems/find-minimum-in-rotated-sorted-array/)

---

## Level 6: Linked List

- [ ] 206 Reverse Linked List · [LeetCode](https://leetcode.com/problems/reverse-linked-list/)
- [ ] 21 Merge Two Sorted Lists · [LeetCode](https://leetcode.com/problems/merge-two-sorted-lists/)
- [ ] 141 Linked List Cycle · [LeetCode](https://leetcode.com/problems/linked-list-cycle/)
- [ ] 23 Merge k Sorted Lists · [LeetCode](https://leetcode.com/problems/merge-k-sorted-lists/)

---

## Level 7: Trees

- [ ] 104 Maximum Depth of Binary Tree · [LeetCode](https://leetcode.com/problems/maximum-depth-of-binary-tree/)
- [ ] 100 Same Tree · [LeetCode](https://leetcode.com/problems/same-tree/)
- [ ] 226 Invert Binary Tree · [LeetCode](https://leetcode.com/problems/invert-binary-tree/)
- [ ] 102 Binary Tree Level Order Traversal · [LeetCode](https://leetcode.com/problems/binary-tree-level-order-traversal/)

---

## Level 8: Dynamic Programming

- [ ] 70 Climbing Stairs · [LeetCode](https://leetcode.com/problems/climbing-stairs/)
- [ ] 198 House Robber · [LeetCode](https://leetcode.com/problems/house-robber/)
- [ ] 62 Unique Paths · [LeetCode](https://leetcode.com/problems/unique-paths/)
- [ ] 322 Coin Change · [LeetCode](https://leetcode.com/problems/coin-change/)

---

## Level 9+: Advanced (optional)

- [ ] Tries — 208
- [ ] Heap — 703, 215
- [ ] Graphs — 200, 133, 207
- [ ] Backtracking — 78, 39, 46
- [ ] Greedy — 55, 45, 122

---

## Quick Links

- Problem notes index (docs/problems)
- README (project hub)

---

## Problem

Given an array of integers `nums` and an integer `target`, return indices of the two numbers such that they add up to `target`.

You may assume that each input would have exactly one solution, and you may not use the same element twice.

You can return the answer in any order.

**Example 1:**
```
Input: nums = [2,7,11,15], target = 9
Output: [0,1]
Explanation: nums[0] + nums[1] == 9
```

**Example 2:**
```
Input: nums = [3,2,4], target = 6
Output: [1,2]
```

**Example 3:**
```
Input: nums = [3,3], target = 6
Output: [0,1]
```

**Constraints:**
- 2 <= nums.length <= 10^4
- -10^9 <= nums[i], target <= 10^9
- Only one valid answer exists.

**Follow-up:** Can you come up with an algorithm less than O(n²)?

---

## Solution

<!-- Add your Swift solution here -->

---

## Thoughts

<!-- Approach, mistakes, insights -->

---

## iOS / Swift

<!-- Dictionary usage, complexity, Swift idioms -->

---

## Problem

Given a string `s`, find the length of the longest substring without repeating characters.

**Example 1:** `s = "abcabcbb"` → 3 ("abc")
**Example 2:** `s = "bbbbb"` → 1 ("b")
**Example 3:** `s = "pwwkew"` → 3 ("wke" or "kew")
**Example 4:** `s = ""` → 0

**Constraints:** 0 <= s.length <= 5*10^4, s consists of English letters, digits, symbols, spaces.

---

## Problem

You are given an integer array `height` of length n. There are n vertical lines drawn such that the two endpoints of the i-th line are (i, 0) and (i, height[i]).

Find two lines that together with the x-axis form a container, such that the container contains the most water.

Return the maximum amount of water a container can store. You may not slant the container.

**Example:** `height = [1,8,6,2,5,4,8,3,7]` → 49 (lines at index 1 and 8, width 7, min height 7 → 7*7=49)

**Constraints:** n >= 2, 0 <= height[i] <= 10^4

---

## Problem

Given an integer array `nums`, return all the triplets `[nums[i], nums[j], nums[k]]` such that i != j, i != k, j != k, and nums[i] + nums[j] + nums[k] == 0.

Notice that the solution set must not contain duplicate triplets.

**Example 1:** `nums = [-1,0,1,2,-1,-4]` → `[[-1,-1,2],[-1,0,1]]`
**Example 2:** `nums = [0,1,1]` → `[]`
**Example 3:** `nums = [0,0,0]` → `[[0,0,0]]`

**Constraints:** 3 <= nums.length <= 3000, -10^5 <= nums[i] <= 10^5

---

## Problem

Given a string `s` containing just the characters `'(', ')', '{', '}', '['` and `']'`, determine if the input string is valid.

An input string is valid if:
1. Every close bracket has a corresponding open bracket of the same type.
2. Open brackets must be closed in the correct order.
3. Open brackets must be closed by the same type of brackets.

**Example 1:** `s = "()"` → `true`
**Example 2:** `s = "()[]{}"` → `true`
**Example 3:** `s = "(]"` → `false`
**Example 4:** `s = "([])"` → `true`
**Example 5:** `s = "([)]"` → `false`

**Constraints:** `s` consists of parentheses only `'()[]{}'`, 1 <= s.length <= 10^4

**Hint:** Use a stack of characters.

---

## Solution

<!-- Add your Swift solution here -->

---

## Thoughts

<!-- Approach, mistakes, insights -->

---

## iOS / Swift

<!-- Swift Array as stack, popLast -->

---

## Problem

You are given the heads of two sorted linked lists `list1` and `list2`. Merge the two lists into one sorted list. The list should be made by splicing together the nodes of the first two lists. Return the head of the merged linked list.

**Example 1:** list1 = [1,2,4], list2 = [1,3,4] → [1,1,2,3,4,4]
**Example 2:** list1 = [], list2 = [] → []
**Example 3:** list1 = [], list2 = [0] → [0]

**Constraints:** 0 <= number of nodes <= 50, -100 <= Node.val <= 100, both sorted non-decreasing.

---

## Problem

You are given an array of k linked-lists `lists`, each linked-list is sorted in ascending order. Merge all the linked-lists into one sorted linked-list and return it.

**Example 1:** lists = [[1,4,5],[1,3,4],[2,6]] → [1,1,2,3,4,4,5,6]
**Example 2:** lists = [] → []
**Example 3:** lists = [[]] → []

**Constraints:** k == lists.length, 0 <= k <= 10^4, 0 <= lists[i].length <= 500, -10^4 <= lists[i][j] <= 10^4, each list sorted.

---

## Problem

There is an integer array `nums` sorted in ascending order (with distinct values). Prior to being passed to your function, nums is possibly rotated at an unknown pivot index k (1 <= k < nums.length) such that the resulting array is [nums[k], nums[k+1], ..., nums[n-1], nums[0], nums[1], ..., nums[k-1]].

Given the array `nums` after the possible rotation and an integer `target`, return the index of target if it is in nums, or -1 if it is not. Algorithm must be O(log n).

**Example 1:** nums = [4,5,6,7,0,1,2], target = 0 → 4
**Example 2:** nums = [4,5,6,7,0,1,2], target = 3 → -1
**Example 3:** nums = [1], target = 0 → -1

**Constraints:** 1 <= nums.length <= 5000, -10^4 <= nums[i], target <= 10^4, all distinct.

---

## Problem

Given an array of strings `strs`, group the anagrams together. You can return the answer in any order.

An Anagram is a word or phrase formed by rearranging the letters of a different word or phrase, typically using all the original letters exactly once.

**Example 1:** `strs = ["eat","tea","tan","ate","nat","bat"]` → `[["bat"],["nat","tan"],["ate","eat","tea"]]`
**Example 2:** `strs = [""]` → `[[""]]`
**Example 3:** `strs = ["a"]` → `[["a"]]`

**Constraints:** 1 <= strs.length <= 10^4, 0 <= strs[i].length <= 100, lowercase letters only.

---

## Problem

There is a robot on an m x n grid. The robot is initially located at the top-left corner (i.e., grid[0][0]). The robot tries to move to the bottom-right corner (i.e., grid[m - 1][n - 1]). The robot can only move either down or right at any point in time.

Given the two integers m and n, return the number of possible unique paths that the robot can take to reach the bottom-right corner.

**Example 1:** m = 3, n = 7 → 28
**Example 2:** m = 3, n = 2 → 3
**Example 3:** m = 1, n = 1 → 1

**Constraints:** 1 <= m, n <= 100

---

## Problem

You are climbing a staircase. It takes `n` steps to reach the top. Each time you can either climb 1 or 2 steps. In how many distinct ways can you climb to the top?

**Example 1:** n = 2 → 2 (1+1 or 2)
**Example 2:** n = 3 → 3 (1+1+1, 1+2, 2+1)

**Constraints:** 1 <= n <= 45

---

## Problem

You are given an m x n integer matrix `matrix` with the following properties:
- Each row is sorted in non-decreasing order
- The first integer of each row is greater than the last integer of the previous row

Given an integer `target`, return `true` if target is in matrix or `false` otherwise. Write in O(log(m*n)) time.

**Example 1:** matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]], target = 3 → true
**Example 2:** matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]], target = 13 → false

**Constraints:** m, n >= 1, m*n <= 10^4, -10^4 <= matrix[i][j], target <= 10^4

---

## Problem

Given the roots of two binary trees `p` and `q`, write a function to check if they are the same or not. Two binary trees are the same if they are structurally identical, and the nodes have the same value.

**Example 1:** p = [1,2,3], q = [1,2,3] → true
**Example 2:** p = [1,2], q = [1,null,2] → false
**Example 3:** p = [1,2,1], q = [1,1,2] → false

**Constraints:** 0 <= number of nodes <= 100, -10^4 <= Node.val <= 10^4

---

## Problem

Given the `root` of a binary tree, return the level order traversal of its nodes' values. (i.e., from left to right, level by level).

**Example 1:** root = [3,9,20,null,null,15,7] → [[3],[9,20],[15,7]]
**Example 2:** root = [1] → [[1]]
**Example 3:** root = [] → []

**Constraints:** 0 <= number of nodes <= 2000, -1000 <= Node.val <= 1000

---

## Problem

Given the `root` of a binary tree, return its maximum depth. The maximum depth is the number of nodes along the longest path from the root node down to the farthest leaf node.

**Example 1:** root = [3,9,20,null,null,15,7] → 3
**Example 2:** root = [1,null,2] → 2

**Constraints:** 0 <= number of nodes <= 10^4, -100 <= Node.val <= 100

---

## Problem

You are given an array `prices` where prices[i] is the price of a given stock on the i-th day.

You want to maximize your profit by choosing a single day to buy one stock and choosing a different day in the future to sell that stock.

Return the maximum profit you can achieve from this transaction. If you cannot achieve any profit, return 0.

**Example 1:** `prices = [7,1,5,3,6,4]` → 5 (buy day 2, sell day 5)
**Example 2:** `prices = [7,6,4,3,1]` → 0
**Example 3:** `prices = [1,2]` → 1

**Constraints:** 1 <= prices.length <= 10^5, 0 <= prices[i] <= 10^4

---

## Problem

A phrase is a palindrome if, after converting all uppercase letters into lowercase letters and removing all non-alphanumeric characters, it reads the same forward and backward. Alphanumeric characters include letters and numbers.

Given a string `s`, return `true` if it is a palindrome, or `false` otherwise.

**Example 1:** `s = "A man, a plan, a canal: Panama"` → `true`
**Example 2:** `s = "race a car"` → `false`
**Example 3:** `s = " "` → `true`

---

## Problem

Given `head`, the head of a linked list, determine if the linked list has a cycle in it. There is a cycle in a linked list if there is some node in the list that can be reached again by continuously following the `next` pointer. Return `true` if there is a cycle, `false` otherwise.

**Example 1:** head with tail's next → pos 1 → true
**Example 2:** head with tail's next → pos 0 → true
**Example 3:** head = [1], no cycle → false

**Constraints:** 0 <= number of nodes <= 10^4, -10^5 <= Node.val <= 10^5, pos is -1 or valid index.

---

## Problem

Suppose an array of length n sorted in ascending order is rotated between 1 and n times. For example, the array nums = [0,1,2,4,5,6,7] might become [4,5,6,7,0,1,2] or [0,1,2,4,5,6,7].

Given the sorted rotated array `nums` of unique elements, return the minimum element of this array. Algorithm must run in O(log n) time.

**Example 1:** nums = [3,4,5,1,2] → 1
**Example 2:** nums = [4,5,6,7,0,1,2] → 0
**Example 3:** nums = [11,13,15,17] → 11

**Constraints:** n >= 1, -5000 <= nums[i] <= 5000, all unique, rotated 1..n times.

---

## Problem

Design a stack that supports push, pop, top, and retrieving the minimum element in constant time.

Implement the `MinStack` class:
- `push(val)` — pushes the element val onto the stack
- `pop()` — removes the element on the top of the stack
- `top()` — gets the top element of the stack
- `getMin()` — retrieves the minimum element in the stack

You must implement a solution with O(1) time complexity for each function.

**Constraints:** -2^31 <= val <= 2^31 - 1, at most 3*10^4 calls total to push, pop, top, getMin.

---

## Problem

Given a 1-indexed array of integers `numbers` that is already sorted in non-decreasing order, find two numbers such that they add up to a specific `target`. Let these two numbers be `numbers[index1]` and `numbers[index2]` where 1 <= index1 < index2 <= numbers.length.

Return the indices [index1, index2] of the two numbers, added by 1 as an integer array [index1, index2].

You may not use the same element twice. Exactly one solution exists.

**Example 1:** `numbers = [2,7,11,15], target = 9` → `[1,2]`
**Example 2:** `numbers = [2,3,4], target = 6` → `[1,3]`
**Example 3:** `numbers = [-1,0], target = -1` → `[1,2]`

**Constraints:** 2 <= numbers.length <= 3*10^4, -1000 <= numbers[i], target <= 1000, sorted ascending.

---

## Problem

You are a professional robber planning to rob houses along a street. Each house has a certain amount of money stashed. The only constraint stopping you from robbing each of them is that adjacent houses have security systems connected and it will automatically contact the police if two adjacent houses were broken into on the same night.

Given an integer array `nums` representing the amount of money of each house, return the maximum amount of money you can rob tonight without alerting the police.

**Example 1:** nums = [1,2,3,1] → 4 (rob house 1 and 3)
**Example 2:** nums = [2,7,9,3,1] → 12 (rob houses 1, 3, 5)

**Constraints:** 1 <= nums.length <= 100, 0 <= nums[i] <= 400

---

## Problem

Given the `head` of a singly linked list, reverse the list, and return the reversed list.

**Example 1:** head = [1,2,3,4,5] → [5,4,3,2,1]
**Example 2:** head = [1,2] → [2,1]
**Example 3:** head = [] → []

**Constraints:** The number of nodes in the list is the range [0, 5000], -5000 <= Node.val <= 5000

---

## Problem

Given an integer array `nums`, return `true` if any value appears at least twice in the array, and return `false` if every element is distinct.

**Example 1:** `nums = [1,2,3,1]` → `true` (1 at indices 0 and 3)
**Example 2:** `nums = [1,2,3,4]` → `false`
**Example 3:** `nums = [1,1,1,3,3,4,3,2,4,2]` → `true`

**Constraints:** -10^9 <= nums[i] <= 10^9, 1 <= nums.length <= 10^5

---

## Problem

Given the `root` of a binary tree, invert the tree, and return its root.

**Example 1:** root = [4,2,7,1,3,6,9] → [4,7,2,9,6,3,1]
**Example 2:** root = [2,1,3] → [2,3,1]
**Example 3:** root = [] → []

**Constraints:** 0 <= number of nodes <= 100, -100 <= Node.val <= 100

---

## Problem

Given an integer array `nums`, return an array `answer` such that `answer[i]` is equal to the product of all the elements of `nums` except `nums[i]`.

You must write an algorithm that runs in O(n) time and without using the division operation.

**Constraints:** 2 <= nums.length <= 10^5, -30 <= nums[i] <= 30. Product fits in 32-bit int.

---

## Problem

You are given an integer array `coins` representing coins of different denominations and an integer `amount` representing a total amount of money. Return the fewest number of coins that you need to make up that amount. If that amount of money cannot be made up by any combination of the coins, return -1. You may assume that you have an infinite number of each kind of coin.

**Example 1:** coins = [1,2,5], amount = 11 → 3 (5+5+1)
**Example 2:** coins = [2], amount = 3 → -1
**Example 3:** coins = [1], amount = 0 → 0

**Constraints:** 1 <= coins.length <= 12, 1 <= coins[i] <= 2^31-1, 0 <= amount <= 10^4

---

## Problem

You are given a string `s` and an integer `k`. You can choose any character of the string and change it to any other uppercase English letter. You can perform this operation at most `k` times.

Return the length of the longest substring containing the same letter you can get after performing the above operations.

**Example 1:** `s = "ABAB", k = 2` → 4 (replace both A's with B's or vice versa)
**Example 2:** `s = "AABABBA", k = 1` → 4 (replace middle A with B → "AABBBBA", or similar)

**Constraints:** 1 <= s.length <= 10^5, s is uppercase English letters only, 0 <= k <= s.length

---

## Problem

Given an array of integers `nums` sorted in ascending order, and an integer `target`, write a function to search `target` in `nums`. If `target` exists, return its index. Otherwise, return `-1`.

You must write an algorithm with O(log n) runtime complexity.

**Example 1:**
```
Input: nums = [-1,0,3,5,9,12], target = 9
Output: 4
```

**Example 2:**
```
Input: nums = [-1,0,3,5,9,12], target = 2
Output: -1
```

**Constraints:**
- `nums` is sorted in ascending order
- All integers in `nums` are unique
- -10^4 < nums[i], target < 10^4
- 1 <= nums.length <= 10^4

---

## Solution

<!-- Add your Swift solution here -->

---

## Thoughts

<!-- Approach, edge cases, loop invariant -->

---

## iOS / Swift

<!-- Overflow with (l + r) / 2, Swift ranges -->

---

## Problem

Given an array of integers `temperatures` representing the daily temperatures, return an array `answer` such that `answer[i]` is the number of days you have to wait after the i-th day to get a warmer temperature. If there is no future day for which this is possible, keep `answer[i] == 0` instead.

**Example 1:** `temperatures = [73,74,75,71,69,72,76,73]` → `[1,1,4,2,1,1,0,0]`
**Example 2:** `temperatures = [30,40,50,60]` → `[1,1,1,0]`
**Example 3:** `temperatures = [30,60,90]` → `[1,1,0]`

**Constraints:** 1 <= temperatures.length <= 10^5, 30 <= temperatures[i] <= 100

---

## Tasks by Topic (note → LeetCode)

| # | Problem | titleSlug | Note | LeetCode | Package |
|---|---------|------|----------|------------------|
| 1 | Two Sum | `two-sum` | note | [LC](https://leetcode.com/problems/two-sum/) | `Packages/Arrays` |
| 3 | Longest Substring Without Repeating | `longest-substring-without-repeating-characters` | note | [LC](https://leetcode.com/problems/longest-substring-without-repeating-characters/) | `Packages/SlidingWindow` |
| 11 | Container With Most Water | `container-with-most-water` | note | [LC](https://leetcode.com/problems/container-with-most-water/) | `Packages/TwoPointers` |
| 15 | 3Sum | `3sum` | note | [LC](https://leetcode.com/problems/3sum/) | `Packages/TwoPointers` |
| 20 | Valid Parentheses | `valid-parentheses` | note | [LC](https://leetcode.com/problems/valid-parentheses/) | `Packages/Stack` |
| 21 | Merge Two Sorted Lists | `merge-two-sorted-lists` | note | [LC](https://leetcode.com/problems/merge-two-sorted-lists/) | `Packages/LinkedList` |
| 23 | Merge k Sorted Lists | `merge-k-sorted-lists` | note | [LC](https://leetcode.com/problems/merge-k-sorted-lists/) | `Packages/LinkedList` |
| 33 | Search in Rotated Sorted Array | `search-in-rotated-sorted-array` | note | [LC](https://leetcode.com/problems/search-in-rotated-sorted-array/) | `Packages/BinarySearch` |
| 49 | Group Anagrams | `group-anagrams` | note | [LC](https://leetcode.com/problems/group-anagrams/) | `Packages/Arrays` |
| 62 | Unique Paths | `unique-paths` | note | [LC](https://leetcode.com/problems/unique-paths/) | `Packages/DynamicProgramming` |
| 70 | Climbing Stairs | `climbing-stairs` | note | [LC](https://leetcode.com/problems/climbing-stairs/) | `Packages/DynamicProgramming` |
| 74 | Search a 2D Matrix | `search-a-2d-matrix` | note | [LC](https://leetcode.com/problems/search-a-2d-matrix/) | `Packages/BinarySearch` |
| 100 | Same Tree | `same-tree` | note | [LC](https://leetcode.com/problems/same-tree/) | `Packages/Trees` |
| 102 | Binary Tree Level Order Traversal | `binary-tree-level-order-traversal` | note | [LC](https://leetcode.com/problems/binary-tree-level-order-traversal/) | `Packages/Trees` |
| 104 | Maximum Depth of Binary Tree | `maximum-depth-of-binary-tree` | note | [LC](https://leetcode.com/problems/maximum-depth-of-binary-tree/) | `Packages/Trees` |
| 121 | Best Time to Buy and Sell Stock | `best-time-to-buy-and-sell-stock` | note | [LC](https://leetcode.com/problems/best-time-to-buy-and-sell-stock/) | `Packages/SlidingWindow` |
| 125 | Valid Palindrome | `valid-palindrome` | note | [LC](https://leetcode.com/problems/valid-palindrome/) | `Packages/TwoPointers` |
| 141 | Linked List Cycle | `linked-list-cycle` | note | [LC](https://leetcode.com/problems/linked-list-cycle/) | `Packages/LinkedList` |
| 153 | Find Minimum in Rotated Sorted Array | `find-minimum-in-rotated-sorted-array` | note | [LC](https://leetcode.com/problems/find-minimum-in-rotated-sorted-array/) | `Packages/BinarySearch` |
| 155 | Min Stack | `min-stack` | note | [LC](https://leetcode.com/problems/min-stack/) | `Packages/Stack` |
| 167 | Two Sum II | `two-sum-ii-input-array-is-sorted` | note | [LC](https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/) | `Packages/TwoPointers` |
| 198 | House Robber | `house-robber` | note | [LC](https://leetcode.com/problems/house-robber/) | `Packages/DynamicProgramming` |
| 206 | Reverse Linked List | `reverse-linked-list` | note | [LC](https://leetcode.com/problems/reverse-linked-list/) | `Packages/LinkedList` |
| 217 | Contains Duplicate | `contains-duplicate` | note | [LC](https://leetcode.com/problems/contains-duplicate/) | `Packages/Arrays` |
| 226 | Invert Binary Tree | `invert-binary-tree` | note | [LC](https://leetcode.com/problems/invert-binary-tree/) | `Packages/Trees` |
| 238 | Product of Array Except Self | `product-of-array-except-self` | note | [LC](https://leetcode.com/problems/product-of-array-except-self/) | `Packages/Arrays` |
| 322 | Coin Change | `coin-change` | note | [LC](https://leetcode.com/problems/coin-change/) | `Packages/DynamicProgramming` |
| 424 | Longest Repeating Character Replacement | `longest-repeating-character-replacement` | note | [LC](https://leetcode.com/problems/longest-repeating-character-replacement/) | `Packages/SlidingWindow` |
| 704 | Binary Search | `binary-search` | note | [LC](https://leetcode.com/problems/binary-search/) | `Packages/BinarySearch` |
| 739 | Daily Temperatures | `daily-temperatures` | note | [LC](https://leetcode.com/problems/daily-temperatures/) | `Packages/Stack` |

---

## LeetCode Explore & Quizzes

- [LeetCode Explore — Interview](https://leetcode.com/explore/interview/) — curated paths
- [Interview Crash Course](https://leetcode.com/explore/featured/card/leetcodes-interview-crash-course-data-structures-and-algorithms/) — 13 chapters, 149 items
- [Cheatsheets](https://leetcode.com/explore/interview/card/cheatsheets) — Big O, data structures, templates
- [Beginner's Guide](https://leetcode.com/explore/featured/card/the-leetcode-beginners-guide/) — intro to the platform
- [LeetCode Quizzes](https://leetcode.com/problem-list/) — various quiz lists; search "quiz" or browse [Explore](https://leetcode.com/explore/) for topic-specific quizzes

---

## Naming

`NNNN-slug.md` — e.g. `0001-two-sum.md`, `0020-valid-parentheses.md`

---

## Interview Q&A (Knowledge cards)

### Q1
- **Question:** Why Big-O on iOS interviews?
- **Answer:** You must reason about lookup vs insert, nested loops, and when `Dictionary`/`Set` give expected O(1) average time—even if you rarely implement custom trees in app code.

---
