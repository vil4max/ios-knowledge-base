# Data Structures & Big-O

## За 30 секунд

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

## Артефакты

- Notes: `notes/`
- Exercises: `exercises/`
- Assets: `assets/`
- Playgrounds: `playgrounds/`
- Practice: `practice/LeetCode/` (локальный алгоритмический трек)

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

- Use when / Когда применять: нужно сравнить подходы, оценить trade-offs и обосновать выбор алгоритма.
- Red flags / Красные флаги: нет четкой модели входа, нет оценки памяти, только "на глаз".
- Canonical task: compare hash-based duplicate check vs sort-and-scan.

## 2) Recursion

- Use when / Когда применять: задача естественно распадается на подзадачи того же типа.
- Red flags / Красные флаги: нет базового случая, нет убывающей меры, повторные вычисления.
- Canonical task: merge sort or fast exponentiation.

## 3) Backtracking

- Use when / Когда применять: нужен полный поиск в пространстве вариантов с ограничениями.
- Red flags / Красные флаги: поздний pruning, отсутствие rollback, неконтролируемый branching.
- Canonical task: N-Queens.

## 4) Dynamic Programming

- Use when / Когда применять: есть overlapping subproblems + optimal substructure.
- Red flags / Красные флаги: state слишком большой/неполный, неверный порядок вычисления.
- Canonical task: Coin Change or LCS.

## 5) Greedy

- Use when / Когда применять: можно доказать greedy-choice property.
- Red flags / Красные флаги: нет доказательства, только "кажется логичным".
- Canonical task: interval scheduling.

## 6) Basic Graph Algorithms

- Use when / Когда применять: связи между объектами важнее самих объектов.
- Red flags / Красные флаги: неверный выбор представления графа, забытые disconnected компоненты.
- Canonical task: connected components (BFS/DFS).

## 7) DFS

- Use when / Когда применять: циклы, топосорт, SCC, структурный анализ графа.
- Red flags / Красные флаги: путаница состояний white/gray/black, ошибка в postorder.
- Canonical task: cycle detection in directed graph.

## 8) MST

- Use when / Когда применять: нужно связать все вершины минимальной стоимостью.
- Red flags / Красные флаги: пропуск cycle checks, неверный DSU.
- Canonical task: Kruskal on weighted undirected graph.

## 9) Shortest Paths

- Use when / Когда применять: оптимальные маршруты от точки(ек) источника.
- Red flags / Красные флаги: Dijkstra при отрицательных весах, нет path reconstruction.
- Canonical task: Dijkstra with parent array.

## 10) APSP

- Use when / Когда применять: много запросов "из любой вершины в любую".
- Red flags / Красные флаги: неправильная infinity-константа, переполнение, неверный loop order.
- Canonical task: Floyd-Warshall with `next` matrix.

## 11) Max Flow / Min Cut

- Use when / Когда применять: задачи пропускной способности, распределения, matching.
- Red flags / Красные флаги: не обновляются обратные ребра, неправильный residual graph.
- Canonical task: Edmonds-Karp.

## 12) Flow Applications

- Use when / Когда применять: можно свести задачу к сети с capacity constraints.
- Red flags / Красные флаги: редукция теряет ограничения или добавляет лишние решения.
- Canonical task: bipartite matching via flow.

## 13) NP-Hardness

- Use when / Когда применять: нужно классифицировать сложность и выбрать реалистичную стратегию.
- Red flags / Красные флаги: редукция в неверную сторону, нет yes/no эквивалентности.
- Canonical task: explain 3-SAT -> Vertex Cover reduction.

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

- RU: Алгоритмы изучают не только "как решить", но и "как доказать корректность и оценить ресурсы".
- EN: Algorithms are about both solving problems and proving correctness with resource bounds.

## Chapter link

