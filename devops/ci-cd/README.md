# CI/CD

## Apple docs

- [Xcode Cloud](https://developer.apple.com/documentation/xcode/xcode-cloud) — Apple-hosted CI for Apple platforms.
- [Configuring your first Xcode Cloud workflow](https://developer.apple.com/documentation/xcode/configuring-your-first-xcode-cloud-workflow)
- [Creating a workflow in Xcode Cloud](https://developer.apple.com/documentation/xcode/creating-a-workflow-in-xcode-cloud)
- [Running tests from the command line](https://developer.apple.com/documentation/xcode/running-tests-from-the-command-line) — `xcodebuild test`.
- [Organizing tests to improve feedback](https://developer.apple.com/documentation/xcode/organizing-tests-to-improve-feedback) — Test Plans.
- [Building from the command line](https://developer.apple.com/documentation/xcode/building-from-the-command-line) — schemes, destinations.
- [Environment variable reference](https://developer.apple.com/documentation/xcode/environment-variable-reference) — CI secrets and flags.

## За 30 секунд

**CI/CD** for iOS runs **build + test + archive** on every change. **Xcode Cloud** integrates with App Store Connect, manages macOS runners and signing; **Fastlane** automates lanes (test, beta, release) on any Mac CI. Locally and in CI, **`xcodebuild test`** drives simulators with a **shared scheme** and **Test Plan** (`.xctestplan`) to split PR vs nightly tests. Keys: reproducible schemes (`shared`), locked simulator OS, parallel test execution, and artifacts (`.xcresult`, dSYM) retained for failures.


<details class="lang-ru">
<summary>По-русски</summary>

**CI/CD** для iOS: **build + test + archive** на каждое изменение. **Xcode Cloud**, GitHub Actions, Fastlane — выбор по команде. Test Plans, кэш DerivedData, артефакты.

</details>



## 🎯 Focus vs Defer

### Focus

- **Xcode Cloud:** workflows (PR, main, release), post-clone scripts, TestFlight upload.
- **Fastlane:** `scan`, `gym`, `match`/`certificates`, lane per branch policy.
- **`xcodebuild test`:** `-scheme`, `-destination`, `-testPlan`, `-resultBundlePath`, `-parallel-testing-enabled`.
- **Schemes:** shared scheme committed; test action points to Test Plan; build configs Debug/Release.
- **Test Plans in CI:** PR = fast unit subset; nightly = UI + integration; environment variables per configuration.

### Defer

- Self-hosted Mac fleet before Xcode Cloud or one Mac mini pilot.
- Complex multi-app monorepo orchestration before one green pipeline exists.
- Caching derived data tuning until baseline timing is measured.
- Deploying to App Store from 5 parallel workflows without promotion gates.

## Key concepts

| Term | Meaning |
|------|---------|
| **Shared scheme** | Checked into `xcshareddata/xcschemes`; CI uses same build/test settings as devs. |
| **Test Plan** | Selects tests, configs (language, diagnostics), repetition for flaky quarantine. |
| **Destination** | Simulator or device UDID: `platform=iOS Simulator,name=iPhone 16,OS=18.2`. |
| **Result bundle** | `.xcresult` with logs, screenshots, test failures for Xcode reopen. |
| **Xcode Cloud workflow** | Trigger (PR, tag, schedule) + actions (analyze, test, archive, distribute). |
| **Fastlane lane** | Named script (`beta`, `release`) composing actions and env. |
| **Code signing CI** | Managed certs (Cloud, `match`) vs manual export; no secrets in repo. |
| **Gating** | Required checks before merge; red CI blocks integration. |

**Sample PR command**

```bash
xcodebuild test \
  -scheme MyApp \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' \
  -testPlan PullRequest \
  -resultBundlePath TestResults.xcresult \
  -parallel-testing-enabled YES \
  CODE_SIGNING_ALLOWED=NO
```

**Test Plan split**

```text
PullRequest.xctestplan   → unit + fast integration (< 10 min)
Nightly.xctestplan       → UI, performance, localization smoke
ReleaseCandidate.xctestplan → full matrix before tag
```

## 🏋️ Exercises

1. **Share scheme:** Ensure scheme is shared; clone fresh repo; build from CLI succeeds. **Expected:** `xcodebuild -list` shows scheme without local-only data.
2. **Test Plan:** Create `PR` plan with only unit targets; wire scheme Test action to plan. **Expected:** UI tests skipped when `-testPlan PR`.
3. **Result bundle:** Run tests with `-resultBundlePath`; open bundle in Xcode on failure. **Expected:** failing test shows log + attachment.
4. **Xcode Cloud workflow:** Add start workflow on PR; post-clone `brew` or `mint` if needed via `ci_scripts`. **Expected:** green test on sample PR.
5. **Fastlane scan:** `fastlane scan` wrapping same scheme/plan/destination as CI YAML. **Expected:** local parity with remote job.

## WWDC & resources

- [Explore Xcode Cloud workflows (WWDC21)](https://developer.apple.com/videos/play/wwdc2021/10268/)
- [Customize your advanced Xcode Cloud workflows (WWDC22)](https://developer.apple.com/videos/play/wwdc2022/110374/)
- [Author fast and reliable tests for Xcode Cloud (WWDC23)](https://developer.apple.com/videos/play/wwdc2023/10071/)

## Artifacts

- Notes: `notes/`
- Exercises: `exercises/`
- Assets: `assets/`
- Playgrounds: `playgrounds/`

---

## Interview Q&A (Knowledge cards)

### Q1
- **Question (EN):** Xcode Cloud vs Fastlane—when to use which?

- **Answer (EN):** Xcode Cloud is integrated and low-ops; Fastlane fits custom CI and complex release automation—many teams combine both.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Xcode Cloud vs Fastlane — когда что?

- **Answer (RU):** **Xcode Cloud** — нативная интеграция Apple (signing, TestFlight, macOS runners), минимум infra. **Fastlane** — гибкость на **любом** CI (GitHub Actions, GitLab), богатые lanes, `match`, кастомные шаги. Часто: Cloud для Apple-centric team; Fastlane там, где уже enterprise CI или multi-platform pipeline.

</details>
### Q2
- **Question (EN):** How do you speed up CI tests?

- **Answer (EN):** Subset Test Plans for PRs, parallel testing, shard slow suites, stub I/O, quarantine flaky tests with explicit policy—keep feedback under ~10 minutes for PR gates.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Как ускорить тесты в CI?

- **Answer (RU):** **Test Plans** с подмножествами для PR; `-parallel-testing-enabled`; шардирование по классам; stub network; без лишних UI tests на каждый commit. Фиксированный simulator OS; кэш SPM/DerivedData где поддерживается. Quarantine flaky tests в отдельный plan с retry policy, не игнорировать красный CI.

</details>
### Q3
- **Question (EN):** Why commit shared schemes and Test Plans?

- **Answer (EN):** Shared schemes and Test Plans make local and CI runs identical and reviewable—test selection lives in git, not tribal CI knowledge.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Зачем shared scheme и Test Plan в репозитории?

- **Answer (RU):** CI и разработчики должны собирать **одинаково**; user-specific scheme не виден на runner. Test Plan версионирует **какие** тесты и **какие** env (язык, args) — PR vs release без дублирования YAML. Изменение набора тестов — code review вместе с фичей.

</details>
### Q4
- **Question (EN):** How do you debug failures that only happen in CI?

- **Answer (EN):** Pull result bundles and logs, match simulator OS and env to local runs, fix timing/data isolation—treat flaky tests as product bugs, not CI noise.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Как дебажить падение только в CI?

- **Answer (RU):** Скачать **`.xcresult`**, логи `xcodebuild`, скриншоты UI tests. Сравнить destination OS, locale, env vars, `CODE_SIGNING_*`. Reproduce locally with same `-destination` и Test Plan. Включить `-showBuildTimingSummary` для timeout vs test failure. Flaky — стабилизировать async (`await`), изолировать данные, не `sleep`.

</details>
