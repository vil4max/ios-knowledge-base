# Agent Patterns

## In 30 seconds

## Apple docs

- [Expanding generation with tool calling](https://developer.apple.com/documentation/foundationmodels/expanding-generation-with-tool-calling) — when the model must call tools vs answer directly.
- [WWDC26 — Build agentic app experiences (242)](https://developer.apple.com/videos/play/wwdc2026/242/) — agentic flows on Foundation Models.
- [Model Context Protocol](https://modelcontextprotocol.io/) — how hosts expose tools to agents (same idea as Xcode `xcode-tools` MCP).

## 🎯 Focus vs Defer

### Focus

- **Search before answer** — retrieve project/docs/data before generating.
- **Think before act** — classify intent; analyze → plan → then edit or respond.
- **Tools first** — prefer structured tools over shell guesses and hallucinated APIs.
- **Context gathering** — explicit step when auto-injected context is insufficient.
- **Single agent + many tools** — one loop, rich tool surface beats multi-agent sprawl for most apps.

### Defer

- Verbatim leaked prompts — study **patterns**, not copy-paste.
- Multi-agent orchestration for MVP — start with one assistant and an allowlist.
- Prompt tricks without eval harness — patterns need regression tests ([14 · Evaluations](../evaluations/)).

## Patterns

### 1 · Search Before Answer

```text
User question
  → search (docs / codebase / vector index)
  → if insufficient → search again with refined query
  → grounded answer
```

**Product mapping (vehicle assistant):**

```text
Question
  → getVehicle()
  → getServiceHistory()
  → getMileage()
  → answer with citations
```

| Signal | Action |
|--------|--------|
| Unknown API / framework | Documentation or embedding search |
| Question about user data | Domain tools or local DB query |
| Empty retrieval | Say so; do not invent facts |

---

### 2 · Think Before Act

```text
User message
  → classify intent
  → gather context (search)
  → brief plan (visible to user)
  → act (tool call) OR answer only
```

---

### 3 · Tool Calling

| Anti-pattern | Pattern |
|--------------|---------|
| Model invents API names | Search docs tool |
| Model guesses file layout | Project search / read file tool |
| Silent side effects | Explicit write tools + confirmation |

---

### 4 · Context Gathering

```text
Injected context (selection, open file)
  → enough? → respond
  → not enough? → targeted search (symbol, module, error)
  → merge observations → continue
```

---

### 5 · Single Agent + Many Tools

```text
Vehicle Assistant (one session)
  Tools:
    - getVehicle()
    - getMileage()
    - getServiceHistory()
    - getExpenses()
    - searchManuals()   // RAG-backed
    - scheduleReminder() // write + confirm
```

| Multi-agent swarm | Single agent + tools |
|-------------------|---------------------|
| Coordination overhead | One transcript, one policy layer |
| Duplicated guardrails | Central allowlist + max steps |
| Hard to eval | Golden questions on one loop |

## Priority for AI Product Engineering

| Priority | Topic | Level |
|:--------:|-------|-------|
| 1 | Foundation Models, Tool Calling | Ship on Apple stack |
| 2 | **Agent patterns** (this page) | How AI products behave |
| 3 | RAG, Embeddings | Grounding at scale |
| 4 | Attention / transformer internals | How LLM works (research) |

## 🏋️ Exercises

1. **Search gate** — User asks «when is next oil change?» without vehicle id. *Expected:* tool fetch vehicle + history before answer; cite dates.

2. **Explain vs act** — Same UI, two intents: «why is this expensive?» vs «add expense». *Expected:* no write tool on explain path.

3. **Tool vs prompt** — Replace `searchManuals` with «read the manual in your knowledge». *Expected:* list failure modes (hallucination, no citation).

4. **Context gap** — Only current screen visible; question references another car. *Expected:* search/list vehicles tool, not guess.

5. **Tool surface audit** — Draw one agent, ≥5 read tools, 1 write tool with confirm. *Expected:* diagram fits on one sticky note.

## Links

- [artemnovichkov/xcode-27-system-prompts](https://github.com/artemnovichkov/xcode-27-system-prompts) — reverse-engineered Xcode 27 prompts; read for **patterns**, not leakage tourism
- Related: [09 · Agents](../agents/), [08 · Tool Calling](../tool-calling/), [06 · RAG](../rag/), [10 · MCP](../mcp/)

## Interview Q&A (Knowledge cards)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question:** What does Search Before Answer mean?

- **Answer:** The model retrieves context via search or tools before answering. Empty retrieval means retry or admit uncertainty — never invent facts.

### Q2
- **Question:** Why Think Before Act?

- **Answer:** Classify intent, gather context, state a brief plan, then invoke tools. Reduces unsafe edits and runaway loops.

### Q3
- **Question:** Why single agent plus many tools?

- **Answer:** One loop simplifies guardrails, evals, and UX. A rich tool allowlist covers most product needs; multi-agent only when domains are truly isolated.

### Q4
- **Question:** How are agent patterns different from copying system prompts?

- **Answer:** Raw prompts rot and are product-specific. Patterns (search-first, classify, prefer tools) transfer to your app and regress with golden tests.

<!-- knowledge-cards-canonical:end -->

<!-- ai-engineering-nav:start -->

---

**AI Engineering:** [Track overview](../README.md) · [← 09 · Agents](../agents/) · [10 · MCP →](../mcp/)

<!-- ai-engineering-nav:end -->
