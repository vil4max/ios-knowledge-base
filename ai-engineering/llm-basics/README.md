# 01 · LLM Basics

## In 30 seconds

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

## Key concepts

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

## Links

- [Foundation Models documentation](https://developer.apple.com/documentation/foundationmodels)
- [Meet the Foundation Models framework (WWDC25)](https://developer.apple.com/videos/play/wwdc2025/286/)
- [Attention Is All You Need](https://arxiv.org/abs/1706.03762) — original transformer paper
- Next: [02 · Tokens](../tokens/README.md), [03 · Context Window](../context-window/README.md)
- Related: [foundation-models](../foundation-models/README.md), [rag](../rag/README.md)

## Interview Q&A (Knowledge cards)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question:** How does an LLM differ from classical ML?

- **Answer:** Classical ML maps fixed inputs to labels or scores. LLMs are sequence models that predict the next token autoregressively with open-ended text output. On iOS use Core ML for classification and Foundation Models or cloud APIs for generation.

### Q2
- **Question:** Explain transformers intuitively.

- **Answer:** Text becomes token embeddings. Self-attention lets each token weigh others in context; stacked layers output next-token probabilities. Repeat for generation. Parallel training enabled LLM scale.

### Q3
- **Question:** On-device vs cloud LLM on iOS?

- **Answer:** On-device offers privacy, offline use, and no cloud token billing with capacity limits. Cloud APIs offer larger models at per-token cost and network dependency. Private Cloud Compute extends Apple-hosted capacity with privacy protections.

### Q4
- **Question:** What is hallucination and how do you reduce it?

- **Answer:** The model confidently invents false content. Mitigate with RAG or tools for facts, citations, structured output with validation, explicit refusal instructions, and user confirmation for critical actions. Low temperature alone does not guarantee truth.

<!-- knowledge-cards-canonical:end -->

<!-- ai-engineering-nav:start -->

---

**AI Engineering:** [Track overview](../README.md) · [← Roadmap](../roadmap/) · [02 · Tokens →](../tokens/)

<!-- ai-engineering-nav:end -->
