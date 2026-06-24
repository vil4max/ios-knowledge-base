# 01 · LLM Basics

## За 30 секунд

**Large Language Models (LLMs)** are neural networks trained to predict the **next token** from prior context — enabling chat, summarization, classification, and code generation. They differ from classical ML (fixed input → label) by accepting **variable-length text** and producing open-ended output. Core interview topics: **transformer intuition** (self-attention stacks), **inference** (prefill + decode, streaming), **on-device vs cloud** trade-offs on iOS, and **hallucination** mitigation. Token budgets and context limits are covered in [02 · Tokens](../tokens/README.md) and [03 · Context Window](../context-window/README.md).

## Apple docs

- [Foundation Models framework](https://developer.apple.com/documentation/foundationmodels) — on-device LLM API for iOS 26+.
- [SystemLanguageModel](https://developer.apple.com/documentation/foundationmodels/systemlanguagemodel) — availability and model access.
- [LanguageModelSession](https://developer.apple.com/documentation/foundationmodels/languagemodelsession) — multi-turn stateful generation.
- [WWDC25 — Meet the Foundation Models framework](https://developer.apple.com/videos/play/wwdc2025/286/)
- [WWDC25 — Deep dive into the Foundation Models framework](https://developer.apple.com/videos/play/wwdc2025/301/) — tokens, context limits, sampling.
- [Core ML](https://developer.apple.com/documentation/coreml) — custom on-device models (classifiers, not generative LLMs).

## 🎯 Focus vs Defer

### Focus

- **ML vs LLM:** classical ML = fixed features → label; LLM = sequence model over tokens, generative output.
- **Transformer stack:** embeddings → self-attention layers → next-token prediction; repeated for generation.
- **Inference phases:** prefill (process prompt) + autoregressive decode (one token at a time); latency grows with output length.
- **On-device (Apple FM):** privacy, offline, no per-token cloud bill; capacity and context limits.
- **Cloud LLM APIs:** larger models, higher cost, network dependency; use for heavy reasoning or when on-device unavailable.
- **Hallucination:** confident but wrong output — mitigate with RAG, citations, structured output, refusal when uncertain.
- **Temperature / sampling:** lower = deterministic/factual; higher = creative/varied.

### Defer

- Full attention O(n²) matrix derivation and backprop math.
- Mixture-of-experts and every open-weight model comparison.
- Training pipeline details unless ML infra role.

## Ключевые понятия

| Concept | Interview line |
|---------|----------------|
| **Token** | Subword unit; text → token IDs before model sees it |
| **Embedding** | Dense vector per token; learned during training |
| **Self-attention** | Each token weighs all others in context to build meaning |
| **Prefill** | Process entire prompt in parallel (fast per token, scales with prompt size) |
| **Decode** | Generate output tokens one-by-one (dominates latency for long answers) |
| **Context window** | Max tokens model can attend to in one request |
| **Hallucination** | Plausible-sounding fabrication — not a random bug |
| **Grounding** | Tie answers to retrieved or tool-fetched facts |

**ML vs LLM on iOS:**

| | Classical ML (Core ML) | LLM (Foundation Models / cloud) |
|---|------------------------|----------------------------------|
| Input | Fixed tensor / features | Variable text (tokens) |
| Output | Label, score, embedding | Generated text or structured types |
| Use case | Vision classify, spam filter | Chat, summarization, extraction |
| Update | Retrain/replace model | Prompt, tools, RAG index |

**On-device vs cloud for mobile apps:**

| Factor | On-device (SystemLanguageModel) | Cloud API |
|--------|----------------------------------|-----------|
| Privacy | Strong; data stays on device | Requires trust + network |
| Latency | Low for small tasks | Network RTT + queue |
| Cost | No per-token billing (Apple FM) | Per input/output token |
| Offline | Yes on supported hardware | No |
| Model size | ~3B-class on device | 70B+ possible |

Apple Intelligence routes some workloads to **Private Cloud Compute** when on-device capacity is insufficient — still Apple-controlled privacy architecture, not a generic third-party cloud.

**Hallucination mitigations for iOS features:** retrieve docs via RAG or Tools before answering; use `@Generable` for typed extraction with validation; instruct model to say "I don't know"; show citations in UI; never auto-commit financial or medical actions without user confirmation.

## 🏋️ Exercises

1. **ML or LLM?** Photo filter that detects faces vs assistant that drafts email replies. *Expected:* Core ML / Vision for detection; Foundation Models or cloud LLM for generation.

2. **Latency budget** — Chat reply must feel instant on iPhone. *Expected:* stream tokens; cap `maximumResponseTokens`; prefer on-device for short tasks; show partial UI.

3. **Hallucination case** — Travel app suggests nonexistent flight. *Expected:* tool/RAG for live data; validate API response; never trust model for inventory/pricing alone.

4. **On-device gate** — Feature requires Apple Intelligence. *Expected:* check `SystemLanguageModel.default.isAvailable`; graceful fallback or settings deep link.

5. **Explain to PM** — Why can't we paste entire 500-page manual into one prompt? *Expected:* context window + token cost; point to chunking/RAG ([vector-search](../vector-search/README.md)).

## Ссылки

- [Foundation Models documentation](https://developer.apple.com/documentation/foundationmodels)
- [Meet the Foundation Models framework (WWDC25)](https://developer.apple.com/videos/play/wwdc2025/286/)
- [Attention Is All You Need](https://arxiv.org/abs/1706.03762) — original transformer paper
- Next: [02 · Tokens](../tokens/README.md), [03 · Context Window](../context-window/README.md)
- Related: [foundation-models](../foundation-models/README.md), [rag](../rag/README.md)

## Карточки знаний (Q&A)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question (RU):** Чем LLM отличается от «обычного» ML?
- **Question (EN):** How does an LLM differ from classical ML?
- **Answer (RU):** **Классический ML** — фиксированный вход (features/image) → метка или score. **LLM** — **sequence model**: текст → tokens → предсказание **следующего token** autoregressively; выход открытый (текст, JSON через guided generation). На iOS: Core ML для классификации; Foundation Models / cloud для generative задач.
- **Answer (EN):** Classical ML maps fixed inputs to labels or scores. LLMs are sequence models that predict the next token autoregressively with open-ended text output. On iOS use Core ML for classification and Foundation Models or cloud APIs for generation.
- **Follow-up:** когда Core ML, а когда LLM в одном приложении?
- **Follow-up answer:** Core ML — детерминированные модели с фиксированным I/O (vision, tabular). LLM — языковые задачи, диалог, extraction из текста. Часто **оба**: Vision находит объект, LLM описывает или отвечает на вопрос пользователя.

### Q2
- **Question (RU):** Transformer «на пальцах»?
- **Question (EN):** Explain transformers intuitively.
- **Answer (RU):** Текст → **token embeddings**. **Self-attention** — каждый token «смотрит» на остальные в контексте и собирает weighted representation. Стек слоёв → logits для **next token**; повтор для генерации. Параллельное обучение на GPU — почему LLM масштабировались.
- **Answer (EN):** Text becomes token embeddings. Self-attention lets each token weigh others in context; stacked layers output next-token probabilities. Repeat for generation. Parallel training enabled LLM scale.
- **Follow-up:** что дороже — длинный prompt или длинный ответ?
- **Follow-up answer:** **Decode** (output tokens) часто доминирует latency, т.к. каждый output token sequential. Prefill prompt тоже стоит, но parallel; длинные ответы в chat UI заметнее пользователю.

### Q3
- **Question (RU):** On-device vs cloud LLM на iOS?
- **Question (EN):** On-device vs cloud LLM on iOS?
- **Answer (RU):** **On-device** (`SystemLanguageModel`) — privacy, offline, нет cloud token bill; лимиты context и reasoning. **Cloud API** — больше модель, выше cost, нужна сеть и политика данных. **PCC** — Apple-hosted для тяжёлых задач. Для PII-heavy features предпочитать on-device/PCC над произвольным third-party cloud.
- **Answer (EN):** On-device offers privacy, offline use, and no cloud token billing with capacity limits. Cloud APIs offer larger models at per-token cost and network dependency. Private Cloud Compute extends Apple-hosted capacity with privacy protections.
- **Follow-up:** как проверить доступность on-device модели?
- **Follow-up answer:** `SystemLanguageModel.default.isAvailable` + OS/device requirements; показать fallback UI или deep link в Settings → Apple Intelligence.

### Q4
- **Question (RU):** Hallucination — что это и как снижать?
- **Question (EN):** What is hallucination and how do you reduce it?
- **Answer (RU):** Модель **уверенно генерирует ложное** — не random glitch. Снижение: **RAG/Tools** для фактов, **citations** в UI, **structured output** + validation, инструкция «скажи, если не знаешь», human confirmation для critical actions. Низкая temperature alone **не** гарантирует truth.
- **Answer (EN):** The model confidently invents false content. Mitigate with RAG or tools for facts, citations, structured output with validation, explicit refusal instructions, and user confirmation for critical actions. Low temperature alone does not guarantee truth.
- **Follow-up:** пользователь видит citation — достаточно ли?
- **Follow-up answer:** Citation снижает доверие к unsupported claims, но chunk может быть irrelevant — нужны retrieval quality + «answer only from context» prompt + empty-retrieval handling.

<!-- knowledge-cards-canonical:end -->

<!-- ai-engineering-nav:start -->

---

**AI Engineering:** [Track overview](../README.md) · [← Roadmap](../roadmap/) · [02 · Tokens →](../tokens/)

<!-- ai-engineering-nav:end -->
