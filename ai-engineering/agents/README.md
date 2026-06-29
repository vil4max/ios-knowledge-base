# 09 · Agents

## In 30 seconds

**AI agents** run a loop: model plans → calls [tools](../tool-calling/) → observes results → repeats until done or a step limit. Unlike a single chat completion, an agent **persists state** across turns and may chain multiple tool calls. **Guardrails** (allowlists, human approval, timeouts) matter on mobile where side effects touch user data and battery. Production-style orchestration patterns (search-first, think-before-act, single agent + many tools) → [Agent Patterns](../agent-patterns/). For transport and IDE integration see [MCP](../mcp/); for on-device tool wiring see [Foundation Models](../foundation-models/).

## Apple docs

- [Foundation Models — tool integration](https://developer.apple.com/documentation/foundationmodels) — provide Swift tools the on-device model can invoke.
- [WWDC — Expand your app’s experience with generative AI](https://developer.apple.com/videos/) — search “Foundation Models” for tool-calling sessions.
- [App Intents](https://developer.apple.com/documentation/appintents) — structured actions Siri/Shortcuts; conceptually similar “typed tools” for system integration.

## 🎯 Focus vs Defer

### Focus

- **Agent loop:** plan → tool call → observe → iterate (ReAct pattern).
- **Tool schema:** name, description, typed parameters — model chooses JSON args.
- **MCP:** host exposes resources/tools; client (Cursor, agent runtime) discovers capabilities.
- **Idempotency & auth:** tools that write need same safeguards as REST mutations.
- **Guardrails:** tool allowlist, max steps, confirmation UI, PII redaction.
- **Human-in-the-loop:** approve payments, sends, deletes.

### Defer

- Full autonomous multi-agent swarms — single-agent loop is enough for interview.
- MCP wire protocol bytes — explain client/server roles.
- Replacing app architecture with agents everywhere — anti-pattern.

## Key concepts

| Term | Role |
|------|------|
| **Tool / function calling** | Model emits structured call; runtime executes |
| **ReAct** | Reasoning + Acting interleaved |
| **MCP server** | Exposes tools, prompts, resources to MCP clients |
| **MCP client** | IDE, agent host connecting to servers |
| **Observation** | Tool result fed back into context |
| **Max iterations** | Cap loops to prevent runaway cost |
| **Guardrail** | Policy layer before/after model |

**Typical loop:**

```text
User goal
  → LLM (with tool definitions)
  → tool_call: searchDocs(query)
  → execute locally / API
  → tool_result → LLM
  → final answer OR next tool_call
```

**MCP value:** one protocol for filesystem, Git, Xcode, Figma tools — agents discover capabilities dynamically instead of hardcoding every integration.

**Mobile guardrails:** run tools on background executor; MainActor for UI; no silent sends; Keychain for secrets; sandbox file access.

## 🏋️ Exercises

1. **Travel assistant agent** — Tools: `searchFlights`, `getCalendar`, `createHold`. *Expected:* diagram loop; confirm before book.

2. **MCP mental model** — Explain how Cursor uses MCP for Xcode. *Expected:* client lists tools from server; model picks `BuildProject`.

3. **Runaway loop** — Agent calls search 50 times. *Expected:* max steps, dedupe queries, cost cap.

4. **Swift tool** — Foundation Models `Tool` wrapping HealthKit read (mock). *Expected:* typed parameters, error as observation.

5. **Unsafe tool** — `deleteAllNotes`. *Expected:* not in allowlist; require explicit user confirmation.

## Links

- [Model Context Protocol](https://modelcontextprotocol.io/) — specification
- [Foundation Models framework](https://developer.apple.com/documentation/foundationmodels)
- Related: [tools](../tools/README.md), [prompt-engineering](../prompt-engineering/README.md)

## Interview Q&A (Knowledge cards)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question:** What is an agent loop?

- **Answer:** The model receives a goal and tool definitions, emits a structured tool call, the runtime executes it, feeds the result back as observation, and repeats until done or a step limit is hit.

### Q2
- **Question:** Tool calling vs plain prompting?

- **Answer:** Prompting alone hallucinates facts and cannot safely perform side effects. Tools provide real data and controlled actions; clear tool descriptions drive correct routing.

### Q3
- **Question:** Why MCP?

- **Answer:** MCP standardizes how agent hosts connect to tool servers — implement once, reuse across clients. Ad hoc per-agent integrations do not scale.

### Q4
- **Question:** Guardrails for a production agent?

- **Answer:** Tool allowlists, step/time limits, schema validation, human confirmation for destructive actions, logging, PII redaction, rate limits. On iOS keep work off the main thread with clear UI error states.

<!-- knowledge-cards-canonical:end -->

<!-- ai-engineering-nav:start -->

---

**AI Engineering:** [Track overview](../README.md) · [← 08 · Tool Calling](../tool-calling/) · [10 · MCP →](../mcp/)

<!-- ai-engineering-nav:end -->
