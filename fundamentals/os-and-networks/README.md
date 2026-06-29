# OS & Networks

## In 30 seconds

Operating systems and networking explain how an iOS app lives inside a sandboxed process, schedules work on threads and RunLoop, reacts to memory pressure, and talks to servers over TCP/TLS/HTTP. Interviewers connect this layer to symptoms you see daily: main-thread jank, background task limits, certificate errors, stale DNS, and crashes after jetsam. You do not need to draw the full OS kernel, but you should explain why URLSession callbacks may hop queues, what happens on a memory warning, and how TLS fits between HTTP and TCP. This topic bridges CS fundamentals to Foundation, URLSession, and app lifecycle.

## Apple docs

- [RunLoop](https://developer.apple.com/documentation/foundation/runloop) — event processing on a thread; main RunLoop drives UIKit.
- [Dispatch (GCD)](https://developer.apple.com/documentation/dispatch) — queues, groups, semaphores, work submission.
- [OperationQueue](https://developer.apple.com/documentation/foundation/operationqueue) — dependencies, cancellation, QoS on top of GCD.
- [App and process life cycle](https://developer.apple.com/documentation/uikit/app_and_environment/managing_your_app_s_life_cycle) — foreground/background, suspension.
- [Responding to memory warnings](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622957-applicationdidreceivememorywarning) — cache eviction under pressure.
- [URL Loading System](https://developer.apple.com/documentation/foundation/url_loading_system) — HTTP stack in Foundation.
- [App Transport Security](https://developer.apple.com/documentation/bundleresources/information_property_list/nsapptransportsecurity) — TLS requirements and exceptions.
- [Network framework](https://developer.apple.com/documentation/network) — lower-level connections, TLS, path monitoring (`NWPathMonitor`).

## 🎯 Focus vs Defer

### Focus

- **iOS process model and sandbox** — one app process, extensions as separate processes, entitlements, container paths.
  - **Answer:** Main app = isolated address space; cannot read another app’s files. Data in sandbox `Documents`, `Library`, `tmp`. Extensions share app group only if configured. Interview: tie to Keychain, file protection, and why background execution is limited.

- **Main thread, RunLoop, and UI responsiveness** — sources, modes, why `DispatchQueue.main.async` defers work.
  - **Answer:** Main thread runs a RunLoop that dispatches timers, input, and perform/select sources. Long synchronous work blocks the loop → frozen UI. `async` to main schedules a block on the main queue for a future RunLoop turn. CommonSources: touch, display link, network callbacks marshaled to main for UI updates.

- **GCD overview** — serial vs concurrent queues, QoS, main queue, sync vs async pitfalls.
  - **Answer:** Serial queue = one task at a time (order preserved). Concurrent = multiple tasks, order of completion undefined. QoS hints priority/energy. Never `sync` on main from main (deadlock). Prefer Swift Concurrency for new code; still explain GCD because legacy APIs and interviews use it.

- **TCP, HTTP, TLS, DNS at client level** — enough to debug URLSession failures.
  - **Answer:** DNS resolves host → IP. TCP = reliable byte stream (3-way handshake, retransmit). TLS encrypts inside TCP (handshake, cert validation). HTTP = request/response semantics on top (methods, headers, status codes). URLSession handles much of this; you configure ATS, timeouts, caching, auth challenges.

- **Memory pressure and jetsam** — warnings vs termination, what to purge.
  - **Answer:** `applicationDidReceiveMemoryWarning` → drop caches, release large buffers. Jetsam kills processes under system memory stress—no guarantee to run code. Footprint = dirty + compressed; reduce peak during image decode and large JSON.

- **Background execution limits** — why arbitrary long work does not run when app is backgrounded.
  - **Answer:** iOS suspends apps quickly; continued work needs modes: BGTaskScheduler, background URLSession, push, audio/location/etc. Abuse leads to throttling or termination.

### Defer

- Writing a custom TCP stack or HTTP/2 frame parser—use URLSession/Network framework unless specialized.
- Kernel scheduler internals and Mach port details—high-level RunLoop/GCD story is enough.
- Full PKI chain management by hand—know pinning trade-offs and system trust store at concept level.
- IPv6 transition mechanisms (464XLAT, etc.) until app shows connectivity bugs on specific networks.

## Key concepts

- **Process:** OS instance with virtual memory; iOS apps and extensions run as separate sandboxed processes.
- **Thread:** Concurrent execution within a process; main thread owns UIKit/SwiftUI updates.
- **RunLoop:** Event loop on a thread processing input sources and timers; main RunLoop ties UI to system events.
- **GCD (Grand Central Dispatch):** C API to submit blocks to serial/concurrent queues backed by thread pool.
- **QoS (Quality of Service):** Priority class affecting scheduling and energy (userInteractive … background).
- **TCP:** Connection-oriented reliable transport; retransmits lost packets; basis for HTTPS.
- **HTTP:** Application protocol: methods (GET/POST/…), headers, status codes (2xx/4xx/5xx), body semantics.
- **TLS:** Encryption and server authentication above TCP; certificates validated against trust store (ATS on iOS).
- **DNS:** Name → address resolution; failures look like “host not found”; caching affects failover.
- **Sandbox:** Kernel-enforced restriction on file system, network capabilities, and IPC between apps.
- **Memory warning:** System signal that memory is tight; app should purge caches; precursor to jetsam.
- **NWPathMonitor:** Observes network interface changes (Wi‑Fi/cellular/offline) for adaptive behavior.

## 🏋️ Exercises

1. **Main-thread freeze:** A JSON parse of 50 MB runs synchronously after `URLSession` callback on main. List two fixes and why. **Expected:** move decode to background QoS; return to main only for UI; mention cooperative cancellation.
2. **GCD deadlock:** Explain why `DispatchQueue.main.sync { }` called from main hangs. **Expected:** serial queue waits for itself; use async or avoid blocking main.
3. **HTTP debugging:** Map status codes 301, 401, 429, 503 to client actions (redirect, refresh token, backoff, retry). **Expected:** policy table with idempotency note for retries.
4. **Memory pressure plan:** App caches 200 MB of images in RAM. Write eviction steps on memory warning and at launch after jetsam kill. **Expected:** NSCache limits, flush in-memory, disk cache optional, reload on demand.
5. **TLS/ATS:** App must call a legacy HTTP endpoint. **Expected:** prefer HTTPS migration; if exception, narrow ATS exception domain, document risk; never disable ATS globally without justification.

Doc link: [Responding to memory warnings](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622957-applicationdidreceivememorywarning)

## Links

- WWDC 2015 — [Protocol-Oriented Programming in Swift](https://developer.apple.com/videos/play/wwdc2015/408/) — still cited for performance mindset (context for system interaction)
- WWDC 2021 — [Meet async/await in Swift](https://developer.apple.com/videos/play/wwdc2021/10132/) — scheduling model today
- WWDC 2018 — [Networking with Custom Protocols](https://developer.apple.com/videos/play/wwdc2018/411/) — URLSession stack depth
- [Energy Efficiency Guide for iOS Apps](https://developer.apple.com/library/archive/documentation/Performance/Conceptual/EnergyGuide-iOS/)
- [Preventing Insecure Network Connections](https://developer.apple.com/documentation/security/preventing_insecure_network_connections)
- External: [MDN HTTP overview](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview) — protocol semantics reference

---

## Interview Q&A (Knowledge cards)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question:** How does the iOS app process model and sandbox work?

- **Answer:** Each iOS app runs in its own sandboxed process with a private container. Extensions are separate processes; shared storage requires App Groups or Keychain. Background apps are suspended unless using approved background modes.

### Q2
- **Question:** Why does the main thread need a RunLoop, and how does GCD relate?

- **Answer:** The main RunLoop drives UI and input; blocking it freezes the UI. GCD schedules blocks; the main queue runs on the main RunLoop turn. Background work uses other queues or Swift tasks.

### Q3
- **Question:** Walk through an HTTP request path: DNS → TCP → TLS → HTTP.

- **Answer:** DNS resolves the host; TCP connects; TLS encrypts and authenticates; HTTP carries request/response semantics. URLSession manages the stack; ATS enforces secure defaults on iOS.

### Q4
- **Question:** Memory pressure and jetsam—what should the app do?

- **Answer:** On memory warnings, purge caches and release large buffers. Jetsam terminates the process under system pressure—design for lower peak memory and fast recovery after relaunch.

<!-- knowledge-cards-canonical:end -->
