# AI Engineer Roadmap

Mobile AI on Apple platforms — stack, levels, 12-month plan, skills matrix. Start here before topic **01 · LLM Basics**.

<div class="ai-roadmap">

<section class="ai-slide">
  <header class="ai-slide__header">
    <span class="ai-slide__num">01</span>
    <span class="ai-slide__label">Industry map</span>
  </header>
  <h2 class="ai-slide__title">Not a tech list — a layer stack</h2>
  <p class="ai-slide__subtitle">Each layer consumes the one below and serves the one above. Understand the layers — and any new acronym slots in on its own.</p>
  <p class="ai-stack-dir">↑ product</p>
  <div class="ai-stack">
    <div class="ai-layer ai-layer--blue">
      <span class="ai-layer__id">L4</span>
      <span class="ai-layer__name ai-layer__name--blue">Product &amp; UX</span>
      <span class="ai-layer__items">mobile apps, AI-first UX — <em>your home turf</em></span>
    </div>
    <div class="ai-layer">
      <span class="ai-layer__id">L3</span>
      <span class="ai-layer__name">Orchestration</span>
      <span class="ai-layer__items">Workflows · Agents · Multi-Agent · A2A</span>
    </div>
    <div class="ai-layer">
      <span class="ai-layer__id">L2</span>
      <span class="ai-layer__name">Tools &amp; Context</span>
      <span class="ai-layer__items">Tool Calling · MCP · RAG · Vector DB · Embeddings</span>
    </div>
    <div class="ai-layer ai-layer--gold">
      <span class="ai-layer__id">L1</span>
      <span class="ai-layer__name ai-layer__name--gold">Foundation Models</span>
      <span class="ai-layer__items">AFM 3 (on-device) · Claude · Gemini · Open Source</span>
    </div>
    <div class="ai-layer">
      <span class="ai-layer__id">L0</span>
      <span class="ai-layer__name">Infrastructure</span>
      <span class="ai-layer__items">Private Cloud Compute · GPU · Neural Engine</span>
    </div>
  </div>
  <p class="ai-stack-dir">↓ hardware</p>
  <p class="ai-rule">Rule: add <strong>complexity</strong> bottom-up and only when a <strong>cheaper</strong> layer is not enough.</p>
  <p class="ai-flow"><span class="t-white">Prompt</span> → <span class="t-blue">tool calling</span> → <span class="t-gold">RAG</span> → <span class="t-blue">workflow</span> → <span class="t-white">agent</span><span class="t-muted">. Not the other way around.</span></p>
</section>

<section class="ai-slide">
  <header class="ai-slide__header">
    <span class="ai-slide__num">02</span>
    <span class="ai-slide__label">Engineer profile</span>
  </header>
  <h2 class="ai-slide__title">Four levels and transition criteria</h2>
  <p class="ai-slide__subtitle">Without explicit criteria it is easy to stall as “forever Intermediate”. Each level is what you can **design**, not what you have read.</p>
  <div class="ai-card-panel">
    <div class="ai-level-row">
      <span class="ai-level-icon ai-level-icon--b">B</span>
      <div>
        <p class="ai-level-title">Beginner — AI User who understands what is happening</p>
        <p class="ai-level-detail">Tokens, context, prompt, tool calling conceptually. Calling an LLM from Swift.</p>
        <p class="ai-level-transition">Transition: ship an app that calls an LLM, handles network errors, and streams the response.</p>
      </div>
    </div>
    <div class="ai-level-row">
      <span class="ai-level-icon ai-level-icon--i">I</span>
      <div>
        <p class="ai-level-title">Intermediate — entry-level AI Builder</p>
        <p class="ai-level-detail">Foundation Models in practice, @Generable, Tool, local RAG, on-device vs cloud.</p>
        <p class="ai-level-transition">Transition: you designed and measured (eval) an offline feature and consciously decided what goes to the cloud.</p>
      </div>
    </div>
    <div class="ai-level-row">
      <span class="ai-level-icon ai-level-icon--a">A</span>
      <div>
        <p class="ai-level-title">Advanced — designs systems</p>
        <p class="ai-level-detail">Coordinator pattern, multi-provider, agentic loops, your own MCP server, security.</p>
        <p class="ai-level-transition">Transition: a senior on another team says “this is well designed”, not just “this works”.</p>
      </div>
    </div>
    <div class="ai-level-row">
      <span class="ai-level-icon ai-level-icon--e">E</span>
      <div>
        <p class="ai-level-title">Expert — AI Architect and taste carrier</p>
        <p class="ai-level-detail">Sees the full stack and economics, knows when AI is **not** needed, shapes industry opinion.</p>
        <p class="ai-level-transition">Transition: people come to you for how to do AI on mobile.</p>
      </div>
    </div>
  </div>
</section>

