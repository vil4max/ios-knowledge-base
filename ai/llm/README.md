# LLM

## За 30 секунд

**Large Language Models** are transformer-based networks trained to predict next tokens — enabling chat, summarization, and code generation. Interviews cover **transformer basics** (attention, self-attention stacks), **context window** limits, **temperature** (randomness vs determinism), and **fine-tuning vs RAG** (change weights vs retrieve external docs). On iOS, know Apple’s on-device models vs cloud APIs and streaming UX.

## Apple docs

- [Foundation Models framework](https://developer.apple.com/documentation/foundationmodels) — `SystemLanguageModel`, `LanguageModelSession`, guided generation.
- [WWDC25 — Meet the Foundation Models framework](https://developer.apple.com/videos/play/wwdc2025/286/)
- [Natural Language — NLEmbedding](https://developer.apple.com/documentation/naturallanguage/nlembedding) — smaller on-device text vectors (not full LLM).

## 🎯 Focus vs Defer

### Focus

- **Transformer intuition:** tokens in → attention over context → next token out; stacks of layers.
- **Context window:** system + history + user message must fit; truncation strategies.
- **Temperature / top-p:** higher = creative, lower = factual/deterministic.
- **Fine-tuning:** adapt model weights on domain data — expensive, needs retrain pipeline.
- **RAG:** keep base model; retrieve relevant chunks at query time — fresher facts, less hallucination.
- **Hallucination:** model confabulates — mitigate with RAG, citations, structured output.
- **Streaming:** token-by-token UI; cancellation via Task.

### Defer

- Full attention matrix math O(n²) derivation.
- Mixture-of-experts architecture details unless infra interview.
- Every open-weight model license comparison.

## Ключевые понятия

| Concept | Interview line |
|---------|------------------|
| **Tokenization** | Text → subword ids; affects languages differently |
| **Prompt** | Instructions + context + user input |
| **System prompt** | Developer-set behavior guardrails |
| **Context window** | Max tokens per request (e.g. 8k–128k+) |
| **Temperature** | Sampling randomness 0.0–2.0 |
| **Fine-tuning** | SFT/LoRA on proprietary data |
| **RAG** | Retrieve docs → inject into prompt |
| **Grounding** | Tie answers to retrieved sources |
| **Structured output** | JSON/schema — `@Generable` on Apple |

**Fine-tuning vs RAG:**

| | Fine-tuning | RAG |
|---|-------------|-----|
| Updates | Retrain/redeploy | Update index |
| Facts | Baked into weights | Retrieved at query |
| Cost | High upfront | Per-query retrieval |
| Best for | Style, format, domain tone | Changing knowledge base |

**Apple Foundation Models (iOS 26+):** on-device ~3B parameter class model; `LanguageModelSession` for multi-turn; instructions obeyed over user prompt (security); guided generation for typed Swift structs.

## 🏋️ Exercises

1. **Context budget** — Chat with 20 turns; design history truncation. *Expected:* keep system + last N tokens + summarize middle.

2. **Temperature choice** — Medical FAQ bot vs creative writing assistant. *Expected:* low temp + RAG for FAQ; higher temp optional for creative with disclaimers.

3. **Fine-tune or RAG** — Internal HR policy bot, policies change monthly. *Expected:* RAG; fine-tune only for tone if needed.

4. **Structured output** — Parse user message into `BookingIntent` struct. *Expected:* schema/guided generation; validate before API call.

5. **Streaming UI** — SwiftUI chat with cancel. *Expected:* `AsyncStream`, Task cancellation, error state.

## Ссылки

- [Foundation Models documentation](https://developer.apple.com/documentation/foundationmodels)
- [Attention Is All You Need](https://arxiv.org/abs/1706.03762) — original transformer paper
- Related: [rag](../rag/README.md), [prompt-engineering](../prompt-engineering/README.md)

## Карточки знаний (Q&A)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question (RU):** Transformer «на пальцах»?
- **Question (EN):** Explain transformers intuitively.
- **Answer (RU):** Текст → **tokens** → embeddings. **Self-attention** позволяет каждому token «смотреть» на другие в контексте и собирать смысл. Стек слоёв предсказывает **следующий token**; повтор для генерации. Параллелizable training — почему LLM масштабировались.
- **Answer (EN):** Text becomes tokens and embeddings. Self-attention lets each token weigh others in context; stacked layers predict the next token repeatedly for generation. Parallel training enabled scale.

### Q2
- **Question (RU):** Context window — что ломается при overflow?
- **Question (EN):** What breaks when you exceed the context window?
- **Answer (RU):** Модель **не видит** обрезанное; теряется ранний диалог и документы. Симптомы: противоречия, «забытые» инструкции. Лечение: truncate, rolling summary, RAG вместо paste всего корпуса.
- **Answer (EN):** Content beyond the window is invisible — early conversation and docs drop. Symptoms include contradictions and ignored instructions. Fix with truncation, summarization, or RAG instead of pasting huge corpora.

### Q3
- **Question (RU):** Temperature — как выбрать?
- **Question (EN):** How do you choose temperature?
- **Answer (RU):** **Низкая (0–0.3)** — factual, classification, JSON. **Средняя** — general chat. **Высокая** — creative writing, brainstorming. Production assistants часто low temp + RAG + schema validation.
- **Answer (EN):** Low (0–0.3) for factual/structured tasks; medium for chat; high for creative work. Production assistants often use low temperature plus RAG and schema checks.

### Q4
- **Question (RU):** Fine-tuning vs RAG?
- **Question (EN):** Fine-tuning vs RAG?
- **Answer (RU):** **Fine-tuning** меняет веса — стиль, формат, узкий домен; дорого, медленно обновлять факты. **RAG** подтягивает актуальные документы в prompt — лучше для changing knowledge и citations. Часто **RAG first**, fine-tune только если нужен стиль/behavior, не факты.
- **Answer (EN):** Fine-tuning changes weights for style or narrow behavior — costly and slow to refresh facts. RAG retrieves current documents — better for changing knowledge. Prefer RAG first; fine-tune when style or behavior needs adaptation.

<!-- knowledge-cards-canonical:end -->
