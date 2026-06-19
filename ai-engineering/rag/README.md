# 06 · RAG

## За 30 секунд

**Retrieval-Augmented Generation (RAG)** improves LLM answers by **retrieving** relevant documents from a **vector store** (similarity search on **embeddings**) and injecting them into the prompt. Quality hinges on **chunking**, metadata filters, and reranking — not just “embed everything.” Mobile apps often run retrieval on server; on-device search may use smaller indexes or Natural Language embeddings for offline FAQ.

## Apple docs

- [NLEmbedding](https://developer.apple.com/documentation/naturallanguage/nlembedding) — on-device word/sentence embeddings (limited vs cloud embedding models).
- [Natural Language framework](https://developer.apple.com/documentation/naturallanguage) — tokenization, language identification.
- [Foundation Models — tool calling](https://developer.apple.com/documentation/foundationmodels) — model calls app tools to fetch context (RAG-like pattern on device).

## 🎯 Focus vs Defer

### Focus

- **Embeddings:** text → dense vector; similar meaning → nearby in space.
- **Vector store:** index for k-nearest neighbor (FAISS, pgvector, Pinecone, etc.).
- **Chunking:** size, overlap, respect headings/paragraphs — bad chunks = bad retrieval.
- **Retrieval pipeline:** query embed → top-k → optional rerank → prompt assembly.
- **Grounding & citations:** show sources; reduce hallucination.
- **Evaluation:** hit rate@k, human review, golden questions.

### Defer

- HNSW index internals — mention approximate NN at high level.
- Training custom embedding models — use off-the-shelf first.
- Full enterprise search ACL design unless prompted.

## Ключевые понятия

| Stage | Detail |
|-------|--------|
| **Ingest** | Load docs → clean → chunk → embed → store with metadata |
| **Chunk size** | Often 256–512 tokens; overlap 10–20% |
| **Metadata** | `source`, `section`, `updatedAt`, `productId` for filtering |
| **Top-k** | Retrieve 5–20 chunks; too many blows context window |
| **Reranker** | Cross-encoder second pass for precision |
| **Hybrid search** | BM25 keyword + vector — helps proper nouns |
| **Freshness** | Re-index on doc update; tombstone old chunks |

**Prompt assembly:**

```text
System: Answer only from provided context. Cite sources.
Context:
[1] {chunk A} (source: doc.pdf p.3)
[2] {chunk B} ...
User question: ...
```

**Failure modes:** chunk splits mid-sentence; stale index; wrong language embedding; no “I don’t know” when retrieval empty.

## 🏋️ Exercises

1. **Chunk strategy** — 50-page PDF help center. *Expected:* split by H2, 400-token chunks, 50-token overlap, store page title in metadata.

2. **Empty retrieval** — No chunks above similarity threshold. *Expected:* model responds “not found” — do not invent.

3. **Hybrid** — User searches SKU “A2142”. *Expected:* keyword match on SKU + vector on description.

4. **Mobile architecture** — FAQ in app offline. *Expected:* precomputed embeddings bundled or SQLite index; sync updates on app launch.

5. **Evaluate** — 20 golden questions with expected doc ids. *Expected:* measure recall@5 before tuning chunk size.

## Ссылки

- [NLEmbedding](https://developer.apple.com/documentation/naturallanguage/nlembedding)
- [Foundation Models framework](https://developer.apple.com/documentation/foundationmodels)
- Related: [llm](../llm/README.md), [prompt-engineering](../prompt-engineering/README.md)

## Карточки знаний (Q&A)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question (RU):** Embeddings — что это?
- **Question (EN):** What are embeddings?
- **Answer (RU):** **Векторное представление** текста (или image) в высокомерном пространстве: близкие по смыслу тексты → близкие векторы (cosine similarity). Используются для **semantic search** в RAG вместо только keyword match.
- **Answer (EN):** Dense vectors representing text meaning — similar texts map nearby. Used for semantic search in RAG beyond keyword matching.

### Q2
- **Question (RU):** Зачем chunking?
- **Question (EN):** Why is chunking important?
- **Answer (RU):** LLM не вмещает весь корпус; retrieval возвращает **фрагменты**. Плохой chunk (слишком большой, обрезанный абзац) → irrelevant context → hallucination. Chunk по структуре документа + overlap сохраняет continuity.
- **Answer (EN):** Models cannot ingest entire corpora; retrieval returns fragments. Bad chunks yield irrelevant context and hallucinations. Structure-aware chunks plus overlap preserve continuity.

### Q3
- **Question (RU):** Как улучшить retrieval quality?
- **Question (EN):** How do you improve retrieval quality?
- **Answer (RU):** Tune **chunk size/overlap**, add **metadata filters**, **hybrid** BM25+vector, **rerank** top candidates, maintain **fresh index**, evaluate on **golden set**. Prompt: instruct model to stay in context and refuse when empty.
- **Answer (EN):** Tune chunks, filter by metadata, use hybrid search and reranking, keep indexes fresh, evaluate on golden questions. Instruct the model to stay grounded and refuse when context is empty.

### Q4
- **Question (RU):** RAG on-device на iOS — realistic?
- **Question (EN):** Is on-device RAG realistic on iOS?
- **Answer (RU):** **Small corpora** (FAQ, manual): prebuilt index in app bundle or SQLite + on-device embedder (**NLEmbedding** or small Core ML model). **Large/knowledge** — server retrieval; on-device LLM (**Foundation Models**) + **Tool** that fetches snippets from local index or API. Trade-off: size, battery, freshness.
- **Answer (EN):** Small corpora can ship with a local index and on-device embeddings. Large knowledge bases usually need server retrieval; combine on-device LLMs with tools that fetch from local or remote indexes — mind size, battery, and freshness.

<!-- knowledge-cards-canonical:end -->

<!-- ai-engineering-nav:start -->

---

**AI Engineering:** [Track overview](../README.md) · [← 05 · Vector Search](../vector-search/) · [07 · Structured Output →](../structured-output/)

<!-- ai-engineering-nav:end -->
