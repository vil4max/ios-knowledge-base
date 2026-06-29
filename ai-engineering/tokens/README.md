# 02 · Tokens

## In 30 seconds

**Tokens** are the atomic units models read and write — not words, but **subword pieces** produced by a **tokenizer** (often BPE). Token count drives **cost**, **latency**, and whether content fits the **context window**. Interviews expect you to distinguish **input vs output tokens**, explain why the same sentence tokenizes differently across languages, and optimize prompts for mobile (shorter system prompts, fewer few-shot examples). Context limits and truncation strategies live in [03 · Context Window](../context-window/README.md).

## Apple docs

- [Foundation Models — LanguageModelSession](https://developer.apple.com/documentation/foundationmodels/languagemodelsession) — transcript grows in tokens each turn.
- [WWDC25 — Deep dive into the Foundation Models framework](https://developer.apple.com/videos/play/wwdc2025/301/) — tokens, context limits, sampling.
- [Natural Language framework](https://developer.apple.com/documentation/naturallanguage) — tokenization for non-LLM NLP tasks.
- [NLTokenizer](https://developer.apple.com/documentation/naturallanguage/nltokenizer) — word/sentence boundaries on device.

## 🎯 Focus vs Defer

### Focus

- **Tokenization pipeline:** raw text → normalize → BPE/WordPiece → integer IDs.
- **BPE intuition:** merge frequent character pairs until vocabulary size reached; common words = one token, rare words = many subwords.
- **Input vs output tokens:** billing and limits often count both separately; output tokens dominate decode latency.
- **Cost/latency:** longer prompts = more prefill work; longer answers = more sequential decode steps.
- **Multilingual:** CJK and low-resource languages often need **more tokens per character** than English — same context window holds less semantic content.
- **Mobile optimization:** trim system prompt, compress examples, avoid pasting huge JSON in user message.

### Defer

- Exact BPE merge table construction algorithm.
- Byte-level BPE vs SentencePiece internals unless NLP research role.
- Vendor-specific tokenizer file formats (tiktoken, etc.) — know concept, not every API.

## Key concepts

| Term | Detail |
|------|--------|
| **Token** | Integer ID mapping to a subword piece in model vocabulary |
| **Vocabulary** | Fixed set of tokens model was trained on (e.g. 32k–128k) |
| **BPE** | Byte Pair Encoding — iterative merge of frequent pairs |
| **Prefill tokens** | All prompt tokens processed before first output token |
| **Completion tokens** | Generated output tokens (autoregressive) |
| **Token budget** | Planned allocation: system + tools + history + user + reserved output |
| **Special tokens** | BOS, EOS, padding — model-specific |

**Rough sizing (English, varies by model):**

| Text | Approx tokens |
|------|---------------|
| 1 word | ~1–1.3 tokens |
| 100 words | ~130 tokens |
| 1 page (~500 words) | ~650 tokens |
| JSON blob | Often **more** tokens than prose (punctuation, keys) |

**Input vs output on cloud APIs:**

| | Input tokens | Output tokens |
|---|--------------|---------------|
| When charged | Prompt + history + tool defs | Generated text + tool call JSON |
| Latency impact | Prefill (parallel) | Decode (sequential) |
| Control | Shorten prompt, truncate history | `max_tokens` / `maximumResponseTokens` |

**Multilingual on iOS apps:** UI in Ukrainian/Russian/Chinese may consume 2–3× tokens vs equivalent English for the same meaning — design shorter instructions, avoid redundant few-shot in every locale, and test token usage per language before shipping on-device features with tight context limits.

**Apple Foundation Models:** tool definitions (name, description, parameter schema) are injected into the prompt and **consume tokens** — keep tool count and descriptions concise. See [08 · Tool Calling](../tool-calling/README.md).

## 🏋️ Exercises

1. **Estimate budget** — System prompt 400 tokens, history 2000, user 100, reserve 500 for reply. Model limit 4096. Safe? *Expected:* 400+2000+100+500=3000 — yes, ~1096 headroom; monitor history growth.

2. **Multilingual** — Same FAQ in EN vs JA; JA uses 2× tokens. *Expected:* shorter JA system prompt or summarize FAQ chunks; don't assume equal capacity.

3. **BPE intuition** — Why is `"unhappiness"` often multiple tokens? *Expected:* rare morphemes split into subwords `"un"`, `"happi"`, `"ness"` depending on training corpus frequency.

4. **Cost model** — Cloud $3/M input, $15/M output. 10k requests × 2k input × 500 output. *Expected:* calculate both line items; output often dominates spend for chatty assistants.

5. **Mobile trim** — 3-page system prompt for on-device chat. *Expected:* cut to role + format + safety; move examples to `@Generable` schema; measure with transcript inspection.

## Links

- [Deep dive Foundation Models (WWDC25)](https://developer.apple.com/videos/play/wwdc2025/301/)
- [Foundation Models framework](https://developer.apple.com/documentation/foundationmodels)
- [NLTokenizer](https://developer.apple.com/documentation/naturallanguage/nltokenizer)
- Next: [03 · Context Window](../context-window/README.md)
- Related: [llm-basics](../llm-basics/README.md), [context-window](../context-window/README.md)

## Interview Q&A (Knowledge cards)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question:** What is a token and why isn't it a word?

- **Answer:** A token is a subword unit from the model vocabulary after tokenization. Frequent words map to one token; rare words split into multiple pieces. The model operates on integer IDs, not raw strings.

### Q2
- **Question:** BPE in 30 seconds?

- **Answer:** Start with characters, repeatedly merge the most frequent pairs until vocabulary size is reached. Produces subwords like common suffixes as single tokens — a balance between characters and whole words.

### Q3
- **Question:** Why distinguish input vs output tokens?

- **Answer:** Cloud APIs often price them differently. Input drives prefill cost; output drives sequential decode latency. Cap maximum response tokens and monitor both in production.

### Q4
- **Question:** Multilingual impact on mobile LLM?

- **Answer:** Non-Latin scripts often need more tokens per character, so the same context window holds less content with higher cost and latency. Test real UI strings per locale and keep prompts concise.

<!-- knowledge-cards-canonical:end -->

<!-- ai-engineering-nav:start -->

---

**AI Engineering:** [Track overview](../README.md) · [← 01 · LLM Basics](../llm-basics/) · [03 · Context Window →](../context-window/)

<!-- ai-engineering-nav:end -->
