# CLI & Terminal

## In 30 seconds


The terminal is how you automate iOS work outside the Xcode GUI: build and test on CI, boot simulators, inspect crashes with LLDB, search a large codebase, and glue scripts into repeatable workflows. Interviewers and senior engineers expect you to recover when Xcode UI is slow or unavailable—run `xcodebuild`, list devices with `simctl`, attach LLDB to a repro, or grep for a symbol across modules. Environment variables and shell scripts tie into Fastlane, Xcode Cloud, and local debugging. Comfort on the CLI separates “I click Run” from “I can ship and diagnose in any environment.”


<details class="lang-ru">
<summary>По-русски</summary>

Терминал автоматизирует iOS-работу вне Xcode: сборка и тесты через `xcodebuild`, симулятор через `xcrun simctl`, зависимости, скрипты CI. Senior уверенно комбинирует CLI с GUI.

</details>

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

<details class="lang-ru">
<summary>По-русски</summary>

- **xcodebuild basics** — list schemes, build, test, archive with `-destination`.
  - **Answer:** `xcodebuild -list -project Foo.xcodeproj` or `-workspace`. Build: `-scheme App -destination 'platform=iOS Simulator,name=iPhone 16' build`. Test: `test -resultBundlePath ./Out.xcresult`. Archive/release need `-configuration Release` and signing on CI. Failures: wrong scheme not shared, simulator name mismatch.

<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- **simctl** — create/boot simulators, install `.app`, open URL, privacy grants.
  - **Answer:** `xcrun simctl list devices`, `boot <UDID>`, `install booted path/to/App.app`, `launch booted com.example.app`, `privacy booted grant photos com.example.app`. Faster than GUI for CI screenshots and deep-link tests.

<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- **Simulator camera** — no native real camera; host-side injection for local QA.
<details class="lang-ru">
<summary>По-русски</summary>

  - **Answer:** iOS Simulator не отдаёт живой `AVCaptureDevice` — только stub. `simctl privacy … grant camera` лишь разрешает permission, не подставляет кадры. **[SimCam](https://simcam.swmansion.com/)** регистрирует виртуальную камеру: **front** → webcam Mac, **back** → окна **за** окном Simulator (live desktop). В таком режиме на симуляторе можно гонять face detection, QR/barcode, Vision pipelines без физического iPhone. Запуск: SimCam.app → boot simulator → app. CLI `simcamctl` — смена source (image, QR, webcam) для скриптов и AI agents. Альтернативы: RocketSim Simulator Camera, open-source [serve-sim](https://github.com/EvanBacon/serve-sim). Caveats: часть Vision/WebRTC сценариев ограничена; release gates — всё равно device.

</details>


</details>

</details>

</details>
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
- **Question (EN):** Basic xcodebuild workflow for CI?

- **Answer (EN):** Share the scheme, list targets, run `xcodebuild test` with a simulator destination and result bundle, fail CI on non-zero exit. Use archive/export for release IPAs; watch signing and destination strings.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (EN):** Shared scheme, explicit destination, fail on non-zero.

</details>
</details>
</details>
- **Follow-up:** workspace vs project flag?

- **Follow-up answer:** CocoaPods/multi-project → `-workspace`; single `.xcodeproj` without workspace → `-project`.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Базовый **`xcodebuild`** workflow для CI?

- **Answer (RU):** 1) Убедиться, что **scheme shared** в git. 2) `xcodebuild -list` — schemes и destinations. 3) Build/test: `xcodebuild -workspace App.xcworkspace -scheme App -destination 'platform=iOS Simulator,name=iPhone 16' -configuration Debug test -resultBundlePath TestResults.xcresult`. 4) CI использует `-quiet` или `xcbeautify` для логов. 5) Код выхода ≠ 0 — fail pipeline. Archive для IPA: `-archivePath` + `-exportArchive`. Частые ошибки: simulator name, signing on device builds, не тот workspace.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (RU):** Shared scheme → list → test с destination → exit code.