<section class="ai-slide">
  <header class="ai-slide__header">
    <span class="ai-slide__num">03</span>
    <span class="ai-slide__label">12 months · step by step</span>
  </header>
  <h2 class="ai-slide__title">A year that lands you in solid Advanced</h2>
  <p class="ai-slide__subtitle">Maps to your sequence: Playgrounds → LanguageModelSession → availability → @Generable → Tool → streaming → coordinator.</p>
  <div class="ai-phase">
    <div class="ai-phase__label">Phase 1 · Foundation (M1—M5)</div>
    <div class="ai-months">
      <div class="ai-month">
        <div class="ai-month__id">M01</div>
        <p class="ai-month__text">Prompt + API call from Swift, streaming, errors</p>
      </div>
      <div class="ai-month">
        <div class="ai-month__id">M02</div>
        <p class="ai-month__text">AFM on-device: LanguageModelSession, availability</p>
      </div>
      <div class="ai-month">
        <div class="ai-month__id">M03</div>
        <p class="ai-month__text">@Generable, Tool, image input + Vision OCR</p>
      </div>
      <div class="ai-month">
        <div class="ai-month__id">M04</div>
        <p class="ai-month__text">Streaming, sessions, and Evaluation — early!</p>
      </div>
      <div class="ai-month">
        <div class="ai-month__id">M05</div>
        <p class="ai-month__text">Embeddings, local RAG over notes</p>
      </div>
    </div>
  </div>
  <div class="ai-phase">
    <div class="ai-phase__label">Phase 2 · Systems (M6—M9)</div>
    <div class="ai-months">
      <div class="ai-month ai-month--flagship">
        <div class="ai-month__id">M06</div>
        <p class="ai-month__text">Coordinator pattern — edge↔cloud routing</p>
        <span class="ai-month__badge">★ Flagship</span>
      </div>
      <div class="ai-month">
        <div class="ai-month__id">M07</div>
        <p class="ai-month__text">MCP: connect and write your first server</p>
      </div>
      <div class="ai-month">
        <div class="ai-month__id">M08</div>
        <p class="ai-month__text">Agents: workflow → agentic, one framework deep</p>
      </div>
      <div class="ai-month">
        <div class="ai-month__id">M09</div>
        <p class="ai-month__text">Security: injection, tool poisoning, guardrails</p>
      </div>
    </div>
  </div>
</section>

<section class="ai-slide">
  <header class="ai-slide__header">
    <span class="ai-slide__num">04</span>
    <span class="ai-slide__label">3 years · long arc</span>
  </header>
  <h2 class="ai-slide__title">AI User → AI Builder → AI Architect</h2>
  <div class="ai-years">
    <div class="ai-year">
      <div class="ai-year__label">Year 1</div>
      <p class="ai-year__heading">AI User → Builder</p>
      <p class="ai-year__summary">Master the full mobile AI stack in practice, build a coordinator, start publishing.</p>
      <ul>
        <li>Foundation Models, structured output, RAG, eval</li>
        <li>First MCP server and first agent</li>
        <li>2–3 portfolio apps</li>
      </ul>
    </div>
    <div class="ai-year">
      <div class="ai-year__label">Year 2</div>
      <p class="ai-year__heading ai-year__heading--orange">Builder → Architect</p>
      <p class="ai-year__summary">From “shipping features” to “designing systems and setting standards”. Reach an English-speaking audience.</p>
      <ul>
        <li>Multi-agent, A2A, observability, inference economics</li>
        <li>Open-source library for mobile AI</li>
        <li>Conference talk</li>
      </ul>
    </div>
    <div class="ai-year">
      <div class="ai-year__label">Year 3</div>
      <p class="ai-year__heading ai-year__heading--blue">AI Architect</p>
      <p class="ai-year__summary">Influence product and AI strategy, shape opinion, mentor.</p>
      <ul>
        <li>Industry reference architecture</li>
        <li>Influence on company strategy</li>
        <li>Sustained public brand</li>
      </ul>
    </div>
  </div>
</section>

