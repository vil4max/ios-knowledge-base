# Performance

## Apple docs

- [Analyzing CPU usage with the Time Profiler instrument](https://developer.apple.com/documentation/xcode/analyzing-cpu-usage-with-the-time-profiler-instrument)
- [Analyzing hangs in your app](https://developer.apple.com/documentation/xcode/analyzing-hangs-in-your-app) — hang detection, responsiveness.
- [Improving app launch time](https://developer.apple.com/documentation/xcode/improving-your-app-s-launch-time) — dyld, pre-main, first frame.
- [Reducing app size](https://developer.apple.com/documentation/xcode/reducing-your-app-s-size) — linked with launch and memory pressure.
- [MetricKit](https://developer.apple.com/documentation/metrickit) — field diagnostics: hang rate, launch, memory, exit metrics.
- [MXMetricManager](https://developer.apple.com/documentation/metrickit/mxmetricmanager) — collect and upload daily payloads.
- [SwiftUI performance](https://developer.apple.com/documentation/swiftui/performance) — identity, equatable, lazy containers.

## За 30 секунд

**Performance** work starts with **measurement**: Time Profiler for CPU, Hangs instrument for main-thread stalls, launch metrics for cold start. On device, watch **main-thread work**—layout, image decode, sync I/O. In SwiftUI, unnecessary **`body` recomputation** (unstable identity, heavy work in `body`) causes jank; fix with stable `id`, extracted subviews, `@Observable` granularity, and moving work off the main actor. **MetricKit** aggregates real-user launch time, hang rate, and memory—complement lab profiling, not replace it.


<details class="lang-ru">
<summary>По-русски</summary>

**Производительность** начинается с **замеров**: Time Profiler, Hangs, Allocations, SwiftUI body cost. Оптимизация только подтверждённых bottleneck (APO).

</details>



## 🎯 Focus vs Defer

### Focus

- **Time Profiler:** main vs background threads; invert call tree; symbolicate app + system frames.
- **Launch time:** pre-main (dyld) vs post-main (your `didFinishLaunching` / first frame); defer non-critical work.
- **Hang detection:** Xcode Hangs instrument; MetricKit `hangRate`; 250ms+ main-thread blocks feel frozen.
- **SwiftUI body cost:** what triggers refresh; `EquatableView`, `@Observable` fine-grained updates; avoid heavy compute in `body`.
- **MetricKit:** daily payloads, diagnostic reports, correlate releases with regressions.

### Defer

- Micro-optimizing Swift syntax before profiling proves a hotspot.
- Premature `@_optimize(none)` / unsafe tricks without Instruments evidence.
- Chasing every MetricKit blip without reproduction recipe in lab.
- Replacing entire UI stack for performance before fixing one synchronous network call on main.

## Key concepts

| Term | Meaning |
|------|---------|
| **Cold launch** | Process not in memory; dyld + init + first frame—user-perceived startup. |
| **Warm / hot launch** | App in memory or resumed; faster but still watch state restore cost. |
| **Main-thread hang** | Long runloop block; touches delayed, watchdog risk on extensions. |
| **Time Profiler** | Samples stacks; self vs total time; find synchronous work. |
| **SwiftUI invalidation** | State change → dependent views recompute `body`; identity drives diffing. |
| **MetricKit hang rate** | Field metric for unresponsive intervals; pairs with stack snapshots in diagnostics. |
| **Signpost** | Mark intervals (launch phases) for Instruments timelines. |
| **Regression budget** | CI or release gate: launch + scroll FPS threshold on fixed device pool. |

**Launch phases (simplified)**

```text
Tap icon
  → dyld + static loaders
  → UIApplicationMain / SwiftUI App init
  → First meaningful frame (avoid sync network on critical path)
```

**SwiftUI checklist**

- Stable `Identifiable` keys in lists.
- Split heavy views; `@ViewBuilder` branches with stable structure.
- Async image/decode off main; `@MainActor` only for UI mutations.

## 🏋️ Exercises

1. **Launch signposts:** Mark `willFinishLaunching`, first view `onAppear`, first network response; one Instruments run. **Expected:** timeline shows largest gap.
2. **Main-thread offender:** Move JSON parsing of 1MB file from main to background; compare Time Profiler self time. **Expected:** main thread freed during parse.
3. **SwiftUI bodies:** Add counter triggering parent refresh; use Instruments SwiftUI template or print in `body` to count recomputes; apply `@Observable` field split. **Expected:** fewer body executions.
4. **Hang reproduction:** Block main with `sleep(2)` on button tap; Hangs instrument flags it. **Expected:** hang report with stack.
5. **MetricKit read:** Enable in TestFlight build; inspect sample payload for `applicationLaunchTime` and hang diagnostics. **Expected:** map keys to doc definitions.

## WWDC & resources

- [Optimize app startup time (WWDC22)](https://developer.apple.com/videos/play/wwdc2022/110362/)
- [Explore UI animation hitches and hangs (WWDC20)](https://developer.apple.com/videos/play/wwdc2020/10077/)
- [Diagnose performance issues with MetricKit (WWDC20)](https://developer.apple.com/videos/play/wwdc2020/10078/)
- [Demystify SwiftUI performance (WWDC23)](https://developer.apple.com/videos/play/wwdc2023/10160/)

## Artifacts

- Notes: `notes/`
- Exercises: `exercises/`
- Assets: `assets/`
- Playgrounds: `playgrounds/`

---

## Interview Q&A (Knowledge cards)

### Q1
- **Question (EN):** How do you investigate scroll jank?

- **Answer (EN):** Profile scrolling on device with Time Profiler, focus on main-thread layout/decode, fix reuse and off-main work, re-measure; use CA instrument for frame hitches if needed.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Как расследуете «приложение тормозит при скролле»?

- **Answer (RU):** Device + Release-like build → **Time Profiler** во время скрола → main thread hot spots (layout, `draw`, decode). Проверить **cell reuse**, размер изображений, синхронный I/O. SwiftUI: частота `body`, тяжёлые модификаторы на каждой ячейке. Подтвердить fix тем же сценарием; опционально Core Animation instrument для hitch frames.

</details>
### Q2
- **Question (EN):** What do you optimize for cold launch?

- **Answer (EN):** Split pre-main vs post-main costs, defer non-critical init and network, reduce linked frameworks, measure with signposts and MetricKit after each change.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Что включаете в оптимизацию cold launch?

- **Answer (RU):** Измерить фазы: **pre-main** (меньше dylibs, +load) и **post-main** (отложить analytics, migrations, sync network). Lazy init тяжёлых singletons. Меньше work до первого кадра; async загрузка некритичного. Signposts + MetricKit launch time в поле. Не гадать — один change → remeasure.

</details>
### Q3
- **Question (EN):** Why can SwiftUI feel slow on large lists?

- **Answer (EN):** Usually excessive invalidation—unstable identity, heavy `body` work, or broad state— not “SwiftUI is slow.” Narrow state, lazy containers, stable IDs, profile to verify.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Почему SwiftUI «медленный» на большом списке?

- **Answer (RU):** Часто не runtime SwiftUI, а **лишние invalidations**: нестабильный `id`, state высоко в дереве, тяжёлая работа в `body`, отсутствие пагинации. `LazyVStack`/`List` без stable identity пересоздаёт subtree. Решение: узкий state, Equatable wrappers где уместно, prefetch/decode off-main, профилировать Instruments.

</details>
### Q4
- **Question (EN):** MetricKit vs Instruments—when to use which?

- **Answer (EN):** Instruments for controlled deep dives; MetricKit for production aggregates and regression detection—field alerts drive lab reproduction.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** MetricKit vs Instruments — когда что?

- **Answer (RU):** **Instruments** — lab, воспроизводимый сценарий, глубокий стек. **MetricKit** — агрегаты с пользовательских устройств (launch, hangs, memory, disk), диагностические отчёты после полевых проблем. Workflow: MetricKit сигналит регрессию → recipe в lab → Instruments → fix → verify in next release.

</details>
