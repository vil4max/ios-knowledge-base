# Crash Analytics & Monitoring

## In 30 seconds

Production iOS monitoring combines **crash reports**, **performance metrics**, and **structured logs** so you can detect regressions before users flood support. Apple gives you **MetricKit** (hangs, launches, disk writes, CPU), **OSLog** (privacy-aware logging), and **Xcode Organizer / crash logs** with **dSYM symbolication**. Third-party tools like **Firebase Crashlytics** add aggregation, breadcrumbs, and release health dashboards. Senior answers tie the pipeline together: collect → symbolicate → triage by impact → fix → verify in the next build with uploaded symbols and MetricKit deltas.

## Apple docs

- [MetricKit](https://developer.apple.com/documentation/metrickit) — `MXMetricManager`, daily diagnostic and metric payloads (hangs, crashes, launches, memory, energy).
- [Logging (OSLog)](https://developer.apple.com/documentation/os/logging) — unified logging, subsystems, categories, privacy levels (`public` / `private`).
- [Analyzing a crash report](https://developer.apple.com/documentation/xcode/analyzing-a-crash-report) — exception types, thread backtraces, last exception backtrace.
- [Building your app to include debugging information](https://developer.apple.com/documentation/xcode/building-your-app-to-include-debugging-information) — Debug Information Format, dSYM generation.
- [Diagnosing issues using crash reports and diagnostic reports](https://developer.apple.com/documentation/xcode/diagnosing-issues-using-crash-reports-and-diagnostic-reports) — Organizer, symbolicated stacks.
- [Uploading your app’s dSYM files](https://developer.apple.com/documentation/xcode/uploading-your-apps-d-sym-file-to-app-store-connect) — App Store Connect symbol upload for server-side symbolication.
- [Reporting crashes to Apple](https://developer.apple.com/documentation/xcode/diagnosing-issues-using-crash-reports-and-diagnostic-reports#Report-crashes-to-Apple) — opt-in crash collection from TestFlight and App Store builds.

## 🎯 Focus vs Defer

### Focus

- **Crash pipeline end-to-end** — capture, symbolicate, group, prioritize, fix, verify.
  - **Answer:** Raw crash = addresses + binary UUIDs. **dSYM** maps addresses to symbols. Without matching dSYM for the exact build UUID, stacks show `0x…` only. Upload dSYMs to App Store Connect and/or Crashlytics on every release build. Triage by **affected users**, **version**, **signal** (SIGSEGV vs SIGABRT), and **reproducibility**.

- **MetricKit for perf regressions** — hangs, launch time, scroll hitch metrics, disk writes.
  - **Answer:** Subscribe to `MXMetricManager`; process **daily** payloads off main thread. Use for “app got slower” without full Instruments session. Pair with release tags to spot regressions between versions. Not a substitute for profiling hot paths—good for fleet-level trends.

- **OSLog discipline** — subsystems, categories, `.info` vs `.debug`, privacy.
  - **Answer:** Prefer `Logger(subsystem:category:)` over `print`. Mark PII as `privacy: .private` so logs survive device collection without leaking data. Correlate logs with crash **breadcrumbs** in Crashlytics by logging stable event IDs, not user emails.

- **Crash triage workflow** — dedupe, root cause, ownership, SLA.
  - **Answer:** Group by **top frame in app code** + exception reason. Ignore system frames until app frame identified. **SIGABRT** often asserts/preconditions; **EXC_BAD_ACCESS** often memory/lifetime. Assign severity: crash on launch > background > edge screen. Link to commit via `CFBundleVersion` / build number in report.

- **Symbolication basics** — UUID match, `atos`, Organizer, missing dSYM.
  - **Answer:** Each binary slice has a **UUID** in the crash report. dSYM must match UUID + architecture. CI should archive dSYMs per build and upload automatically. “Missing symbol” usually means wrong build or bitcode recompilation (legacy)—keep immutable artifact per release.

### Defer

- Building a custom crash reporter from scratch when MetricKit + Crashlytics + Organizer cover most teams.
- Real-time log streaming infrastructure (ELK/Datadog) before structured OSLog and release-scoped debugging are in place.
- Chasing every low-volume crash in third-party SDKs before fixing top 3 app-owned crash clusters.
- MetricKit custom signposts for every function—start with launch, network, and main-screen interactive milestones.

## Key concepts

- **Crash report:** OS-generated artifact after fatal signal/exception; includes threads, registers, binary images, exception type.
- **dSYM (debug symbol file):** Companion file mapping machine addresses to function names and line numbers for a specific build UUID.
- **Symbolication:** Process of resolving raw addresses to human-readable stack frames using dSYM + crash report.
- **MetricKit:** Framework delivering aggregated diagnostics (crashes, hangs, CPU, memory, disk, launch) from user devices with user consent.
- **OSLog / unified logging:** System-wide logging with persistence, performance, and privacy annotations; view in Console.app and Instruments.
- **Breadcrumb:** Timestamped trail of user/app events before a crash (Crashlytics and similar); narrows reproduction.
- **Crash triage:** Prioritization by frequency, severity, version scope, and whether stack points to first-party code.
- **Hang rate:** MetricKit metric for main-thread unresponsiveness; distinct from crash but equally visible in reviews.
- **Non-fatal / recorded error:** Logged error without process termination; useful for degraded paths (API parse failure) with sampling.
- **Release health:** Dashboard view—crash-free users/sessions, new vs recurring issues, build comparison.

## 🏋️ Exercises

1. **dSYM UUID match:** Given a crash log listing `MyApp` UUID `ABC…` and an archived dSYM with UUID `DEF…`, explain why symbolication fails and what CI step fixes it. **Expected:** UUID mismatch; archive and upload dSYM from the exact CI job that produced the shipped IPA.
2. **OSLog privacy:** Rewrite `print("User logged in: \(email)")` using `Logger` with appropriate privacy. **Expected:** `logger.info("User logged in: \(email, privacy: .private)"` or log user ID hash only.
3. **MetricKit handler:** Sketch `MXMetricManagerSubscriber` that parses hang diagnostics and attaches `CFBundleShortVersionString` before forwarding to your backend. **Expected:** async processing, no main-thread JSON work, version tagging for regression detection.
4. **Triage table:** For three crash clusters—launch SIGABRT in `AppDelegate`, background `EXC_BAD_ACCESS` in image cache, 0.01% SDK crash—order fix priority and justify. **Expected:** launch first, app-owned background second, low-rate SDK third unless blocking release.
5. **Breadcrumb design:** List five breadcrumb events for a checkout flow that would help debug a crash on payment confirmation. **Expected:** cart state, payment method type (not PAN), network request start/end, view appearance, error codes—no secrets.

## Links

- WWDC 2020 — [Detect and diagnose memory issues](https://developer.apple.com/videos/play/wwdc2020/10180/) — crashes, leaks, MetricKit mindset
- WWDC 2020 — [Explore logging in OSLog](https://developer.apple.com/videos/play/wwdc2020/10168/)
- WWDC 2021 — [Analyze HTTP traffic in Instruments](https://developer.apple.com/videos/play/wwdc2021/10209/) — correlate network with user-visible failures
- [MetricKit — MXCrashDiagnostic](https://developer.apple.com/documentation/metrickit/mxcrashdiagnostic)
- [Energy Efficiency Guide for iOS Apps](https://developer.apple.com/library/archive/documentation/Performance/Conceptual/EnergyGuide-iOS/) — monitoring-driven optimizations
- External: [Firebase Crashlytics — iOS get started](https://firebase.google.com/docs/crashlytics/get-started?platform=ios) — third-party crash aggregation (common in production)

---

## Interview Q&A (Knowledge cards)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question:** What is a dSYM and why is it needed for crash reports?

- **Answer:** A dSYM maps instruction addresses in a crash report to function names and line numbers for one specific build UUID. Symbolication requires the dSYM that matches the shipped binary; otherwise stacks stay unsymbolicated.

### Q2
- **Question:** How does MetricKit differ from Crashlytics?

- **Answer:** MetricKit is Apple’s on-device aggregated diagnostics channel. Crashlytics is a third-party service for crash grouping, breadcrumbs, and team dashboards. They complement each other rather than replace each other.

### Q3
- **Question:** How should you use OSLog in production?

- **Answer:** Use `Logger` with subsystem and category, annotate sensitive values with privacy, prefer `.info`/`.error` in production, and avoid `print`. OSLog integrates with Console and Instruments and respects user privacy settings.

### Q4
- **Question:** Describe crash triage for a new release.

- **Answer:** Filter by release, ensure symbolication, cluster by in-app top frame, rank by user impact and novelty, assign owners, fix with regression test, verify metrics on the next build.

<!-- knowledge-cards-canonical:end -->
