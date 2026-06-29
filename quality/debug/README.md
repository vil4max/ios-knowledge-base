# Debug & Instruments

## Apple docs

- [Debugging](https://developer.apple.com/documentation/xcode/debugging) — Xcode debugger overview.
- [LLDB](https://lldb.llvm.org/) — breakpoint commands, `po`, `expr`, memory inspection.
- [Analyzing CPU usage with the Time Profiler instrument](https://developer.apple.com/documentation/xcode/analyzing-cpu-usage-with-the-time-profiler-instrument) — sampling call stacks.
- [Analyzing memory usage with the Allocations instrument](https://developer.apple.com/documentation/xcode/analyzing-memory-usage-with-the-allocations-instrument) — heap growth and object lifetimes.
- [Finding memory leaks](https://developer.apple.com/documentation/xcode/finding-memory-leaks) — Leaks instrument + Memory Graph.
- [Viewing the debug navigator](https://developer.apple.com/documentation/xcode/viewing-the-debug-navigator) — CPU, memory, disk, network gauges.
- [Logging](https://developer.apple.com/documentation/os/logging) — `Logger`, `os_log`, privacy levels, signposts.
- [Measuring performance using logging](https://developer.apple.com/documentation/os/logging/measuring_performance_using_logging) — signposts for Instruments.

## In 30 seconds

**Debugging** on iOS is LLDB in Xcode (breakpoints, view hierarchy, memory graph) plus **Instruments** for time and memory at scale. Use **breakpoints** (symbolic, conditional, exception) to stop at failure; use **Instruments** when the problem is statistical (jank, leaks over time). **`os_log` / `Logger`** gives structured, low-cost production-safe logging with privacy redaction—pair with **signposts** to correlate code regions in Time Profiler. Memory Graph catches retain cycles UI tests miss; View Hierarchy debugs layout and accessibility tree issues.

## 🎯 Focus vs Defer

### Focus

- **LLDB essentials:** `po`, `p`, `expr`, `bt`, `frame variable`, `memory read`, breakpoint actions.
- **Breakpoint types:** file/line, symbolic, exception (`objc_exception_throw`), Swift error, conditional, shared scheme for team.
- **Instruments overview:** Time Profiler, Allocations, Leaks, Energy, Network—when to open which.
- **Memory Graph:** capture → filter retain cycles → inspect strong refs from closures/delegates.
- **View Hierarchy / Debug View:** constraints, hidden views, SwiftUI identity issues (with Xcode tools).
- **`os_log` / `Logger`:** subsystems, categories, `.debug` vs `.fault`, privacy `.public`/`.private`.

### Defer

- Custom LLDB Python commands until standard workflow is exhausted.
- Every Instruments template on day one—start with Time Profiler + Allocations + Leaks.
- **`print()` in production** instead of unified logging.
- Symbolicating crash logs manually before Xcode Organizer workflow is understood.

## Key concepts

| Term | Meaning |
|------|---------|
| **Breakpoint** | Execution pause; inspect state; optional auto-continue with logging. |
| **Exception breakpoint** | Stops at thrown ObjC/Swift exceptions before crash report. |
| **Time Profiler** | Statistical CPU sampling—find hot functions and main-thread work. |
| **Allocations** | Heap events over time; mark generations to see what survived a scenario. |
| **Leaks instrument** | Detects unreferenced malloc blocks still allocated. |
| **Memory Graph** | Snapshot of object graph; highlights cycles and unexpected strong refs. |
| **View Hierarchy** | 3D/layer tree of UIKit; constraint warnings; accessibility elements. |
| **Signpost** | `os_signpost` interval markers visible in Instruments alongside CPU. |
| **Unified logging** | `Logger`/`os_log`; persisted; filter in Console.app; respects privacy. |

**Typical workflow**

```text
Repro bug
  → Breakpoint / exception break (correct stack)
  → If perf/memory: Instruments trace on device
  → If layout: View Hierarchy + accessibility inspector
  → If field issue: logs + MetricKit/crash report correlation
```

## 🏋️ Exercises

1. **Conditional break:** Break in `cellForRow` only when `indexPath.row == 5`. **Expected:** other rows render without stopping.
2. **Retain cycle:** Create closure capturing `self` strongly in a demo VC; confirm Leaks + Memory Graph show cycle; fix with `[weak self]`. **Expected:** graph clean after fix.
3. **Time Profiler:** Scroll a heavy list; record 10s; top symbols on main thread. **Expected:** identify one layout or image decode hotspot.
4. **Signpost:** Wrap network fetch with `os_signpost`; run trace; see interval in Instruments. **Expected:** interval aligns with URLSession work.
5. **`Logger` privacy:** Log user email with `.private`; view in Console—redacted. **Expected:** structured entry without PII leak.

## WWDC & resources

- [Debug with structured logging (WWDC20)](https://developer.apple.com/videos/play/wwdc2020/10109/)
- [Model your processes with signposts (WWDC18)](https://developer.apple.com/videos/play/wwdc2018/405/)
- [Detect and diagnose memory issues (WWDC21)](https://developer.apple.com/videos/play/wwdc2021/10180/)

## Artifacts

- Notes: `notes/`
- Exercises: `exercises/`
- Assets: `assets/`
- Playgrounds: `playgrounds/`

---

## Interview Q&A (Knowledge cards)

### Q1
- **Question:** How do you find a retain cycle in a running app?

- **Answer:** Reproduce, capture Memory Graph or Leaks trace, inspect unexpected strong edges (closures, delegates, timers). Verify `deinit` after fixing weak/unowned captures.

### Q2
- **Question:** Why prefer `os_log`/`Logger` over `print` on iOS?

- **Answer:** Structured subsystems, privacy redaction, persistence, signpost integration, and lower overhead—`print` lacks filtering and leaks data easily.

### Q3
- **Question:** When do you use Time Profiler vs Allocations?

- **Answer:** Time Profiler for CPU/jank; Allocations for heap growth and churn; Leaks/Memory Graph for retention. Often profile CPU first, then heap on the same scenario.

### Q4
- **Question:** Why set an exception breakpoint if you get a crash log anyway?

- **Answer:** It stops at throw time with intact stack and locals—often clearer than post-mortem crash logs, especially around ObjC exceptions and assertion failures.
