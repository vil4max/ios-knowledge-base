# Glossary

Section **XI · Summary** on the [iosiq roadmap](https://iosiq.ru/roadmap.html): terms and short definitions.

## Theme

### Q1
- **Question:** What should this folder contain?
- **Answer:** An extensible glossary (or digests from topics I–X) for quick recall before interviews or reviews.

---

## Glossary of key terms

### Memory and data model

<a id="glossary-arc"></a>
**ARC** — *Automatic Reference Counting* — automatic reference counting; an object is freed when it has zero strong references.

<a id="glossary-weak"></a>
**weak** — optional reference (`Optional`); does not retain the object — typical way to break a cycle with a delegate or closure.

<a id="glossary-unowned"></a>
**unowned** — non-retaining reference; assumes the object outlives the reference; wrong lifecycle can crash on access.

<a id="glossary-retain-cycle"></a>
**Retain cycle** — mutual strong references between objects (or `self` in `@escaping` without `weak`), so memory is never released.

<a id="glossary-value-type"></a>
**Value type** — `struct` / `enum` (etc.): copy semantics; shared ownership via buffer reference with COW collections.

<a id="glossary-reference-type"></a>
**Reference type** — `class`: one heap instance, identity via reference; lifetime managed by ARC.

<a id="glossary-cow"></a>
**COW** — *Copy-On-Write* — when copying large value types (e.g. `Array`), the buffer is shared until the first mutation, then copied.

<a id="glossary-shallow-copy"></a>
**Shallow copy** — duplicates the top-level container, but nested **reference** objects remain the same instances: copy and original share references to the same `class` objects (or the same buffer until a COW break).

<a id="glossary-deep-copy"></a>
**Deep copy** — copies the data graph “deeply”: nested objects get independent copies as required (often manually or via `Codable`/archiving); Swift has no universal automatic deep copy for classes.

### Swift Concurrency

<a id="glossary-actor"></a>
**actor** — Swift type guaranteeing *serialised access* to its state through isolation on its executor.

<a id="glossary-mainactor"></a>
**@MainActor** — global actor binding execution to the main queue (UI and typical main-thread API).

<a id="glossary-sendable"></a>
**Sendable** — marker protocol for types safe to cross *isolation domains* without data races.

<a id="glossary-nonisolated"></a>
**nonisolated** — member of an actor-isolated type (e.g. `@MainActor`) explicitly run **outside** that actor’s isolation; removes automatic serialization — you must control what is passed and from where it is called.

<a id="glossary-nonisolated-unsafe"></a>
**nonisolated(unsafe)** — like `nonisolated`, but the compiler **does not check** state safety; only as a narrow exception when the invariant is proven manually.

<a id="glossary-async-await"></a>
**async / await** — at `await` execution suspends; the thread is not blocked waiting on I/O — the runtime can do other work (alternative to completion-handler chains).

<a id="glossary-task"></a>
**Task** — unit of structured concurrency: inherits priority and context (including cancellation from the parent task).

<a id="glossary-structured-concurrency"></a>
**Structured concurrency** — hierarchy of `Task` / `async let` / `TaskGroup`: on scope exit the parent waits for child tasks; cancellation propagates downward.

<a id="glossary-isolation"></a>
**Isolation** — compiler rule: actor / `@MainActor` code runs only on the allowed executor or via `await` when crossing a boundary.

### Types and protocols

<a id="glossary-existential"></a>
**Existential** — type `any P`: runtime “box” for any conformance to protocol `P` (existential container / witness table).

<a id="glossary-opaque"></a>
**Opaque** — type `some P`: concrete type known to the compiler, exposed only as `P` conformance (opaque result type).

<a id="glossary-pat"></a>
**PAT** — *Protocol with Associated Types* — protocol with associated types; cannot be used as a plain type without concretization, `any`/`some`, or type erasure as needed.

<a id="glossary-generic"></a>
**Generic** — parameterize a type or function with a placeholder type (`Array<Element>`, `func foo<T>(_: T)`).

<a id="glossary-type-erasure"></a>
**Type erasure** — wrapper (`AnySequence`, `AnyView`) hiding a concrete generic behind one protocol type for collections or public API.

<a id="glossary-pop"></a>
**POP** — *Protocol-Oriented Programming* — compose behavior via protocols and `extension` instead of deep class inheritance.

<a id="glossary-codable"></a>
**Codable** — synonym for `Encodable & Decodable`; automatic or manual mapping to/from JSON/plist.

<a id="glossary-equatable"></a>
**Equatable** — logical equality protocol (`==`); basis for tests, `contains`, value branching.

<a id="glossary-hashable"></a>
**Hashable** — extends `Equatable`: hash for `Set` elements and `Dictionary` keys; implement via `hash(into:)` — hash value is not guaranteed stable across process launches (Hasher randomization).

### UIKit

<a id="glossary-diffable-data-source"></a>
**Diffable Data Source** — API for `UICollectionView` / `UITableView` with automatic animations via snapshot diffing.

<a id="glossary-compositional-layout"></a>
**Compositional Layout** — declarative layout for `UICollectionView`: items → groups → sections.

<a id="glossary-auto-layout"></a>
**Auto Layout** — constraint system between views: position and size from constraints, not fixed frames (adapts to screen and localization).

<a id="glossary-safe-area"></a>
**Safe Area** — content region inside the screen accounting for notches, Home indicator, and keyboard; pin UI to `safeAreaLayoutGuide`.

<a id="glossary-uiviewcontroller-lifecycle"></a>
**UIViewController lifecycle** — chain `loadView` → `viewDidLoad` → `viewWillAppear` → `viewDidAppear` → …; hooks for loading data and subscribing to notifications.

<a id="glossary-intrinsic-content-size"></a>
**Intrinsic Content Size** — view’s natural size from content; affects constraint resolution without explicit width/height.

<a id="glossary-runloop"></a>
**RunLoop** — thread event loop (on main: gestures, timers, input sources); long synchronous work on main blocks UI responsiveness.

<a id="glossary-kvo"></a>
**KVO** — *Key-Value Observing* — notifications when a property changes via key-path; in Swift requires `@objc` and `dynamic` (or NSObject subclasses); remove observation carefully to avoid dangling references.

### SwiftUI

<a id="glossary-state"></a>
**@State** — stores value-type state owned by the view; updates `body` on change.

<a id="glossary-binding"></a>
**@Binding** — two-way link to parent state (`$foo`); does not own the value.

<a id="glossary-observable"></a>
**@Observable** — (Swift 5.9+) observable model macro; fine-grained view updates on field changes without manual `objectWillChange`.

<a id="glossary-viewbuilder"></a>
**ViewBuilder** — `@resultBuilder` for nested view DSL in `body` and modifiers.

### Swift syntax / DSL

<a id="glossary-optional"></a>
**Optional** — enum with `.some(Wrapped)` and `.none`; `?` and `!` suffixes are Optional sugar.

<a id="glossary-optional-chaining"></a>
**Optional chaining** — access chain via `?.`: if any link is `nil`, the whole chain is `nil` and right-hand expressions are not evaluated (*short-circuit*); result type stays Optional.

<a id="glossary-nil-coalescing-operator"></a>
**Nil-coalescing operator** — binary `??`: if the left side is not `.none`, returns the unwrapped value; otherwise evaluates and returns the right operand (right side is **not** evaluated when left has a value).

<a id="glossary-implicitly-unwrapped-optional"></a>
**Implicitly unwrapped optional** — *IUO* — type `Wrapped!`; same as `Optional<Wrapped>`, but the compiler allows access to `Wrapped` without explicit `?`/`!`; `.none` access causes a runtime error; use only where “value exists before use” is truly guaranteed (often `@IBOutlet`, initialization phases).

<a id="glossary-pattern-matching"></a>
**Pattern matching** — match a value to a **pattern**: `switch` / `if case` / `guard case` / `for case`, extract enum associated values, unpack tuples, `where` conditions; basis of expressive branching in Swift.

<a id="glossary-swift-operators-overview"></a>
**Swift operators (overview)** — ternary `? :`; **nil-coalescing** `??` and **optional chaining** `?.` in separate entries; arithmetic `+ - * / %`, comparison `== != < > <= >=`, logic `&& || !`, assignment `=` and compound `+=` … `>>=`; ranges `...` `..<` (including one-sided); overflow `&+ &- &* &/ &%`; reference identity `=== !==`; casting `is` `as` `as?` `as!`; closure operator `{ }`; custom operators via `operator` (`prefix` / `infix` / `postfix`) with precedence and associativity.

<a id="glossary-capture-list"></a>
**Capture list** — in a closure `{ [weak self] in … }` explicit capture list; default is strong references and retain-cycle risk.

<a id="glossary-concatenation"></a>
**Concatenation** — joining data into one whole; most often used for string joining.

<a id="glossary-escaping"></a>
**@escaping** — closure that may be called after the function returns (e.g. `URLSession` callback); capture `self` deliberately (`weak`/`unowned` when needed).

<a id="glossary-guard"></a>
**guard** — early exit from a function; straightens the “happy path”.

<a id="glossary-defer"></a>
**defer** — block run on **any** exit from the current scope (reverse order with multiple `defer`) — handy for symmetric cleanup.

<a id="glossary-throws-rethrows"></a>
**throws / rethrows** — `throws`: function may end with `Error`; `rethrows`: propagates error only if the passed closure throws.

<a id="glossary-inout"></a>
**inout** — parameter passed by reference for mutation inside the function and visible outside after return.

<a id="glossary-property-wrapper"></a>
**Property wrapper** — syntax `@Wrapper var x`: compiler generates storage and access via the wrapper type (`@State`, `@Published`, …).

<a id="glossary-result-builder"></a>
**Result Builder** — declarative syntax “like SwiftUI `body`”; built via `@resultBuilder`.

### Network and storage

<a id="glossary-urlsession"></a>
**URLSession** — HTTP(S) API: `data(for:)`, upload/download tasks, configurations and cache; typical REST client foundation.

<a id="glossary-rest"></a>
**REST** — HTTP API style: resources, method verbs, status codes; convention, not a protocol.

<a id="glossary-json"></a>
**JSON** — text data interchange format; in Swift usually parsed via `Codable`.

<a id="glossary-keychain"></a>
**Keychain** — secret storage isolated from the app and protected by the system (encryption, access policies).

<a id="glossary-ats"></a>
**ATS** — *App Transport Security* — platform policy: by default requires secure transport (HTTPS, modern TLS, limits on exceptions).

<a id="glossary-certificate-pinning"></a>
**Certificate pinning** — client verifies server certificate or public key against an embedded fingerprint (pin), not only the system trust store; hardens against MITM if a CA is compromised, but complicates certificate rotation.

### Metrics, diagnostics, and tests

<a id="glossary-metrickit"></a>
**MetricKit** — framework for stability and performance metrics from real devices (field diagnostics).

<a id="glossary-instruments"></a>
**Instruments** — Xcode profiler suite: CPU, memory, network, energy, SwiftUI; find bottlenecks and leaks.

<a id="glossary-mcp"></a>
**MCP** — *Model Context Protocol* — open protocol connecting AI assistants to external tools and data.

<a id="glossary-unit-test"></a>
**Unit test** — isolated logic (models, services) with mocks/stubs; no manual UI.

<a id="glossary-ui-test"></a>
**UI test** — XCTest scenarios over the accessibility tree on simulator or device: end-to-end user flows.

### Build and project architecture

<a id="glossary-spm"></a>
**SPM** — *Swift Package Manager* — Apple’s package and dependency manager.

<a id="glossary-tuist"></a>
**Tuist** — generates Xcode projects from Swift descriptions (modules, targets, consistent structure).

<a id="glossary-tca"></a>
**TCA** — *The Composable Architecture* (Point-Free) — **Reducer / State / Action** model for composing logic, often with SwiftUI.

<a id="glossary-dsym"></a>
**dSYM** — debug symbols mapping crash log addresses to source lines (including TestFlight/App Store Connect).

<a id="glossary-ci-cd"></a>
**CI/CD** — continuous integration and delivery: automated builds, tests, and artifact deployment via pipeline.

<a id="glossary-app-thinning"></a>
**App Thinning** — App Store delivers a “slim” build: only the **binary slice** for the device architecture and matching resource variants by idiom/scale; reduces download size (optionally with *On-Demand Resources*).

### Processes and documents

<a id="glossary-rfc"></a>
**RFC** — *Request For Comments* — document proposing a technical change (including Swift Evolution).

<a id="glossary-adr"></a>
**ADR** — *Architecture Decision Record* — short record of an architecture decision with context and consequences.
