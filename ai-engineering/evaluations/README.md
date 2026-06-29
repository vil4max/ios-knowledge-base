# 14 · Evaluations

## In 30 seconds

**Evaluations** measure whether AI features behave correctly after **prompt**, **model**, or **tool** changes — beyond traditional unit tests that can't catch fluent-but-wrong answers. Apple's **Evaluations framework** (WWDC26) runs **golden datasets** in Xcode with **quantitative evaluators** and **Model Judge** for qualitative traits. For agentic apps: **`ToolCallEvaluator`** verifies **tool trajectories** (which tools, args, order). Essential for regression when iOS updates ship new Foundation Models weights.

## Apple docs

- [Evaluations framework](https://developer.apple.com/documentation/evaluations) — core types and workflow.
- [ToolCallEvaluator](https://developer.apple.com/documentation/evaluations/toolcallevaluator) — agentic tool trajectory verification.
- [TrajectoryExpectation](https://developer.apple.com/documentation/evaluations/trajectoryexpectation) — expected tool call pattern.
- [WWDC26 — Meet the Evaluations framework (298)](https://developer.apple.com/videos/play/wwdc2026/298/) — Evaluation protocol, metrics, Model Judge.
- [WWDC26 — What's new in Foundation Models (241)](https://developer.apple.com/videos/play/wwdc2026/241/) — Evaluations + Dynamic Profiles overview.
- [WWDC26 — Create robust evaluations for agentic apps (299)](https://developer.apple.com/videos/play/wwdc2026/299/) — ToolCallEvaluator, synthetic datasets.
- [WWDC26 — Improve prompts by hill-climbing (335)](https://developer.apple.com/videos/play/wwdc2026/335/) — compare eval runs, iterate prompts.

## 🎯 Focus vs Defer

### Focus

- **Golden dataset:** curated inputs + expected properties (not exact prose).
- **Evaluation protocol:** `dataset`, `evaluators`, run in Xcode test navigator.
- **Regression on model updates:** re-run after iOS beta, prompt change, tool schema change.
- **Prompt eval:** structure checks, tag counts, schema validation, Model Judge dimensions.
- **ToolCallEvaluator:** expected trajectory vs actual transcript tool calls.
- **Hill-climbing:** iterate prompt/tools using eval scores as feedback loop.

### Defer

- Full ML benchmark suites (MMLU, etc.) — not app-level eval.
- **IDE-generated Swift** — validate with unit tests and [AI-assisted TDD](../../quality/testing/notes/ai-assisted-tdd.md), not this eval framework.
- Human rating infrastructure at scale — mention spot-check + Model Judge.
- Statistical significance formulas — qualitative "compare runs in Xcode" enough for interview.

## Key concepts

| Component | Role |
|-----------|------|
| **Sample** | One test case: input prompt (+ optional context) |
| **Expectation** | What "pass" means — struct properties, trajectory |
| **Evaluator** | Scoring logic producing `Metric` values |
| **Metric** | Named score (pass/fail, percentage, 1–4 quality) |
| **Model Judge** | LLM-as-judge for subjective quality with rationales |
| **ToolCallEvaluator** | Compares tool call sequence to `TrajectoryExpectation` |
| **Golden set** | 20–100+ representative real + edge cases |

**Why unit tests fail for LLM features:**

| Unit test | LLM eval |
|-----------|----------|
| `assertEqual("hello")` | Output varies in wording |
| Deterministic | Sampling (unless greedy) |
| Logic branches | Probabilistic quality |
| Fast | Slower — calls real model |

Assert **properties**: JSON parses, `tags.count >= 3`, tool `searchNotes` was called, Model Judge relevance ≥ 3.

**ToolCallEvaluator pattern (WWDC26):**

```swift
import Evaluations
import FoundationModels

struct BookSearchToolEval: Evaluation {
    var dataset: [ModelSample<TrajectoryExpectation>] = goldenSamples

    var evaluators: some Evaluators {
        ToolCallEvaluator(
            allPass: Metric("All Passed"),
            percentagePass: Metric("Percentage Passed")
        )
    }
}

// Sample expectation: user asks for gothic books →
// must call searchBooks(withTag: "gothic") before respond
```

**TrajectoryExpectation** captures: tool names, argument matchers, call order, optional "must not call" tools. Critical because model can **answer plausibly without calling tools** — wrong for RAG/agent features.

**Prompt eval workflow:**

1. **Baseline** — run eval on current prompt → store metrics.
2. **Change** — edit instructions, add tool, tune `@Guide`.
3. **Compare** — Xcode 27 can compare two evaluation runs (WWDC26 hill-climbing session).
4. **Gate** — CI or pre-release checklist: percentage pass must not drop > X%.

**Regression on model updates:** Apple ships new on-device model weights with iOS releases — re-run golden set on **beta seeds** before your app's AI release. Track `SystemLanguageModel` availability and behavior shifts (structured output stricter/looser).

**Synthetic data (WWDC26-299):** `@Generable` samples + `SampleGenerator` expand datasets — validate synthetic rows before trusting; start with **20–30 real** samples from production logs (redacted).

**iOS/mobile specifics:** run evals on **physical device** for on-device model fidelity; simulator may differ. Budget time — eval suites call live FM. Integrate with Test Plan before App Store submission of AI features.

## 🏋️ Exercises

1. **Golden set design** — Note-tagging feature. *Expected:* 25 samples: short/long notes, non-English, empty note, PII-heavy; expect ≥3 tags or explicit empty.

2. **Tool regression** — Added `BookLookupTool`; model stops calling search. *Expected:* ToolCallEvaluator trajectory requires `searchBooks` before `respond`; catch in Xcode.

3. **Model update** — iOS 26.1 beta, JSON field renamed in `@Generable` output. *Expected:* structured eval fails; fix `@Guide` or prompt before release.

4. **Model Judge split** — Single "quality" score noisy. *Expected:* separate ScoreDimensions: Relevance + Usefulness; read rationales for prompt fix.

5. **Hill-climb** — Tag quality 2.8 avg → edit system prompt → 3.4. *Expected:* compare eval runs in Xcode; document winning prompt version in git.

## Links

- [Evaluations framework](https://developer.apple.com/documentation/evaluations)
- [ToolCallEvaluator](https://developer.apple.com/documentation/evaluations/toolcallevaluator)
- [Meet the Evaluations framework (WWDC26-298)](https://developer.apple.com/videos/play/wwdc2026/298/)
- [Create robust evaluations for agentic apps (WWDC26-299)](https://developer.apple.com/videos/play/wwdc2026/299/)
- [What's new in Foundation Models (WWDC26-241)](https://developer.apple.com/videos/play/wwdc2026/241/)
- Related: [tool-calling](../tool-calling/README.md), [dynamic-profiles](../dynamic-profiles/README.md), [structured-output](../structured-output/README.md)

## Interview Q&A (Knowledge cards)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question:** Why Evaluations when you have unit tests?

- **Answer:** LLM outputs vary in wording and can be fluently wrong. Evaluations check properties — schema, counts, tool trajectories, judge scores — and catch regressions when prompts, models, or iOS versions change.

- **Follow-up:** assert exact string ever?

- **Follow-up answer:** Rarely — only fixed templates (legal disclaimer). Prefer contains-keywords or structured fields; exact match too brittle.

### Q2
- **Question:** How do you build a golden dataset?

- **Answer:** Start with 20–30 real redacted cases plus edge cases. Each sample has a prompt and expectation. Expand with SampleGenerator but review synthetic rows.

- **Follow-up answer:** Enough to cover **top user paths + known failures** — often 50–100 before major AI launch; continuous add from support tickets post-release.

### Q3
- **Question:** What does ToolCallEvaluator verify?

- **Answer:** Tool names, arguments, and call order against TrajectoryExpectation. Catches plausible answers that skipped required tool calls.

- **Follow-up:** trajectory vs final answer quality?

- **Follow-up answer:** Both matter — wrong tools → wrong data even if prose sounds good; combine ToolCallEvaluator + output property checks + Model Judge.

### Q4
- **Question:** Regression process on Apple model updates?

- **Answer:** Re-run the eval suite on device for each iOS beta seed. Compare to baseline, triage failures, iterate prompts and tools, gate release on pass-rate thresholds.

- **Follow-up answer:** Challenging — needs Apple Intelligence device/simulator in CI; often **manual pre-release gate** + smaller heuristic unit tests for parsing; run full eval locally and on TestFlight dogfood builds.

<!-- knowledge-cards-canonical:end -->

<!-- ai-engineering-nav:start -->

---

**AI Engineering:** [Track overview](../README.md) · [← 13 · Dynamic Profiles](../dynamic-profiles/)

<!-- ai-engineering-nav:end -->
