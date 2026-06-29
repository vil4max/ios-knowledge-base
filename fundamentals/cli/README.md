# CLI & Terminal

## In 30 seconds

The terminal is how you automate iOS work outside the Xcode GUI: build and test on CI, boot simulators, inspect crashes with LLDB, search a large codebase, and glue scripts into repeatable workflows. Interviewers and senior engineers expect you to recover when Xcode UI is slow or unavailable—run `xcodebuild`, list devices with `simctl`, attach LLDB to a repro, or grep for a symbol across modules. Environment variables and shell scripts tie into Fastlane, Xcode Cloud, and local debugging. Comfort on the CLI separates “I click Run” from “I can ship and diagnose in any environment.”

## Apple docs

- [Building from the command line with xcodebuild](https://developer.apple.com/documentation/xcode/building-from-the-command-line-with-xcodebuild) — schemes, destinations, build/test/archive.
- [xcodebuild man page (Archive)](https://developer.apple.com/library/archive/technotes/tn2339/_index.html) — TN2339: Xcode build settings from CLI.
- [Simulator CLI (simctl)](https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device) — boot, install, launch, screenshots.
- [Debugging with LLDB](https://developer.apple.com/documentation/xcode/debugging) — breakpoints, expression evaluation, attach.
- [Using LLDB from the command line](https://developer.apple.com/library/archive/documentation/IDEs/Conceptual/gdb_to_lldb_transition_guide/document/lldb-terminal-workflow-tutorial.html) — lldb terminal workflow.
- [Environment variable reference](https://developer.apple.com/documentation/xcode/environment-variable-reference) — `OS_ACTIVITY_MODE`, diagnostics flags.
- [Configuring your project for continuous integration](https://developer.apple.com/documentation/xcode/configuring-your-project-for-continuous-integration) — schemes shared for CLI/CI.
- [Swift Package Manager — swift build / swift test](https://developer.apple.com/documentation/xcode/swift-packages) — CLI for pure Swift packages.

## 🎯 Focus vs Defer

### Focus

- **LLDB CLI essentials** — backtrace, frame vars, po, breakpoint, continue.
  - **Answer:** Attach: `lldb --attach-name App` or launch under lldb. `bt`, `frame variable`, `po object`, `br set -n function`, `c`. Swift expressions need `-enable-objc-interop` context; `@MainActor` code attach on paused main thread.

- **grep/find/ripgrep in repos** — search symbols, plist keys, localized strings.
  - **Answer:** `rg "URLSession" --type swift`, `find . -name "*.xcstrings"`. Exclude `DerivedData`, `.build`, `Pods` via `.ignore` or `--glob '!DerivedData'`. Prefer `rg` speed on large monorepos.

- **Environment variables for iOS dev** — `DEVELOPER_DIR`, scheme pre-actions, runtime debug.
  - **Answer:** `DEVELOPER_DIR` selects Xcode.app on machine with multiple Xcodes. Scheme env vars inject API base URLs for staging. `OS_ACTIVITY_MODE=disable` reduces console noise (use carefully). Never commit secrets—use `.xcconfig` + CI secrets.

- **Shell scripts in workflow** — lint, format, codegen, pre-push hooks.
  - **Answer:** Idempotent scripts in `scripts/`; `set -euo pipefail`; call `xcodebuild` or `swiftformat`/`swiftlint`. Document entry points in README for teammates and agents.

### Defer

- Full `xcodebuild` export IPA/notarization pipeline until release engineering role—know archive exists.
- Advanced LLDB Python scripting and custom formatters—until deep crash triage role.
- GNU vs BSD sed/awk portability wars—use Python/Swift for complex transforms.
- Managing multiple Ruby versions for legacy CocoaPods unless project still requires it.

## Key concepts

- **xcodebuild:** CLI driver for Xcode builds, tests, analysis, and archives using shared schemes.
- **Scheme:** Build/test/run configuration; must be **shared** (`xcshareddata`) for CI CLI access.
- **Destination:** `-destination` string selecting simulator, device, or generic platform for build.
- **simctl:** Subcommand of `xcrun` controlling iOS/watchOS/tvOS simulators from terminal.
- **Virtual simulator camera:** Host Mac app injects frames into AVFoundation inside the simulator process; front/back map to different sources (webcam vs desktop behind Simulator window).
- **xcrun:** Runs tool from active developer directory (`xcrun simctl`, `xcrun swift`, `xcrun lldb`).
- **LLDB:** Debugger backing Xcode; inspect threads, memory, Swift/ObjC expressions at breakpoint.
- **Backtrace (`bt`):** Call stack of current thread; first stop for crash investigation.
- **grep / ripgrep (`rg`):** Search file contents; `rg` is faster with respect for `.gitignore`.
- **find:** Locate files by name/path; combine with `-exec` or pipes carefully.
- **Environment variable:** Key-value in process environment; schemes and CI inject configuration.
- **Exit code:** 0 = success; scripts and CI gate on non-zero from `xcodebuild`/tests.
- **result bundle (`.xcresult`):** Structured test/build results for Xcode and `xcresulttool`.

## 🏋️ Exercises

1. **Build simulator:** Write commands to list schemes and build `MyApp` for iPhone 16 simulator without opening Xcode. **Expected:** `-list`, then `build` with `-workspace`/`-project`, `-scheme`, `-destination`.
2. **simctl install & launch:** Install a `.app` to booted simulator and launch by bundle ID; grant camera permission. **Expected:** `boot`, `install booted`, `launch booted`, `privacy ... grant camera`. Note: grant ≠ real feed — see SimCam / RocketSim for injection.
3. **LLDB crash:** Given EXC_BAD_ACCESS on main, list four lldb commands to run first. **Expected:** `bt`, `frame info`, `register read`, `po`/`memory read` on fault address if valid.
4. **Repo search:** Find all `@MainActor` types under `Sources/` excluding tests. **Expected:** `rg '@MainActor' Sources --glob '!*Test*'`.
5. **CI script sketch:** Bash script: SwiftLint → unit tests → exit non-zero on failure. **Expected:** `set -euo pipefail`, `swiftlint`, `xcodebuild test ...`, propagate exit code.

Doc link: [Building from the command line with xcodebuild](https://developer.apple.com/documentation/xcode/building-from-the-command-line-with-xcodebuild)

## Links

- WWDC 2018 — [Getting Started with Xcode Server](https://developer.apple.com/videos/play/wwdc2018/102/) — historical context for CLI automation (superseded by Xcode Cloud)
- WWDC 2021 — [Customize your Xcode Cloud workflow](https://developer.apple.com/videos/play/wwdc2021/10268/)
- [TN2339: Xcode Build System Guide](https://developer.apple.com/library/archive/technotes/tn2339/_index.html)
- [LLDB terminal workflow (Archive)](https://developer.apple.com/library/archive/documentation/IDEs/Conceptual/gdb_to_lldb_transition_guide/document/lldb-terminal-workflow-tutorial.html)
- External: [ripgrep User Guide](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md) — fast search in large repos
- [SimCam](https://simcam.swmansion.com/) — Mac webcam + desktop-as-rear-camera in iOS Simulator ([GitHub](https://github.com/software-mansion/simcam.app))
- [serve-sim camera](https://github.com/EvanBacon/serve-sim) — open-source webcam/file injection via `simctl`-adjacent CLI

---

## Interview Q&A (Knowledge cards)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question:** Basic xcodebuild workflow for CI?

- **Answer:** Share the scheme, list targets, run `xcodebuild test` with a simulator destination and result bundle, fail CI on non-zero exit. Use archive/export for release IPAs; watch signing and destination strings.

- **Follow-up:** workspace vs project flag?

- **Follow-up answer:** CocoaPods/multi-project → `-workspace`; single `.xcodeproj` without workspace → `-project`.

### Q2
- **Question:** What can simctl automate?

- **Answer:** simctl manages simulator lifecycle, app install/launch, URLs, screenshots, privacy grants, and log streaming—core to headless iOS automation.

### Q3
- **Question:** LLDB from the terminal—minimum for crash triage?

- **Answer:** Start with backtrace, select frame, inspect variables, use `po` on the stopped thread, then breakpoints/continue. Match the failing thread (often main for UI). Symbolicate with dSYM/atos when crashes come from devices.

- **Follow-up:** `po` vs `p`?

### Q4
- **Question:** grep/find, environment variables, and scripts in iOS workflow?

- **Answer:** Use ripgrep/find with ignores for DerivedData; inject config via scheme env and xcconfig; keep secrets in CI. Wrap lint/build/test in strict bash scripts for local and CI parity.

### Q5
- **Question:** How do you test camera features (QR, face detection, Vision) on the iOS Simulator?

- **Answer:** The Simulator has no real camera hardware—only permission grants via simctl. Use host-side tools (SimCam: front = Mac webcam, back = desktop behind the Simulator window; RocketSim; serve-sim) that inject into AVFoundation. Good for QR, face detection, and Vision locally; validate on device before release; CI often stubs camera.

<!-- knowledge-cards-canonical:end -->
