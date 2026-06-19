# 08 · Tool Calling

## За 30 секунд

**Tool calling** (function calling) lets the model **request app-side execution** — search local database, fetch weather, run vector search — instead of inventing facts. Flow: model emits **structured tool call** (name + arguments) → app **executes** → **returns output** to model → model continues. Covers schema design, **execution loop**, **idempotency**, and **error feedback** to the model. This topic is the **single-turn tool round-trip** — not the full multi-step [09 · Agents](../agents/README.md) orchestration loop.

## Apple docs

- [Tool](https://developer.apple.com/documentation/foundationmodels/tool) — protocol, `call(arguments:)`, `@Generable` arguments.
- [LanguageModelSession](https://developer.apple.com/documentation/foundationmodels/languagemodelsession) — attach tools to session or profile.
- [Expanding generation with tool calling](https://developer.apple.com/documentation/foundationmodels/expanding-generation-with-tool-calling) — ToolCallingMode: allowed, disallowed, required.
- [WWDC25 — Deep dive into the Foundation Models framework](https://developer.apple.com/videos/play/wwdc2025/301/) — tool calling basics.
- [WWDC26 — Build agentic app experiences (242)](https://developer.apple.com/videos/play/wwdc2026/242/) — tool calling mode, transcript impact.

## 🎯 Focus vs Defer

### Focus

- **Tool schema:** `name`, natural-language `description`, typed `Arguments` — model reads these in prompt.
- **Execution loop:** respond → tool call? → execute → feed output → respond again (may repeat).
- **Idempotency:** duplicate tool calls must not double-charge or double-book.
- **Errors back to model:** return structured error string so model can retry or explain to user.
- **Side effects:** separate read tools from write tools; confirm writes in UI.
- **Context cost:** each tool definition consumes tokens ([02 · Tokens](../tokens/README.md)).

### Defer

- Full agent planner/reasoning loops — see [agents](../agents/README.md).
- MCP wire protocol — see [mcp](../mcp/README.md).
- Parallel tool execution scheduling internals — mention concurrent `Sendable` tools.

## Ключевые понятия

| Piece | Role |
|-------|------|
| **Tool definition** | Name + description + parameter schema in prompt |
| **Tool call** | Model output selecting tool + JSON/Generable args |
| **Tool output** | App returns string or `@Generable` to model |
| **Execution loop** | Repeat until model produces final user-facing text |
| **Idempotency key** | Same call twice → same effect once |
| **ToolCallingMode** | `.allowed` (default), `.disallowed`, `.required` |

**Apple Tool example:**

```swift
struct SearchNotesTool: Tool {
    let name = "searchNotes"
    let description = "Search user notes by keyword; returns top 3 snippets."

    @Generable
    struct Arguments {
        @Guide(description: "Search query", .maximumLength(100))
        let query: String
    }

    func call(arguments: Arguments) async throws -> String {
        let results = await notesStore.search(arguments.query, limit: 3)
        guard !results.isEmpty else { return "No notes found." }
        return results.map { "- \($0.title): \($0.preview)" }.joined(separator: "\n")
    }
}

var session = LanguageModelSession(tools: [SearchNotesTool(notesStore: store)])
let reply = try await session.respond(to: "Find my budget notes")
```

**Execution loop (conceptual — one tool round, not full agent):**

```text
1. User message → session.respond
2. Model returns ToolCall(name, args) OR final text
3. If ToolCall → app.call(arguments) → ToolOutput
4. Framework appends output to transcript → model continues
5. Repeat until final text (cap max tool rounds in production)
```

**Idempotency patterns (iOS):**

| Write tool | Pattern |
|------------|---------|
| Create calendar event | Dedupe by `(title, startDate)` hash in session |
| Send notification | Idempotency-Key header to backend |
| Deduct credits | Server-side ledger with request UUID |

**Errors back to model:**

```swift
func call(arguments: Arguments) async throws -> String {
    do {
        return try await api.fetchWeather(arguments.city)
    } catch {
        return "Error: city not found or network unavailable. Ask user to clarify city name."
    }
}
```

Model can apologize or ask clarifying question — better than silent failure. Log errors in OSLog for engineers; don't expose stack traces to model or user.

**ToolCallingMode (WWDC26):** `.required` forces tool use when you know retrieval is mandatory (RAG-style); `.disallowed` for pure summarization turn; default `.allowed` for mixed chat.

**Separate from agents:** tool calling is the **mechanism**; agents add planning, multi-step goals, profile switching ([dynamic-profiles](../dynamic-profiles/README.md)), and eval of trajectories ([evaluations](../evaluations/README.md)).

## 🏋️ Exercises

1. **Read vs write** — `getAccountBalance` vs `transferMoney`. *Expected:* read tool auto; write tool requires confirmation + idempotent server API.

2. **Duplicate call** — Model calls `createReminder` twice with same args. *Expected:* second call no-op or returns existing ID.

3. **Error path** — Search returns 0 results. *Expected:* tool output `"No results"`; model asks user to refine query — not invent results.

4. **Schema design** — Weather tool with vague description. *Expected:* precise description + `@Guide` on city/country; reduces wrong tool selection.

5. **Context bloat** — 12 tools attached. *Expected:* trim descriptions; dynamic tool subset per screen via DynamicProfile; drop unused tools from session.

## Ссылки

- [Tool protocol](https://developer.apple.com/documentation/foundationmodels/tool)
- [LanguageModelSession](https://developer.apple.com/documentation/foundationmodels/languagemodelsession)
- [Build agentic experiences (WWDC26-242)](https://developer.apple.com/videos/play/wwdc2026/242/)
- Related: [structured-output](../structured-output/README.md), [agents](../agents/README.md), [rag](../rag/README.md)

## Карточки знаний (Q&A)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question (RU):** Tool calling — как работает?
- **Question (EN):** How does tool calling work?
- **Answer (RU):** App регистрирует **Tool** (name, description, Arguments schema). Framework кладёт definitions в prompt. Model может emit **tool call** → app **`call(arguments:)`** → output возвращается в transcript → model продолжает. Цикл до final user-facing ответа.
- **Answer (EN):** The app registers tools with names, descriptions, and argument schemas. The model may emit a tool call; the app executes `call(arguments:)` and returns output to the transcript for the model to continue until a final answer.
- **Follow-up:** чем Tool отличается от простого API call в app?
- **Follow-up answer:** **Model chooses** when/which tool based on user intent — app doesn't hardcode routing. Tool output **informs next model turn**, enabling multi-step reasoning within session.

### Q2
- **Question (RU):** Idempotency — зачем в tool calling?
- **Question (EN):** Why idempotency in tool calling?
- **Answer (RU):** Model может **повторить** tool call (retry, duplicate turn, transcript noise). Write tools без idempotency → **double purchase, duplicate reminders**. Pattern: dedupe keys, server idempotency tokens, check-before-create.
- **Answer (EN):** Models may repeat tool calls. Write tools without idempotency can double-charge or duplicate records. Use dedupe keys and server-side idempotency tokens.
- **Follow-up:** read tools нужна idempotency?
- **Follow-up answer:** Less critical but caching helps latency; still avoid unbounded repeated network calls — debounce or return cached result within same turn.

### Q3
- **Question (RU):** Как сообщать ошибки модели?
- **Question (EN):** How do you report errors back to the model?
- **Answer (RU):** Return **structured natural-language error** as tool output: what failed, what user can fix. Не stack trace. Model может уточнить у пользователя. Log details in OSLog separately.
- **Answer (EN):** Return a clear natural-language error as tool output describing what failed and how to recover. Log technical details separately; don't pass stack traces to the model.
- **Follow-up:** throw vs return error string из `call`?
- **Follow-up answer:** Prefer **return message** for recoverable errors model can handle; `throw` for programmer errors — framework may surface differently; follow Apple FM error policy for transcript.

### Q4
- **Question (RU):** Tool calling vs full agent loop?
- **Question (EN):** Tool calling vs full agent loop?
- **Answer (RU):** **Tool calling** — mechanism: one or few call/response rounds. **Agent loop** — orchestration: planning, multi-step goals, profile/mode switches, eval of trajectories, context engineering. Tool calling — **building block**; agents — **architecture** ([agents](../agents/README.md)).
- **Answer (EN):** Tool calling is the mechanism for call/response rounds. Agent loops add planning, multi-step goals, profile switching, and trajectory evaluation. Tool calling is a building block, not the full architecture.
- **Follow-up:** ToolCallingMode `.required` — когда?
- **Follow-up answer:** When retrieval/action **must** happen before answer (e.g. search notes before summarizing) — prevents model from answering from memory alone; use with eval to verify tool is actually invoked.

<!-- knowledge-cards-canonical:end -->

<!-- ai-engineering-nav:start -->

---

**AI Engineering:** [Track overview](../README.md) · [← 07 · Structured Output](../structured-output/) · [09 · Agents →](../agents/)

<!-- ai-engineering-nav:end -->
