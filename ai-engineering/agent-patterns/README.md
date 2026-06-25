# Agent Patterns

## In 30 seconds


<details class="lang-ru">
<summary>По-русски</summary>

**Agent patterns** — повторяемые решения в промптах и runtime, которые делают AI-фичу **grounded**, **safe**, и **useful**. Изучать их полезнее, чем копировать сырые system prompts: Apple в Xcode Coding Intelligence явно учит модель **сначала искать контекст**, **рассуждать до действия**, и **выбирать tools** вместо галлюцинаций. Эти паттерны лежат между [08 · Tool Calling](../tool-calling/) и [09 · Agents](../agents/) — один tool round-trip vs полный agent loop.

</details>
<details class="lang-ru">
<summary>По-русски</summary>

**Agent patterns** — повторяемые решения в промптах и runtime для надёжных AI-фич: routing, reflection, human-in-the-loop.

</details>

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

<details class="lang-ru">
<summary>По-русски</summary>

**Идея:** модель не отвечает «из головы», пока не получила релевантный контекст.

Xcode Coding Intelligence буквально требует: если API новее training data — **DocumentationSearch**; если вопрос про проект — **query_search** почти всегда; не угадывать содержимое файлов через `find`/`grep` в shell.

</details>

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

<details class="lang-ru">
<summary>По-русски</summary>

Это зачаток [06 · RAG](../rag/): retrieve → augment → generate, но tools могут заменить или дополнить vector search.

</details>

| Signal | Action |
|--------|--------|
| Unknown API / framework | Documentation or embedding search |
| Question about user data | Domain tools or local DB query |
| Empty retrieval | Say so; do not invent facts |

---

### 2 · Think Before Act

<details class="lang-ru">
<summary>По-русски</summary>

**Идея:** запретить немедленную генерацию кода или side effects без классификации и плана.

Xcode planner сначала **classify_message** (explain vs make changes), затем для edits: понять → кратко объяснить план → **один** `edit_file` на файл за turn.

</details>

```text
User message
  → classify intent
  → gather context (search)
  → brief plan (visible to user)
  → act (tool call) OR answer only
```

<details class="lang-ru">
<summary>По-русски</summary>

**Mobile guardrails:** max steps, timeout, confirm destructive tools — см. [09 · Agents](../agents/).

</details>

---

### 3 · Tool Calling

<details class="lang-ru">
<summary>По-русски</summary>

**Идея:** победа агента — в **инструментах**, не в «умнее промпте».

Xcode предпочитает MCP (`BuildProject`, `DocumentationSearch`, `XcodeRefreshCodeIssuesInFile`) вместо ad hoc shell. Каждый tool — typed capability с описанием для model routing.

</details>

| Anti-pattern | Pattern |
|--------------|---------|
| Model invents API names | Search docs tool |
| Model guesses file layout | Project search / read file tool |
| Silent side effects | Explicit write tools + confirmation |

<details class="lang-ru">
<summary>По-русски</summary>

См. [08 · Tool Calling](../tool-calling/) для schema, idempotency, error feedback.

</details>

---

### 4 · Context Gathering

<details class="lang-ru">
<summary>По-русски</summary>

**Идея:** отдельная фаза, когда стартового контекста (current file, selection) недостаточно.

</details>

<details class="lang-ru">
<summary>По-русски</summary>

Промпты Xcode: «don't overly rely on files given at start»; «avoid guessing at contents of other files»; use search liberally for cross-file refs (renames, call sites).

</details>
```text
Injected context (selection, open file)
  → enough? → respond
  → not enough? → targeted search (symbol, module, error)
  → merge observations → continue
```

<details class="lang-ru">
<summary>По-русски</summary>

**iOS app:** session holds vehicle id + last N messages; tools fetch fresh mileage/expenses on each turn — не кэшировать stale facts в prompt навсегда.

</details>

---

### 5 · Single Agent + Many Tools

<details class="lang-ru">
<summary>По-русски</summary>

**Идея:** один agent loop + богатый tool allowlist часто лучше, чем 10 специализированных sub-agents.

</details>

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

<details class="lang-ru">
<summary>По-русски</summary>

Добавляй sub-agents только когда **domains truly isolated** (e.g. separate compliance reviewer).

</details>

## Priority for AI Product Engineering


| Priority | Topic | Level |
|:--------:|-------|-------|
| 1 | Foundation Models, Tool Calling | Ship on Apple stack |
| 2 | **Agent patterns** (this page) | How AI products behave |
| 3 | RAG, Embeddings | Grounding at scale |
| 4 | Attention / transformer internals | How LLM works (research) |

<details class="lang-ru">
<summary>По-русски</summary>

Patterns из production IDE ближе к цели **Senior iOS + AI Product Engineer**, чем глубокая теория GPT-2.

</details>

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
- **Question (EN):** What does Search Before Answer mean?

- **Answer (EN):** The model retrieves context via search or tools before answering. Empty retrieval means retry or admit uncertainty — never invent facts.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Что значит Search Before Answer?

- **Answer (RU):** Модель **сначала** получает контекст через search/tools (docs, codebase, DB), **потом** генерирует ответ. Если retrieval пуст — не выдумывать; повторить search или сказать пользователю.

</details>

### Q2
- **Question (EN):** Why Think Before Act?

- **Answer (EN):** Classify intent, gather context, state a brief plan, then invoke tools. Reduces unsafe edits and runaway loops.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Think Before Act — зачем?

- **Answer (RU):** Разделить **explain** и **make changes**; собрать контекст; озвучить короткий план; только потом tool calls с side effects. Снижает опасные правки и runaway loops.

</details>

### Q3
- **Question (EN):** Why single agent plus many tools?

- **Answer (EN):** One loop simplifies guardrails, evals, and UX. A rich tool allowlist covers most product needs; multi-agent only when domains are truly isolated.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Почему Single Agent + Many Tools?

- **Answer (RU):** Один loop проще guardrails, eval и UX. Много **typed tools** покрывают домен без orchestration между sub-agents. Multi-agent — когда домены реально изолированы.

</details>

### Q4
- **Question (EN):** How are agent patterns different from copying system prompts?

- **Answer (EN):** Raw prompts rot and are product-specific. Patterns (search-first, classify, prefer tools) transfer to your app and regress with golden tests.

<!-- knowledge-cards-canonical:end -->

<!-- ai-engineering-nav:start -->

---

**AI Engineering:** [Track overview](../README.md) · [← 09 · Agents](../agents/) · [10 · MCP →](../mcp/)

<!-- ai-engineering-nav:end -->


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Чем agent patterns отличаются от копирования system prompts?

- **Answer (RU):** Prompts устаревают и привязаны к продукту. **Паттерны** (search-first, classify, tool preference) переносимы в свой app и тестируются через golden questions.

</details>
