# Apple Foundation Models

## За 30 секунд

**Foundation Models framework** (iOS 26+, iPadOS 26+, macOS 26+) exposes Apple’s **on-device LLM** powering Apple Intelligence: Swift-native API, offline-capable, no per-token cloud bill for on-device inference. Core types: **`SystemLanguageModel`**, **`LanguageModelSession`**, **guided generation** (`@Generable`), and **Tools** for app callbacks. Requires Apple Intelligence–compatible device with Intelligence enabled; larger requests may use **Private Cloud Compute**.

## Apple docs

- [Foundation Models framework](https://developer.apple.com/documentation/foundationmodels)
- [SystemLanguageModel](https://developer.apple.com/documentation/foundationmodels/systemlanguagemodel)
- [LanguageModelSession](https://developer.apple.com/documentation/foundationmodels/languagemodelsession)
- [Generable](https://developer.apple.com/documentation/foundationmodels/generable) — structured Swift output
- [WWDC25 — Meet the Foundation Models framework](https://developer.apple.com/videos/play/wwdc2025/286/)
- [WWDC25 — Deep dive into the Foundation Models framework](https://developer.apple.com/videos/) — search session catalog
- [Apple Intelligence & privacy](https://www.apple.com/legal/privacy/data/en/intelligence-engine/)

## 🎯 Focus vs Defer

### Focus

- **Availability gate:** check model/device readiness before showing AI UI.
- **Session lifecycle:** instructions, multi-turn transcript, streaming responses.
- **Guided generation:** typed structs instead of fragile JSON parsing.
- **Tools:** Swift types model can invoke for calendar, search, app state.
- **Instructions vs prompts:** system instructions win over user injection (security).
- **Private Cloud Compute (PCC):** when on-device insufficient; privacy architecture.
- **Evaluations framework:** quality tests for generative features (iOS 26+).

### Defer

- Exact parameter count of Apple’s on-device model — cite “on-device LLM” without stale numbers unless from current docs.
- Replacing all NL APIs — Vision/Natural Language still fit non-generative tasks.
- Jailbreak / model extraction — out of scope for app dev interview.

## Ключевые понятия

| API | Purpose |
|-----|---------|
| `SystemLanguageModel.default` | Entry to built-in on-device model |
| `LanguageModelSession` | Stateful chat; holds transcript |
| `respond(to:)` / streaming | Generate text or structured output |
| `@Generable` | Compiler-guided schema for output |
| `@Guide` | Field-level constraints on generated types |
| `Tool` | Let model request app-side execution |
| `Transcript` | Inspect turns for debug/support |

**Capability check pattern:**

```swift
import FoundationModels

let model = SystemLanguageModel.default
guard model.isAvailable else {
    // Hide AI feature or show fallback
    return
}
var session = LanguageModelSession(instructions: "Summarize in 3 bullets.")
let response = try await session.respond(to: userText)
```

**When to use vs Core ML / NL:** generative text and tool-using assistants → Foundation Models; fixed classifier/regressor → Core ML; embeddings/language ID → Natural Language.

**UX:** stream tokens; cancel `Task`; show “Apple Intelligence required” settings deep link when unavailable.

## 🏋️ Exercises

1. **Availability UX** — Feature flag + `isAvailable` gating. *Expected:* graceful hide on unsupported hardware/OS.

2. **Guided extraction** — `@Generable struct EventDraft { title, date }` from natural language. *Expected:* validate before saving to Calendar API.

3. **Tool design** — `SearchNotesTool` returning top 3 snippets. *Expected:* RAG-like flow entirely on device for small corpus.

4. **Session reset** — New chat clears transcript without leaking prior PII. *Expected:* new `LanguageModelSession` instance.

5. **Evaluations** — Golden prompts after iOS beta upgrade. *Expected:* mention Evaluations framework regression suite.

## Ссылки

- [Foundation Models documentation](https://developer.apple.com/documentation/foundationmodels)
- [Meet the Foundation Models framework (WWDC25)](https://developer.apple.com/videos/play/wwdc2025/286/)
- [Apple Intelligence overview](https://www.apple.com/apple-intelligence/)
- Related: [fundamentals](../fundamentals/README.md), [ai-in-ios-apps](../ai-in-ios-apps/README.md)

## Карточки знаний (Q&A)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question (RU):** Что даёт Foundation Models framework iOS разработчику?
- **Question (EN):** What does the Foundation Models framework give iOS developers?
- **Answer (RU):** Нативный **Swift API** к on-device LLM Apple Intelligence: генерация текста, multi-turn **sessions**, **structured output** (`@Generable`), **Tools** для данных app. Работает **offline** на supported devices; inference on-device без cloud API billing для базового сценария.
- **Answer (EN):** Native Swift access to Apple’s on-device LLM: generation, sessions, structured output via `@Generable`, and Tools for app data — offline on supported devices without cloud token billing for standard on-device use.

### Q2
- **Question (RU):** LanguageModelSession vs one-shot prompt?
- **Question (EN):** LanguageModelSession vs one-shot prompts?
- **Answer (RU):** **Session** хранит **transcript** multi-turn диалога и **instructions**; модель использует контекст предыдущих turns. One-shot — один запрос без history. Chat UI почти всегда session; простые transforms — single `respond`.
- **Answer (EN):** Sessions keep transcripts and instructions across turns. One-shot calls suit single transforms without history; chat UIs use sessions.

### Q3
- **Question (RU):** Guided generation — зачем?
- **Question (EN):** Why guided generation?
- **Answer (RU):** LLM raw text → хрупкий `JSONDecoder`. **`@Generable`** заставляет модель заполнять **Swift struct** с compile-time schema — меньше parse errors, type-safe integration с app logic.
- **Answer (EN):** Raw JSON from LLMs is fragile. `@Generable` targets Swift structs with a defined schema — fewer parse failures and type-safe integration.

### Q4
- **Question (RU):** On-device vs Private Cloud Compute?
- **Question (EN):** On-device vs Private Cloud Compute?
- **Answer (RU):** **On-device** — privacy, latency, offline; лимиты размера задачи. **PCC** — Apple-hosted compute для более тяжёлых запросов с **privacy architecture** (не classic cloud logging user content). Проверять availability и не отправлять sensitive data третьим cloud LLM без необходимости.
- **Answer (EN):** On-device offers privacy, latency, and offline use with capacity limits. PCC extends capability on Apple-controlled infrastructure with privacy protections — prefer over third-party clouds for sensitive Apple Intelligence workflows.

<!-- knowledge-cards-canonical:end -->