- Book chapter: [Introduction](https://jeffe.cs.illinois.edu/teaching/algorithms/book/00-intro.pdf)

## Mental model

- RU: Для каждой задачи фиксируй вход, выход, ограничения, модель вычислений.
- EN: For every problem, fix input, output, constraints, and computational model.
- RU: Разделяй решение на корректность, сложность, и инженерные компромиссы.
- EN: Separate correctness, complexity, and engineering trade-offs.

## Complexity checklist

- RU: Определи размер входа `n`.
- EN: Define input size `n`.
- RU: Выдели доминирующую операцию.
- EN: Identify the dominant operation.
- RU: Оцени worst-case и, если нужно, average-case.
- EN: Estimate worst-case and when useful average-case.

## Proof intuition

- RU: Начни с четкой спецификации: что именно должен вернуть алгоритм.
- EN: Start with a precise specification of what the algorithm must return.
- RU: Затем докажи инвариант цикла или рекурсии.
- EN: Then prove a loop or recursion invariant.
- RU: В конце покажи termination и свяжи инвариант с финальным ответом.
- EN: Finally prove termination and connect invariant to final output.

## Typical tasks

- Поиск минимума/максимума.
- Подсчет операций в простых циклах.
- Сравнение двух алгоритмов при росте `n`.

## Common mistakes

- RU: Путать константы с асимптотикой.
- EN: Mixing constants with asymptotic growth.
- RU: Не фиксировать модель стоимости операций.
- EN: Forgetting the cost model assumptions.

## Practice prompt

- RU: Возьми 3 реализации поиска дубликата в массиве и сравни их по времени/памяти.
- EN: Compare three duplicate-detection approaches by time and space.

## Interview framing

- RU: "Как выбрать между `O(n)` с памятью и `O(n log n)` in-place?"
- EN: "How do you choose between `O(n)` extra-space and `O(n log n)` in-place?"
- RU: "Какие предположения о входе критичны для корректности?"
- EN: "Which assumptions about input are critical for correctness?"

## Key statements

- RU: Если два алгоритма корректны, для больших `n` решает порядок роста.
- EN: If two algorithms are correct, asymptotic growth dominates for large `n`.
- RU: Асимптотика без модели операций неполна.
- EN: Asymptotics are incomplete without an operation-cost model.

## Must-know tasks

- Easy: определить асимптотику для вложенных циклов и простых рекурсий.
- Medium: сравнить 2-3 корректных решения одной задачи по времени/памяти и выбрать под constraint.

## Explain in 60 seconds

- RU: Сначала формализую задачу и ограничения, потом проверяю корректность через инвариант и termination, после этого считаю time/space через доминирующие операции. Финальный выбор алгоритма делаю не по "красоте", а по ограничениям входа и SLA.
- EN: I first formalize problem constraints, then verify correctness via invariants and termination, and only then compute time/space by dominant operations. Final algorithm choice is constraint-driven, not style-driven.

---

## Core idea

- RU: Рекурсия работает, когда задача естественно раскладывается на меньшие подзадачи того же типа.
- EN: Recursion is effective when a problem decomposes into smaller instances of itself.

## Chapter link

- Book chapter: [Recursion](https://jeffe.cs.illinois.edu/teaching/algorithms/book/01-recursion.pdf)

## Mental model

- RU: Каждая рекурсивная функция должна иметь базовый случай и шаг уменьшения.
- EN: Every recursive function needs a base case and a shrinking step.
- RU: Инвариант: глубина вызовов конечна.
- EN: Invariant: call depth must be finite.

## Complexity checklist

- RU: Запиши рекурренту `T(n)`.
- EN: Write the recurrence `T(n)`.
- RU: Оцени глубину стека.
- EN: Estimate stack depth.
- RU: Проверяй дублирование подзадач.
- EN: Check whether subproblems are duplicated.

## Proof intuition

- RU: Доказывай по индукции на размере входа.
- EN: Use induction on input size for correctness proofs.
- RU: База индукции = базовый случай функции.
- EN: Induction base corresponds to the function base case.
- RU: Индукционный шаг = корректность рекурсивного шага при предположении для меньших `n`.
- EN: Induction step mirrors recursive correctness assuming smaller `n` cases.

## Typical tasks

- Бинарный поиск.
- Обход дерева.
- Быстрое возведение в степень.

## Common mistakes

- RU: Слабый базовый случай или его отсутствие.
- EN: Missing or weak base case.
- RU: Экспоненциальный рост из-за повторного вычисления.
- EN: Exponential blowup from repeated recomputation.

## Practice prompt

- RU: Реализуй Fibonacci: рекурсивно, memoized, и итеративно; сравни сложности.
- EN: Implement Fibonacci recursively, memoized, and iteratively; compare costs.

## Interview framing

- RU: "Когда recursion лучше итерации, а когда опасна?"
- EN: "When is recursion preferable to iteration, and when is it risky?"
- RU: "Как из рекурсии перейти в DP?"
- EN: "How do you transition from recursion to DP?"

## Key statements

- RU: Рекурсия корректна, если есть достижимая база и строгая мера убывания.
- EN: Recursion is correct when a base case is reachable and a strict decreasing measure exists.
- RU: Перекрывающиеся подзадачи сигнализируют о memoization/DP.
- EN: Overlapping subproblems signal memoization/DP opportunities.

## Must-know tasks

- Easy: бинарный поиск и вычисление степени `pow(x, n)` через divide and conquer.
- Medium: merge sort с рекуррентным анализом и оценкой глубины стека.

## Explain in 60 seconds

- RU: Рекурсию я пишу как "база + уменьшение задачи". Корректность обычно доказываю индукцией, а сложность считаю через рекурренту. Если вижу повтор одних и тех же подзадач, переключаюсь на memoization или bottom-up DP.
- EN: I structure recursion as "base case + problem shrink". I prove correctness by induction and derive complexity via recurrence. If the same subproblems repeat, I switch to memoization or bottom-up DP.

---

## Core idea

- RU: Backtracking строит решение по шагам и откатывает выбор, если ветка невалидна.
- EN: Backtracking builds solutions incrementally and undoes choices on invalid branches.

## Chapter link

- Book chapter: [Backtracking](https://jeffe.cs.illinois.edu/teaching/algorithms/book/02-backtracking.pdf)

## Mental model

- RU: Дерево состояний + проверка ограничений как можно раньше.
- EN: State-space tree + early constraint checks.
- RU: Эффективность зависит от pruning.
- EN: Performance depends on pruning quality.

## Complexity checklist

- RU: Оцени branching factor `b` и глубину `d`.
- EN: Estimate branching factor `b` and depth `d`.
- RU: Верхняя оценка обычно `O(b^d)`.
- EN: Typical upper bound is `O(b^d)`.
- RU: Память часто `O(d)`.
- EN: Space is often `O(d)`.

## Proof intuition

- RU: Корректность опирается на полный перебор валидного пространства состояний.
- EN: Correctness relies on exhaustive exploration of valid state space.
- RU: Pruning не должен отрезать потенциально оптимальные решения.
- EN: Pruning must not discard potentially optimal solutions.

## Typical tasks

- N-Queens.
- Sudoku.
- Генерация перестановок и комбинаций.

## Common mistakes

- RU: Поздняя проверка ограничений.
- EN: Validating constraints too late.
- RU: Мутирование общего состояния без корректного отката.
- EN: Mutating shared state without proper rollback.

## Practice prompt

- RU: Реализуй N-Queens с оптимизацией через множества колонок и диагоналей.
- EN: Implement N-Queens with column/diagonal sets for pruning.

## Interview framing

- RU: "Какие pruning-правила безопасны и почему?"
- EN: "Which pruning rules are safe and why?"
- RU: "Как оценить реальную, а не только worst-case сложность?"
- EN: "How do you reason about practical, not only worst-case complexity?"

## Key statements

- RU: Backtracking гарантирует полноту поиска, если перебирает все допустимые выборы.
- EN: Backtracking guarantees completeness if all feasible choices are explored.
- RU: Безопасный pruning не удаляет ни одного потенциального решения.
- EN: Safe pruning removes no potentially valid solution.

## Must-know tasks

- Easy: генерация подмножеств/перестановок.
- Medium: N-Queens или Word Search с агрессивным pruning.

## Explain in 60 seconds

- RU: Я моделирую задачу как дерево состояний: выбор, проверка ограничений, рекурсивный шаг, откат. Оптимизация достигается ранним pruning и компактным состоянием. Корректность: мы либо находим валидное решение, либо доказываем, что его нет, потому что рассмотрели все допустимые ветви.
- EN: I model the task as a state-space tree: choose, validate constraints, recurse, rollback. Performance comes from early pruning and compact state representation. Correctness follows from exhaustive exploration of all feasible branches.

---

## Core idea

- RU: DP решает задачу через сохранение ответов для перекрывающихся подзадач.
- EN: DP solves problems by storing answers for overlapping subproblems.

## Chapter link

- Book chapter: [Dynamic Programming](https://jeffe.cs.illinois.edu/teaching/algorithms/book/03-dynprog.pdf)

## Mental model

- RU: Сначала формулируем состояние, затем переход, затем порядок вычисления.
- EN: First define state, then transition, then evaluation order.
- RU: Цель: убрать повторный пересчет.
- EN: Goal: eliminate repeated work.

## Complexity checklist

- RU: Время = число состояний × стоимость перехода.
- EN: Time = number of states × transition cost.
- RU: Память = число сохраняемых состояний.
- EN: Space = number of stored states.
- RU: Проверяй возможность оптимизации памяти.
- EN: Check if rolling memory optimization is possible.

## Proof intuition

- RU: Докажи, что состояние содержит всю нужную информацию о "прошлом".
- EN: Prove the state captures all necessary information about the "past".
- RU: Докажи корректность перехода как локального шага к глобальному оптимуму.
- EN: Prove transition correctness as a local step toward global optimum.
- RU: Обоснуй порядок вычисления (topological order of dependencies).
- EN: Justify computation order (dependency topological order).

## Typical tasks

- Knapsack.
- Longest Common Subsequence.
- Edit Distance.

## Common mistakes

- RU: Неправильная размерность состояния.
- EN: Wrong state dimensionality.
- RU: Смешивание top-down и bottom-up без ясной инвариантности.
- EN: Mixing top-down and bottom-up without clear invariants.

## Practice prompt

- RU: Реализуй `Climbing Stairs`, потом обобщи до `Min Cost Climbing Stairs`.
- EN: Implement `Climbing Stairs`, then extend to `Min Cost Climbing Stairs`.

## Interview framing

- RU: "Как определить state, если вариантов слишком много?"
- EN: "How do you choose a compact state when options explode?"
- RU: "Какая минимальная память нужна для этого DP?"
- EN: "What is the minimum memory needed for this DP?"

## Key statements

- RU: DP применим при overlapping subproblems и optimal substructure.
- EN: DP applies when overlapping subproblems and optimal substructure hold.
- RU: Неверный state чаще ломает DP, чем неверная формула перехода.
- EN: A wrong state definition breaks DP more often than a wrong transition formula.

## Must-know tasks

- Easy: Climbing Stairs / House Robber.
- Medium: Longest Common Subsequence или Coin Change.

## Explain in 60 seconds

- RU: Для DP я сначала фиксирую state как минимально достаточную информацию о прошлом, затем пишу переход и базу, после чего выбираю порядок вычисления. Сложность считаю как "количество состояний × стоимость перехода", и отдельно проверяю, можно ли свернуть память.
- EN: For DP, I define state as the minimal sufficient history, then write transition and base cases, and choose evaluation order. Complexity is "number of states × transition cost", with separate memory optimization checks.

---

## Core idea

- RU: Жадный алгоритм выбирает локально лучший шаг, надеясь получить глобальный оптимум.
- EN: Greedy algorithms take locally optimal choices aiming for global optimality.

## Chapter link

- Book chapter: [Greedy Algorithms](https://jeffe.cs.illinois.edu/teaching/algorithms/book/04-greedy.pdf)

## Mental model

- RU: Нужны свойства greedy-choice и optimal substructure.
- EN: You need greedy-choice property and optimal substructure.
- RU: Корректность часто доказывается exchange argument.
- EN: Correctness is often proved via exchange arguments.

## Complexity checklist

- RU: Часто доминирует сортировка: `O(n log n)`.
- EN: Sorting often dominates: `O(n log n)`.
- RU: Проверяй, не требуется ли структура типа heap.
- EN: Check if a heap or ordered structure is needed.

## Proof intuition

- RU: Главный шаблон — exchange argument: заменяем часть оптимального решения без ухудшения.
- EN: Main template is exchange argument: replace part of an optimal solution without worsening it.
- RU: Альтернатива — stay-ahead proof: жадный префикс "не хуже" любого другого.
- EN: Alternative is stay-ahead proof: greedy prefix stays at least as good as any competitor.

## Typical tasks

- Interval Scheduling.
- Huffman coding.
- Activity selection.

## Common mistakes

- RU: Применять жадность без доказательства.
- EN: Applying greediness without proof.
- RU: Игнорировать контрпримеры.
- EN: Ignoring counterexamples.

## Practice prompt

- RU: Сравни greedy и DP для задачи о размене монет на разных наборах номиналов.
- EN: Compare greedy vs DP for coin change under different coin systems.

## Interview framing

- RU: "Дай контрпример, где жадность ломается."
- EN: "Give a counterexample where greedy fails."
- RU: "Как быстро понять, нужен ли здесь DP вместо greedy?"
- EN: "How do you quickly detect DP is needed instead of greedy?"

## Key statements

- RU: Greedy корректен только при доказанном greedy-choice property.
- EN: Greedy is correct only with a proven greedy-choice property.
- RU: Exchange argument часто дает самое короткое доказательство.
- EN: Exchange arguments often provide the shortest correctness proof.

## Must-know tasks

- Easy: activity selection (максимум непересекающихся интервалов).
- Medium: минимальное число платформ/комнат или Huffman coding.

## Explain in 60 seconds

- RU: В greedy я выбираю локально лучший шаг и доказываю, что его можно включить в глобально оптимальное решение. Если не удается доказать exchange/stay-ahead, считаю greedy неподтвержденным и проверяю DP или графовую модель.
- EN: In greedy, I take locally optimal choices and prove they can appear in a global optimum. If I cannot prove exchange/stay-ahead, I treat greedy as unproven and evaluate DP or graph formulations.

---

## Core idea

- RU: Граф моделирует связи; выбор представления влияет на сложность.
- EN: Graphs model relationships; representation drives complexity.

## Chapter link

- Book chapter: [Basic Graph Algorithms](https://jeffe.cs.illinois.edu/teaching/algorithms/book/05-graphs.pdf)

## Mental model

- RU: Явно различай directed/undirected и weighted/unweighted.
- EN: Explicitly distinguish directed/undirected and weighted/unweighted.
- RU: Для разреженных графов удобен adjacency list.
- EN: Adjacency lists are preferred for sparse graphs.

## Complexity checklist

- RU: BFS/DFS работают за `O(V + E)` на списках смежности.
- EN: BFS/DFS run in `O(V + E)` with adjacency lists.
- RU: На матрице смежности обход близок к `O(V^2)`.
- EN: With adjacency matrix, traversal tends toward `O(V^2)`.

## Proof intuition

- RU: Для BFS докажи, что вершина впервые посещается по кратчайшему числу ребер.
- EN: For BFS, prove first visit gives shortest edge-count distance.
- RU: Для DFS докажи, что каждая вершина посещается не более одного раза.
- EN: For DFS, prove each vertex is visited at most once.

## Typical tasks

- Проверка связности.
- Поиск компонент.
- Поиск кратчайшего пути в невзвешенном графе.

## Common mistakes

- RU: Неинициализированные `visited`.
- EN: Improper visited-state initialization.
- RU: Неправильная работа с индексами вершин.
- EN: Vertex indexing mistakes.

## Practice prompt

- RU: Реализуй общий `Graph`-тип и операции addEdge, neighbors, BFS.
- EN: Build a reusable `Graph` type with addEdge, neighbors, and BFS.

## Interview framing

- RU: "Какое представление графа выберешь и почему?"
- EN: "Which graph representation do you choose and why?"
- RU: "Как обработать несвязный граф?"
- EN: "How do you handle disconnected graphs?"

## Key statements

- RU: Для невзвешенного кратчайшего пути BFS оптимален по числу ребер.
- EN: For unweighted shortest paths, BFS is optimal by edge count.
- RU: Для разреженных графов adjacency list почти всегда выгоднее матрицы.
- EN: For sparse graphs, adjacency lists are almost always more efficient than matrices.

## Must-know tasks

- Easy: количество компонент связности.
- Medium: shortest path in unweighted graph + восстановление пути.

## Explain in 60 seconds

- RU: Я начинаю с выбора представления графа по плотности и операциям. Базовые обходы BFS/DFS дают каркас для большинства задач: связность, расстояния, циклы, компоненты. На собеседовании важно сразу назвать `O(V + E)` и условия, когда она меняется.
- EN: I start by choosing representation based on graph density and required operations. BFS/DFS form the core for connectivity, distances, cycles, and components. In interviews, I immediately state `O(V + E)` and when that bound changes.

---

## Core idea

- RU: DFS проходит граф по глубине и дает мощный каркас для структурного анализа.
- EN: DFS explores depth-first and provides a framework for structural graph analysis.

## Chapter link

- Book chapter: [Depth-First Search](https://jeffe.cs.illinois.edu/teaching/algorithms/book/06-dfs.pdf)

## Mental model

- RU: Времена входа/выхода вершины задают полезный порядок.
- EN: Entry/exit times induce useful orderings.
- RU: Через DFS удобно находить циклы, топосорт и компоненты.
- EN: DFS naturally enables cycle detection, topological order, and components.

## Complexity checklist

- RU: Базовая сложность `O(V + E)`.
- EN: Base complexity is `O(V + E)`.
- RU: Рекурсивная версия ограничена глубиной стека.
- EN: Recursive implementation is stack-depth limited.

## Proof intuition

- RU: Для cycle detection в ориентированном графе достаточно находить ребро в "серую" вершину.
- EN: For directed cycle detection, finding an edge to a "gray" node is sufficient.
- RU: Для topological sort докажи, что postorder обратного порядка уважает все ребра.
- EN: For topological sort, prove reverse postorder respects all edges.

## Typical tasks

- Topological sort.
- Cycle detection.
- Strongly connected components.

## Common mistakes

- RU: Путать состояние "в стеке" и "полностью обработан".
- EN: Mixing "in recursion stack" with "fully processed".
- RU: Ломать порядок постобработки.
- EN: Breaking post-order logic.

## Practice prompt

- RU: Реализуй DFS с цветами (white/gray/black) для детекции цикла.
- EN: Implement color-based DFS for cycle detection.

## Interview framing

- RU: "Как получить топологический порядок и как проверить его?"
- EN: "How do you produce and validate a topological order?"
- RU: "Как адаптировать DFS для больших графов без переполнения стека?"
- EN: "How do you adapt DFS for large graphs to avoid stack overflow?"

## Key statements

- RU: Обратный postorder DFS дает топосорт в DAG.
- EN: Reverse DFS postorder yields a topological ordering in DAGs.
- RU: Ребро в серую вершину в directed графе эквивалентно наличию цикла.
- EN: An edge to a gray node in a directed graph implies a cycle.

## Must-know tasks

- Easy: topological sort для DAG.
- Medium: strongly connected components (Kosaraju/Tarjan conceptual level).

## Explain in 60 seconds

- RU: DFS — это не только обход, а инструмент структурного анализа графа. Через состояния вершин и порядок выхода я получаю циклы, топологический порядок и компоненты сильной связности. Главное — аккуратное управление visited/state и понимание postorder.
- EN: DFS is not just traversal; it is a structural analysis tool. With node states and exit order, I derive cycle detection, topological sort, and SCCs. The key is careful state management and postorder reasoning.

---

## Core idea

- RU: MST минимизирует суммарный вес ребер при связности всех вершин без циклов.
- EN: MST minimizes total edge weight while connecting all vertices without cycles.

## Chapter link

- Book chapter: [Minimum Spanning Trees](https://jeffe.cs.illinois.edu/teaching/algorithms/book/07-mst.pdf)

## Mental model

- RU: Ключевые свойства: cut property и cycle property.
- EN: Core properties: cut property and cycle property.
- RU: Практика: Kruskal и Prim.
- EN: Practical algorithms: Kruskal and Prim.

## Complexity checklist

- RU: Kruskal: сортировка ребер `O(E log E)` + DSU операции.
- EN: Kruskal: edge sorting `O(E log E)` + DSU operations.
- RU: Prim c heap: `O(E log V)`.
- EN: Prim with heap: `O(E log V)`.

## Proof intuition

- RU: Cut property: минимальное ребро через разрез принадлежит некоторому MST.
- EN: Cut property: the minimum edge crossing a cut belongs to some MST.
- RU: Cycle property: максимальное ребро в цикле не нужно в MST.
- EN: Cycle property: the heaviest edge in a cycle is unnecessary for MST.

## Typical tasks

- Проектирование сетей.
- Кластеризация.
- Приближения для TSP.

## Common mistakes

- RU: Пропуск проверки циклов в Kruskal.
- EN: Missing cycle checks in Kruskal.
- RU: Неправильная инициализация DSU.
- EN: Incorrect DSU initialization.

## Practice prompt

- RU: Сравни Prim и Kruskal на плотных и разреженных графах.
- EN: Compare Prim vs Kruskal on dense and sparse graphs.

## Interview framing

- RU: "Когда лучше Prim, а когда Kruskal?"
- EN: "When is Prim better, and when is Kruskal better?"
- RU: "Как проверить, что полученное дерево действительно минимально?"
- EN: "How do you verify the produced tree is truly minimal?"

## Key statements

- RU: Cut property и cycle property — фундаментальные критерии корректности MST-алгоритмов.
- EN: Cut and cycle properties are fundamental correctness criteria for MST algorithms.
- RU: Все MST имеют одинаковый вес, даже если реберные составы различаются.
- EN: All MSTs share the same total weight even if edge sets differ.

## Must-know tasks

- Easy: построить MST на маленьком графе вручную (Prim/Kruskal).
- Medium: minimum cost to connect points (геометрическая интерпретация MST).

## Explain in 60 seconds

- RU: MST соединяет все вершины минимальной стоимостью без циклов. Kruskal сортирует ребра и добавляет безопасные через DSU, Prim растит дерево от стартовой вершины. Корректность обосновывается cut/cycle property, а выбор алгоритма зависит от структуры графа и доступных структур данных.
- EN: MST connects all vertices with minimum total weight and no cycles. Kruskal sorts edges and adds safe ones via DSU, while Prim grows a tree from a start node. Correctness follows from cut/cycle properties, and algorithm choice depends on graph structure and data structures.

---

## Core idea

- RU: Ищем минимальную стоимость пути от источника к другим вершинам.
- EN: Find minimum-cost paths from a source to other vertices.

## Chapter link

- Book chapter: [Shortest Paths](https://jeffe.cs.illinois.edu/teaching/algorithms/book/08-sssp.pdf)

## Mental model

- RU: Для невзвешенных графов используй BFS.
- EN: Use BFS for unweighted graphs.
- RU: Для неотрицательных весов — Dijkstra.
- EN: Use Dijkstra for nonnegative weights.
- RU: При отрицательных ребрах — Bellman-Ford.
- EN: Use Bellman-Ford when negative edges exist.

## Complexity checklist

- RU: Dijkstra с heap: `O((V + E) log V)`.
- EN: Dijkstra with heap: `O((V + E) log V)`.
- RU: Bellman-Ford: `O(VE)`.
- EN: Bellman-Ford: `O(VE)`.

## Proof intuition

- RU: Dijkstra корректен при неотрицательных весах из-за "финализации" минимальной вершины.
- EN: Dijkstra is correct with nonnegative edges due to safe distance finalization.
- RU: Bellman-Ford опирается на факт: кратчайший путь имеет не более `V-1` ребер.
- EN: Bellman-Ford relies on the fact that shortest simple paths use at most `V-1` edges.

## Typical tasks

- Навигация.
- Routing.
- Time-cost path planning.

## Common mistakes

- RU: Применять Dijkstra при отрицательных весах.
- EN: Using Dijkstra with negative edges.
- RU: Необновлять приоритеты корректно.
- EN: Mishandling priority updates.

## Practice prompt

- RU: Реализуй Dijkstra и Bellman-Ford на одном интерфейсе графа.
- EN: Implement Dijkstra and Bellman-Ford over a shared graph interface.

## Interview framing

- RU: "Как обнаружить отрицательный цикл?"
- EN: "How do you detect a negative cycle?"
- RU: "Как восстановить сам путь, а не только расстояние?"
- EN: "How do you reconstruct the actual path, not only the distance?"

## Key statements

- RU: Dijkstra корректен только при неотрицательных ребрах.
- EN: Dijkstra is correct only with nonnegative edge weights.
- RU: Дополнительная релаксация в Bellman-Ford обнаруживает отрицательный цикл.
- EN: One extra Bellman-Ford relaxation detects a negative cycle.

## Must-know tasks

- Easy: shortest path in unweighted graph (BFS).
- Medium: network delay time / cheapest route with weighted edges.

## Explain in 60 seconds

- RU: Для shortest paths я сначала проверяю тип графа: невзвешенный, weighted nonnegative или с отрицательными весами. От этого сразу выбирается BFS, Dijkstra или Bellman-Ford. Ключевая техника — релаксация ребер и хранение `parent`, чтобы восстановить путь.
- EN: For shortest paths, I first classify the graph: unweighted, weighted nonnegative, or with negative edges. That directly selects BFS, Dijkstra, or Bellman-Ford. Core technique is edge relaxation plus parent tracking for path reconstruction.

---

## Core idea

- RU: APSP ищет расстояния между каждой парой вершин.
- EN: APSP computes distances for every vertex pair.

## Chapter link

- Book chapter: [All-Pairs Shortest Paths](https://jeffe.cs.illinois.edu/teaching/algorithms/book/09-apsp.pdf)

## Mental model

- RU: Floyd-Warshall удобно формулируется как DP по промежуточным вершинам.
- EN: Floyd-Warshall is a DP over allowed intermediate vertices.
- RU: Для разреженных графов часто лучше запускать SSSP из каждой вершины.
- EN: For sparse graphs, repeated SSSP is often better.

## Complexity checklist

- RU: Floyd-Warshall: `O(V^3)` время, `O(V^2)` память.
- EN: Floyd-Warshall: `O(V^3)` time, `O(V^2)` space.
- RU: Dijkstra from each source: `O(VE log V)` примерно.
- EN: Repeated Dijkstra: roughly `O(VE log V)`.

## Proof intuition

- RU: Во Floyd-Warshall шаг `k` разрешает использовать только вершины `0...k` как промежуточные.
- EN: In Floyd-Warshall, step `k` allows only vertices `0...k` as intermediates.
- RU: Переход: либо путь без `k`, либо через `k`.
- EN: Transition: either path excludes `k` or goes through `k`.

## Typical tasks

- Матрица shortest paths.
- Центры графа.
- Анализ транспортных сетей.

## Common mistakes

- RU: Переполнение при использовании "бесконечности".
- EN: Overflow from large sentinel infinity values.
- RU: Ошибки в порядке циклов Floyd-Warshall.
- EN: Incorrect loop ordering in Floyd-Warshall.

## Practice prompt

- RU: Реализуй Floyd-Warshall и восстановление пути по матрице `next`.
- EN: Implement Floyd-Warshall with path reconstruction via `next` matrix.

## Interview framing

- RU: "Когда APSP нужен, а когда достаточно нескольких SSSP?"
- EN: "When do you need APSP vs a few SSSP runs?"
- RU: "Как обнаружить отрицательные циклы во Floyd-Warshall?"
- EN: "How do you detect negative cycles in Floyd-Warshall?"

## Key statements

- RU: Floyd-Warshall — DP по множеству разрешенных промежуточных вершин.
- EN: Floyd-Warshall is DP over allowed intermediate vertex sets.
- RU: Отрицательный цикл обнаруживается, если `dist[v][v] < 0`.
- EN: A negative cycle exists if `dist[v][v] < 0`.

## Must-know tasks

- Easy: построить матрицу кратчайших расстояний для маленького графа.
- Medium: shortest paths with path reconstruction for all pairs.

## Explain in 60 seconds

- RU: APSP нужен, когда запросов "из любой в любую" много. Для плотных графов и умеренного `V` удобен Floyd-Warshall с `O(V^3)`, для разреженных обычно выгоднее запускать SSSP из каждой вершины. Важно уметь не только считать расстояния, но и восстанавливать маршруты.
- EN: APSP is useful when many all-to-all queries are expected. For dense graphs and moderate `V`, Floyd-Warshall with `O(V^3)` is convenient; for sparse graphs, repeated SSSP is often better. You should support both distances and path reconstruction.

---

## Core idea

- RU: Ищем максимальный поток из `s` в `t` при ограничениях пропускных способностей.
- EN: Find the maximum `s -> t` flow under edge capacity constraints.
- RU: Теорема max-flow min-cut связывает поток и разрез.
- EN: The max-flow min-cut theorem links flow value to cut capacity.

## Chapter link

- Book chapter: [Maximum Flows & Minimum Cuts](https://jeffe.cs.illinois.edu/teaching/algorithms/book/10-maxflow.pdf)

## Mental model

- RU: Работай с residual graph и augmenting paths.
- EN: Work with residual graphs and augmenting paths.
- RU: Каждый найденный augmenting path увеличивает поток.
- EN: Each augmenting path increases total flow.

## Complexity checklist

- RU: Edmonds-Karp: `O(VE^2)`.
- EN: Edmonds-Karp: `O(VE^2)`.
- RU: Dinic обычно быстрее на практике.
- EN: Dinic is usually faster in practice.

## Proof intuition

- RU: Если augmenting path отсутствует, residual-граф задает минимальный разрез.
- EN: If no augmenting path exists, the residual graph induces a minimum cut.
- RU: Значение потока равно емкости этого разреза.
- EN: Flow value equals the capacity of that cut.

## Typical tasks

- Пропускная способность сети.
- Двудольное паросочетание через flow.
- Resource allocation.

## Common mistakes

- RU: Неправильное обновление обратных ребер.
- EN: Incorrect reverse-edge updates.
- RU: Игнорирование остаточной емкости.
- EN: Ignoring residual capacities.

## Practice prompt

- RU: Реализуй Edmonds-Karp и проверь на маленьких сетях вручную.
- EN: Implement Edmonds-Karp and validate on small hand-checkable networks.

## Interview framing

- RU: "Почему отсутствие augmenting path означает оптимальность?"
- EN: "Why does no augmenting path imply optimality?"
- RU: "Как извлечь minimum cut после max flow?"
- EN: "How do you extract a minimum cut after max flow?"

## Key statements

- RU: Значение максимального потока равно емкости минимального `s-t` разреза.
- EN: Maximum flow value equals minimum `s-t` cut capacity.
- RU: Residual graph полностью определяет следующие допустимые улучшения.
- EN: Residual graph fully determines feasible future improvements.

## Must-know tasks

- Easy: посчитать max flow на маленькой сети вручную.
- Medium: сведение bipartite matching к max flow.

## Explain in 60 seconds

- RU: Flow-задачи я решаю через остаточную сеть: ищу augmenting path, увеличиваю поток и обновляю обратные ребра. Когда путь больше не находится, поток оптимален по теореме max-flow min-cut. После этого из достижимых в residual-графе вершин сразу читается минимальный разрез.
- EN: I solve flow problems via residual networks: find augmenting paths, push flow, update reverse edges. When no path remains, flow is optimal by max-flow min-cut theorem. The minimum cut is then read from vertices reachable in the residual graph.

---

## Core idea

- RU: Многие дискретные задачи сводятся к flow/cut через правильное моделирование.
- EN: Many discrete problems reduce to flow/cut via proper modeling.

## Chapter link

- Book chapter: [Applications of Flows and Cuts](https://jeffe.cs.illinois.edu/teaching/algorithms/book/11-maxflowapps.pdf)

## Mental model

- RU: Главный шаг — корректная редукция в сеть.
- EN: The key step is building the right network reduction.
- RU: Вершины/ребра кодируют ограничения задачи.
- EN: Nodes/edges encode problem constraints.

## Complexity checklist

- RU: После редукции сложность определяется алгоритмом max flow.
- EN: After reduction, complexity depends on chosen max-flow algorithm.
- RU: Важно контролировать размер построенной сети.
- EN: Control the size of the constructed network.

## Proof intuition

- RU: Корректность доказывается bi-directional соответствием: решение задачи <-> допустимый поток.
- EN: Correctness is proved by a bidirectional mapping: problem solution <-> feasible flow.
- RU: Оптимальность переносится через равенство целевых функций редукции.
- EN: Optimality transfers via objective-function equivalence in the reduction.

## Typical tasks

- Bipartite matching.
- Project selection.
- Image segmentation (graph cut formulation).

## Common mistakes

- RU: Некорректная интерпретация результата разреза.
- EN: Misinterpreting the resulting cut.
- RU: Потеря ограничений при редукции.
- EN: Dropping constraints during reduction.

## Practice prompt

- RU: Сведи задачу расписания к bipartite matching и реши через max flow.
- EN: Reduce a scheduling problem to bipartite matching and solve via max flow.

## Interview framing

- RU: "Какие ограничения задачи кодируются вершинами, а какие ребрами?"
- EN: "Which constraints map to nodes and which map to edges?"
- RU: "Как понять, что редукция не потеряла валидные решения?"
- EN: "How do you ensure the reduction did not lose valid solutions?"

## Key statements

- RU: Качественная редукция сохраняет множество допустимых решений и целевую функцию.
- EN: A high-quality reduction preserves feasibility space and objective value.
- RU: Практический успех зависит от того, насколько компактно построена сеть.
- EN: Practical performance depends on how compactly the network is constructed.

## Must-know tasks

- Easy: maximum bipartite matching как flow.
- Medium: project selection / closure problem через min-cut.

## Explain in 60 seconds

- RU: Применения flow начинаются не с алгоритма, а с моделирования: что такое вершина, ребро, capacity и источник/сток для конкретной бизнес-логики задачи. Если редукция построена корректно, дальше работает стандартный max flow/min cut и мы получаем решение исходной задачи.
- EN: Flow applications begin with modeling, not with algorithm details: define nodes, edges, capacities, source, and sink for the domain logic. If reduction is correct, standard max flow/min cut yields a valid solution to the original problem.

---

## Core idea

- RU: NP-hard показывает, что задача не ожидает полиномиального решения в общем случае.
- EN: NP-hardness indicates no expected polynomial-time solution in general.

## Chapter link

- Book chapter: [NP-Hardness](https://jeffe.cs.illinois.edu/teaching/algorithms/book/12-nphard.pdf)

## Mental model

- RU: Основной инструмент — полиномиальные редукции.
- EN: Core tool: polynomial-time reductions.
- RU: Доказываем "не легче", а не "невозможно абсолютно".
- EN: We prove "at least as hard", not absolute impossibility.

## Complexity checklist

- RU: Проверь принадлежность целевой задачи к NP (если нужно NP-complete).
- EN: Verify NP membership when proving NP-completeness.
- RU: Построй корректную редукцию из известной NP-hard задачи.
- EN: Build a valid reduction from a known NP-hard problem.

## Proof intuition

- RU: Выбирай "близкую" исходную задачу, чтобы редукция была прозрачной.
- EN: Choose a structurally close source problem to keep reduction transparent.
- RU: Докажи оба направления для yes/no-инстансов.
- EN: Prove both directions for yes/no instances.
- RU: Контролируй, что преобразование полиномиально по размеру входа.
- EN: Ensure transformation size/time stays polynomial in input length.

## Typical tasks

- SAT/3-SAT reductions.
- Clique/Vertex Cover/Independent Set.
- Subset Sum variations.

## Common mistakes

- RU: Редукция в неверную сторону.
- EN: Reduction in the wrong direction.
- RU: Отсутствие доказательства эквивалентности "yes/no" ответов.
- EN: Missing yes/no equivalence proof.

## Practice prompt

- RU: Разбери редукцию 3-SAT -> Vertex Cover и объясни ее в 5 шагах.
- EN: Explain the 3-SAT -> Vertex Cover reduction in 5 clear steps.

## Interview framing

- RU: "Чем NP-hard отличается от NP-complete на практике?"
- EN: "What practical difference exists between NP-hard and NP-complete?"
- RU: "Когда выбираешь exact, approximation или heuristic подход?"
- EN: "When do you choose exact, approximation, or heuristic approaches?"

## Key statements

- RU: NP-hard не требует принадлежности к NP; NP-complete требует.
- EN: NP-hard does not require NP membership; NP-complete does.
- RU: Полиномиальная редукция показывает отношение "не легче, чем".
- EN: Polynomial reduction establishes "at least as hard as" relation.

## Must-know tasks

- Easy: объяснить редукцию Subset Sum -> Partition на уровне идеи.
- Medium: разобрать 3-SAT -> Vertex Cover с конструкцией графа.

## Explain in 60 seconds

- RU: В NP-hard темах я не пытаюсь "найти быстрый алгоритм любой ценой", а сначала классифицирую задачу по сложности через редукции. Если задача NP-hard, обсуждаю практические стратегии: ограничения инстанса, approximation, FPT, heuristics. Это показывает зрелый инженерный подход, а не только теорию.
- EN: In NP-hard topics, I do not force a universally fast algorithm; I first classify complexity via reductions. If a problem is NP-hard, I move to practical strategies: restricted instances, approximation, FPT, and heuristics. This demonstrates mature engineering, not just theory.

---

## How to answer

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
