# 04 · Embeddings

## За 30 секунд


**Embeddings** map text (or other data) to **dense vectors** in high-dimensional space — similar meaning → **nearby vectors**, measurable by **cosine similarity** or dot product. They power semantic search, clustering, and RAG retrieval. On iOS: **`NLEmbedding`** (Natural Language) for lightweight on-device word/sentence vectors; cloud **embedding models** (OpenAI, Cohere, etc.) for higher quality at scale. **Dimensions** must match between index and query embedder. Downstream: [05 · Vector Search](../vector-search/README.md) and [06 · RAG](../rag/README.md).


<details class="lang-ru">
<summary>По-русски</summary>

**Embeddings** — плотные векторы смысла текста. Основа semantic search и RAG.

</details>



## Apple docs

- [NLEmbedding](https://developer.apple.com/documentation/naturallanguage/nlembedding) — pre-trained word embeddings on device.
- [Natural Language framework](https://developer.apple.com/documentation/naturallanguage) — language ID, tokenization, tagging.
- [NLVector](https://developer.apple.com/documentation/naturallanguage/nlvector) — vector operations for embeddings.
- [Creating a word embedding from a custom vocabulary](https://developer.apple.com/documentation/createml/creating-a-word-embedding-from-a-custom-vocabulary) — Create ML for domain vocab.
- [Core ML](https://developer.apple.com/documentation/coreml) — deploy custom embedding models.

## 🎯 Focus vs Defer

### Focus

- **Vector intuition:** list of floats capturing semantic direction; not human-readable.
- **Similarity:** cosine similarity (angle) vs Euclidean distance — cosine common for normalized embeddings.
- **NLEmbedding:** Apple on-device word vectors; limited vs modern sentence transformers; good for small offline FAQ.
- **Embedding models:** `text-embedding-3-small`, etc. — sentence/paragraph level, higher quality, often server-side.
- **Dimensions:** e.g. 384, 768, 1536 — query and index **must use same model and dimension**.
- **Use cases:** RAG retrieval, dedup, clustering support tickets, "related articles" in app.

### Defer

- Training embedding models from scratch — use off-the-shelf.
- Full contrastive learning math (InfoNCE, triplet loss).
- Every embedding model benchmark table — know trade-offs qualitatively.

## Ключевые понятия

| Concept | Detail |
|---------|--------|
| **Dense vector** | Fixed-length float array representing meaning |
| **Dimensionality** | Vector length (d); higher ≠ always better for mobile |
| **Cosine similarity** | `dot(a,b) / (‖a‖‖b‖)` — range often interpreted 0–1 for normalized vectors |
| **Semantic search** | Query embed → nearest neighbors in index |
| **NLEmbedding** | Static or context-limited word vectors bundled with OS |
| **Sentence embedding** | Whole sentence → one vector (modern RAG standard) |
| **Normalization** | Unit-length vectors simplify cosine to dot product |

**NLEmbedding vs cloud embedding models:**

| | NLEmbedding | Cloud embedding API |
|---|-------------|---------------------|
| Location | On device | Network call |
| Granularity | Word-level (sentence = aggregate) | Sentence/paragraph optimized |
| Quality | Baseline semantic signal | Stronger retrieval quality |
| Cost | Free, offline | Per token / request |
| Size | OS-bundled | Index stored in app or server |

**iOS patterns:**

```swift
import NaturalLanguage

let embedding = NLEmbedding.wordEmbedding(for: .english)
let vector = embedding?.vector(for: "flight delay")
// Compare with cosine similarity helper for FAQ matching
```

For production RAG on mobile: **precompute embeddings at build time** or on server during ingest; ship SQLite/flat index in app bundle for offline FAQ; refresh index on app update or background sync — avoid embedding entire corpus on every launch (battery).

**Dimensions matter:** mixing 384-dim index with 1536-dim query vectors returns nonsense. Version embedding model in index metadata (`modelId`, `dimensions`, `createdAt`).

**When embeddings fail:** proper nouns, SKUs, rare names — pair with **hybrid search** (BM25 + vector) in [vector-search](../vector-search/README.md).

## 🏋️ Exercises

1. **Pick embedder** — Offline travel FAQ, 200 Q&A pairs, no server. *Expected:* precomputed vectors with NLEmbedding or small Core ML model; bundle index.

2. **Dimension mismatch** — Reindexed with new model, forgot to re-embed queries. *Expected:* zero retrieval quality; version gate index + query pipeline.

3. **Similarity threshold** — Cosine 0.72 vs 0.45 for user question. *Expected:* threshold tuning on golden set; below threshold → "no match" not random chunk.

4. **Word vs sentence** — Match whole user question to FAQ paragraph. *Expected:* sentence-level embedding or average word vectors poorly — prefer sentence model or chunk FAQ.

5. **Privacy** — Health app semantic search over notes. *Expected:* on-device embed + local index; no raw notes to third-party embedding API without consent.

## Ссылки

- [NLEmbedding](https://developer.apple.com/documentation/naturallanguage/nlembedding)
- [Natural Language framework](https://developer.apple.com/documentation/naturallanguage)
- [Create ML word embeddings](https://developer.apple.com/documentation/createml/creating-a-word-embedding-from-a-custom-vocabulary)
- Next: [05 · Vector Search](../vector-search/README.md)
- Related: [rag](../rag/README.md), [vector-search](../vector-search/README.md)

## Карточки знаний (Q&A)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question (EN):** What is an embedding?

- **Answer (EN):** A fixed-length dense float vector encoding text meaning. Similar meaning maps to nearby vectors measured by cosine similarity. Used for search and retrieval, not direct text generation.

- **Follow-up:** embedding vs one-hot encoding?

- **Follow-up answer:** One-hot — sparse, no similarity between words. Embedding — learned dense space where semantic relations become geometry (e.g. king − man + woman ≈ queen in classic examples).


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Embedding — что это?

- **Answer (RU):** **Плотный вектор** (массив floats) фиксированной длины, кодирующий смысл текста. Близкий смысл → близкие векторы (**cosine similarity**). Используется для semantic search, clustering, RAG retrieval — не для generation напрямую.

</details>
### Q2
- **Question (EN):** When is NLEmbedding enough on iOS?

- **Answer (EN):** Fine for small offline corpora, prototypes, and privacy-sensitive local matching. Insufficient for large RAG or best-in-class retrieval — use server or Core ML sentence encoders.

- **Follow-up:** NLEmbedding для Ukrainian/Russian?

- **Follow-up answer:** Check `NLEmbedding.wordEmbedding(for:)` language availability; quality varies — test golden queries per locale; may need multilingual cloud embedder for production.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** NLEmbedding — когда достаточно на iOS?

- **Answer (RU):** **Small offline corpora** (FAQ, glossary), prototype semantic match, privacy-critical без network. Недостаточно для large RAG, multilingual production search, или когда нужен state-of-art retrieval — тогда server embedding model или Core ML sentence encoder.

</details>
### Q3
- **Question (EN):** Why do dimensions matter?

- **Answer (EN):** Index and query vectors must come from the same model with the same dimensionality. Store model metadata with the index and re-embed everything when the model changes.

- **Follow-up:** больше dimensions = лучше?

- **Follow-up answer:** Not always — higher dims = more storage and compute; diminishing returns. Pick model for quality/size trade-off; measure recall@k on golden set, don't assume.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Зачем следить за dimensions?

- **Answer (RU):** Index и query **must match** model + dimension (e.g. 768). Mixing models = random similarity scores. Store `modelId` + `dimensions` in index metadata; re-embed entire corpus on model change.

</details>
### Q4
- **Question (EN):** Cosine similarity vs Euclidean distance?

- **Answer (EN):** Cosine measures angle between vectors and works well for normalized embeddings. Euclidean measures straight-line distance. RAG typically uses cosine or dot product on normalized vectors.

- **Follow-up:** similarity 0.85 — always good match?

- **Follow-up answer:** **Threshold depends on corpus and model** — calibrate on golden questions; high score on tiny corpus can be misleading; always combine with metadata filters and empty-result handling.

<!-- knowledge-cards-canonical:end -->

<!-- ai-engineering-nav:start -->

---

**AI Engineering:** [Track overview](../README.md) · [← 03 · Context Window](../context-window/) · [05 · Vector Search →](../vector-search/)

<!-- ai-engineering-nav:end -->


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Cosine similarity vs Euclidean distance?

- **Answer (RU):** **Cosine** — угол между векторами; robust когда magnitude less important (normalized embeddings). **Euclidean** — straight-line distance in space. RAG indexes usually **cosine** or dot product on **normalized** vectors. Interview: explain cosine as "same direction = similar meaning."

</details>
