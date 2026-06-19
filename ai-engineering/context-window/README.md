# 03 · Context Window

## За 30 секунд

The **context window** is the maximum number of **tokens** a model can attend to in a single request — system instructions, tool definitions, conversation history, retrieved documents, and the user message must all fit. When content overflows, the model **cannot see** what was dropped — leading to forgotten instructions and contradictions. Mobile strategies: **truncation**, **summarization**, **rolling windows**, and Apple FM **transcript management** (`historyTransform`, `summarizeHistory` via [FoundationModelsUtilities](https://github.com/apple/foundation-models-utilities)). Token basics: [02 · Tokens](../tokens/README.md).

## Apple docs

- [LanguageModelSession](https://developer.apple.com/documentation/foundationmodels/languagemodelsession) — stateful transcript and context limits.
- [LanguageModelSession.DynamicProfile — historyTransform](https://developer.apple.com/documentation/foundationmodels/languagemodelsession/dynamicprofile) — per-profile lossless transcript transforms.
- [WWDC25 — Deep dive into the Foundation Models framework](https://developer.apple.com/videos/play/wwdc2025/301/) — context limits, transcript, summarization patterns.
- [WWDC26 — Build agentic app experiences (242)](https://developer.apple.com/videos/play/wwdc2026/242/) — history property, rolling window, session properties.
- [Foundation Models Utilities (GitHub)](https://github.com/apple/foundation-models-utilities) — `rollingWindow`, `droppingCompletedToolCalls`, `summarizeHistory` modifiers.

## 🎯 Focus vs Defer

### Focus

- **Hard limit:** everything in one `respond(to:)` call must fit; no "memory" beyond the window.
- **What consumes context:** instructions, tools schema, RAG chunks, full chat history, images (multimodal).
- **Truncation:** drop oldest turns or middle — predictable but lossy.
- **Summarization:** compress older turns into a short summary entry — preserves gist, risks detail loss.
- **Rolling window:** keep last N entries or tokens — common for chat UIs.
- **Apple FM session history:** transcript entries per turn; `historyTransform` for profile-scoped views; global `history` property is lossy across profiles.

### Defer

- Exact token count formulas for multimodal inputs unless vision AI role.
- KV-cache internals and speculative decoding — mention at high level only.
- Sliding-window attention architecture (model-side) vs app-side truncation — distinguish clearly.

## Ключевые понятия

| Strategy | When | Risk |
|----------|------|------|
| **Truncate oldest** | Simple chat | Loses early user preferences |
| **Truncate middle** | Long docs + recent chat | Keeps system + latest user |
| **Summarize history** | Many-turn support chat | Summary omits specifics |
| **Rolling window (N turns)** | Agent with tool spam | May drop needed tool context |
| **RAG instead of paste** | Large knowledge base | Retrieval quality dependent |
| **Separate session** | Unrelated tasks | Loses continuity by design |

**Context budget template (mobile chat):**

```text
[Fixed]     System instructions     ~200–800 tokens
[Fixed]     Tool definitions        ~100–500 per tool
[Growing]   Conversation history    monitor each turn
[Variable]  RAG context chunks      top-k × chunk size
[Variable]  User message            current input
[Reserved]  Model output            cap with maximumResponseTokens
```

**Apple Foundation Models transcript:** each `respond(to:)` appends to the session transcript. When approaching the limit, options include:

1. **New session** — clean break; carry over summary in instructions manually.
2. **`historyTransform`** — profile-scoped, lossless view of transcript (e.g. last 20 entries, filter completed tool calls).
3. **`onResponse` + session properties** — store rolling summary in `@SessionPropertyEntry` (WWDC26 agentic patterns).
4. **FoundationModelsUtilities modifiers** — `.rollingWindow(size:)`, `.droppingCompletedToolCalls()`, `.summarizeHistory()` on `DynamicProfile`.

**Important distinction (WWDC26):** writes to the built-in **`history` property** are **lossy and global** — all profiles see the change. Prefer **`historyTransform`** for per-profile, reversible views unless you intentionally want permanent deletion.

**iOS UX:** warn before long paste; show "conversation getting long" and offer "new chat"; never silently drop without product decision; stream partial responses so users see progress within output token budget.

## 🏋️ Exercises

1. **Overflow symptom** — User set language preference in turn 1; turn 25 model switches to English. *Expected:* early turn truncated; fix with pinned system instruction or summary that preserves preference.

2. **Support bot** — 50-turn ticket thread. *Expected:* summarize turns 1–40 into bullet summary entry; keep last 10 verbatim; or RAG over ticket database instead of full paste.

3. **RAG + window** — 20 chunks × 400 tokens = 8000; limit 4096. *Expected:* reduce top-k, rerank, or compress chunks; never blindly retrieve max-k.

4. **Tool-heavy agent** — 30 tool call/output pairs fill transcript. *Expected:* `droppingCompletedToolCalls()` after state persisted to app; keep final tool result only in prompt view.

5. **Apple FM profile switch** — Scouting profile needs short history; trail guide needs tool records. *Expected:* different `historyTransform` per profile branch, not one global truncate.

## Ссылки

- [LanguageModelSession](https://developer.apple.com/documentation/foundationmodels/languagemodelsession)
- [DynamicProfile — historyTransform](https://developer.apple.com/documentation/foundationmodels/languagemodelsession/dynamicprofile)
- [Build agentic experiences (WWDC26-242)](https://developer.apple.com/videos/play/wwdc2026/242/)
- [foundation-models-utilities](https://github.com/apple/foundation-models-utilities)
- Related: [tokens](../tokens/README.md), [rag](../rag/README.md), [dynamic-profiles](../dynamic-profiles/README.md)

## Карточки знаний (Q&A)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question (RU):** Context window — что происходит при overflow?
- **Question (EN):** What happens when you exceed the context window?
- **Answer (RU):** Контент **за пределами окна невидим** модели — не «медленно читается», а **отсутствует**. Симптомы: забытые instructions, противоречия, ignored constraints. Лечение: truncate, summarize, RAG, новый session — **явная** product strategy.
- **Answer (EN):** Content beyond the window is invisible to the model, not slowly processed. Symptoms include forgotten instructions and contradictions. Fix with truncation, summarization, RAG, or a new session — as an explicit product choice.
- **Follow-up:** можно ли «попросить модель запомнить» beyond window?
- **Follow-up answer:** **Нет** — только то, что в текущем prompt/transcript. External memory = app state, database, RAG index, session properties — не магия модели.

### Q2
- **Question (RU):** Truncation vs summarization?
- **Question (EN):** Truncation vs summarization?
- **Answer (RU):** **Truncation** — drop entries/tokens (быстро, предсказуемо, теряются детали). **Summarization** — LLM сжимает старые turns в короткий summary (сохраняет gist, риск hallucination в summary, extra latency/cost). Часто **hybrid**: summary + last N turns verbatim.
- **Answer (EN):** Truncation drops content quickly and predictably. Summarization compresses older turns but risks summary errors and adds cost. Hybrid approaches keep a summary plus recent verbatim turns.
- **Follow-up:** кто делает summary — та же session?
- **Follow-up answer:** Можно отдельным `respond` с instruction «summarize for context» или `summarizeHistory` modifier; validate summary length; on Apple FM watch token budget for the summarization call itself.

### Q3
- **Question (RU):** Rolling window — когда достаточно?
- **Question (EN):** When is a rolling window enough?
- **Answer (RU):** **Short chat** без long-range dependencies; **agents** после persist tool results в app state. Недостаточно когда early turns содержат constraints (language, account id) — pin в system или summary.
- **Answer (EN):** Fine for short chats or when tool results live in app state. Insufficient when early turns hold durable constraints — pin those in system instructions or a summary.
- **Follow-up:** `.rollingWindow(size: .entries(10))` vs token-based?
- **Follow-up answer:** Entry-based проще, но entries uneven in tokens; token-based window точнее для hard limits; FoundationModelsUtilities supports entry sizing — measure real transcripts.

### Q4
- **Question (RU):** Apple FM — historyTransform vs history property?
- **Question (EN):** Apple FM — historyTransform vs history property?
- **Answer (RU):** **`historyTransform`** — lossless, **per-profile** view перед prompt; не меняет global transcript. **`history` property** — **lossy, global**; изменения видны всем profiles. Apple рекомендует transforms для scoped filtering; permanent delete/summary — осознанно через lifecycle hooks.
- **Answer (EN):** `historyTransform` provides a lossless per-profile view before prompting without changing the global transcript. The `history` property is lossy and global across profiles. Prefer transforms for scoped filtering.
- **Follow-up:** tool calls в history — всегда держать?
- **Follow-up answer:** Зависит от profile: scouting может `.droppingCompletedToolCalls()` после save в app; trail guide может нуждаться в tool output в prompt — per-profile transforms (WWDC26 Crafts demo).

<!-- knowledge-cards-canonical:end -->
