# Performance

## Apple docs

- [Analyzing CPU usage with the Time Profiler instrument](https://developer.apple.com/documentation/xcode/analyzing-cpu-usage-with-the-time-profiler-instrument)
- [Analyzing hangs in your app](https://developer.apple.com/documentation/xcode/analyzing-hangs-in-your-app) — hang detection, responsiveness.
- [Improving app launch time](https://developer.apple.com/documentation/xcode/improving-your-app-s-launch-time) — dyld, pre-main, first frame.
- [Reducing app size](https://developer.apple.com/documentation/xcode/reducing-your-app-s-size) — linked with launch and memory pressure.
- [MetricKit](https://developer.apple.com/documentation/metrickit) — field diagnostics: hang rate, launch, memory, exit metrics.
- [MXMetricManager](https://developer.apple.com/documentation/metrickit/mxmetricmanager) — collect and upload daily payloads.
- [SwiftUI performance](https://developer.apple.com/documentation/swiftui/performance) — identity, equatable, lazy containers.

## In 30 seconds

**Performance** work starts with **measurement**: Time Profiler for CPU, Hangs instrument for main-thread stalls, launch metrics for cold start. On device, watch **main-thread work**—layout, image decode, sync I/O. In SwiftUI, unnecessary **`body` recomputation** (unstable identity, heavy work in `body`) causes jank; fix with stable `id`, extracted subviews, `@Observable` granularity, and moving work off the main actor. **MetricKit** aggregates real-user launch time, hang rate, and memory—complement lab profiling, not replace it.

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
- **Question:** How do you investigate scroll jank?

- **Answer:** Profile scrolling on device with Time Profiler, focus on main-thread layout/decode, fix reuse and off-main work, re-measure; use CA instrument for frame hitches if needed.

### Q2
- **Question:** What do you optimize for cold launch?

- **Answer:** Split pre-main vs post-main costs, defer non-critical init and network, reduce linked frameworks, measure with signposts and MetricKit after each change.

### Q3
- **Question:** Why can SwiftUI feel slow on large lists?

- **Answer:** Usually excessive invalidation—unstable identity, heavy `body` work, or broad state— not “SwiftUI is slow.” Narrow state, lazy containers, stable IDs, profile to verify.

### Q4
- **Question:** MetricKit vs Instruments—when to use which?

- **Answer:** Instruments for controlled deep dives; MetricKit for production aggregates and regression detection—field alerts drive lab reproduction.