</details>
</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Доп. информация:** [Building from the command line](https://developer.apple.com/documentation/xcode/building-from-the-command-line-with-xcodebuild)

</details>

### Q2
- **Question (EN):** What can simctl automate?

- **Answer (EN):** simctl manages simulator lifecycle, app install/launch, URLs, screenshots, privacy grants, and log streaming—core to headless iOS automation.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (EN):** Boot, install, launch—then URLs, privacy, screenshots.

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up:** как узнать UDID booted simulator?

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer:** `xcrun simctl list devices booted` или `xcrun simctl getenv booted SIMULATOR_UDID` (environment); многие команды принимают `booted` alias.

</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Что умеет **`simctl`** для автоматизации?

- **Answer (RU):** `xcrun simctl list` — devices/runtimes. `create`/`delete`/`boot`/`shutdown`. `install booted <App.app>`, `launch booted <bundle id>`, `terminate`. `openurl booted myapp://path` — deep links. `io booted screenshot out.png`. `privacy booted grant|revoke <service> <bundle>` — permissions без Settings UI. `spawn booted log stream` — логи. На CI: boot нужный runtime, install artifact из `xcodebuild`, UI tests или maestro/скрипты.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (RU):** boot → install → launch → privacy/screenshot по необходимости.

</details>
</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Доп. информация:** [Running your app in Simulator](https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device)

</details>

### Q3
- **Question (EN):** LLDB from the terminal—minimum for crash triage?

- **Answer (EN):** Start with backtrace, select frame, inspect variables, use `po` on the stopped thread, then breakpoints/continue. Match the failing thread (often main for UI). Symbolicate with dSYM/atos when crashes come from devices.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (EN):** Backtrace, frame, po—right thread, symbolicate.

</details>
</details>
</details>
- **Follow-up:** `po` vs `p`?

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer:** `po` — print object description (ObjC `description`/Swift debug); `p` — typed formatter; для Swift часто `po` проще.

</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** **LLDB** из терминала — минимум для crash?

- **Answer (RU):** Подключение: Xcode уже остановил на exception, или `lldb -p <pid>`. **`bt`** — стек всех frames; **`frame select N`**, **`frame variable`**. **`po expr`** — Swift/ObjC объект (на paused thread). **`br set`**, **`c`** — continue. **`thread list`**, **`register read`**. Для Swift concurrency смотреть правильный thread (main vs background). Symbolicate dSYM — Xcode Organizer или `atos`. CLI полезен когда нет GUI на CI device logs — symbolicated crash report + source line.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (RU):** bt → frame → po; правильный thread; dSYM.

</details>
</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Доп. информация:** [Debugging with LLDB](https://developer.apple.com/documentation/xcode/debugging)

</details>

### Q4
- **Question (EN):** grep/find, environment variables, and scripts in iOS workflow?

- **Answer (EN):** Use ripgrep/find with ignores for DerivedData; inject config via scheme env and xcconfig; keep secrets in CI. Wrap lint/build/test in strict bash scripts for local and CI parity.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (EN):** Fast search, xcconfig env, strict scripts.

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up:** зачем `set -u` в CI script?

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer:** fail early на unset variable вместо silent wrong `xcodebuild` path.

</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** **grep/find**, env vars и **scripts** в iOS workflow?

- **Answer (RU):** **Search:** `rg "fatalError" --type swift`, `find . -path '*/DerivedData' -prune -o -name '*.plist' -print`. Исключать build artifacts. **Env:** scheme variables для API endpoints; `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer` на CI; не хранить secrets в git — Keychain/CI secrets + `.xcconfig`. **Scripts:** `scripts/ci-test.sh` with `set -euo pipefail`, вызывает `swiftlint`, `xcodebuild test`. Pre-commit: format/lint staged files. Документировать команды для повторяемости локально и в Xcode Cloud/GitHub Actions.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (RU):** rg + ignore; env через xcconfig; scripts с set -e.

</details>
</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Доп. информация:** [Environment variable reference](https://developer.apple.com/documentation/xcode/environment-variable-reference)

</details>

### Q5
- **Question (EN):** How do you test camera features (QR, face detection, Vision) on the iOS Simulator?

- **Answer (EN):** The Simulator has no real camera hardware—only permission grants via simctl. Use host-side tools (SimCam: front = Mac webcam, back = desktop behind the Simulator window; RocketSim; serve-sim) that inject into AVFoundation. Good for QR, face detection, and Vision locally; validate on device before release; CI often stubs camera.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (EN):** No native feed—injection locally, device for ship.

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up:** нужны ли правки в коде приложения?

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer:** SimCam/RocketSim — нет, если нет `targetEnvironment(simulator)` guard, отключающего камеру. Свой stub — `#if targetEnvironment(simulator)` + fake `FrameSource`.

</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Как тестировать камеру (QR, лица, Vision) на iOS Simulator?

- **Answer (RU):** Нативно — **нельзя**: `AVCaptureDevice` в симуляторе пустой; `simctl privacy grant camera` только permission. Для локальной разработки — **host injection**: [SimCam](https://simcam.swmansion.com/) (front = webcam Mac, back = рабочий стол за окном Simulator), RocketSim, или `serve-sim camera`. Приложение без изменений кода — стандартный AVFoundation. QR: programmatic inject в SimCam. Ограничения: не все Vision/WebRTC пути; перед релизом — **device**. CI обычно stub/mock или UI без live camera.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (RU):** Stub в симуляторе → injection tool → device для релиза.

</details>
</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Доп. информация:** [SimCam](https://simcam.swmansion.com/) · [Running your app in Simulator](https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device)

</details>
<!-- knowledge-cards-canonical:end -->