<section class="ai-slide">
  <header class="ai-slide__header">
    <span class="ai-slide__num">06</span>
    <span class="ai-slide__label">Skills matrix</span>
  </header>
  <h2 class="ai-slide__title">What to learn and in what order</h2>
  <p class="ai-slide__subtitle">Underrated skill — <strong>Evaluation</strong>. Whoever measures AI feature quality owns the team conversation. Cheapest lever to influence.</p>
  <div class="ai-matrix">
    <div class="ai-matrix-col">
      <p class="ai-matrix-col__title ai-matrix-col__title--now">Now</p>
      <p class="ai-matrix-col__period">M1–M5</p>
      <div class="ai-skill"><span class="ai-skill__name">Prompt Engineering</span><span class="ai-roi ai-roi--high">high ROI</span></div>
      <div class="ai-skill"><span class="ai-skill__name">Claude Code / Cursor</span><span class="ai-roi ai-roi--high">high ROI</span></div>
      <div class="ai-skill"><span class="ai-skill__name">Foundation Models</span><span class="ai-roi ai-roi--high">high ROI</span></div>
      <div class="ai-skill"><span class="ai-skill__name">Structured output</span><span class="ai-roi ai-roi--high">high ROI</span></div>
      <div class="ai-skill"><span class="ai-skill__name">Evaluation</span><span class="ai-roi ai-roi--high">high ROI</span></div>
      <div class="ai-skill"><span class="ai-skill__name">Anthropic SDK</span><span class="ai-roi ai-roi--high">high ROI</span></div>
    </div>
    <div class="ai-matrix-col">
      <p class="ai-matrix-col__title ai-matrix-col__title--mid">Along the way</p>
      <p class="ai-matrix-col__period">M5–M9</p>
      <div class="ai-skill"><span class="ai-skill__name">RAG</span><span class="ai-roi ai-roi--high">high ROI</span></div>
      <div class="ai-skill"><span class="ai-skill__name">MCP</span><span class="ai-roi ai-roi--high">high ROI</span></div>
      <div class="ai-skill"><span class="ai-skill__name">Agents (concepts)</span><span class="ai-roi ai-roi--high">high ROI</span></div>
      <div class="ai-skill"><span class="ai-skill__name">Python / TypeScript</span><span class="ai-roi ai-roi--high">high ROI</span></div>
      <div class="ai-skill"><span class="ai-skill__name">LangGraph (one)</span><span class="ai-roi ai-roi--mid">mid ROI</span></div>
      <div class="ai-skill"><span class="ai-skill__name">Vector DB</span><span class="ai-roi ai-roi--mid">mid ROI</span></div>
    </div>
    <div class="ai-matrix-col">
      <p class="ai-matrix-col__title ai-matrix-col__title--later">Defer</p>
      <p class="ai-matrix-col__period">Year 2+ / as needed</p>
      <div class="ai-skill"><span class="ai-skill__name">AI Product Design</span><span class="ai-roi ai-roi--high">high ROI</span></div>
      <div class="ai-skill"><span class="ai-skill__name">AI UX</span><span class="ai-roi ai-roi--high">high ROI</span></div>
      <div class="ai-skill"><span class="ai-skill__name">AI Infrastructure</span><span class="ai-roi ai-roi--mid">mid ROI</span></div>
      <div class="ai-skill"><span class="ai-skill__name">OpenAI SDK</span><span class="ai-roi ai-roi--mid">mid ROI</span></div>
      <div class="ai-skill"><span class="ai-skill__name">Fine-tuning</span><span class="ai-roi ai-roi--low">low ROI</span></div>
    </div>
  </div>
</section>

<section class="ai-slide">
  <header class="ai-slide__header">
    <span class="ai-slide__num">07</span>
    <span class="ai-slide__label">What not to learn</span>
  </header>
  <h2 class="ai-slide__title">The most important section for speed</h2>
  <div class="ai-card-panel">
    <div class="ai-skip-row">
      <span class="ai-skip-icon">✕</span>
      <div>
        <p class="ai-skip-title">Fine-tuning / training models from scratch</p>
        <p class="ai-skip-desc">Expensive, goes stale fast. You consume models, you do not produce them. 99% of tasks — prompt + RAG + tools.</p>
      </div>
    </div>
    <div class="ai-skip-row">
      <span class="ai-skip-icon">✕</span>
      <div>
        <p class="ai-skip-title">“All 6 agent frameworks”</p>
        <p class="ai-skip-desc">Pick one deep (LangGraph or Claude Agent SDK). Others — by analogy in a day when you need them.</p>
      </div>
    </div>
    <div class="ai-skip-row">
      <span class="ai-skip-icon">✕</span>
      <div>
        <p class="ai-skip-title">Chasing every model and benchmark</p>
        <p class="ai-skip-desc">Models converged — harness and architecture matter more than +2% on a leaderboard. Watch what changes architecture.</p>
      </div>
    </div>
    <div class="ai-skip-row">
      <span class="ai-skip-icon">✕</span>
      <div>
        <p class="ai-skip-title">“Tutorial hell”</p>
        <p class="ai-skip-desc">One shipped project with eval &gt; ten courses watched. Build &gt; consume.</p>
      </div>
    </div>
  </div>
</section>

</div>

---

## Topic map · M01–M09 → KB

| Month | Focus | KB topics |
|-------|--------|-----------|
| M01 | Prompting & API | [01 · LLM Basics](llm-basics/) · [02 · Tokens](tokens/) · [03 · Context Window](context-window/) |
| M02 | On-device AFM | [11 · Foundation Models](foundation-models/) |
| M03 | Tools & structure | [07 · Structured Output](structured-output/) · [08 · Tool Calling](tool-calling/) |
| M04 | Sessions & eval idea | [03 · Context Window](context-window/) · [14 · Evaluations](evaluations/) |
| M05 | RAG | [04 · Embeddings](embeddings/) · [05 · Vector Search](vector-search/) · [06 · RAG](rag/) |
| M06 ⭐ | Coordinator | [11 · Foundation Models](foundation-models/) · [Agent Patterns](agent-patterns/) |
| M07 | MCP | [10 · MCP](mcp/) |
| M08 | Agents | [09 · Agents](agents/) |
| M09 | Security | [09 · Agents](agents/) · guardrails in topics |

**Next:** [01 · LLM Basics →](llm-basics/)
