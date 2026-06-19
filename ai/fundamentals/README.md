# Fundamentals

## За 30 секунд

**ML** learns patterns from data (classification, regression, on-device Vision/Core ML). **LLMs** predict next tokens over text — generative, context-bound, latency- and cost-sensitive. Mobile interviews contrast **on-device** (privacy, offline, model size limits) vs **cloud** (larger models, network dependency). Know **tokens** as the billing/latency unit and where Apple places on-device intelligence vs Private Cloud Compute.

## Apple docs

- [Core ML](https://developer.apple.com/documentation/coreml) — run converted models on device (Vision, custom models).
- [Create ML](https://developer.apple.com/documentation/createml) — train tabular/image models on Mac.
- [Natural Language framework](https://developer.apple.com/documentation/naturallanguage) — embeddings, language ID, on-device NLP.
- [Foundation Models framework](https://developer.apple.com/documentation/foundationmodels) — on-device LLM (Apple Intelligence, iOS 26+).
- [Apple Intelligence security](https://support.apple.com/guide/security/apple-intelligence-security-secaa112143f/web) — on-device vs Private Cloud Compute overview.

## 🎯 Focus vs Defer

### Focus

- **ML vs LLM:** discriminative vs generative; training vs inference.
- **On-device vs cloud:** privacy, latency, offline, model size, update cadence.
- **Tokens:** input + output length drives cost and context limits.
- **Latency budget:** UI expectations (streaming, cancel, timeout).
- **When not to use AI:** rules engine, search, deterministic logic cheaper and safer.

### Defer

- Backpropagation math derivations unless research role.
- GPU kernel optimization — mention Neural Engine at high level only.
- Full comparison of every cloud provider pricing table.

## Ключевые понятия

| Term | Meaning |
|------|---------|
| **Inference** | Running a trained model on new input |
| **Training** | Learning weights from dataset (usually server/Mac, not on phone) |
| **Token** | Subword unit for LLMs; ~4 chars English average |
| **Context window** | Max tokens model can attend to in one request |
| **Embedding** | Vector representation of text/image for similarity |
| **Quantization** | Smaller/faster model weights (INT8) — common on device |
| **Neural Engine** | Apple silicon accelerator for ML workloads |
| **Private Cloud Compute** | Apple-hosted inference for requests that cannot stay on device |

**On-device fit:** classification, OCR, face/pose, small LLM tasks, personalization without sending raw data.

**Cloud fit:** large context, heavy reasoning, RAG over huge corpora, multi-modal at scale — with privacy review.

**Latency rough tiers:** on-device NLP <100ms; small LLM stream first token 200ms–2s; cloud LLM network + queue variable.

## 🏋️ Exercises

1. **Choose stack** — Spam filter in Mail-like app: ML or LLM? *Expected:* classical ML or small classifier on device; LLM overkill.

2. **Token estimate** — 800-word support article as prompt; rough token count. *Expected:* ~1000–1200 tokens; discuss context limit impact.

3. **Privacy decision** — Health journal summarization. *Expected:* on-device Foundation Models or PCC per Apple policy; not random third-party cloud without consent.

4. **Latency UX** — Streaming vs wait-for-full-response. *Expected:* stream tokens for chat; show cancel; fallback message on timeout.

5. **Hybrid** — On-device intent detection routes to cloud LLM for complex query. *Expected:* diagram with gate and PII stripping.

## Ссылки

- [Core ML overview](https://developer.apple.com/documentation/coreml)
- [Foundation Models framework](https://developer.apple.com/documentation/foundationmodels)
- [WWDC — Meet the Foundation Models framework](https://developer.apple.com/videos/play/wwdc2025/286/)
- Related: [llm](../llm/README.md), [apple-foundation-models](../apple-foundation-models/README.md)

## Карточки знаний (Q&A)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question (RU):** ML vs LLM — в чём разница для iOS разработчика?
- **Question (EN):** ML vs LLM — what is the difference for an iOS developer?
- **Answer (RU):** **ML** (Core ML, Vision) — узкие задачи: классификация, детекция, регрессия; фиксированный input/output. **LLM** — генерация текста по контексту; нужны prompts, tokens, guardrails. ML чаще deterministic и дешевле; LLM — гибче, но variable quality и latency.
- **Answer (EN):** ML covers narrow tasks via Core ML/Vision with fixed IO. LLMs generate text from context — prompts, tokens, guardrails. ML is often deterministic and cheaper; LLMs are flexible but variable in quality and latency.

### Q2
- **Question (RU):** On-device vs cloud AI?
- **Question (EN):** On-device vs cloud AI?
- **Answer (RU):** **On-device:** privacy, offline, низкая latency, лимит размера модели. **Cloud:** большие модели и контекст, проще обновлять, но сеть, cost, compliance. Apple: on-device first + **Private Cloud Compute** когда нужно больше мощности без selling user data.
- **Answer (EN):** On-device gives privacy, offline use, and low latency with model size limits. Cloud offers larger models and easier updates with network and compliance costs. Apple prioritizes on-device plus Private Cloud Compute when needed.

### Q3
- **Question (RU):** Что такое token и зачем iOS dev это знать?
- **Question (EN):** What is a token and why should iOS devs care?
- **Answer (RU):** **Token** — единица текста для LLM; лимит **context window**, стоимость API, время inference. Длинный prompt + history = медленнее и дороже. На клиенте: обрезать history, summarization, не слать лишние JSON в prompt.
- **Answer (EN):** Tokens chunk text for LLMs — they define context limits, cost, and speed. Long prompts and history increase latency and price; trim history and avoid bloated prompts on device.

### Q4
- **Question (RU):** Когда AI не нужен?
- **Question (EN):** When should you not use AI?
- **Answer (RU):** **Детерминированная** логика: validation, navigation, CRUD, sort/filter. AI добавляет nondeterminism, cost, privacy review. Использовать когда качество улучшается measurably (summarization, semantic search), не «потому что модно».
- **Answer (EN):** Use rules and code for validation, navigation, CRUD, sorting. AI adds nondeterminism, cost, and privacy overhead — use it when quality gains are measurable, not for hype.

<!-- knowledge-cards-canonical:end -->
