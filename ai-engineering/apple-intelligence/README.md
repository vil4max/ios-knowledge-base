# 12 · Apple Intelligence

## In 30 seconds

Practical **on-device AI** in iOS apps mixes **Apple frameworks** by task: **Vision** / **Core ML** for perception, **Natural Language** for lightweight NLP, **Foundation Models** (iOS 26+) for generative text and tools. Patterns: capability gating, streaming UI, background inference off main thread, privacy manifests, hybrid cloud fallback only when justified. Ship measurable value — summarization, search, assistive input — not AI for its own sake.

## Apple docs

- [Core ML](https://developer.apple.com/documentation/coreml) — custom and converted models.
- [Vision](https://developer.apple.com/documentation/vision) — face, text, barcode, object detection.
- [Natural Language](https://developer.apple.com/documentation/naturallanguage) — tokenization, sentiment, embeddings.
- [Speech framework](https://developer.apple.com/documentation/speech) — on-device recognition where supported.
- [Foundation Models framework](https://developer.apple.com/documentation/foundationmodels) — generative on-device LLM.
- [Privacy manifest files](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files) — declare ML-related API use.

## 🎯 Focus vs Defer

### Focus

- **Pick the smallest tool:** rules → NL → Core ML → Foundation Models.
- **MainActor vs background:** inference off main; UI updates on MainActor.
- **Model delivery:** bundled `.mlmodel`, App Store size, OTA model updates (download + verify).
- **Streaming chat UI:** `AsyncStream`, partial text, cancel, error retry.
- **Feature gating:** hardware, OS, Apple Intelligence enabled, remote kill switch.
- **Privacy:** on-device default; anonymize cloud payloads; ATT if tracking ad networks.
- **Battery & thermal:** batch Vision requests; throttle generative calls.

### Defer

- Training pipelines on device — training is Mac/server; device runs inference.
- Custom CUDA — irrelevant on Apple platforms (Neural Engine / GPU via Core ML).
- Embedding entire ChatGPT clone in v1 — scope to one assistive feature.

## Key concepts

| Use case | Apple stack |
|----------|-------------|
| OCR / doc scan | Vision `VNRecognizeTextRequest` |
| Image classification | Core ML + Vision |
| Language detection | `NLLanguageRecognizer` |
| Semantic FAQ (small) | NLEmbedding + local index |
| Chat assist / summarize | Foundation Models session |
| Speech input | Speech analyzer / `SFSpeechRecognizer` |

**Architecture sketch:**

```text
UI (SwiftUI)
  → ViewModel (@MainActor)
  → AIService (actor)
       → Core ML / Vision / FM session
  → Local store (SwiftData) for cache
  → Optional: sync API for non-AI data only
```

**Patterns:**

- **Preprocessor:** resize/crop images before Vision — consistent latency.
- **Result cache:** hash input → cached summary.
- **Degradation ladder:** FM unavailable → shorter template summary → show raw text.
- **Human review:** AI drafts, user confirms send (mail, message).

## 🏋️ Exercises

1. **Smart reply** — Three suggested replies to incoming message using on-device model. *Expected:* low temp, max length, user tap to send (no auto-send).

2. **Receipt scan** — Vision OCR + guided extraction of total/date. *Expected:* Vision for text, FM or regex for fields, validate currency.

3. **Photo search** — Natural language query over on-device labels. *Expected:* Core ML classifier tags + keyword filter; optional embeddings for synonyms.

4. **Model update** — Download new Core ML model v2 from CDN with checksum. *Expected:* background download, atomic swap, fallback to v1.

5. **Privacy review** — List data leaving device for AI feature. *Expected:* default none for FM; if cloud, document in privacy manifest and UI disclosure.

## Links

- [Core ML](https://developer.apple.com/documentation/coreml)
- [Foundation Models framework](https://developer.apple.com/documentation/foundationmodels)
- [Human Interface Guidelines — Machine learning](https://developer.apple.com/design/human-interface-guidelines/machine-learning) — UX expectations
- Related: [apple-foundation-models](../apple-foundation-models/README.md), [fundamentals](../fundamentals/README.md)

## Interview Q&A (Knowledge cards)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question:** How do you choose between Core ML and Foundation Models?

- **Answer:** Core ML fits fixed IO tasks like classification and detection. Foundation Models fit generative text, dialog, and tools. Do not use an LLM where Vision and rules suffice.

### Q2
- **Question:** Where should inference run?

- **Answer:** Keep inference off the main thread in a Task or actor; update UI on MainActor. Stream long generation with cancellation; downsample large images to control memory.

### Q3
- **Question:** On-device AI UX patterns?

- **Answer:** Show progress or streaming; disclose AI-generated content; confirm irreversible actions; provide fallbacks and settings links; avoid long blank waits without feedback.

### Q4
- **Question:** App Store and privacy considerations for AI features?

- **Answer:** Accurate privacy manifests and labels; on-device processing reduces collection disclosure. For cloud AI use encryption, minimal retention, and consent. Do not hide AI behavior from App Review; disclose third-party ML SDKs.

<!-- knowledge-cards-canonical:end -->

<!-- ai-engineering-nav:start -->

---

**AI Engineering:** [Track overview](../README.md) · [← 11 · Foundation Models](../foundation-models/) · [13 · Dynamic Profiles →](../dynamic-profiles/)

<!-- ai-engineering-nav:end -->
