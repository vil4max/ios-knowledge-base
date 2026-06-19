# 05 · Vector Search

## За 30 секунд

**Vector search** finds the **k nearest neighbors** to a query embedding in a high-dimensional index — the retrieval core of RAG and in-app semantic search. Production systems use **ANN** (approximate nearest neighbor) indexes for speed at scale, **cosine similarity** for scoring, **metadata filters** for tenant/product scoping, and often **hybrid search** (BM25 keywords + vectors) for SKUs and names. Mobile: small indexes in SQLite or bundled flat files; large corpora on server. Builds on [04 · Embeddings](../embeddings/README.md).

## Apple docs

- [NLEmbedding](https://developer.apple.com/documentation/naturallanguage/nlembedding) — on-device vectors for small indexes.
- [Accelerate framework](https://developer.apple.com/documentation/accelerate) — SIMD dot products for brute-force k-NN on small datasets.
- [Core Data / SQLite](https://developer.apple.com/documentation/coredata) — persist vectors + metadata locally.
- [Foundation Models — Tool](https://developer.apple.com/documentation/foundationmodels/tool) — model calls app tool that runs vector search.

## 🎯 Focus vs Defer

### Focus

- **k-NN retrieval:** embed query → search index → return top-k chunk IDs + scores.
- **ANN:** HNSW, IVF — trade exactness for speed; "approximate" usually fine for RAG.
- **Cosine similarity:** standard score; normalize vectors for dot-product speed.
- **Metadata filters:** `productId`, `locale`, `docVersion` before or during search.
- **Hybrid search:** combine keyword (BM25/inverted index) + vector — helps proper nouns.
- **Mobile constraints:** index size in app bundle, query latency on CPU, sync strategy.

### Defer

- HNSW layer graph construction details.
- Sharding petabyte-scale vector DBs unless platform interview.
- Every vendor API (Pinecone, Weaviate) — know pattern, one example enough.

## Ключевые понятия

| Term | Meaning |
|------|---------|
| **k-NN** | k nearest neighbors by similarity |
| **ANN** | Approximate NN — faster, slightly lower recall |
| **HNSW** | Graph-based ANN index (common in FAISS, many SaaS DBs) |
| **Flat index** | Brute-force — OK for <10k vectors on device |
| **Metadata filter** | Restrict search to subset (user id, category) |
| **Hybrid search** | Fuse keyword + vector rankings (RRF common) |
| **Recall@k** | Golden query found in top-k — eval metric |

**Pipeline (RAG retrieval):**

```text
Ingest:  doc → chunk → embed → store(vector, metadata)
Query:   user text → embed → ANN top-k → optional rerank → prompt
```

**Exact vs approximate:**

| | Exact (flat) | ANN (HNSW) |
|---|--------------|------------|
| Speed | O(n) — slow at scale | Sublinear, fast |
| Recall | 100% | ~95–99% tunable |
| Mobile | FAQ <5k chunks | Server or large local index |

**Metadata filters (iOS multi-tenant app):**

```text
filter: { appVersion >= 2.0, locale: "en", feature: "billing" }
→ search only matching vectors before k-NN
```

Pre-filter when cardinality small; post-filter when index lacks composite support — watch recall drop if k too small before filter.

**Hybrid search when:** user query contains **SKU**, **error code**, **person name** — pure vector may miss exact token match. Reciprocal Rank Fusion (RRF) merges BM25 and vector ranked lists without score normalization.

**On-device pattern:** bundle `embeddings.bin` + SQLite metadata; query with Accelerate vDSP dot products; cap k=5–10 for Foundation Models context budget ([context-window](../context-window/README.md)).

## 🏋️ Exercises

1. **Index sizing** — 10k chunks × 768 floats × 4 bytes. *Expected:* ~30 MB vectors alone; consider quantization or server index for App Store size limits.

2. **Empty results** — All similarities below 0.55 threshold. *Expected:* return empty context; model says "not found" — do not inject random chunks.

3. **Hybrid** — Query `"error E1042 wifi"`. *Expected:* keyword match on `E1042` + vector on surrounding help text.

4. **Filter bug** — Search all tenants, leak other user's docs. *Expected:* mandatory `userId` metadata filter; security review for multi-tenant RAG.

5. **Evaluate** — 30 golden questions with expected doc IDs. *Expected:* measure recall@5; tune chunk size and k before prompt engineering.

## Ссылки

- [NLEmbedding](https://developer.apple.com/documentation/naturallanguage/nlembedding)
- [Accelerate](https://developer.apple.com/documentation/accelerate)
- [FAISS (Meta)](https://github.com/facebookresearch/faiss) — reference ANN library
- Related: [embeddings](../embeddings/README.md), [rag](../rag/README.md), [context-window](../context-window/README.md)

## Карточки знаний (Q&A)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question (RU):** ANN — зачем, если есть exact k-NN?
- **Question (EN):** Why ANN when exact k-NN exists?
- **Answer (RU):** **Exact** brute-force O(n) — OK для thousands vectors on device. **Millions+** — too slow. **ANN** (HNSW, IVF) жертвует negligible recall ради **sublinear latency**. RAG production almost always ANN on server; mobile FAQ may use flat index.
- **Answer (EN):** Exact search is fine for thousands of vectors. At millions of scale, ANN indexes trade a tiny recall loss for much faster queries. Production RAG typically uses ANN on the server.
- **Follow-up:** как проверить, что ANN не ломает quality?
- **Follow-up answer:** Compare recall@k **ANN vs brute force** on golden set; tune HNSW `efSearch` / `M` parameters; monitor retrieval regressions when reindexing.

### Q2
- **Question (RU):** Metadata filters — до или после vector search?
- **Question (EN):** Metadata filters — before or after vector search?
- **Answer (RU):** **Pre-filter** когда index supports filtered ANN — efficient, correct k. **Post-filter** — retrieve larger k', then filter — риск empty if k' too small. Interview: always filter **tenant/user** for security; design index schema upfront.
- **Answer (EN):** Pre-filter when the index supports it. Post-filter by retrieving a larger k first risks empty results if k is too small. Always filter tenant or user scope for security.
- **Follow-up:** iOS offline index — как хранить metadata?
- **Follow-up answer:** SQLite table: `id, chunk_text, source, locale, embedding_blob`; query with filtered IDs then similarity in Swift or GRDB; version index with app releases.

### Q3
- **Question (RU):** Hybrid search — когда нужен?
- **Question (EN):** When do you need hybrid search?
- **Answer (RU):** Когда **exact tokens matter**: SKU, error codes, names, IDs. Pure vector семantically близок, но может **miss exact match**. **BM25 + vector** + RRF merge — standard production pattern.
- **Answer (EN):** When exact tokens matter — SKUs, error codes, names. Pure vector search can miss exact matches. Combine BM25 with vectors and merge rankings with RRF.
- **Follow-up:** Foundation Models on-device — hybrid realistic?
- **Follow-up answer:** Small corpus: local SQLite FTS + NLEmbedding similarity in app Tool; large corpus: server hybrid; expose to model via Tool returning top snippets.

### Q4
- **Question (RU):** top-k — как выбрать k?
- **Question (EN):** How do you choose top-k?
- **Answer (RU):** Balance **recall vs context window**. Typical **5–20** chunks; each 256–512 tokens. Too many k → prompt overflow + noise. Tune on golden set recall@k; rerank top-20 → final 5 for prompt.
- **Answer (EN):** Balance recall against context window size. Often 5–20 chunks of 256–512 tokens. Too many adds noise and overflows the window. Tune on a golden set; rerank if needed.
- **Follow-up:** similarity score 0.91 vs 0.62 — брать оба?
- **Follow-up answer:** Depends on gap and threshold; steep drop-off after rank 3 may mean only top-2 relevant — use **minimum similarity threshold** + max k; don't fill context with weak matches.

<!-- knowledge-cards-canonical:end -->
