# 13 · Dynamic Profiles

## In 30 seconds


**Dynamic Profiles** (Foundation Models, WWDC26) let one **`LanguageModelSession`** swap **model**, **tools**, and **instructions** declaratively as app state changes — **without losing transcript**. Conform a struct to **`LanguageModelSession.DynamicProfile`** with a SwiftUI-style **`body`** that resolves to exactly one active **`Profile`**. Pair with **`historyTransform`**, **`summarizeHistory`**, and **[FoundationModelsUtilities](https://github.com/apple/foundation-models-utilities)** for context management. Building block for agentic iOS features — distinct from hand-rolled multi-session juggling.


<details class="lang-ru">
<summary>По-русски</summary>

**Dynamic Profiles** (WWDC26) — один **`LanguageModelSession`** с переключаемыми профилями поведения без пересоздания сессии.

</details>

## Apple docs


- [LanguageModelSession.DynamicProfile](https://developer.apple.com/documentation/foundationmodels/languagemodelsession/dynamicprofile) — protocol, `body`, modifiers.
- [historyTransform(_:)](https://developer.apple.com/documentation/foundationmodels/languagemodelsession/dynamicprofile) — per-profile lossless transcript views.
- [WWDC26 — What's new in the Foundation Models framework (241)](https://developer.apple.com/videos/play/wwdc2026/241/) — Dynamic Profiles intro, Crafts demo.
- [WWDC26 — Build agentic app experiences (242)](https://developer.apple.com/videos/play/wwdc2026/242/) — orchestration patterns, session properties, lifecycle modifiers.
- [Foundation Models Utilities (GitHub)](https://github.com/apple/foundation-models-utilities) — `rollingWindow`, `droppingCompletedToolCalls`, `summarizeHistory`.

## 🎯 Focus vs Defer


### Focus

- **Single session, multiple configurations:** transcript persists; active profile changes per prompt.
- **DynamicProfile `body`:** re-evaluated each prompt; branch on `@Observable` app mode.
- **Profile modifiers:** `.model()`, `.reasoningLevel()`, `.toolCallingMode()`, `.temperature()`.
- **Model swap:** `SystemLanguageModel.default` vs `PrivateCloudComputeLanguageModel` per task.
- **historyTransform vs history property:** transform = scoped/lossless view; history = global/lossy.
- **summarizeHistory modifier:** utilities package — compress old turns to reclaim context.
- **FoundationModelsUtilities:** experimental helpers — treat API as evolving.

### Defer

- Reimplementing full agent frameworks — profiles are a primitive, not AutoGPT.
- Every lifecycle modifier (`onToolCall`, etc.) unless debugging/orchestration interview.
- Private Cloud Compute pricing details — cite Apple docs, don't guess numbers.

## Key concepts


| API | Purpose |
|-----|---------|
| `DynamicProfile` | Top-level coordinator; `body` picks active profile |
| `Profile { }` | Instructions + tools bundle for one mode |
| `.model(_:)` | Switch on-device vs PCC vs other `LanguageModel` |
| `.historyTransform` | Filter/suffix transcript before this profile prompts |
| `.onResponse` | Mutate state/summary at response boundary |
| `@SessionPropertyEntry` | Shared state across tools and profiles |
| `summarizeHistory` | Utilities modifier — summarize + drop old entries |

**Mental model:** exactly **one active Profile** at a time; `body` re-runs on each user prompt — like SwiftUI resolving view tree from state.

**Example pattern (WWDC26 Crafts-style):**

```swift
import FoundationModels
import FoundationModelsUtilities

enum CraftMode { case reviewing, brainstorming }

struct CraftProfile: LanguageModelSession.DynamicProfile {
    var mode: CraftMode

    var body: some LanguageModelSession.DynamicProfile {
        switch mode {
        case .reviewing:
            Profile {
                Instructions("Analyze the craft step-by-step. Be concise.")
                AnalyzeCraftTool()
            }
            .model(SystemLanguageModel.default)
            .rollingWindow(size: .entries(10))
            .droppingCompletedToolCalls()

        case .brainstorming:
            Profile {
                Instructions("Brainstorm creative variations. Think deeply.")
                BrainstormTool()
            }
            .model(PrivateCloudComputeLanguageModel())
            .reasoningLevel(.high)
        }
    }
}

let session = LanguageModelSession(profile: CraftProfile(mode: .reviewing))
```

**Why not multiple sessions?** Switching sessions **drops or requires manual transcript copy** — bad UX for continuous flows (photo analysis → brainstorm on same artifact). Dynamic Profiles keep **one conversation thread** while changing capabilities.

**Context management toolkit:**

| Need | Approach |
|------|----------|
| Last N entries only | `.rollingWindow(size:)` (utilities) |
| Remove finished tool rounds | `.droppingCompletedToolCalls()` |
| Summarize old chat | `.summarizeHistory()` or `onResponse` + custom summary property |
| Profile-specific tool visibility | Different `Profile` branches with different tools |
| Lossless filter | `.historyTransform { ... }` |

**history vs historyTransform (critical):** mutating built-in **`history`** in `onResponse` changes transcript **for all profiles** and is **lossy**. Prefer **`historyTransform`** when scouting profile needs short history but trail profile needs tool records in prompt — WWDC26 demo contrast.

**iOS integration:** drive `mode` from `@Observable` view model (selected tab, editing phase); profile `body` reads current mode automatically on next `respond(to:)`. Test mode switches with **Evaluations** ([evaluations](../evaluations/README.md)) — wrong profile = wrong tools called.

## 🏋️ Exercises


1. **Photo workflow** — Analyze image on-device, then creative captions via PCC. *Expected:* one session, DynamicProfile switches model + instructions; transcript keeps image discussion context.

2. **Tool visibility** — Checkout mode must not expose admin `DeleteUserTool`. *Expected:* separate Profile branch without admin tools; not runtime hide only.

3. **History trim** — Scouting agent spammed 20 tool calls. *Expected:* `droppingCompletedToolCalls()` after persisting results to `CraftOrchestrator` state.

4. **Summarize** — 40-turn support chat approaching limit. *Expected:* `summarizeHistory` or `onResponse` writes summary to `@SessionPropertyEntry`; verify with Instruments FM template.

5. **Wrong profile bug** — User in "review" but brainstorm tools fire. *Expected:* fix `body` branch condition; add ToolCallEvaluator golden trajectories.

## Links


- [LanguageModelSession.DynamicProfile](https://developer.apple.com/documentation/foundationmodels/languagemodelsession/dynamicprofile)
- [What's new in Foundation Models (WWDC26-241)](https://developer.apple.com/videos/play/wwdc2026/241/)
- [Build agentic experiences (WWDC26-242)](https://developer.apple.com/videos/play/wwdc2026/242/)
- [foundation-models-utilities](https://github.com/apple/foundation-models-utilities)
- Related: [foundation-models](../foundation-models/README.md), [tool-calling](../tool-calling/README.md), [context-window](../context-window/README.md), [evaluations](../evaluations/README.md)

## Interview Q&A (Knowledge cards)


<!-- knowledge-cards-canonical:start -->

### Q1
- **Question (EN):** What problem do Dynamic Profiles solve?

- **Answer (EN):** Multi-mode AI in one session — swap model, tools, and instructions as app state changes without a new session or manual transcript copying. The declarative body re-evaluates each prompt.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up:** сколько profiles active одновременно?

</details>
</details>
</details>
- **Follow-up answer:** **Exactly one** active Profile at a time — `body` must resolve to single configuration; not parallel multi-agent in one prompt.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Dynamic Profile — что решает?

- **Answer (RU):** **Multi-mode AI** в одном **`LanguageModelSession`**: swap model, tools, instructions по app state **без нового session** и без ручного copy transcript. Declarative `body` re-evaluated каждый prompt — SwiftUI-style для model config.

</details>

### Q2
- **Question (EN):** When on-device vs PCC in profiles?

- **Answer (EN):** On-device for fast private tasks; Private Cloud Compute for heavier reasoning. Branch in DynamicProfile switches model and reasoning level while keeping transcript.

- **Follow-up:** availability check per model?

- **Follow-up answer:** Check each `LanguageModel` availability before exposing mode in UI; fallback profile branch with degraded features.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Когда on-device vs PCC в profiles?

- **Answer (RU):** **On-device** — fast, private, simple analysis. **PCC** (`PrivateCloudComputeLanguageModel`) — heavier reasoning, larger context tasks. Same session: user selects "deep brainstorm" → profile branch switches model + `.reasoningLevel(.high)`.

</details>

### Q3
- **Question (EN):** summarizeHistory vs historyTransform?

- **Answer (EN):** `summarizeHistory` compresses and drops old turns. `historyTransform` provides a custom lossless view. The global history property is lossy and affects all profiles — use it deliberately.

- **Follow-up:** rewrite history hurts performance?

- **Follow-up answer:** Yes — WWDC26 warns transcript mutations can **invalidate KV cache** and increase latency; prefer append-friendly patterns; measure with Foundation Models Instruments.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** summarizeHistory vs historyTransform?

- **Answer (RU):** **`summarizeHistory`** (utilities) — prebuilt **compress + drop** old turns. **`historyTransform`** — custom **lossless view** (filter, suffix) without necessarily deleting global transcript. Global **`history` property** — lossy, affects all profiles — use deliberately in `onResponse`.

</details>

### Q4
- **Question (EN):** What is FoundationModelsUtilities?

- **Answer (EN):** Open-source Apple package with history modifiers, Skills API, and chat-completions adapter. Experimental — add via SPM, not bundled in the OS framework.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up:** можно ли production без utilities?

</details>
</details>
</details>
- **Follow-up answer:** Yes — implement `historyTransform` manually; utilities save boilerplate; pin package version; monitor API changes as "emerging patterns."

<!-- knowledge-cards-canonical:end -->

<!-- ai-engineering-nav:start -->

---

**AI Engineering:** [Track overview](../README.md) · [← 12 · Apple Intelligence](../apple-intelligence/) · [14 · Evaluations →](../evaluations/)

<!-- ai-engineering-nav:end -->


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** FoundationModelsUtilities — что там?

- **Answer (RU):** **Open-source** Apple package (Apache-2.0): history modifiers (`rollingWindow`, `droppingCompletedToolCalls`, `summarizeHistory`), Skills API, `ChatCompletionsLanguageModel` adapter. **Experimental** — не часть OS framework; SPM dependency.

</details>
